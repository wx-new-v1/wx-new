//
//  AllAreaDataModel.m
//  RKWXT
//
//  Created by SHB on 16/1/8.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "AllAreaDataModel.h"
#import "LoadAreaModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface AllAreaDataModel(){
    LoadAreaModel *_model;
}
@end

@implementation AllAreaDataModel

-(id)init{
    self = [super init];
    if(self){
        _model = [[LoadAreaModel alloc] init];
    }
    return self;
}

+(AllAreaDataModel*)shareAllAreaData{
    static dispatch_once_t onceToken;
    static AllAreaDataModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[AllAreaDataModel alloc] init];
    });
    return sharedInstance;
}

-(void)checkAllAreaVersion{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block AllAreaDataModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_CheckAreaVersion httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
        }else{
            NSString *newVersion = [NSString stringWithFormat:@"%d",[[[retData.data objectForKey:@"data"] objectForKey:@"area_version"] integerValue]];
            [blockSelf compareLocalAreaVersionToServiceAreaVersion:newVersion];
        }
    }];
}

-(void)compareLocalAreaVersionToServiceAreaVersion:(NSString*)newVersion{
    if(![newVersion isEqualToString:[[self class] lastCheckDate]]){
        [self removeAreaPlist];
        
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:newVersion forKey:CheckAreaVersion];
}

-(void)removeAreaPlist{
    NSFileManager *manager=[NSFileManager defaultManager];
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:ServiceAreaPlist];
    if(![manager fileExistsAtPath:ServiceAreaPlist]){
        [_model loadAllAreaData];
        NSLog(@"没有areaPlist文件");
        return;
    }
    if ([manager removeItemAtPath:filepath error:nil]) {
        [_model loadAllAreaData];
        NSLog(@"areaPlist文件删除成功");
    }
}

+(NSString*)lastCheckDate{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:CheckAreaVersion];
}

@end
