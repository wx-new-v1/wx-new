//
//  NewForgetPwdVC.m
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "NewForgetPwdVC.h"
#import "NewResetPwdVC.h"
#import "ForgetModel.h"

#define Size self.bounds.size
#define kFetchPasswordDur (60)

@interface NewForgetPwdVC()<ForgetResetPwdDelegate>{
    WXUIButton *_gainBtn;
    WXUITextField *userPhoneTextfield;
    WXUITextField *pwdTextField;
    
    NSTimer *_fetchPWDTimer;
    NSInteger _fetchPasswordTime;
    
    ForgetModel *_model;
}
@end

@implementation NewForgetPwdVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[ForgetModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"找回密码"];
    [self setBackgroundColor:WXColorWithInteger(0xf0f0f0)];
    
    [self createBaseView];
}

-(void)createBaseView{
    CGFloat xOffset = 18;
    CGFloat yOffset = 20;
    CGFloat height = 42;
    userPhoneTextfield = [[WXUITextField alloc] init];
    userPhoneTextfield.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, height);
    [userPhoneTextfield setBackgroundColor:WXColorWithInteger(0xffffff)];
    [userPhoneTextfield setPlaceHolder:@" 请输入注册的手机号码" color:WXColorWithInteger(0xbababa)];
    [userPhoneTextfield setTextColor:WXColorWithInteger(0x000000)];
    [userPhoneTextfield setReturnKeyType:UIReturnKeyDone];
    [userPhoneTextfield setFont:WXFont(14.0)];
    [userPhoneTextfield setTintColor:[UIColor blackColor]];
    [userPhoneTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    [userPhoneTextfield addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self addSubview:userPhoneTextfield];
    if(_userPhone){
        [userPhoneTextfield setText:_userPhone];
    }
    
    yOffset += height+8;
    CGFloat pwdWidth = 175;
    pwdTextField = [[WXUITextField alloc] init];
    pwdTextField.frame = CGRectMake(xOffset, yOffset, pwdWidth, height);
    [pwdTextField setBackgroundColor:WXColorWithInteger(0xffffff)];
    [pwdTextField setPlaceHolder:@" 请输入验证码" color:WXColorWithInteger(0xbababa)];
    [pwdTextField setTextColor:WXColorWithInteger(0x000000)];
    [pwdTextField setReturnKeyType:UIReturnKeyDone];
    [pwdTextField setTintColor:[UIColor blackColor]];
    [pwdTextField setFont:WXFont(14.0)];
    [pwdTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [pwdTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self addSubview:pwdTextField];
    
    CGFloat xGap = 8;
    _gainBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    _gainBtn.frame = CGRectMake(xOffset+pwdWidth+xGap, yOffset, Size.width-2*xOffset-pwdWidth-xGap, height);
    [_gainBtn setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [_gainBtn.titleLabel setFont:WXTFont(14.0)];
    [_gainBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_gainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_gainBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [_gainBtn addTarget:self action:@selector(gainCode) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_gainBtn];
    
    yOffset += height+27;
    WXUIButton *submitBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, height);
    [submitBtn setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [submitBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitUserPhone) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitBtn];
}

#pragma mark 数据是否有效~
- (BOOL)checkUserValide{
    NSString *user = userPhoneTextfield.text;
    NSInteger len = user.length;
    if(len == 0){
        [UtilTool showAlertView:@"请输入手机号"];
        return NO;
    }
    NSString *phoneStr = [UtilTool callPhoneNumberRemovePreWith:userPhoneTextfield.text];
    if(![UtilTool determineNumberTrue:phoneStr]){
        [UtilTool showAlertView:@"请输入正确的手机号码"];
        return NO;
    }
    return YES;
}

#pragma mark delegate
-(void)gainCode{
    if(![self checkUserValide]){
        return;
    }
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    [_model forgetPwdWithUserPhone:userPhoneTextfield.text];
    [self startFetchPwdTiming];
    [_gainBtn setEnabled:NO];
    [self textFieldResighFirstResponder];
}

-(void)forgetPwdSucceed{
    [self unShowWaitView];
    [UtilTool showAlertView:[NSString stringWithFormat:@"验证码已经发送到你的号码为%@的手机上，请注意查收",userPhoneTextfield.text]];
}

-(void)forgetPwdFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取验证码失败";
    }
    [self stopFetchPwdTiming];
    [self setFetchPasswordButtonTitle];
    [UtilTool showAlertView:errorMsg];
}

- (void)startFetchPwdTiming{
    _fetchPWDTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countFetchPassword) userInfo:nil repeats:YES];
}

- (void)countFetchPassword{
    _fetchPasswordTime ++;
    if(_fetchPasswordTime == kFetchPasswordDur){
        _fetchPasswordTime = 0;
        [self stopFetchPwdTiming];
    }
    [self setFetchPasswordButtonTitle];
}

- (void)stopFetchPwdTiming{
    if(_fetchPWDTimer){
        if([_fetchPWDTimer isValid]){
            [_fetchPWDTimer invalidate];
        }
    }
    _fetchPasswordTime = 0;
}

- (void)setFetchPasswordButtonTitle{
    [_gainBtn setEnabled:_fetchPasswordTime == 0];
    NSString *title = @"获取验证码";
    if(_fetchPasswordTime > 0){
        title = [NSString stringWithFormat:@"(%d秒)",kFetchPasswordDur - (int)_fetchPasswordTime];
    }
    [_gainBtn setTitle:title forState:UIControlStateNormal];
    [_gainBtn setTitle:title forState:UIControlStateHighlighted];
    [_gainBtn setTitle:title forState:UIControlStateDisabled];
}

- (void)textFieldResighFirstResponder{
    [userPhoneTextfield resignFirstResponder];
    [pwdTextField resignFirstResponder];
}

#pragma mark userPhone
-(void)submitUserPhone{
    if([userPhoneTextfield.text isEqualToString:@""] || [pwdTextField.text isEqualToString:@""]){
        [UtilTool showAlertView:@"请填写注册的手机号和接收到的验证码"];
        return;
    }
    NewResetPwdVC *newVC = [[NewResetPwdVC alloc] init];
    newVC.phone = userPhoneTextfield.text;
    newVC.code = [pwdTextField.text integerValue];
    [self.wxNavigationController pushViewController:newVC];
}

-(void)textFieldDone:(WXUITextField*)textField{
    [textField resignFirstResponder];
}

@end
