//
//  WaitSendOrderGoodsCell.m
//  RKWXT
//
//  Created by SHB on 16/1/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WaitSendOrderGoodsCell.h"
#import "WXRemotionImgBtn.h"
#import "AllOrderListEntity.h"

@interface WaitSendOrderGoodsCell(){
    WXRemotionImgBtn *imgView;
    WXUILabel *nameLabel;
    WXUILabel *priceLabel;
    WXUILabel *numLabel;
}
@end

@implementation WaitSendOrderGoodsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 62;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (WaitSendOrderGoodsCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+5;
        CGFloat yOffset = 10;
        CGFloat nameLabelWidth = 150;
        CGFloat nameLabelHeight = 35;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, nameLabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(12.0)];
        [nameLabel setNumberOfLines:2];
        [self.contentView addSubview:nameLabel];
        
        yOffset += nameLabelHeight+8;
        CGFloat labelHeight = 20;
        CGFloat labelWidth = 100;
        priceLabel = [[WXUILabel alloc] init];
        priceLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextAlignment:NSTextAlignmentLeft];
        [priceLabel setTextColor:WXColorWithInteger(0x000000)];
        [priceLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:priceLabel];
        
        numLabel = [[WXUILabel alloc] init];
        numLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-10-labelWidth, yOffset, labelWidth, labelHeight);
        [numLabel setTextAlignment:NSTextAlignmentRight];
        [numLabel setTextColor:WXColorWithInteger(0x414141)];
        [numLabel setFont:WXFont(12.0)];
        [numLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:numLabel];
    }
    return self;
}

-(void)load{
    AllOrderListEntity *entity = self.cellInfo;
    [imgView setCpxViewInfo:entity.goodsImg];
    [imgView load];
    
    [nameLabel setText:entity.goodsName];
    [priceLabel setText:[NSString stringWithFormat:@"￥%.2f",entity.stockPrice]];
    [numLabel setText:[NSString stringWithFormat:@"X%ld",(long)entity.buyNumber]];
}

@end
