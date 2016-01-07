//
//  GoodsInfoModel.h
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GoodsInfoModelDelegate;
@interface GoodsInfoModel : NSObject
@property (nonatomic,assign) id<GoodsInfoModelDelegate>delegate;
@property (nonatomic,strong) NSArray *goodsInfoArr;

-(void)loadGoodsInfoData:(NSInteger)goods_id;
@end

@protocol GoodsInfoModelDelegate <NSObject>
-(void)loadGoodsInfoSucceed;
-(void)loadGoodsInfoFailed:(NSString*)errorMsg;

@end
