//
//  ClassifySrarchListCell.m
//  RKWXT
//
//  Created by app on 16/2/29.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ClassifySrarchListCell.h"
#import "SearchResultEntity.h"

@interface ClassifySrarchListCell ()
@property (nonatomic,strong)UIView *baseView;
@end

@implementation ClassifySrarchListCell

+ (instancetype)classIfySrarchListCellWithTabelview:(UITableView*)tableview{
    NSString *identifier = @"ClassifySrarchListCell";
    ClassifySrarchListCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ClassifySrarchListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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

-(NSString*)dateWithTimeInterval:(NSString*)timer{
    if(!timer){
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:timer];
    NSInteger timeSp = [date timeIntervalSince1970];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeSp];
    NSString *timeStr = [date1 YMRSFMString];
    
    return timeStr;
}

@end
