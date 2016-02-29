//
//  ClassifyHistoryCell.h
//  RKWXT
//
//  Created by app on 16/2/29.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"
@class SearchResultEntity;
@interface ClassifyHistoryCell : WXUITableViewCell
@property (nonatomic,strong)SearchResultEntity *entity;
+ (instancetype)classIfyHistoryCellWithTabelview:(UITableView*)tableview;
@end
