//
//  HomePageTopEntity.h
//  RKWXT
//
//  Created by SHB on 16/1/15.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageTopEntity : NSObject
@property (nonatomic,assign) NSInteger topAddID;
@property (nonatomic,assign) NSInteger linkID; //链接地址
@property (nonatomic,strong) NSString *topImg; //图片URL
@property (nonatomic,assign) NSInteger sortID; //排序

+(HomePageTopEntity*)homePageTopEntityWithDictionary:(NSDictionary*)dic;

@end
