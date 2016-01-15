//
//  HomeGuessInfoCell.m
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomeGuessInfoCell.h"
#import "NewHomePageCommonDef.h"
#import "WXRemotionImgBtn.h"
#import "HomePageSurpEntity.h"

@interface HomeGuessInfoCell(){
    WXRemotionImgBtn *imgView;
    WXUILabel *nameLabel;
    WXUILabel *priceLabel;
}
@end

@implementation HomeGuessInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 90;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (T_HomePageGuessInfoHeight-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+10;
        CGFloat yOffset = imgView.frame.origin.y+12;
        CGFloat labelHeight = 30;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-10-xOffset, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(12.0)];
        [nameLabel setNumberOfLines:2];
        [self.contentView addSubview:nameLabel];
        
        yOffset += labelHeight+20;
        priceLabel = [[WXUILabel alloc] init];
        priceLabel.frame = CGRectMake(xOffset, yOffset, 150, labelHeight/2);
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextAlignment:NSTextAlignmentLeft];
        [priceLabel setTextColor:WXColorWithInteger(0x000000)];
        [priceLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:priceLabel];
    }
    return self;
}

-(void)load{
    HomePageSurpEntity *entity = self.cellInfo;
    [imgView setCpxViewInfo:entity.home_img];
    [imgView load];
    [nameLabel setText:entity.goods_name];
    [priceLabel setText:[NSString stringWithFormat:@"%.2f",entity.shop_price]];
}

@end
