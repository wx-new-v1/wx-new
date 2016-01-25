//
//  RegistVC.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RegistVC.h"
#import "WXTUITextField.h"
#import "UIView+Render.h"
#import "RegistModel.h"
#import "GainModel.h"

#define kLoginBigImgViewheight (220)
#define UserPhoneLength (11)
#define EveryCellHeight (40)
#define kFetchPasswordDur (60)
#define Size self.bounds.size

enum{
    WXT_Regist_UserPhone = 0,
    WXT_Regist_FetchPwd,
    WXT_Regist_Pwd,
    WXT_Regist_OtherPhone,
    
    WXT_Regist_Invalid,
}WXT_Regist_Type;

@interface RegistVC()<RegistDelegate,GainNumDelegate>{
    WXTUITextField *_userTextField;
    WXTUITextField *_fetchPwd;
    WXTUITextField *_pwdTextfield;
    WXTUITextField *_otherPhone;
    
    WXTUIButton *_gainBtn;
    NSTimer *_fetchPWDTimer;
    NSInteger _fetchPasswordTime;
    
    RegistModel *_model;
    GainModel *_gainModel;
}
@end

@implementation RegistVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[RegistModel alloc] init];
        [_model setDelegate:self];
        
        _gainModel = [[GainModel alloc] init];
        [_gainModel setDelegate:self];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoardDur) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"注册"];
    [self setBackgroundColor:WXColorWithInteger(0xf0f0f0)];
    
    [self createUI];
}

-(void)createUI{
    CGFloat yGap = 20;
    CGRect tableRect = CGRectMake(0, 0, Size.width, yGap);
    [self createUserAndPwdTable:tableRect];
    
    //没有推荐人
//    CGFloat yOffset = tableRect.size.height+15;
    
    //有推荐人
    CGFloat yOffset = 230;
    CGFloat btnHeight1 = 41.0;
    CGFloat xgap = 20;
    CGFloat btnWidth1 = Size.width-2*xgap;
    CGFloat titleSize = 18.0;
    WXTUIButton *_submitBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setFrame:CGRectMake(xgap, yOffset, btnWidth1, btnHeight1)];
    [_submitBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [_submitBtn.titleLabel setFont:WXTFont(titleSize)];
    [_submitBtn setBackgroundImageOfColor:WXColorWithInteger(AllBaseColor) controlState:UIControlStateNormal];
    [_submitBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_submitBtn];
}

-(void)createUserAndPwdTable:(CGRect)rect{
    CGSize size = rect.size;
    CGFloat xGap = 20.0;
    CGFloat height = 35.0;
    CGFloat width = size.width - xGap*2.0;
    CGFloat yOffset = 25;
    
    CGFloat fontSize = 15.0;
    _userTextField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap, yOffset, width, height)];
    [_userTextField setBackgroundColor:[UIColor whiteColor]];
    [_userTextField setReturnKeyType:UIReturnKeyDone];
    [_userTextField setKeyboardType:UIKeyboardTypePhonePad];
    [_userTextField addTarget:self action:@selector(showKeyBoard)  forControlEvents:UIControlEventEditingDidBegin];
    [_userTextField setTextColor:WXColorWithInteger(0xda7c7b)];
    [_userTextField setTintColor:WXColorWithInteger(AllBaseColor)];
    [_userTextField setPlaceHolder:@"请输入你的手机号" color:WXColorWithInteger(0xbababa)];
    [_userTextField setFont:WXFont(16.0)];
    [_userTextField setFont:WXTFont(fontSize)];
    [self addSubview:_userTextField];
    
    yOffset += height+10;
    _fetchPwd = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap, yOffset, width-110, height)];
    [_fetchPwd setReturnKeyType:UIReturnKeyDone];
    [_fetchPwd setBackgroundColor:[UIColor whiteColor]];
    [_fetchPwd addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_fetchPwd addTarget:self action:@selector(showKeyBoard)  forControlEvents:UIControlEventEditingDidBegin];
    [_fetchPwd setTextColor:WXColorWithInteger(0xda7c7b)];
    [_fetchPwd setTintColor:WXColorWithInteger(AllBaseColor)];
    [_fetchPwd setKeyboardType:UIKeyboardTypePhonePad];
    [_fetchPwd setFont:WXFont(16.0)];
    [_fetchPwd setPlaceHolder:@"请输入验证码" color:WXColorWithInteger(0xbababa)];
    [_fetchPwd setFont:WXTFont(fontSize)];
    [self addSubview:_fetchPwd];
    
    _gainBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    _gainBtn.frame = CGRectMake(xGap+width-100, yOffset, 100, height);
    [_gainBtn setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [_gainBtn.titleLabel setFont:WXTFont(14.0)];
    [_gainBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_gainBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [_gainBtn addTarget:self action:@selector(fecthCode) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_gainBtn];
    
    yOffset += height+10;
    _pwdTextfield = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap, yOffset, width, height)];
    [_pwdTextfield setReturnKeyType:UIReturnKeyDone];
    [_pwdTextfield setBackgroundColor:[UIColor whiteColor]];
    [_pwdTextfield addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_pwdTextfield addTarget:self action:@selector(showKeyBoard)  forControlEvents:UIControlEventEditingDidBegin];
    [_pwdTextfield setTextColor:WXColorWithInteger(0xda7c7b)];
    [_pwdTextfield setTintColor:WXColorWithInteger(AllBaseColor)];
    [_pwdTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    [_pwdTextfield setSecureTextEntry:YES];
    [_pwdTextfield setFont:WXFont(16.0)];
    [_pwdTextfield setPlaceHolder:@"请输入密码" color:WXColorWithInteger(0xbababa)];
    [self addSubview:_pwdTextfield];
    
    yOffset += height+10;
    _otherPhone = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap, yOffset, width, height)];
    [_otherPhone setReturnKeyType:UIReturnKeyDone];
    [_otherPhone setBackgroundColor:[UIColor whiteColor]];
    [_otherPhone addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_otherPhone addTarget:self action:@selector(showKeyBoard)  forControlEvents:UIControlEventEditingDidBegin];
    [_otherPhone setTextColor:WXColorWithInteger(0xda7c7b)];
    [_otherPhone setTintColor:WXColorWithInteger(AllBaseColor)];
    [_otherPhone setKeyboardType:UIKeyboardTypePhonePad];
    [_otherPhone setFont:WXFont(16.0)];
    [_otherPhone setPlaceHolder:@"输入推荐人手机号(选填)" color:WXColorWithInteger(0xbababa)];
    [self addSubview:_otherPhone];
}

#pragma mark keyboard
-(void)showKeyBoard{
}

- (void)hideKeyBoardDur{
}

#pragma mark 数据是否有效~
- (BOOL)checkUserValide{
    NSString *user = _userTextField.text;
    NSInteger len = user.length;
    if(len == 0){
        [UtilTool showAlertView:@"请输入手机号"];
        return NO;
    }
    NSString *phoneStr = [UtilTool callPhoneNumberRemovePreWith:_userTextField.text];
    if(![UtilTool determineNumberTrue:phoneStr]){
        [UtilTool showAlertView:@"请输入正确的手机号码"];
        return NO;
    }
    return YES;
}

#pragma mark textField resignFirstResponder
- (void)swip{
    [self textFieldResighFirstResponder];
}

- (void)tap{
    [self textFieldResighFirstResponder];
}

#pragma mark delegate
-(void)fecthCode{
    if(![self checkUserValide]){
        return;
    }
    [_gainModel gainNumber:_userTextField.text];
    [self startFetchPwdTiming];
    [_gainBtn setEnabled:NO];
    [self textFieldResighFirstResponder];
}

-(void)gainNumSucceed{
    [UtilTool showAlertView:[NSString stringWithFormat:@"验证码已经发送到你的号码为%@的手机上，请注意查收",_userTextField.text]];
}

-(void)gainNumFailed:(NSString *)errorMsg{
    if(!errorMsg){
        errorMsg = @"获取验证码失败";
    }
    [self stopFetchPwdTiming];
    [self setFetchPasswordButtonTitle];
    [UtilTool showAlertView:errorMsg];
}

#pragma mark textfield
-(void)textFieldDone:(id)sender{
    WXTUITextField *textField = sender;
    [textField resignFirstResponder];
}

- (void)textFieldResighFirstResponder{
    [_userTextField resignFirstResponder];
    [_fetchPwd resignFirstResponder];
    [_pwdTextfield resignFirstResponder];
    [_otherPhone resignFirstResponder];
    [self hideKeyBoardDur];
}

#pragma mark 验证码
- (void)setFetchPasswordButtonTitle{
    [_gainBtn setEnabled:_fetchPasswordTime == 0];
    NSString *title = @"获取验证码";
    if(_fetchPasswordTime > 0){
        title = [NSString stringWithFormat:@"(%d)",kFetchPasswordDur - (int)_fetchPasswordTime];
    }
    [_gainBtn setTitle:title forState:UIControlStateNormal];
    [_gainBtn setTitle:title forState:UIControlStateHighlighted];
    [_gainBtn setTitle:title forState:UIControlStateDisabled];
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

-(BOOL)checkRegistInfo{
    if(![self checkUserValide]){
        return NO;
    }
    if(_pwdTextfield.text.length < 6){
        [UtilTool showAlertView:@"密码不能小于6位"];
        return NO;
    }
    if(![self checkPwdStyleWith:_pwdTextfield.text]){
        return NO;
    }
    if(_fetchPwd.text.length < 1){
        [UtilTool showAlertView:@"验证码不能为空"];
        return NO;
    }
    if(_otherPhone.text.length > 0){
        NSString *phoneStr = [UtilTool callPhoneNumberRemovePreWith:_otherPhone.text];
        if(![UtilTool determineNumberTrue:phoneStr]){
            [UtilTool showAlertView:@"推荐人手机号格式不正确"];
            return NO;
        }
    }
    return YES;
}

-(BOOL)checkPwdStyleWith:(NSString*)pwdString{
    BOOL isOk = YES;
    for(NSInteger i = 0;i < [pwdString length]; i++){
        char ch = [pwdString characterAtIndex:i];
        if(!((ch <= 'z' && ch >= 'a') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9'))){
            [UtilTool showAlertView:@"密码不能含有数字和字母以外的字符"];
            return NO;
        }
    }
    return isOk;
}

#pragma mark registerDelegate
-(void)regist{
    [self textFieldResighFirstResponder];
    if(![self checkRegistInfo]){
        return;
    }
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    if(userDefault.smsID == 0){
        userDefault.smsID = 1;
    }
    if(_otherPhone.text.length == 0){
       _otherPhone.text = @"";
    }
    
    [_model registWithUserPhone:_userTextField.text andPwd:_pwdTextfield.text andSmsID:userDefault.smsID andCode:[_fetchPwd.text integerValue] andRecommondUser:_otherPhone.text];
}

-(void)registSucceed{
    [self unShowWaitView];
    [self backLogin];
    [UtilTool showAlertView:@"注册成功"];
}

-(void)registFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [UtilTool showAlertView:errorMsg];
}

#pragma mark back
-(void)backLogin{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
