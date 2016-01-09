//
//  HomeLimitBuyInfoView.m
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomeLimitBuyInfoView.h"
#import "NewHomePageCommonDef.h"
#import "WXRemotionImgBtn.h"
#import "HomeLimitBuyInfoCell.h"

@interface HomeLimitBuyInfoView(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_newPriceLabel;
    WXUILabel *_oldPriceLabel;
    WXUILabel *_nameLabel;
}
@end

@implementation HomeLimitBuyInfoView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-4*10)/3;
        CGFloat bgHeight = T_HomePageLimitBuyHeight;
        WXUIButton *bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, bgWidth, bgHeight);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(forMeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat yOffset = 8;
        CGFloat imgWidth = 90;
        CGFloat imgHeight = imgWidth;
        CGFloat xOffset = (bgWidth-imgWidth)/2;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [bgBtn addSubview:_imgView];
        
        yOffset += imgHeight+7;
        CGFloat nameLabelHeight = 10;
        _newPriceLabel = [[WXUILabel alloc] init];
        _newPriceLabel.frame = CGRectMake(xOffset, yOffset, imgWidth, nameLabelHeight);
        [_newPriceLabel setBackgroundColor:[UIColor clearColor]];
        [_newPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [_newPriceLabel setTextColor:WXColorWithInteger(AllBaseColor)];
        [_newPriceLabel setFont:[UIFont systemFontOfSize:10.0]];
        [bgBtn addSubview:_newPriceLabel];
        
        yOffset += nameLabelHeight+5;
        _oldPriceLabel = [[WXUILabel alloc] init];
        _oldPriceLabel.frame = CGRectMake(xOffset, yOffset, imgWidth, nameLabelHeight);
        [_oldPriceLabel setBackgroundColor:[UIColor clearColor]];
        [_oldPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [_oldPriceLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [_oldPriceLabel setFont:[UIFont systemFontOfSize:10.0]];
        [bgBtn addSubview:_oldPriceLabel];
        
        WXUILabel *lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(xOffset+5, yOffset+nameLabelHeight/2, imgWidth-2*10, 0.5);
        [lineLabel setBackgroundColor:[UIColor grayColor]];
        [bgBtn addSubview:lineLabel];
    }
    return self;
}

-(void)forMeBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[HomeLimitBuyInfoCell class]]);
    if(superView && [superView isKindOfClass:[HomeLimitBuyInfoCell class]]){
        HomeLimitBuyInfoCell *cell = (HomeLimitBuyInfoCell*)superView;
        id<HomeLimitBuyInfoCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(homeLimitBuyCellbtnClicked:)]){
            [delegate homeLimitBuyCellbtnClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
//    TimeShopData *entity = self.cpxViewInfo;
//    [_imgView setCpxViewInfo:entity.goods_home_img];
//    [_imgView load];
//    [_newPriceLabel setText:[NSString stringWithFormat:@"抢购价:￥%.2f",0];
//    [_oldPriceLabel setText:[NSString stringWithFormat:@"原价:￥%.2f",0];
}

@end
