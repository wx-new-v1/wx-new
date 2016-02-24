//
//  RechargeModel.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RechargeModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation RechargeModel

-(void)rechargeWithCardNum:(NSString *)num andPwd:(NSString *)pwd phone:(NSString *)rechargePhone{
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userDefault.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userDefault.wxtID, @"woxin_id", num, @"card_id", pwd, @"card_pwd", rechargePhone, @"recharge_phone", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userDefault.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userDefault.wxtID, @"woxin_id", num, @"card_id", pwd, @"card_pwd", rechargePhone, @"recharge_phone", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_Recharge httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(rechargeFailed:)]){
                [_delegate rechargeFailed:retData.errorDesc];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(rechargeSucceed)]){
                [_delegate rechargeSucceed];
            }
        }
    }];
}

@end
