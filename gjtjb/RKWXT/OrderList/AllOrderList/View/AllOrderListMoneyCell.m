//
//  AllOrderListMoneyCell.m
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "AllOrderListMoneyCell.h"
#import "AllOrderListEntity.h"

@interface AllOrderListMoneyCell(){
    WXUILabel *numberLabel;
    WXUILabel *nameLabel;
    WXUILabel *priceLabel;
}
@end

@implementation AllOrderListMoneyCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat numLabelWidth = 85;
        CGFloat numLabelHeight = 16;
        numberLabel = [[WXUILabel alloc] init];
        numberLabel.frame = CGRectMake(xOffset, (AllOrderListMoneyCellHeight-numLabelHeight)/2, numLabelWidth, numLabelHeight);
        [numberLabel setBackgroundColor:[UIColor clearColor]];
        [numberLabel setTextAlignment:NSTextAlignmentLeft];
        [numberLabel setFont:WXFont(14.0)];
        [numberLabel setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:numberLabel];
        
        CGFloat nameWidth = 55;
        CGFloat nameHeight = numLabelHeight;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH/2, (AllOrderListMoneyCellHeight-nameHeight)/2, nameWidth, nameHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentRight];
        [nameLabel setTextColor:WXColorWithInteger(0xbababa)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        priceLabel = [[WXUILabel alloc] init];
        priceLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-100, (AllOrderListMoneyCellHeight-nameHeight), 100, nameHeight);
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextAlignment:NSTextAlignmentRight];
        [priceLabel setTextColor:WXColorWithInteger(0x000000)];
        [priceLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:priceLabel];
    }
    return self;
}

-(void)load{
    
}

@end
