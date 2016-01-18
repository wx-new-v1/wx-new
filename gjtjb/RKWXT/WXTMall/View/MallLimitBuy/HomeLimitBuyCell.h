//
//  HomeLimitBuyCell.h
//  RKWXT
//
//  Created by SHB on 16/1/18.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol HomeLimitBuyCellDelegate;
@interface HomeLimitBuyCell : WXUITableViewCell
@property (nonatomic,assign)id<HomeLimitBuyCellDelegate>delegate;

@end

@protocol HomeLimitBuyCellDelegate <NSObject>
- (void)clickClassifyBtnAtIndex:(NSInteger)index;

@end
