//
//  GoodsInfoEntity.h
//  RKWXT
//
//  Created by SHB on 16/1/8.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    Goods_Postage_Have = 0,   //不包邮
    Goods_Postage_None,       //包邮
}Goods_Postage;

typedef enum{
    Goods_Collection_None = 0,  //未收藏
    Goods_Collection_Has,
}Goods_Collection;

@interface GoodsInfoEntity : NSObject
@property (nonatomic,strong) NSString *homeImg;
@property (nonatomic,strong) NSString *goodsImg;
@property (nonatomic,strong) NSArray *goodsImgArr;
@property (nonatomic,assign) NSInteger goodsID;
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,assign) Goods_Postage postage;
@property (nonatomic,assign) CGFloat marketPrice;
@property (nonatomic,assign) CGFloat shopPrice;
@property (nonatomic,assign) NSInteger meterageID;
@property (nonatomic,strong) NSString *meterageName;
@property (nonatomic,assign) NSInteger goodshop_id;
@property (nonatomic,strong) NSString *goodsShopName;
@property (nonatomic,assign) Goods_Collection collectionType;

@property (nonatomic,strong) NSString *sellerAddress;
@property (nonatomic,assign) CGFloat sellerLatitude;
@property (nonatomic,assign) CGFloat sellerLongitude;
@property (nonatomic,assign) NSInteger sellerID;
@property (nonatomic,strong) NSString *sellerName;

//基本参数
@property (nonatomic,strong) NSString *attrName;
@property (nonatomic,strong) NSString *attrValue;

//评价
@property (nonatomic,assign) NSInteger addTime;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *userPhone;
@property (nonatomic,strong) NSString *userHeadImg;

//相关店铺
@property (nonatomic,strong) NSString *shopAddress;
@property (nonatomic,assign) CGFloat shopLatitude;
@property (nonatomic,assign) CGFloat shopLongitude;
@property (nonatomic,assign) CGFloat shopDistance;
@property (nonatomic,assign) CGFloat shopID;
@property (nonatomic,strong) NSString *shopName;

//库存
@property (nonatomic,assign) NSInteger userCut;
@property (nonatomic,assign) NSInteger stockNum;
@property (nonatomic,assign) CGFloat stockPrice;
@property (nonatomic,assign) NSInteger stockID;
@property (nonatomic,strong) NSString *stockName;
@property (nonatomic,assign) NSInteger redPacket;

//临时属性
@property (nonatomic,assign) BOOL selected;

+(GoodsInfoEntity*)initGoodsInfoEntity:(NSDictionary*)dic;  //商品详情
+(GoodsInfoEntity*)initSellerInfoEntity:(NSDictionary*)dic;  //所属商家
+(GoodsInfoEntity*)initBaseAttrDataEntity:(NSDictionary*)dic;//基础属性
+(GoodsInfoEntity*)initEvaluteDataEntity:(NSDictionary*)dic;  //评价
+(GoodsInfoEntity*)initOtherShopEntity:(NSDictionary*)dic;  //推荐商家
+(GoodsInfoEntity*)initStockDataEntity:(NSDictionary*)dic; //库存

@end
