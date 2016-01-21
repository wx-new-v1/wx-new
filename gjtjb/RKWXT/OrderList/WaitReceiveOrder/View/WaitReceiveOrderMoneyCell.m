//
//  WaitReceiveOrderMoneyCell.m
//  RKWXT
//
//  Created by SHB on 16/1/21.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WaitReceiveOrderMoneyCell.h"
#import "AllOrderListEntity.h"

@interface WaitReceiveOrderMoneyCell(){
    WXUILabel *numberLabel;
    WXUILabel *nameLabel;
    WXUILabel *priceLabel;
}
@end

@implementation WaitReceiveOrderMoneyCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat numLabelWidth = 85;
        CGFloat numLabelHeight = 16;
        numberLabel = [[WXUILabel alloc] init];
        numberLabel.frame = CGRectMake(xOffset, (WaitReceiveOrderMoneyCellHeight-numLabelHeight)/2, numLabelWidth, numLabelHeight);
        [numberLabel setBackgroundColor:[UIColor clearColor]];
        [numberLabel setTextAlignment:NSTextAlignmentLeft];
        [numberLabel setFont:WXFont(14.0)];
        [numberLabel setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:numberLabel];
        
        CGFloat nameWidth = 55;
        CGFloat nameHeight = numLabelHeight;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH/2, (WaitReceiveOrderMoneyCellHeight-nameHeight)/2, nameWidth, nameHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentRight];
        [nameLabel setTextColor:WXColorWithInteger(0xbababa)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        priceLabel = [[WXUILabel alloc] init];
        priceLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-100, (WaitReceiveOrderMoneyCellHeight-nameHeight)/2, 100, nameHeight);
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextAlignment:NSTextAlignmentCenter];
        [priceLabel setTextColor:WXColorWithInteger(0x000000)];
        [priceLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:priceLabel];
    }
    return self;
}

-(void)load{
    AllOrderListEntity *entity = self.cellInfo;
    NSInteger number = 0;
    for(AllOrderListEntity *ent in entity.goodsListArr){
        number += ent.buyNumber;
    }
    [numberLabel setText:[NSString stringWithFormat:@"共%ld件商品",(long)number]];
    [nameLabel setText:@"实付款:"];
    
    NSString *priceText = [NSString stringWithFormat:@"￥%.2f",entity.orderMoney+entity.carriageMoney];
    [priceLabel setText:priceText];
    
    CGFloat priceWidth = [NSString widthForString:priceText fontSize:14.0 andHeight:16];
    CGRect rect = priceLabel.frame;
    rect.size.width = priceWidth;
    rect.origin.x = IPHONE_SCREEN_WIDTH-10-priceWidth;
    [priceLabel setFrame:rect];
    
    CGRect rect1 = nameLabel.frame;
    rect1.origin.x = IPHONE_SCREEN_WIDTH-15-priceWidth-55;
    [nameLabel setFrame:rect1];
}

@end
