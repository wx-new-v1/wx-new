//
//  ClassIfyHistoryModel.m
//  RKWXT
//
//  Created by app on 16/2/29.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ClassIfyHistoryModel.h"

@implementation ClassIfyHistoryModel
+ (void)classifyHistoryModelWithSaveEntityArray:(NSArray*)entityArray{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"entity.data"];
    [NSKeyedArchiver archiveRootObject:entityArray toFile:path];
}
+ (NSArray*)classifyHistoryModelWithReadEntityArray{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"entity.data"];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}
@end
