//
//  LoadAreaModel.m
//  RKWXT
//
//  Created by SHB on 16/1/8.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "LoadAreaModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation LoadAreaModel

-(void)loadAllAreaData{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", @"all", @"parent_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", @"all", @"parent_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block LoadAreaModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadAreaData httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
        }else{
            [blockSelf writeAllAreaDataToPlist:[retData.data objectForKey:@"data"]];
        }
    }];
}

-(void)writeAllAreaDataToPlist:(id)data{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:ServiceAreaPlist];
    
    __block NSInteger count = 0;
    __block NSMutableDictionary *dictPlist = [[NSMutableDictionary alloc] init];
    if([data isKindOfClass:[NSArray class]]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for(NSMutableDictionary *dic in data){
                NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                NSString *areaID = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"area_id"] integerValue]];
                NSString *parentID = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"parent_id"] integerValue]];
                NSString *name = [dic objectForKey:@"area_name"];
                
                [d setValue:areaID forKey:@"area_id"];
                [d setValue:parentID forKey:@"parent_id"];
                [d setObject:name forKey:@"area_name"];
                [dictPlist setObject:d forKey:[NSString stringWithFormat:@"%ld",(long)count]];
                count++;
            }
            [dictPlist writeToFile:plistPath atomically:YES];
        });
    }
}

@end
