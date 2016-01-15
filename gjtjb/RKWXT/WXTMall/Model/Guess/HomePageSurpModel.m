//
//  HomePageSurpModel.m
//  RKWXT
//
//  Created by SHB on 16/1/15.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomePageSurpModel.h"
#import "HomePageSurpEntity.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface HomePageSurpModel(){
    NSMutableArray *_dataList;
}
@end

@implementation HomePageSurpModel
@synthesize data = _dataList;

-(id)init{
    if(self = [super init]){
        _dataList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)toInit{
    [super toInit];
    [_dataList removeAllObjects];
}

-(void)fillDataWithJsonData:(NSDictionary *)jsonDicData{
    if(!jsonDicData){
        return;
    }
    [_dataList removeAllObjects];
    NSArray *list = [jsonDicData objectForKey:@"data"];
    for(NSDictionary *dic in list){
        HomePageSurpEntity *entity = [HomePageSurpEntity homePageSurpEntityWithDictionary:dic];
        entity.home_img = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.home_img];
        [_dataList addObject:entity];
    }
}

-(void)loadDataFromWeb{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.shopID, @"shop_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.shopID, @"shop_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block HomePageSurpModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_Surprise httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(homePageSurpLoadedFailed:)]){
                [_delegate homePageSurpLoadedFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf fillDataWithJsonData:retData.data];
            if (_delegate && [_delegate respondsToSelector:@selector(homePageSurpLoadedSucceed)]){
                [_delegate homePageSurpLoadedSucceed];
            }
        }
    }];
}

-(void)loadCacheDataSucceed{
    if(_delegate && [_delegate respondsToSelector:@selector(homePageSurpLoadedSucceed)]){
        [_delegate homePageSurpLoadedSucceed];
    }
}

@end
