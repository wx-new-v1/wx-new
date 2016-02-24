//
//  WaitPayOrderHandleCell.h
//  RKWXT
//
//  Created by SHB on 16/1/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define WaitPayOrderHandleCellHeight (40)

@protocol WaitPayOrderHandleCellDelegate;
@interface WaitPayOrderHandleCell : WXUITableViewCell
@property (nonatomic,assign) id<WaitPayOrderHandleCellDelegate>delegate;
@end

@protocol WaitPayOrderHandleCellDelegate <NSObject>
-(void)userCancelOrder:(id)sender;
-(void)userPayOrder:(id)sender;

@end
