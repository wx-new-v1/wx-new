//
//  AllAreaDataModel.h
//  RKWXT
//
//  Created by SHB on 16/1/8.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CheckAreaVersion @"CheckAreaVersion"

@interface AllAreaDataModel : NSObject

+(AllAreaDataModel*)shareAllAreaData;
-(void)checkAllAreaVersion;

@end
