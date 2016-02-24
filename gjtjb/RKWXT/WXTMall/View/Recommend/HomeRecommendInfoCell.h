//
//  HomeRecommendInfoCell.h
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol HomeRecommendInfoCellDelegate;

@interface HomeRecommendInfoCell : WXMiltiViewCell
@property (nonatomic,assign) id<HomeRecommendInfoCellDelegate>delegate;
@end

@protocol HomeRecommendInfoCellDelegate <NSObject>
-(void)homeRecommendCellbtnClicked:(id)sender;

@end
