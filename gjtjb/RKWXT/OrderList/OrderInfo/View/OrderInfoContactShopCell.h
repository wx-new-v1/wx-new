//
//  OrderInfoContactShopCell.h
//  RKWXT
//
//  Created by SHB on 16/1/21.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define OrderInfoContactShopCellHeight (54)

@protocol OrderInfoContactShopCellDelegate;

@interface OrderInfoContactShopCell : WXUITableViewCell
@property (nonatomic,assign) id<OrderInfoContactShopCellDelegate>delegate;
@end

@protocol OrderInfoContactShopCellDelegate <NSObject>
-(void)contactSellerWith:(NSString*)phone;
-(void)userRefundBtnClicked;

@end
