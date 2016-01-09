//
//  AllOrderListHandleCell.h
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define AllOrderListHandleCellHeight (40)

@protocol AllOrderListHandleCellDelegate;
@interface AllOrderListHandleCell : WXUITableViewCell
@property (nonatomic,assign) id<AllOrderListHandleCellDelegate>delegate;
@end

@protocol AllOrderListHandleCellDelegate <NSObject>
-(void)userCancelOrder:(id)sender;
-(void)userPayOrder:(id)sender;
-(void)userCompleteOrder:(id)sender;
-(void)userEvaluateOrder:(id)sender;

@end
