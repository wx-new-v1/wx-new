//
//  NewResetPwdVC.m
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "NewResetPwdVC.h"
#import "ResetNewPwdModel.h"
#import "LoginVC.h"

#define Size self.bounds.size

@interface NewResetPwdVC()<ResetNewPwdDelegate>{
    WXUITextField *userPhoneTextfield;
    WXUITextField *pwdTextField;
    
    ResetNewPwdModel *_model;
}
@end

@implementation NewResetPwdVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[ResetNewPwdModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"重置密码"];
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
    [userPhoneTextfield setPlaceHolder:@" 请输入新密码" color:WXColorWithInteger(0xbababa)];
    [userPhoneTextfield setTextColor:WXColorWithInteger(0x000000)];
    [userPhoneTextfield setReturnKeyType:UIReturnKeyDone];
    [userPhoneTextfield setFont:WXFont(14.0)];
    [userPhoneTextfield setTextColor:WXColorWithInteger(0x000000)];
    [userPhoneTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    [userPhoneTextfield addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self addSubview:userPhoneTextfield];
    
    yOffset += height+8;
    pwdTextField = [[WXUITextField alloc] init];
    pwdTextField.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, height);
    [pwdTextField setBackgroundColor:WXColorWithInteger(0xffffff)];
    [pwdTextField setPlaceHolder:@" 请再次输入新密码" color:WXColorWithInteger(0xbababa)];
    [pwdTextField setTextColor:WXColorWithInteger(0x000000)];
    [pwdTextField setReturnKeyType:UIReturnKeyDone];
    [pwdTextField setFont:WXFont(14.0)];
    [pwdTextField setTextColor:WXColorWithInteger(0x000000)];
    [pwdTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [pwdTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self addSubview:pwdTextField];
    
    yOffset += height+27;
    WXUIButton *submitBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, height);
    [submitBtn setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [submitBtn setTitle:@"确 认" forState:UIControlStateNormal];
    [submitBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitUserPhone) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitBtn];
}

-(void)submitUserPhone{
    if(!userPhoneTextfield.text || !pwdTextField.text){
        [UtilTool showAlertView:@"请输入您要设置的新密码"];
        return;
    }
    if(userPhoneTextfield.text.length < 6){
        [UtilTool showAlertView:@"新密码长度不能小于6位"];
        return;
    }
    
    if(![userPhoneTextfield.text isEqualToString:pwdTextField.text]){
        [UtilTool showAlertView:@"两次输入的新密码不相同"];
        return;
    }
    if(![self checkPwdStyleWith:userPhoneTextfield.text]){
        return;
    }
    
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    [self resignAllFirstResponder];
    [_model resetNewPwdWithUserPhone:_phone withCode:_code withNewPwd:userPhoneTextfield.text];
}

-(void)resetNewPwdSucceed{
    [self unShowWaitView];
    [UtilTool showAlertView:@"密码重置成功"];
    NSArray *viewControllers = [self.wxNavigationController viewControllers];
    for( int i = 0; i < [viewControllers count]; i++){
        id obj = [viewControllers objectAtIndex:[viewControllers count]-i-1];
        if([obj isKindOfClass:[LoginVC class]]){
            [self.wxNavigationController popToViewController:obj animated:YES Completion:^{
            }];
        }
    }
}

-(void)resetNewPwdFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"重置密码失败";
    }
    [UtilTool showAlertView:errorMsg];
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

-(void)resignAllFirstResponder{
    [userPhoneTextfield resignFirstResponder];
    [pwdTextField resignFirstResponder];
}

-(void)textFieldDone:(WXUITextField*)textField{
    [userPhoneTextfield resignFirstResponder];
    [pwdTextField resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resignAllFirstResponder];
    [_model setDelegate:nil];
}

@end
