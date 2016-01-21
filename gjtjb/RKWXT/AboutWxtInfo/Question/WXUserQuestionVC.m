//
//  WXUserQuestionVC.m
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUserQuestionVC.h"
#import "CallBackVC.h"
#import "UserQuestionModel.h"

#define Size self.bounds.size

@interface WXUserQuestionVC()<WXUITextViewDelegate,UIActionSheetDelegate,UserQuestionModelDelegate>{
    WXUIView *baseView;
    WXUITextField *userPhoneTextfield;
    WXUITextView *_textView;
    
    NSString *shopPhone;
    
    UserQuestionModel *_model;
}
@end

@implementation WXUserQuestionVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[UserQuestionModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"意见反馈"];
    [self setBackgroundColor:WXColorWithInteger(0xf0f0f0)];
    
    [self createUpBaseView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoardDur:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)createUpBaseView{
    CGFloat xOffset = 17;
    CGFloat yOffset = 14;
    CGFloat textLabelWidth = 72;
    CGFloat textLabelHeight = 14;
    WXUILabel *webLabel = [[WXUILabel alloc] init];
    webLabel.frame = CGRectMake(xOffset, yOffset, textLabelWidth, textLabelHeight);
    [webLabel setBackgroundColor:[UIColor clearColor]];
    [webLabel setText:@"我们的网址:"];
    [webLabel setTextAlignment:NSTextAlignmentLeft];
    [webLabel setTextColor:WXColorWithInteger(0x000000)];
    [webLabel setFont:WXFont(12.0)];
    [self addSubview:webLabel];
    
    CGFloat btnWidth = 160;
    CGFloat btnHeight = textLabelHeight;
    WXUIButton *webBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    webBtn.frame = CGRectMake(xOffset+textLabelWidth, yOffset, btnWidth, btnHeight);
    webBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [webBtn setTitle:@"http://www.67call.com" forState:UIControlStateNormal];
    [webBtn.titleLabel setFont:WXFont(12.0)];
    [webBtn setTitleColor:WXColorWithInteger(0x000000) forState:UIControlStateNormal];
    [webBtn addTarget:self action:@selector(webBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:webBtn];
    
    yOffset += textLabelHeight+3;
    WXUILabel *phoneNum = [[WXUILabel alloc] init];
    phoneNum.frame = CGRectMake(xOffset, yOffset, textLabelWidth, textLabelHeight);
    [phoneNum setBackgroundColor:[UIColor clearColor]];
    [phoneNum setText:@"客 服 电 话:"];
    [phoneNum setTextAlignment:NSTextAlignmentLeft];
    [phoneNum setTextColor:WXColorWithInteger(0x000000)];
    [phoneNum setFont:WXFont(12.0)];
    [self addSubview:phoneNum];
    
    WXUIButton *phoneBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.frame = CGRectMake(xOffset+textLabelWidth, yOffset, btnWidth, btnHeight);
    [phoneBtn setTitle:@"0755-61665888" forState:UIControlStateNormal];
    phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [phoneBtn.titleLabel setFont:WXFont(12.0)];
    [phoneBtn setTitleColor:WXColorWithInteger(0x000000) forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(phoneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:phoneBtn];
    
    yOffset += textLabelHeight+3;
    WXUILabel *lineNum = [[WXUILabel alloc] init];
    lineNum.frame = CGRectMake(xOffset, yOffset, textLabelWidth, textLabelHeight);
    [lineNum setBackgroundColor:[UIColor clearColor]];
    [lineNum setText:@"在 线 反 馈:"];
    [lineNum setTextAlignment:NSTextAlignmentLeft];
    [lineNum setTextColor:WXColorWithInteger(0x000000)];
    [lineNum setFont:WXFont(12.0)];
    [self addSubview:lineNum];
    
    WXUIButton *lineBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    lineBtn.frame = CGRectMake(xOffset+textLabelWidth, yOffset, btnWidth, btnHeight);
    [lineBtn setTitle:@"0755-82599860" forState:UIControlStateNormal];
    [lineBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    lineBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [lineBtn.titleLabel setFont:WXFont(12.0)];
    [lineBtn setTitleColor:WXColorWithInteger(0x000000) forState:UIControlStateNormal];
    [lineBtn addTarget:self action:@selector(lineBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lineBtn];
    
    yOffset += textLabelHeight+10;
    [self createTextfieldView:yOffset];
}

-(void)createTextfieldView:(CGFloat)yOffset{
    CGFloat BaseViewHeight = 200;
    baseView = [[WXUIView alloc] init];
    baseView.frame = CGRectMake(0, yOffset, Size.width, BaseViewHeight);
    [baseView setBackgroundColor:WXColorWithInteger(0xf0f0f0)];
    [self addSubview:baseView];
    
    CGFloat xOffset = 17;
    CGFloat textViewHeight = 150;
    _textView = [[WXUITextView alloc] init];
    _textView.frame = CGRectMake(xOffset, 0, Size.width-2*xOffset, textViewHeight);
    [_textView setBackgroundColor:WXColorWithInteger(0xffffff)];
    [_textView setPlaceholder:@"请输入您的问题和建议 (必填*)"];
    [_textView setPlaceholderColor:WXColorWithInteger(0xbababa)];
    [_textView setTextColor:WXColorWithInteger(0xbababa)];
    [_textView setTextAlignment:NSTextAlignmentLeft];
    [_textView setFont:WXFont(11.0)];
    [_textView setWxDelegate:self];
    [baseView addSubview:_textView];
    
    userPhoneTextfield = [[WXUITextField alloc] init];
    userPhoneTextfield.frame = CGRectMake(xOffset, textViewHeight+10, Size.width-2*xOffset, BaseViewHeight-textViewHeight-10);
    [userPhoneTextfield setBackgroundColor:WXColorWithInteger(0xffffff)];
    [userPhoneTextfield setPlaceHolder:@" 请留下您的手机号，方便我们和您沟通联系.(必填*)" color:WXColorWithInteger(0xbababa)];
    [userPhoneTextfield setTextColor:WXColorWithInteger(0xbababa)];
    [userPhoneTextfield setReturnKeyType:UIReturnKeyDone];
    [userPhoneTextfield setFont:WXFont(11.0)];
    [userPhoneTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    [userPhoneTextfield addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [userPhoneTextfield addTarget:self action:@selector(textFieldStartInput) forControlEvents:UIControlEventEditingDidBegin];
    [baseView addSubview:userPhoneTextfield];
    
    yOffset += BaseViewHeight;
    [self createSubmitBtn:yOffset];
}

-(void)createSubmitBtn:(CGFloat)yOffset{
    CGFloat yGap = 12;
    CGFloat xOffset = 14;
    CGFloat btnWidth = 100;
    CGFloat btnHieght = 37;
    
    yOffset += yGap;
    WXUIButton *submitBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(Size.width-xOffset-btnWidth, yOffset, btnWidth, btnHieght);
    [submitBtn setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitUserQuestion) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitBtn];
    
    [self createDownView:yOffset+btnHieght];
}

-(void)createDownView:(CGFloat)yOffset{
    yOffset += 40;
    CGFloat xOffset = 14;
    CGFloat nameWidth = 120;
    CGFloat nameHeght = 18;
    WXUILabel *nameLabel = [[WXUILabel alloc] init];
    nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeght);
    [nameLabel setText:@"温馨提示:"];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setTextColor:WXColorWithInteger(0x000000)];
    [nameLabel setFont:WXFont(14.0)];
    [self addSubview:nameLabel];
    
    yOffset += nameHeght+3;
    WXUILabel *desLabel = [[WXUILabel alloc] init];
    desLabel.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, 40);
    [desLabel setBackgroundColor:[UIColor clearColor]];
    [desLabel setText:@"我们将在收到您的意见反馈后1-3个工作日内与您取得联系，请保持您的手机通讯畅通。"];
    [desLabel setTextAlignment:NSTextAlignmentLeft];
    [desLabel setTextColor:WXColorWithInteger(0x000000)];
    [desLabel setFont:WXFont(12.0)];
    [desLabel setNumberOfLines:0];
    [self addSubview:desLabel];
}

#pragma mark web
-(void)webBtnClicked{
    NSString *wbUrl = @"www.67call.com";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",wbUrl]]];
}

#pragma mark phone
-(void)phoneBtnClicked{
    NSString *phoneStr = [self phoneWithoutNumber:@"0755-61665888"];
    shopPhone = phoneStr;
    [self showAlertView:shopPhone];
}

-(void)lineBtnClicked{
    NSString *phoneStr = [self phoneWithoutNumber:@"0755-82599860"];
    shopPhone = phoneStr;
    [self showAlertView:shopPhone];
}

-(void)showAlertView:(NSString*)phone{
    NSString *title = [NSString stringWithFormat:@"联系商家:%@",phone];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:title
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:[NSString stringWithFormat:@"使用%@",kMerchantName]
                                  otherButtonTitles:@"系统", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex > 2){
        return;
    }
    if(shopPhone.length == 0){
        return;
    }
    if(buttonIndex == 1){
        [UtilTool callBySystemAPI:shopPhone];
        return;
    }
    if(buttonIndex == 0){
        CallBackVC *backVC = [[CallBackVC alloc] init];
        backVC.phoneName = kMerchantName;
        if([backVC callPhone:shopPhone]){
            [self presentViewController:backVC animated:YES completion:^{
            }];
        }
    }
}

-(NSString*)phoneWithoutNumber:(NSString*)phone{
    NSString *new = [[NSString alloc] init];
    for(NSInteger i = 0; i < phone.length; i++){
        char c = [phone characterAtIndex:i];
        if(c >= '0' && c <= '9'){
            new = [new stringByAppendingString:[NSString stringWithFormat:@"%c",c]];
        }
    }
    return new;
}

#pragma mark submit
-(void)submitUserQuestion{
    if(_textView.text.length == 0){
        [UtilTool showAlertView:@"请输入您的问题或建议"];
        return;
    }
    if(_textView.text.length > 255){
        [UtilTool showAlertView:@"请控制在255字以内"];
        return;
    }
    if(![self checkUserValide]){
        return;
    }
    [_model submitUserQuestion:_textView.text phone:userPhoneTextfield.text];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)submitUserQuestionSucceed{
    [self unShowWaitView];
    [UtilTool showTipView:@"感谢您的反馈!"];
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)submitUserQuestionFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"提交反馈信息失败";
    }
    [UtilTool showAlertView:errorMsg];
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

#pragma mark textField
-(void)wxTextViewDidBeginEditing:(WXUITextView *)textView{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = baseView.frame;
        rect.origin.y = 10;
        baseView.frame = rect;
    }];
}

-(void)wxTextViewDidEndEditing:(WXUITextView *)textView{
}

-(void)textFieldStartInput{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = baseView.frame;
        rect.origin.y = 10;
        baseView.frame = rect;
    }];
}

-(void)textFieldDone:(WXUITextField*)textField{
}

- (void)hideKeyBoardDur:(CGFloat)dur{
    [userPhoneTextfield resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = baseView.frame;
        rect.origin.y = 72;
        baseView.frame = rect;
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
