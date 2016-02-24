//
//  WaitReceiveOrderHandleCell.h
//  RKWXT
//
//  Created by SHB on 16/1/21.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define WaitPayOrderHandleCellHeight (40)

@protocol WaitReceiveOrderHandleCellDelegate;
@interface WaitReceiveOrderHandleCell : WXUITableViewCell
@property (nonatomic,assign) id<WaitReceiveOrderHandleCellDelegate>delegate;
@end

@protocol WaitReceiveOrderHandleCellDelegate <NSObject>
-(void)userRefundOrder:(id)sender;
-(void)userCompleteOrder:(id)sender;

@end
