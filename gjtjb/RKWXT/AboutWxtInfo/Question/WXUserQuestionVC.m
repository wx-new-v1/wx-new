//
//  WXUserQuestionVC.m
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUserQuestionVC.h"

#define Size self.bounds.size

@interface WXUserQuestionVC()<WXUITextViewDelegate>{
    WXUIView *baseView;
}
@end

@implementation WXUserQuestionVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"意见反馈"];
    [self setBackgroundColor:[UIColor grayColor]];
    
    [self createUpBaseView];
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
    [webBtn setTitle:@"http://www.67call.com" forState:UIControlStateNormal];
    [webBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
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
    [phoneBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
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
    [baseView setBackgroundColor:[UIColor grayColor]];
    [self addSubview:baseView];
    
    CGFloat xOffset = 17;
    CGFloat textViewHeight = 150;
    WXUITextView *_textView = [[WXUITextView alloc] init];
    _textView.frame = CGRectMake(xOffset, 0, Size.width-2*xOffset, textViewHeight);
    [_textView setBackgroundColor:WXColorWithInteger(0xffffff)];
    [_textView setPlaceholder:@"请输入您的问题和建议 (必填*)"];
    [_textView setPlaceholderColor:WXColorWithInteger(0xb8b8b8)];
    [_textView setTextAlignment:NSTextAlignmentLeft];
    [_textView setFont:WXFont(14.0)];
    [_textView setWxDelegate:self];
    [baseView addSubview:_textView];
    
    yOffset += textViewHeight+10;
    WXUITextField *userPhoneTextfield = [[WXUITextField alloc] init];
    userPhoneTextfield.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, BaseViewHeight-yOffset);
    [userPhoneTextfield setBackgroundColor:WXColorWithInteger(0xffffff)];
    [userPhoneTextfield setPlaceholder:@"请留下您的手机号，方便我们和您沟通联系.(必填*)"];
    [userPhoneTextfield setReturnKeyType:UIReturnKeyDone];
    [userPhoneTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    [userPhoneTextfield addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [userPhoneTextfield addTarget:self action:@selector(textFieldStartInput) forControlEvents:UIControlEventEditingDidBegin];
    [baseView addSubview:userPhoneTextfield];
    
    yOffset += (BaseViewHeight-yOffset);
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
    
    yOffset += nameHeght+5;
    WXUILabel *desLabel = [[WXUILabel alloc] init];
    desLabel.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, 2*nameHeght);
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
    
}

#pragma mark phone
-(void)phoneBtnClicked{
    
}

-(void)lineBtnClicked{
    
}

#pragma mark submit
-(void)submitUserQuestion{
    
}

#pragma mark textField
-(void)wxTextViewDidBeginEditing:(WXUITextView *)textView{
    [UIView animateWithDuration:0.8 animations:^{
        CGRect rect = baseView.frame;
        rect.origin.y -= 80;
        baseView.frame = rect;
    }];
}

-(void)wxTextViewDidEndEditing:(WXUITextView *)textView{
    [UIView animateWithDuration:0.8 animations:^{
        CGRect rect = baseView.frame;
        rect.origin.y += 80;
        baseView.frame = rect;
    }];
}

-(void)textFieldStartInput{
    [UIView animateWithDuration:0.8 animations:^{
        CGRect rect = baseView.frame;
        rect.origin.y -= 80;
        baseView.frame = rect;
    }];
}

-(void)textFieldDone:(WXUITextField*)textField{
    [textField resignFirstResponder];
    
    [UIView animateWithDuration:0.8 animations:^{
        CGRect rect = baseView.frame;
        rect.origin.y += 80;
        baseView.frame = rect;
    }];
}

@end
