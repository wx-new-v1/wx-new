//
//  HomeLimitBuyInfoCell.h
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol HomeLimitBuyInfoCellDelegate;

@interface HomeLimitBuyInfoCell : WXMiltiViewCell
@property (nonatomic,assign) id<HomeLimitBuyInfoCellDelegate>delegate;
@end

@protocol HomeLimitBuyInfoCellDelegate <NSObject>
-(void)homeLimitBuyCellbtnClicked:(id)sender;

@end
