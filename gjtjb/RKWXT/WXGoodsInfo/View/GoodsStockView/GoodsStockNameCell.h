//
//  GoodsStockNameCell.h
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define GoodsStockNameCellHeight (40)

@protocol GoodsStockNameCellDelegate;

@interface GoodsStockNameCell : WXUITableViewCell
@property (nonatomic,assign) id<GoodsStockNameCellDelegate>delegate;
@end

@protocol GoodsStockNameCellDelegate <NSObject>
-(void)goodsStockNameBtnClicked:(id)sender;

@end
