//
//  LoadAreaModel.h
//  RKWXT
//
//  Created by SHB on 16/1/8.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadAreaModel : NSObject
@property (nonatomic,strong) NSString *areaVersion;  //服务器端区域存储版本号
-(void)loadAllAreaData;

@end
