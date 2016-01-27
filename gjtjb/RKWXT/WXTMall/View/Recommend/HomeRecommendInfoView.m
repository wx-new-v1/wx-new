//
//  HomeRecommendInfoView.m
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomeRecommendInfoView.h"
#import "NewHomePageCommonDef.h"
#import "WXRemotionImgBtn.h"
#import "HomeRecommendInfoCell.h"
#import "HomePageRecEntity.h"

@interface HomeRecommendInfoView(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_newPriceLabel;
    WXUILabel *_oldPriceLabel;
    WXUILabel *_nameLabel;
}
@end

@implementation HomeRecommendInfoView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-4*10)/3;
        CGFloat bgHeight = T_HomePageRecommendHeight;
        WXUIButton *bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, bgWidth, bgHeight);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(recommendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat yOffset = 8;
        CGFloat imgWidth = 80;
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
        [_newPriceLabel setTextColor:WXColorWithInteger(0x000000)];
        [_newPriceLabel setFont:[UIFont systemFontOfSize:12.0]];
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
        lineLabel.frame = CGRectMake(xOffset, yOffset+nameLabelHeight/2, imgWidth-2*10+8, 0.5);
        [lineLabel setBackgroundColor:[UIColor grayColor]];
        [bgBtn addSubview:lineLabel];
        
        yOffset += nameLabelHeight+5;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, imgWidth, nameLabelHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [bgBtn addSubview:_nameLabel];
    }
    return self;
}

-(void)recommendBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[HomeRecommendInfoCell class]]);
    if(superView && [superView isKindOfClass:[HomeRecommendInfoCell class]]){
        HomeRecommendInfoCell *cell = (HomeRecommendInfoCell*)superView;
        id<HomeRecommendInfoCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(homeRecommendCellbtnClicked:)]){
            [delegate homeRecommendCellbtnClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
    HomePageRecEntity *entity = self.cpxViewInfo;
    [_imgView setCpxViewInfo:entity.home_img];
    [_imgView load];
    [_newPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",entity.shopPrice]];
    [_oldPriceLabel setText:[NSString stringWithFormat:@"原价:￥%.2f",entity.marketPrice]];
    [_nameLabel setText:entity.goods_name];
}

@end
