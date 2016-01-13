//
//  ResetPwdModel.m
//  RKWXT
//
//  Created by SHB on 15/3/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ResetPwdModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation ResetPwdModel

-(void)resetPwdWithNewPwd:(NSString *)newPwd{
    if(!newPwd){
        return;
    }
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSString *pwdString = [UtilTool md5:newPwd];
    NSString *oldPwd = [UtilTool md5:userObj.pwd];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", oldPwd, @"opwd", pwdString, @"npwd", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", oldPwd, @"opwd", pwdString, @"npwd", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_ResetPwd httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(resetPwdFailed:)]){
                [_delegate resetPwdFailed:retData.errorDesc];
            }
        }else{
            [userObj setPwd:newPwd];
            if (_delegate && [_delegate respondsToSelector:@selector(resetPwdSucceed)]){
                [_delegate resetPwdSucceed];
            }
        }
    }];
}

@end
