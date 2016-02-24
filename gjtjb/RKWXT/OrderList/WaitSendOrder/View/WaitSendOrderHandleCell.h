//
//  WaitSendOrderHandleCell.h
//  RKWXT
//
//  Created by SHB on 16/1/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define WaitSendOrderHandleCellHeight (40)

@protocol WaitSendOrderHandleCellDelegate;
@interface WaitSendOrderHandleCell : WXUITableViewCell
@property (nonatomic,assign) id<WaitSendOrderHandleCellDelegate>delegate;
@end

@protocol WaitSendOrderHandleCellDelegate <NSObject>
-(void)userRefundOrder:(id)sender;

@end
