//
//  HangupModel.m
//  RKWXT
//
//  Created by SHB on 15/4/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HangupModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation HangupModel

-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}

-(void)hangupWithCallID:(NSString *)swCallID{
    if(!swCallID){
        return;
    }
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", swCallID, @"sw_call_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", swCallID, @"sw_call_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_HungUp httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != 0){
            if (_hangupDelegate && [_hangupDelegate respondsToSelector:@selector(hangupFailed:)]){
                [_hangupDelegate hangupFailed:retData.errorDesc];
            }
        }else{
            if (_hangupDelegate && [_hangupDelegate respondsToSelector:@selector(hangupSucceed)]){
                [_hangupDelegate hangupSucceed];
            }
        }
    }];
}

@end

