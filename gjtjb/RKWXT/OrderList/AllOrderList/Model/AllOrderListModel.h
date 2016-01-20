//
//  AllOrderListModel.h
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    OrderList_Type_All = 1,
    OrderList_Type_WaitPay,
    OrderList_Type_WaitSend,
    OrderList_Type_WaitReceive,
    OrderList_Type_HasDone,
}OrderList_Type;

@protocol AllOrderListModelDelegate;

@interface AllOrderListModel : NSObject
@property (nonatomic,assign) id<AllOrderListModelDelegate>delegate;
@property (nonatomic,strong) NSArray *orderList;

-(void)loadOrderList:(NSInteger)startItem andLength:(NSInteger)length type:(OrderList_Type)orderType;
@end

@protocol AllOrderListModelDelegate <NSObject>
-(void)loadAllOrderlistSucceed;
-(void)loadAllOrderlistFailed:(NSString*)errorMsg;

@end
