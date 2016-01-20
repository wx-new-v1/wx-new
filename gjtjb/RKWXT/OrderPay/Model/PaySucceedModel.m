//
//  PaySucceedModel.m
//  RKWXT
//
//  Created by SHB on 15/7/14.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "PaySucceedModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation PaySucceedModel

+(PaySucceedModel*)sharePaySucceed{
    static dispatch_once_t onceToken;
    static PaySucceedModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[PaySucceedModel alloc] init];
    });
    return sharedInstance;
}

-(void)updataPayOrder:(Pay_Type)type withOrderID:(NSString*)orderID{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.wxtID, @"woxin_id", userObj.user, @"phone", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [NSNumber numberWithInt:(int)type], @"type", orderID, @"order_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.wxtID, @"woxin_id", userObj.user, @"phone", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [NSNumber numberWithInt:(int)type], @"type", orderID, @"order_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_UpdapaOrderID httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code == 0){
            NSLog(@"通知支付状态:%@",[retData.data objectForKey:@"data"]);
        }
    }];
}

@end
