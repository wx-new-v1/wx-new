//
//  ClassifyModel.h
//  RKWXT
//
//  Created by SHB on 16/1/19.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

#define D_Notification_Name_LoadClassifyData_Succeed @"D_Notification_Name_LoadClassifyData_Succeed"
#define D_Notification_Name_LoadClassifyData_Failed  @"D_Notification_Name_LoadClassifyData_Failed"

@interface ClassifyModel : T_HPSubBaseModel
@property (nonatomic,strong) NSArray *classifyDataArr;
+(ClassifyModel*)shareClassifyNodel;
-(void)loadAllClassifyData;

@end
