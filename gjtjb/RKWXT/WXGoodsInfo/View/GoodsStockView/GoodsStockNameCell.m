//
//  GoodsStockNameCell.m
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "GoodsStockNameCell.h"
#import "GoodsInfoEntity.h"

@interface GoodsStockNameCell(){
    WXUIButton *stockBtn;
}
@end

@implementation GoodsStockNameCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat btnWidth = 240;
        CGFloat btnHeight = 30;
        stockBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        stockBtn.frame = CGRectMake((IPHONE_SCREEN_WIDTH-btnWidth)/2, (GoodsStockNameCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [stockBtn setBorderRadian:16.0 width:1.0 color:[UIColor clearColor]];
        [stockBtn setBackgroundColor:[UIColor grayColor]];
        [stockBtn.titleLabel setFont:WXFont(14.0)];
        [stockBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
        [stockBtn addTarget:self action:@selector(stockBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:stockBtn];
    }
    return self;
}

-(void)load{
    GoodsInfoEntity *entity = self.cellInfo;
    [stockBtn setTitle:entity.stockName forState:UIControlStateNormal];
    if(entity.selected){
        [stockBtn setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    }else{
        [stockBtn setBackgroundColor:WXColorWithInteger(0x9b9b9b)];
    }
}

-(void)stockBtnClicked{
    GoodsInfoEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(goodsStockNameBtnClicked:)]){
        [_delegate goodsStockNameBtnClicked:entity];
    }
}

@end
