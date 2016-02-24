//
//  HomeLimitBuyInfoCell.m
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomeLimitBuyInfoCell.h"
#import "NewHomePageCommonDef.h"
#import "HomeLimitBuyInfoView.h"

#define xGap (10)

@implementation HomeLimitBuyInfoCell

- (NSInteger)xNumber{
    return LimitBuyShow;
}

- (CGFloat)cellHeight{
    return T_HomePageLimitBuyHeight;
}

- (CGFloat)sideGap{
    return xGap;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-4*xGap)/LimitBuyShow,T_HomePageLimitBuyHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    HomeLimitBuyInfoView *merchandiseView = [[HomeLimitBuyInfoView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end
