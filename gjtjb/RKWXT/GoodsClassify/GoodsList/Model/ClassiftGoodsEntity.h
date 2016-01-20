//
//  ClassiftGoodsEntity.h
//  RKWXT
//
//  Created by SHB on 16/1/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassiftGoodsEntity : NSObject
@property (nonatomic,assign) NSInteger goodsID;
@property (nonatomic,strong) NSString *goodsImg;
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,assign) CGFloat market_price;
@property (nonatomic,assign) CGFloat shop_price;

+(ClassiftGoodsEntity*)initCLassifyGoodsListData:(NSDictionary*)dic;

@end
