//
//  UserQuestionModel.m
//  RKWXT
//
//  Created by SHB on 16/1/21.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserQuestionModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation UserQuestionModel

-(void)submitUserQuestion:(NSString *)question phone:(NSString *)userPhone{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userPhone, @"qphone", question, @"question", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userPhone, @"qphone", question, @"question", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_UserQuestion httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(submitUserQuestionFailed:)]){
                [_delegate submitUserQuestionFailed:retData.errorDesc];
            }
        }else{
            if(_delegate && [_delegate respondsToSelector:@selector(submitUserQuestionSucceed)]){
                [_delegate submitUserQuestionSucceed];
            }
        }
    }];
}

@end
