//
//  OrderInfoShopCell.m
//  RKWXT
//
//  Created by SHB on 16/1/21.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "OrderInfoShopCell.h"
#import "AllOrderListEntity.h"

@interface OrderInfoShopCell(){
    WXUIImageView *imgView;
    WXUILabel *nameLabel;
}
@end

@implementation OrderInfoShopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 18;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, (OrderInfoShopCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView setImage:[UIImage imageNamed:@"Icon.png"]];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+5;
        CGFloat labelWidth = 150;
        CGFloat labelHeight = 20;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (OrderInfoShopCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:nameLabel];
    }
    return self;
}

-(void)load{
    AllOrderListEntity *entity = self.cellInfo;
    [nameLabel setText:entity.shopName];
}

@end
