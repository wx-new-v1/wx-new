//
//  GoodsInfoDesCell.h
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define GoodsInfoDesCellHeight (73)

@protocol GoodsInfoDesCellDelegate;
@interface GoodsInfoDesCell : WXUITableViewCell
@property (nonatomic,assign) id<GoodsInfoDesCellDelegate>delegate;
@property (nonatomic,assign) BOOL userCut;

@end

@protocol GoodsInfoDesCellDelegate <NSObject>
-(void)goodsInfoDesCutBtnClicked;
-(void)goodsInfoDesCarriageBtnClicked;

@end
