//
//  MakeOrderShopCell.m
//  RKWXT
//
//  Created by SHB on 15/6/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MakeOrderShopCell.h"
#import "MakeOrderDef.h"
#import "NSString+Encrypt.h"

@implementation MakeOrderShopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat imgWidth = 15;
        CGFloat imgHeight = 15;
        CGFloat xOffset = 12;
        UIImage *img = [UIImage imageNamed:@"Icon.png"];
        UIImageView *iconImgView = [[UIImageView alloc] init];
        iconImgView.frame = CGRectMake(xOffset, (Order_Section_Height_ShopName-imgHeight)/2, imgWidth, imgHeight);;
        [iconImgView setImage:img];
        [self.contentView addSubview:iconImgView];
        
        xOffset += imgWidth;
        UIFont *font = WXFont(14.0);
        CGFloat nameHeight = 20;
        WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
        CGFloat nameWidth = [NSString widthForString:userObj.sellerName fontSize:14 andHeight:nameHeight];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (Order_Section_Height_ShopName-nameHeight)/2, nameWidth, nameHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTextColor:WXColorWithInteger(0x202020)];
        [nameLabel setFont:font];
        [nameLabel setText:kMerchantName];
        [self.contentView addSubview:nameLabel];
        
        xOffset += nameHeight+2;
        UIImage *arrowImg = [UIImage imageNamed:@"MakeOrderNextPageImg.png"];
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        arrowImgView.frame = CGRectMake(xOffset, (Order_Section_Height_ShopName-imgHeight)/2, imgWidth-3, imgHeight);
        [arrowImgView setImage:arrowImg];
//        [self.contentView addSubview:arrowImgView];
    }
    return self;
}

-(void)load{

}

@end
