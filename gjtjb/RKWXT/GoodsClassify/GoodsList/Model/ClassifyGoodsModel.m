//
//  ClassifyGoodsModel.m
//  RKWXT
//
//  Created by SHB on 16/1/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "ClassifyGoodsModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "ClassiftGoodsEntity.h"

@interface ClassifyGoodsModel(){
    NSMutableArray *_goodsListArr;
}
@end

@implementation ClassifyGoodsModel
@synthesize goodsListArr = _goodsListArr;

-(id)init{
    self = [super init];
    if(self){
        _goodsListArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseClassifyGoodsDataWith:(NSArray*)arr{
    if(!arr){
        return;
    }
    [_goodsListArr removeAllObjects];
    for(NSDictionary *dic in arr){
        ClassiftGoodsEntity *entity = [ClassiftGoodsEntity initCLassifyGoodsListData:dic];
        entity.goodsImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.goodsImg];
        [_goodsListArr addObject:entity];
    }
}

-(void)loadClassifyGoodsListData:(NSInteger)catID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", [NSNumber numberWithInt:(int)catID], @"woxin_id", [NSNumber numberWithInteger:catID], @"cat_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", [NSNumber numberWithInt:(int)catID], @"woxin_id", [NSNumber numberWithInteger:catID], @"cat_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block ClassifyGoodsModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadClassifyGoodsList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadClassifyGoodsListDataFailed:)]){
                [_delegate loadClassifyGoodsListDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseClassifyGoodsDataWith:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadClassifyGoodsListDataSucceed)]){
                [_delegate loadClassifyGoodsListDataSucceed];
            }
        }
    }];
}

@end
