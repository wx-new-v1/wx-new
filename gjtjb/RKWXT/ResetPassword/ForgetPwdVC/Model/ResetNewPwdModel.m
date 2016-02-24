//
//  ResetNewPwdModel.m
//  RKWXT
//
//  Created by SHB on 15/7/8.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ResetNewPwdModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation ResetNewPwdModel

-(void)resetNewPwdWithUserPhone:(NSString *)phone withCode:(NSInteger)code withNewPwd:(NSString *)newPwd{
    NSString *pwdString = [UtilTool md5:newPwd];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:phone, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", pwdString, @"pwd", [NSNumber numberWithInt:userObj.smsID], @"rand_id", [NSNumber numberWithInteger:code], @"rcode", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", pwdString, @"pwd", [NSNumber numberWithInt:userObj.smsID], @"rand_id", [NSNumber numberWithInteger:code], @"rcode", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_ResetNewPwd httpMethod:WXT_HttpMethod_Post timeoutIntervcal:40 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(resetNewPwdFailed:)]){
                [_delegate resetNewPwdFailed:retData.errorDesc];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(resetNewPwdSucceed)]){
                [_delegate resetNewPwdSucceed];
            }
        }
    }];
}

@end