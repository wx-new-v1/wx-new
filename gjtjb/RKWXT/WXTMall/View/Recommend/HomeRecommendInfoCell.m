//
//  HomeRecommendInfoCell.m
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomeRecommendInfoCell.h"
#import "NewHomePageCommonDef.h"
#import "HomeRecommendInfoView.h"

#define xGap (10)
@implementation HomeRecommendInfoCell

- (NSInteger)xNumber{
    return RecommendShow;
}

- (CGFloat)cellHeight{
    return T_HomePageRecommendHeight;
}

- (CGFloat)sideGap{
    return xGap;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-4*xGap)/LimitBuyShow,T_HomePageRecommendHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    HomeRecommendInfoView *merchandiseView = [[HomeRecommendInfoView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end
