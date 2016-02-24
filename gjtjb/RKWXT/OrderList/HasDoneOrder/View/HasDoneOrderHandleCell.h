//
//  HasDoneOrderHandleCell.h
//  RKWXT
//
//  Created by SHB on 16/1/21.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define HasDoneOrderHandleCellHeight (40)

@protocol HasDoneOrderHandleCellDelegate;
@interface HasDoneOrderHandleCell : WXUITableViewCell
@property (nonatomic,assign) id<HasDoneOrderHandleCellDelegate>delegate;
@end

@protocol HasDoneOrderHandleCellDelegate <NSObject>
-(void)userEvaluateOrder:(id)sender;

@end
