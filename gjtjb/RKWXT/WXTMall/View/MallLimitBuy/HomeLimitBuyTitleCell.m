//
//  HomeLimitBuyTitleCell.m
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomeLimitBuyTitleCell.h"
#import "NewHomePageCommonDef.h"

@interface HomeLimitBuyTitleCell(){
    WXUILabel *hoursLabel;
    WXUILabel *minuteLabel;
    WXUILabel *secondLabel;
}
@end

@implementation HomeLimitBuyTitleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 15;
        CGFloat nameWidth = 60;
        CGFloat nameHeight = 20;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (T_HomePageTextSectionHeight-nameHeight)/2, nameWidth, nameHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(15.0)];
        [nameLabel setText:@"秒杀"];
        [self.contentView addSubview:nameLabel];
        
        CGFloat timeLabelWidth = 24;
        CGFloat timeLabelHeight = 16;
        secondLabel = [[WXUILabel alloc] init];
        secondLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-timeLabelWidth, (T_HomePageTextSectionHeight-timeLabelHeight)/2, timeLabelWidth, timeLabelHeight);
        [secondLabel setBackgroundColor:[UIColor clearColor]];
        [secondLabel setBorderRadian:1.0 width:0.5 color:WXColorWithInteger(0x999999)];
        [secondLabel setTextAlignment:NSTextAlignmentCenter];
        [secondLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:secondLabel];
        
        xOffset += timeLabelWidth+1;
        CGFloat markLabelWidth = 5;
        WXUILabel *markLabel = [[WXUILabel alloc] init];
        markLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-markLabelWidth, (T_HomePageTextSectionHeight-timeLabelHeight)/2, markLabelWidth, timeLabelHeight);
        [markLabel setBackgroundColor:[UIColor clearColor]];
        [markLabel setText:@":"];
        [markLabel setTextColor:WXColorWithInteger(0x000000)];
        [markLabel setTextAlignment:NSTextAlignmentCenter];
        [markLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:markLabel];
        
        xOffset += markLabelWidth+1;
        minuteLabel = [[WXUILabel alloc] init];
        minuteLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-timeLabelWidth, (T_HomePageTextSectionHeight-timeLabelHeight)/2, timeLabelWidth, timeLabelHeight);
        [minuteLabel setBackgroundColor:[UIColor clearColor]];
        [minuteLabel setBorderRadian:1.0 width:0.5 color:WXColorWithInteger(0x999999)];
        [minuteLabel setTextAlignment:NSTextAlignmentCenter];
        [minuteLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:minuteLabel];
        
        xOffset += timeLabelWidth+1;
        WXUILabel *markLabel1 = [[WXUILabel alloc] init];
        markLabel1.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-markLabelWidth, (T_HomePageTextSectionHeight-timeLabelHeight)/2, markLabelWidth, timeLabelHeight);
        [markLabel1 setBackgroundColor:[UIColor clearColor]];
        [markLabel1 setText:@":"];
        [markLabel1 setTextColor:WXColorWithInteger(0x000000)];
        [markLabel1 setTextAlignment:NSTextAlignmentCenter];
        [markLabel1 setFont:WXFont(12.0)];
        [self.contentView addSubview:markLabel1];
        
        xOffset += markLabelWidth+1;
        hoursLabel = [[WXUILabel alloc] init];
        hoursLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-timeLabelWidth, (T_HomePageTextSectionHeight-timeLabelHeight)/2, timeLabelWidth, timeLabelHeight);
        [hoursLabel setBackgroundColor:[UIColor clearColor]];
        [hoursLabel setBorderRadian:1.0 width:0.5 color:WXColorWithInteger(0x999999)];
        [hoursLabel setTextAlignment:NSTextAlignmentCenter];
        [hoursLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:hoursLabel];
        
        xOffset += timeLabelWidth+3;
        CGFloat labelWidth = 75;
        CGFloat labelHeight = 17;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-labelWidth, (T_HomePageTextSectionHeight-labelHeight)/2, labelWidth, labelHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setText:@"距结束时间:"];
        [textLabel setTextAlignment:NSTextAlignmentRight];
        [textLabel setTextColor:WXColorWithInteger(0x999999)];
        [textLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:textLabel];
    }
    return self;
}

-(void)load{
    
}

@end
