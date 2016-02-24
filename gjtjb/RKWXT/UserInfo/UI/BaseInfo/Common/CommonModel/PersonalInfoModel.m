//
//  PersonalInfoModel.m
//  RKWXT
//
//  Created by SHB on 15/7/20.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "PersonalInfoModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "PersonalInfoEntity.h"

@interface PersonalInfoModel(){
    NSMutableArray *_personalInfoArr;
}
@end

@implementation PersonalInfoModel
@synthesize personalInfoArr = _personalInfoArr;

-(id)init{
    self = [super init];
    if(self){
        _personalInfoArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)updataUserInfoWith:(NSInteger)sex withNickName:(NSString *)nickName withBirthday:(NSString *)birStr{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:_type], @"type", [NSNumber numberWithInteger:sex], @"sex", birStr, @"birthday", nickName, @"nickname", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:_type], @"type", [NSNumber numberWithInteger:sex], @"sex", birStr, @"birthday", nickName, @"nickname", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_PersonalInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(updataPersonalInfoFailed:)]){
                [_delegate updataPersonalInfoFailed:retData.errorDesc];
            }
        }else{
            WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
            [userDefault setNickname:nickName];
            [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_UploadUserInfo object:nil];
            if(_delegate && [_delegate respondsToSelector:@selector(updataPersonalInfoSucceed)]){
                [_delegate updataPersonalInfoSucceed];
            }
        }
    }];
}


#pragma mark loadPersonalInfo
-(void)parsePersonalInfo:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_personalInfoArr removeAllObjects];
    PersonalInfoEntity *entity = [PersonalInfoEntity initWithPersonalInfoWith:dic];
    [_personalInfoArr addObject:entity];
}

-(void)loadUserInfo{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:_type], @"type", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:_type], @"type", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block PersonalInfoModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_PersonalInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadPersonalInfoFainled:)]){
                [_delegate loadPersonalInfoFainled:retData.errorDesc];
            }
        }else{
            [blockSelf parsePersonalInfo:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadPersonalInfoSucceed)]){
                [_delegate loadPersonalInfoSucceed];
            }
        }
    }];
}

@end
