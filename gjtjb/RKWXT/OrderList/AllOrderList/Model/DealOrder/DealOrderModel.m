//
//  DealOrderModel.m
//  RKWXT
//
//  Created by SHB on 16/1/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "DealOrderModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "AllOrderListEntity.h"

@implementation DealOrderModel

+(DealOrderModel*)shareOrderDealModel{
    static dispatch_once_t onceToken;
    static DealOrderModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[DealOrderModel alloc] init];
    });
    return sharedInstance;
}

//取消订单
-(void)cancelUserOrder:(NSInteger)orderID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSString *orderIDStr = [NSString stringWithFormat:@"%ld",(long)orderID];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", orderIDStr, @"order_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", orderIDStr, @"order_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_CancelOrder httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserOderList_CancelFailed object:retData.errorDesc];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserOderList_CancelSucceed object:orderIDStr];
        }
    }];
}

-(void)completeUserOrder:(NSInteger)orderID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSString *orderIDStr = [NSString stringWithFormat:@"%ld",(long)orderID];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", orderIDStr, @"order_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", orderIDStr, @"order_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_CompleteOrder httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserOderList_CompleteFailed object:retData.errorDesc];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserOderList_CompleteSucceed object:orderIDStr];
        }
    }];
}

@end
