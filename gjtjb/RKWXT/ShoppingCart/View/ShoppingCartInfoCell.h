//
//  ShoppingCartInfoCell.h
//  RKWXT
//
//  Created by SHB on 16/1/19.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol deleteStoreGoods;

@interface ShoppingCartInfoCell : WXUITableViewCell
@property (nonatomic,assign) id<deleteStoreGoods>delegate;
-(void)setGoodsInfo:(id)entity;
-(void)selectAllGoods:(BOOL)selectAll;
@end

@protocol deleteStoreGoods <NSObject>
-(void)goodsImgBtnClicked:(NSInteger)goodsID;
-(void)deleteGoods:(NSInteger)cart_id;
-(void)selectGoods;
-(void)cancelGoods;
-(void)minusBtnClicked;
-(void)plusBtnClicked;

@end
