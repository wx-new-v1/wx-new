//
//  ForgetModel.m
//  RKWXT
//
//  Created by SHB on 15/7/8.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ForgetModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation ForgetModel

-(void)forgetPwdWithUserPhone:(NSString *)phone{
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:phone, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [NSNumber numberWithInt:2], @"type", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [NSNumber numberWithInt:2], @"type", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_Code httpMethod:WXT_HttpMethod_Post timeoutIntervcal:40 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(forgetPwdFailed:)]){
                [_delegate forgetPwdFailed:retData.errorDesc];
            }
        }else{
            WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
            [userObj setSmsID:[[[retData.data objectForKey:@"data"] objectForKey:@"rand_id"] integerValue]];
            if (_delegate && [_delegate respondsToSelector:@selector(forgetPwdSucceed)]){
                [_delegate forgetPwdSucceed];
            }
        }
    }];
}

@end