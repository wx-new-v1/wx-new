//
//  ClassifyHistoryCell.m
//  RKWXT
//
//  Created by app on 16/2/29.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ClassifyHistoryCell.h"
#import "SearchResultEntity.h"

@interface ClassifyHistoryCell ()
@property (nonatomic,strong)UIView *baseView;
@end

@implementation ClassifyHistoryCell
+ (instancetype)classIfyHistoryCellWithTabelview:(UITableView*)tableview{
    NSString *identifier = @"ClassifyHistoryCell";
    ClassifyHistoryCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ClassifyHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(void)setEntity:(SearchResultEntity *)entity{
    _entity = entity;
    
    [self.baseView removeFromSuperview];
    self.baseView = [[UIView alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:self.baseView];
    
    [self setCellContent];
}

- (void)setCellContent{
    CGFloat xOffset = 10;
    CGFloat labelWidth = 150;
    CGFloat labelHeight = 25;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(xOffset, (44-labelHeight)/2, labelWidth, labelHeight);
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setTextColor:WXColorWithInteger(0x606062)];
    [nameLabel setFont:WXFont(14.0)];
    [nameLabel setText:self.entity.goodsName];
    [nameLabel setTextColor:WXColorWithInteger(0x606062)];
    [nameLabel setFont:WXFont(14.0)];
    [self.baseView addSubview:nameLabel];
    
    CGFloat timeWidth = 140;
    UILabel * timeLabel = [[UILabel alloc] init];
    timeLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-timeWidth-xOffset, (44-labelHeight)/2, timeWidth, labelHeight);
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    [timeLabel setTextColor:[UIColor grayColor]];
    [timeLabel setFont:WXFont(14.0)];
    [self.baseView addSubview:timeLabel];
}
@end
