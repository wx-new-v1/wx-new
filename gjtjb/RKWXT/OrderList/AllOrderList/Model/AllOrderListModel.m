//
//  AllOrderListModel.m
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "AllOrderListModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "AllOrderListEntity.h"

@interface AllOrderListModel(){
    NSMutableArray *_orderList;
    NSInteger number;
}
@end

@implementation AllOrderListModel
@synthesize orderList = _orderList;

-(id)init{
    self = [super init];
    if(self){
        _orderList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseLmOrderListData:(NSDictionary*)allDic{
    if(!allDic){
        return;
    }
    if(number == 0){
        [_orderList removeAllObjects];
    }
    for(NSDictionary *dic in [allDic objectForKey:@"order"]){
        NSMutableArray *goodsArr = [[NSMutableArray alloc] init];
        for(NSDictionary *goodsDic in [dic objectForKey:@"order_goods"]){
            AllOrderListEntity *goodsEntity = [AllOrderListEntity initOrderGoodsListEntity:goodsDic];
            goodsEntity.goodsImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,goodsEntity.goodsImg];
            [goodsArr addObject:goodsEntity];
        }
        AllOrderListEntity *entity = [AllOrderListEntity initOrderInfoEntity:[dic objectForKey:@"order_info"]];
        entity.goodsListArr = goodsArr;
        entity.shopName = [[allDic objectForKey:@"shop"] objectForKey:@"shop_name"];
        entity.shopPhone = [[allDic objectForKey:@"shop"] objectForKey:@"telephone"];
        [_orderList addObject:entity];
    }
}

-(void)loadOrderList:(NSInteger)startItem andLength:(NSInteger)length type:(OrderList_Type)orderType{
    number = startItem;
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", userObj.wxtID, @"woxin_id", userObj.shopID, @"shop_id", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [NSNumber numberWithInt:(int)startItem], @"start_item", [NSNumber numberWithInt:length], @"length", [NSNumber numberWithInt:orderType], @"type", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", userObj.wxtID, @"woxin_id", userObj.shopID, @"shop_id", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [NSNumber numberWithInt:(int)startItem], @"start_item", [NSNumber numberWithInt:length], @"length", [NSNumber numberWithInt:orderType], @"type", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block AllOrderListModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_OrderList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(loadAllOrderlistFailed:)]){
                [_delegate loadAllOrderlistFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseLmOrderListData:[retData.data objectForKey:@"data"]];
            if (_delegate && [_delegate respondsToSelector:@selector(loadAllOrderlistSucceed)]){
                [_delegate loadAllOrderlistSucceed];
            }
        }
    }];
}
@end
