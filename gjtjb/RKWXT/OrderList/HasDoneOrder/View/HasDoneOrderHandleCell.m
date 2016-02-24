//
//  HasDoneOrderHandleCell.m
//  RKWXT
//
//  Created by SHB on 16/1/21.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HasDoneOrderHandleCell.h"
#import "AllOrderListEntity.h"

@interface HasDoneOrderHandleCell(){
    WXUIButton *rightBtn;
}
@end

@implementation HasDoneOrderHandleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat btnWidth = 56;
        CGFloat btnHeight = 24;
        rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-btnWidth, (HasDoneOrderHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [rightBtn setHidden:YES];
        [rightBtn setBackgroundColor:WXColorWithInteger(0xff9c00)];
        [rightBtn setBorderRadian:3.0 width:1.0 color:[UIColor clearColor]];
        [rightBtn.titleLabel setFont:WXFont(10.0)];
        [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:rightBtn];
    }
    return self;
}

-(void)load{
    [self userHandleBtnState];
}

-(void)userHandleBtnState{
//    AllOrderListEntity *entity = self.cellInfo;
//    if(entity.orderState == Order_State_Complete && entity.evaluate == Order_Evaluate_None){
//        [rightBtn setTitle:@"评价" forState:UIControlStateNormal];
//        [rightBtn setHidden:NO];
//        return;
//    }
}

-(void)rightBtnClicked{
    AllOrderListEntity *entity = self.cellInfo;
    if(entity.orderState == Order_State_Complete && entity.evaluate == Order_Evaluate_None){
        if(_delegate && [_delegate respondsToSelector:@selector(userEvaluateOrder:)]){
            [_delegate userEvaluateOrder:entity];
        }
    }
}

@end
