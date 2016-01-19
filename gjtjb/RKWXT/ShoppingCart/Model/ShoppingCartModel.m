//
//  ShoppingCartModel.m
//  RKWXT
//
//  Created by SHB on 16/1/19.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "ShoppingCartModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "ShoppingCartEntity.h"

@interface ShoppingCartModel(){
    NSMutableArray *_shoppingCartListArr;
}
@end

@implementation ShoppingCartModel

+(ShoppingCartModel*)shareShoppingCartModel{
    static dispatch_once_t onceToken;
    static ShoppingCartModel *shareInstance = nil;
    dispatch_once(&onceToken,^{
        shareInstance = [[ShoppingCartModel alloc] init];
    });
    return shareInstance;
}

-(id)init{
    if(self = [super init]){
        _shoppingCartListArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL)shouldDataReload{
    return self.status == E_ModelDataStatus_Init || self.status == E_ModelDataStatus_LoadFailed;
}

-(void)toInit{
    [super toInit];
    [_shoppingCartListArr removeAllObjects];
}

-(void)parseShoppingCartList:(NSDictionary*)jsonDic{
    if(!jsonDic){
        return;
    }
    [_shoppingCartListArr removeAllObjects];
    NSArray *arr = [jsonDic objectForKey:@"data"];
    for(NSDictionary *dic in arr){
        ShoppingCartEntity *entity = [ShoppingCartEntity initShoppingCartDataWithDictionary:dic];
        NSString *smallImgStr = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.smallImg];
        entity.smallImg = smallImgStr;
        [_shoppingCartListArr addObject:entity];
    }
}

//查询
-(void)loadShoppingCartList{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:2], @"type", userObj.shopID, @"shop_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:2], @"type", userObj.shopID, @"shop_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block ShoppingCartModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_ShoppingCart httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_LoadShoppingCartList_Failed object:retData.errorDesc];
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf parseShoppingCartList:retData.data];
            [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_LoadShoppingCartList_Succeed object:nil];
        }
    }];
}

//添加购物车成功后在本地加入数据
-(void)insertOneGoodsInShoppingCartList:(NSDictionary *)listDic{
//    if(!listDic){
//        return;
//    }
//    ShoppingCartEntity *entity = [ShoppingCartEntity initShoppingCartDataWithDictionary:listDic];
//    NSString *smallImgStr = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.smallImg];
//    entity.smallImg = smallImgStr;
//    [_shoppingCartListArr addObject:entity];
}

//添加
-(void)insertOneGoodsToShoppingCart:(NSInteger)stockID num:(NSInteger)number{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:1], @"type", [NSNumber numberWithInteger:stockID], @"goods_stock_id", [NSNumber numberWithInteger:number], @"goods_number", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:1], @"type", [NSNumber numberWithInteger:stockID], @"goods_stock_id", [NSNumber numberWithInteger:number], @"goods_number", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_ShoppingCart httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_AddGoodsShoppingCart_Failed object:retData.errorDesc];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_AddGoodsShoppingCart_Succeed object:retData.errorDesc];
        }
    }];
}

//删除
-(BOOL)parseAfterDeleteGoodsInShoppingCartList:(NSInteger)cartID{
    for(ShoppingCartEntity *entity in _shoppingCartListArr){
        if(entity.cart_id == cartID){
            [_shoppingCartListArr removeObject:entity];
            return YES;
        }
    }
    return NO;
}

-(void)deleteOneGoodsInShoppingCartList:(NSInteger)cartID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:3], @"type", [NSNumber numberWithInteger:cartID], @"cart_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:3], @"type", [NSNumber numberWithInteger:cartID], @"cart_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_ShoppingCart httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_DeleteOneGoodsInShoppingCartList_Failed object:retData.errorDesc];
        }else{
            BOOL succeed = [self parseAfterDeleteGoodsInShoppingCartList:cartID];
            if(succeed){
                [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_DeleteOneGoodsInShoppingCartList_Succeed object:nil];
            }
        }
    }];
}

@end
