//
//  NewResetPwdVC.m
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "NewResetPwdVC.h"

#define Size self.bounds.size

@interface NewResetPwdVC(){
    WXUITextField *userPhoneTextfield;
    WXUITextField *pwdTextField;
}
@end

@implementation NewResetPwdVC

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
    [userPhoneTextfield setTextColor:WXColorWithInteger(0xbababa)];
    [userPhoneTextfield setReturnKeyType:UIReturnKeyDone];
    [userPhoneTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    [userPhoneTextfield addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self addSubview:userPhoneTextfield];
    
    yOffset += height+8;
    pwdTextField = [[WXUITextField alloc] init];
    pwdTextField.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, height);
    [pwdTextField setBackgroundColor:WXColorWithInteger(0xffffff)];
    [pwdTextField setPlaceHolder:@" 请再次输入新密码" color:WXColorWithInteger(0xbababa)];
    [pwdTextField setTextColor:WXColorWithInteger(0xbababa)];
    [pwdTextField setReturnKeyType:UIReturnKeyDone];
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
    
}

-(void)textFieldDone:(WXUITextField*)textField{
    [textField resignFirstResponder];
}

@end
