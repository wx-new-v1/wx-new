//
//  CLassifySearchModel.m
//  RKWXT
//
//  Created by app on 16/2/29.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "CLassifySearchModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "SearchResultEntity.h"
#import "WXTURLFeedOBJ.h"
#import "ClassIfyHistoryModel.h"

@implementation CLassifySearchModel

- (NSMutableArray*)searchResultArr{
    if (!_searchResultArr) {
        _searchResultArr = [NSMutableArray array];
    }
    return _searchResultArr;
}

- (NSArray*)historyArr{
    if (!_historyArr) {
        NSArray *oldArr = [ClassIfyHistoryModel classifyHistoryModelWithReadEntityArray];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in oldArr) {
            SearchResultEntity *entity = [SearchResultEntity initSearchResultEntityWith:dict];
            [arr addObject:entity];
        }
        _historyArr = arr;
    }
    return _historyArr;
}

/*
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 woxin_id : 我信ID
 type: 1.商品，2.店铺
 sid:商家ID
 shop_id:店铺ID
 keyword:关键字
 
 */
-(void)classifySearchWith:(NSString*)searchStr{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"] = @"ios";
    baseDic[@"ver"] = [UtilTool currentVersion];
    baseDic[@"ts"] = [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"] = userObj.wxtID;
    baseDic[@"type"] = [NSNumber numberWithInt:(int)_searchType];
    baseDic[@"sid"] = [NSNumber numberWithInt:(int)kMerchantID];
    baseDic[@"shop_id"] = [NSNumber numberWithInt:(int)kSubShopID];
    baseDic[@"keyword"] = searchStr;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"] = @"ios";
    dic[@"ver"] = [UtilTool currentVersion];
    dic[@"ts"] = [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"] = userObj.wxtID;
    dic[@"type"] = [NSNumber numberWithInt:(int)_searchType];
    dic[@"sid"] = [NSNumber numberWithInt:(int)kMerchantID];
    dic[@"shop_id"] = [NSNumber numberWithInt:(int)kSubShopID];
    dic[@"keyword"] = searchStr;
    dic[@"sign"] = [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    
    if (![searchStr isEqualToString:@""]) {
        __block CLassifySearchModel *blockSelf = self;
        [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_SearchGoodsOrShop httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
            if(retData.code != 0){
                NSLog(@"%@",retData);
            }else{
                [blockSelf parseSearchResultWith:[retData.data objectForKey:@"data"]];
            }
        }];
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(classifySearchResultClearSource)]) {
            [_delegate classifySearchResultClearSource];
        }
    }
    
}

-(void)parseSearchResultWith:(id)arr{
    [_searchResultArr removeAllObjects];
    if([arr isKindOfClass:[NSString class]]){
        return;
    }
    for(NSDictionary *dic in arr){
        SearchResultEntity *entity = [SearchResultEntity initSearchResultEntityWith:dic];
        [_searchResultArr addObject:entity];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(classifySearchResultSucceed)]){
        [_delegate classifySearchResultSucceed];
    }
    
    [ClassIfyHistoryModel classifyHistoryModelWithSaveEntityArray:arr];
}






@end
