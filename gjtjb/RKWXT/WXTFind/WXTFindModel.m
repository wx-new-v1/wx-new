//
//  WXTFindModel.m
//  RKWXT
//
//  Created by SHB on 15/3/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTFindModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"
#import "FindEntity.h"

@interface WXTFindModel(){
    NSMutableArray *_findDataArr;
}
@end

@implementation WXTFindModel
@synthesize findDataArr = _findDataArr;

-(id)init{
    if(self = [super init]){
        _findDataArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseClassifyData:(id)data{
    if(!data){
        return;
    }
}

-(void)loadFindData{
    
    for(NSInteger i = 0;i < 8; i++){
        FindEntity *entity = [[FindEntity alloc] init];
        entity.icon_url = @"http://wx3.67call.com/wx3/Public/Uploads/20151216/20151216094640_491660.png";
        entity.name = @"我信科技";
        [_findDataArr addObject:entity];
    }
    if (_findDelegate && [_findDelegate respondsToSelector:@selector(initFinddataSucceed)]){
        [_findDelegate initFinddataSucceed];
    }
    
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"get_discovery_item", @"cmd", userObj.wxtID, @"user_id", [NSNumber numberWithInt:(int)kMerchantID], @"agent_id", userObj.token, @"token", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_LoadBalance httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        __block WXTFindModel *blockSelf = self;
        if (retData.code != 0){
            if (_findDelegate && [_findDelegate respondsToSelector:@selector(initFinddataFailed:)]){
                [_findDelegate initFinddataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseClassifyData:retData.data];
            if (_findDelegate && [_findDelegate respondsToSelector:@selector(initFinddataSucceed)]){
                [_findDelegate initFinddataSucceed];
            }
        }
    }];
}

@end
