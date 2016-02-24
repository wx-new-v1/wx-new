//
//  OrderInfoContactShopCell.m
//  RKWXT
//
//  Created by SHB on 16/1/21.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "OrderInfoContactShopCell.h"
#import "AllOrderListEntity.h"

@interface OrderInfoContactShopCell(){
}
@end

@implementation OrderInfoContactShopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 15;
        CGFloat btnWidth = (IPHONE_SCREEN_WIDTH-3*xOffset)/2;
        CGFloat btnHeight = 35;
        WXUIButton *callBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        callBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-btnWidth-xOffset, (OrderInfoContactShopCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [callBtn setBackgroundColor:[UIColor whiteColor]];
        [callBtn setBorderRadian:3.0 width:1.0 color:[UIColor grayColor]];
        [callBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
        [callBtn setTitleColor:WXColorWithInteger(0x43433e) forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:callBtn];
    }
    return self;
}

-(void)load{
}

-(void)callBtnClicked{
    AllOrderListEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(contactSellerWith:)]){
        [_delegate contactSellerWith:entity.shopPhone];
    }
}

@end
