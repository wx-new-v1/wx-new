//
//  DealOrderModel.h
//  RKWXT
//
//  Created by SHB on 16/1/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define K_Notification_UserOderList_LoadSucceed  @"K_Notification_UserOderList_LoadSucceed"
#define K_Notification_UserOderList_LoadFailed   @"K_Notification_UserOderList_LoadFailed"

#define K_Notification_UserOderList_CancelSucceed @"K_Notification_UserOderList_CancelSucceed"
#define K_Notification_UserOderList_CancelFailed  @"K_Notification_UserOderList_CancelFailed"

#define K_Notification_UserOderList_CompleteSucceed @"K_Notification_UserOderList_CompleteSucceed"
#define K_Notification_UserOderList_CompleteFailed  @"K_Notification_UserOderList_CompleteFailed"

#define K_Notification_UserOderList_RefundSucceed @"K_Notification_UserOderList_RefundSucceed"
#define K_Notification_UserOderList_RefundFailed  @"K_Notification_UserOderList_RefundFailed"

@interface DealOrderModel : NSObject
@property (nonatomic,strong) NSString *orderID;  //临时记录，以备支付用

+(DealOrderModel*)shareOrderDealModel;
-(void)cancelUserOrder:(NSInteger)orderID;
-(void)completeUserOrder:(NSInteger)orderID;

@end
