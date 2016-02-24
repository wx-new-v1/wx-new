//
//  OrderListCommonDef.h
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#ifndef OrderListCommonDef_h
#define OrderListCommonDef_h

#define K_Notification_Name_JumpToOrderInfo    @"K_Notification_Name_JumpToOrderInfo"
#define K_Notification_Name_JumpToPay          @"K_Notification_Name_JumpToPay"
#define K_Notification_Name_JumpToEvaluate     @"K_Notification_Name_JumpToEvaluate"
#define K_Notification_Name_RefundSucceed      @"K_Notification_Name_RefundSucceed"
#define K_Notification_Name_JumpToShopInfo     @"K_Notification_Name_JumpToShopInfo"

enum{
    OrderList_All = 0,
    OrderList_Wait_Pay,
    OrderList_Wait_Send,
    OrderList_Wait_Receive,
    OrderList_Wait_HasDone,
    
    OrderList_Invalid
};

#import "AllOrderListVC.h"
#import "WaitPayOrderVC.h"
#import "WaitSendOrderVC.h"
#import "WaitReceiveOrderVC.h"
#import "OrderHasDoneVC.h"

#import "AllOrderListEntity.h"

#import "OrderPayVC.h"
#import "OrderInfoVC.h"

#endif /* OrderListCommonDef_h */
