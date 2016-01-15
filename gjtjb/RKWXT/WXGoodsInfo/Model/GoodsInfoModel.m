//
//  GoodsInfoModel.m
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "GoodsInfoModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "GoodsInfoEntity.h"

@interface GoodsInfoModel(){
    NSMutableArray *_goodsInfoArr;
    NSMutableArray *_evaluteArr;
    NSMutableArray *_attrArr;
    NSMutableArray *_stockArr;
    NSMutableArray *_otherShopArr;
    NSMutableArray *_sellerArr;
}
@end

@implementation GoodsInfoModel
@synthesize goodsInfoArr = _goodsInfoArr;
@synthesize evaluteArr = _evaluteArr;
@synthesize attrArr = _attrArr;
@synthesize stockArr = _stockArr;
@synthesize otherShopArr = _otherShopArr;
@synthesize sellerArr = _sellerArr;

-(id)init{
    self = [super init];
    if(self){
        _goodsInfoArr = [[NSMutableArray alloc] init];
        _stockArr = [[NSMutableArray alloc] init];
        _evaluteArr = [[NSMutableArray alloc] init];
        _attrArr = [[NSMutableArray alloc] init];
        _otherShopArr = [[NSMutableArray alloc] init];
        _sellerArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseGoodsInfoData:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_goodsInfoArr removeAllObjects];
    [_stockArr removeAllObjects];
    [_attrArr removeAllObjects];
    [_evaluteArr removeAllObjects];
    [_otherShopArr removeAllObjects];
    [_sellerArr removeAllObjects];
    
    //商品详情
    GoodsInfoEntity *goodsInfoEntity = [GoodsInfoEntity initGoodsInfoEntity:[dic objectForKey:@"goods"]];
    goodsInfoEntity.homeImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,goodsInfoEntity.homeImg];
    goodsInfoEntity.goodsImgArr = [self goodsInfoTopImgArrWithImgString:goodsInfoEntity.goodsImg];
    [_goodsInfoArr addObject:goodsInfoEntity];
    
    //商家信息
    GoodsInfoEntity *sellerEntity = [GoodsInfoEntity initSellerInfoEntity:[dic objectForKey:@"seller"]];
    [_sellerArr addObject:sellerEntity];
    
    //基础信息
    if([[dic objectForKey:@"attr"] isKindOfClass:[NSArray class]]){
        for(NSDictionary *attrDic in [dic objectForKey:@"attr"]){
            GoodsInfoEntity *attrEntity = [GoodsInfoEntity initBaseAttrDataEntity:attrDic];
            [_attrArr addObject:attrEntity];
        }
    }
    
    //评价
//    for(NSDictionary *evaluateDic in [dic objectForKey:@"evaluate"]){
//        GoodsInfoEntity *evaluateEntity = [GoodsInfoEntity initEvaluteDataEntity:evaluateDic];
//        evaluateEntity.userHeadImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,evaluateEntity.userHeadImg];
//        [_evaluteArr addObject:evaluateEntity];
//    }
    
    //推荐店铺
    GoodsInfoEntity *shopEntity = [GoodsInfoEntity initOtherShopEntity:[dic objectForKey:@"shop"]];
    [_otherShopArr addObject:shopEntity];
    
    //库存
    for(NSDictionary *stockDic in [dic objectForKey:@"stock"]){
        GoodsInfoEntity *stockEntity = [GoodsInfoEntity initStockDataEntity:stockDic];
        [_stockArr addObject:stockEntity];
    }
}

-(NSArray*)goodsInfoTopImgArrWithImgString:(NSString*)imgStr{
    if(!imgStr){
        return nil;
    }
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    NSArray *array = [imgStr componentsSeparatedByString:@","];
    for (NSString *str in array) {
        NSString *str1 = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,str];
        [imgArr addObject:str1];
    }
    return imgArr;
}

-(void)loadGoodsInfoData:(NSInteger)goodsID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:goodsID], @"goods_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:goodsID], @"goods_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block GoodsInfoModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_GoodsInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadGoodsInfoDataFailed:)]){
                [_delegate loadGoodsInfoDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseGoodsInfoData:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadGoodsInfoDataSucceed)]){
                [_delegate loadGoodsInfoDataSucceed];
            }
        }
    }];
}

@end
