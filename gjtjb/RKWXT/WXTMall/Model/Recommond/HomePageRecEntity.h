//
//  HomePageRecEntity.h
//  RKWXT
//
//  Created by SHB on 16/1/15.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageRecEntity : NSObject

@property (nonatomic,assign) NSInteger goods_id;
@property (nonatomic,strong) NSString *goods_name;
@property (nonatomic,strong) NSString *home_img;
@property (nonatomic,assign) CGFloat shopPrice;
@property (nonatomic,assign) CGFloat marketPrice;

+(HomePageRecEntity*)homePageRecEntityWithDictionary:(NSDictionary*)dic;

@end
