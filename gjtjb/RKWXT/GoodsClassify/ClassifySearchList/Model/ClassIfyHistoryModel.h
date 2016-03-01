//
//  ClassIfyHistoryModel.h
//  RKWXT
//
//  Created by app on 16/2/29.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SearchResultEntity;
@interface ClassIfyHistoryModel : NSObject <NSCoding>
@property (nonatomic,strong)NSMutableArray *entityArr;
+ (instancetype)classIfyhistoryModelClass;
- (void)classifyHistoryModelWithSaveEntity:(SearchResultEntity*)entity;
+ (NSArray*)classifyHistoryModelWithReadEntityArray;
@end
