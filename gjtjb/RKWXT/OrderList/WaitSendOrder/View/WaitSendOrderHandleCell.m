//
//  WaitSendOrderHandleCell.m
//  RKWXT
//
//  Created by SHB on 16/1/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WaitSendOrderHandleCell.h"
#import "AllOrderListEntity.h"

@interface WaitSendOrderHandleCell(){
    WXUIButton *rightBtn;
}
@end

@implementation WaitSendOrderHandleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat btnWidth = 56;
        CGFloat btnHeight = 24;
        rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-btnWidth, (WaitSendOrderHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
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
    AllOrderListEntity *entity = self.cellInfo;
    if(entity.payType == Order_PayType_HasPay && entity.sendType == Order_SendType_WaitSend){
//        [rightBtn setTitle:@"退款" forState:UIControlStateNormal];
//        [rightBtn setHidden:NO];
    }
}

-(void)rightBtnClicked{
    AllOrderListEntity *entity = self.cellInfo;
    if(entity.payType == Order_PayType_WaitPay && entity.orderState == Order_State_Normal){
        if(_delegate && [_delegate respondsToSelector:@selector(userRefundOrder:)]){
            [_delegate userRefundOrder:entity];
        }
    }
}

@end
