//
//  WXHomeBaseFunctionCell.m
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXHomeBaseFunctionCell.h"
#import "NewHomePageCommonDef.h"

#define ImgBtnHeight (T_HomePageBaseFunctionHeight-8)

@interface WXHomeBaseFunctionCell(){
    WXUIButton *bgImgBtn;
}
@end

@implementation WXHomeBaseFunctionCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        NSArray *textArr = @[@"免费抽奖",@"签到有奖",@"商家红包",@"邀请有奖",@"我信游戏",@"我的身边",@"我的提成",@"商家联盟"];
        NSArray *imgArr = @[@"HomePageSharkImg.png",@"HomePageSignImg.png",@"HomePageWallet.png",@"HomePageShareImg.png",@"HomePageGame.png",@"HomePageSide.png",@"HomePageCutImg.png",@"HomePageUnion.png"];
        NSInteger count = 0;
        for(NSInteger k = 0; k < 2; k++){
            for(NSInteger j = 0; j < 4; j++){
                WXUIButton *commonBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
                [commonBtn setBackgroundColor:[UIColor whiteColor]];
                commonBtn.frame = CGRectMake(j*(Size.width/4), k==1?ImgBtnHeight/2:0, Size.width/4, ImgBtnHeight/2);
                [commonBtn setBorderRadian:0 width:1 color:[UIColor clearColor]];
                commonBtn.tag = ++count;
                [commonBtn setImage:[UIImage imageNamed:imgArr[j+(k==1?4:0)]] forState:UIControlStateNormal];
                [commonBtn setTitle:textArr[j+(k==1?4:0)] forState:UIControlStateNormal];
                [commonBtn setTitleColor:WXColorWithInteger(0x414141) forState:UIControlStateNormal];
                [commonBtn.titleLabel setFont:WXFont(11.0)];
                [commonBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:commonBtn];
                
                
                CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(commonBtn.bounds), CGRectGetMidY(commonBtn.bounds));
                CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(commonBtn.imageView.bounds));
                CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(commonBtn.bounds)-CGRectGetMidY(commonBtn.titleLabel.bounds));
                CGPoint startImageViewCenter = commonBtn.imageView.center;
                CGPoint startTitleLabelCenter = commonBtn.titleLabel.center;
                CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
                CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
                commonBtn.imageEdgeInsets = UIEdgeInsetsMake(0, imageEdgeInsetsLeft, 12, imageEdgeInsetsRight);
                CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
                CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
                commonBtn.titleEdgeInsets = UIEdgeInsetsMake(ImgBtnHeight/2-12, titleEdgeInsetsLeft, 0, titleEdgeInsetsRight);
            }
        }
        
        WXUILabel *lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(0, T_HomePageBaseFunctionHeight-0.1, Size.width, 0.1);
        [lineLabel setBackgroundColor:WXColorWithInteger(0x999999)];
        [self.contentView addSubview:lineLabel];
    }
    return self;
}

-(void)buttonClicked:(id)sender{
    WXUIButton *btn = (WXUIButton*)sender;
    NSInteger tag = btn.tag;
    T_BaseFunction t_baseFunction = T_BaseFunction_Init;
    switch (tag) {
        case 1:
            t_baseFunction = T_BaseFunction_Shark;
            break;
        case 2:
            t_baseFunction = T_BaseFunction_Sign;
            break;
        case 3:
            t_baseFunction = T_BaseFunction_Wallet;
            break;
        case 4:
            t_baseFunction = T_BaseFunction_Invate;
            break;
        case 5:
            t_baseFunction = T_BaseFunction_Game;
            break;
        case 6:
            t_baseFunction = T_BaseFunction_Side;
            break;
        case 7:
            t_baseFunction = T_BaseFunction_Cut;
            break;
        case 8:
            t_baseFunction = T_BaseFunction_Union;
            break;
        default:
            break;
    }
    if(_delegate && [_delegate respondsToSelector:@selector(wxHomeBaseFunctionBtnClickedAtIndex:)]){
        [_delegate wxHomeBaseFunctionBtnClickedAtIndex:t_baseFunction];
    }
}

@end
