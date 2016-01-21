//
//  AllOrderListHandleCell.m
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "AllOrderListHandleCell.h"
#import "AllOrderListEntity.h"

@interface AllOrderListHandleCell(){
    WXUIButton *leftBtn;
    WXUIButton *rightBtn;
}
@end

@implementation AllOrderListHandleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat btnWidth = 56;
        CGFloat btnHeight = 24;
        rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-btnWidth, (AllOrderListHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [rightBtn setHidden:YES];
        [rightBtn setBackgroundColor:WXColorWithInteger(0xff9c00)];
        [rightBtn setBorderRadian:3.0 width:1.0 color:[UIColor clearColor]];
        [rightBtn.titleLabel setFont:WXFont(10.0)];
        [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:rightBtn];
        
        leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-2*(xOffset+btnWidth), (AllOrderListHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [leftBtn setHidden:YES];
        [leftBtn setBackgroundColor:WXColorWithInteger(0xff9c00)];
        [leftBtn setBorderRadian:3.0 width:1.0 color:[UIColor clearColor]];
        [leftBtn.titleLabel setFont:WXFont(10.0)];
        [leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:leftBtn];
    }
    return self;
}

-(void)load{
    [self userHandleBtnState];
}

-(void)userHandleBtnState{
    AllOrderListEntity *entity = self.cellInfo;
    if(entity.orderState == Order_State_Cancel){
        [leftBtn setHidden:YES];
        [rightBtn setHidden:YES];
        return;
    }
    if(entity.orderState == Order_State_Complete){
        [leftBtn setHidden:YES];
        [rightBtn setHidden:YES];
//        if(entity.evaluate == Order_Evaluate_None){
//            [rightBtn setTitle:@"评价" forState:UIControlStateNormal];
//            [rightBtn setHidden:NO];
//        }
        return;
    }
    if(entity.orderState == Order_State_None){
        [leftBtn setHidden:YES];
        [rightBtn setHidden:YES];
        return;
    }
    if(entity.payType == Order_PayType_WaitPay && entity.orderState == Order_State_Normal){
        [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [leftBtn setHidden:NO];
        [rightBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [rightBtn setHidden:NO];
    }
    if(entity.payType == Order_PayType_HasPay && entity.sendType == Order_SendType_WaitSend){
        [leftBtn setHidden:YES];
        [rightBtn setHidden:YES];
    }
    if(entity.payType == Order_PayType_HasPay && entity.orderState == Order_State_Normal && entity.sendType == Order_SendType_HasSend){
        [leftBtn setHidden:YES];
        [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [rightBtn setHidden:NO];
    }
}

-(void)rightBtnClicked{
    AllOrderListEntity *entity = self.cellInfo;
    if(entity.payType == Order_PayType_WaitPay && entity.orderState == Order_State_Normal){
        if(_delegate && [_delegate respondsToSelector:@selector(userPayOrder:)]){
            [_delegate userPayOrder:entity];
        }
    }
    if(entity.payType == Order_PayType_HasPay && entity.orderState == Order_State_Normal && entity.sendType == Order_SendType_HasSend){
        if(_delegate && [_delegate respondsToSelector:@selector(userCompleteOrder:)]){
            [_delegate userCompleteOrder:entity];
        }
    }
    if(entity.orderState == Order_State_Complete && entity.evaluate == Order_Evaluate_None){
        if(_delegate && [_delegate respondsToSelector:@selector(userEvaluateOrder:)]){
            [_delegate userEvaluateOrder:entity];
        }
    }
}

-(void)leftBtnClicked{
    AllOrderListEntity *entity = self.cellInfo;
    if(entity.payType == Order_PayType_WaitPay && entity.orderState == Order_State_Normal){
        if(_delegate && [_delegate respondsToSelector:@selector(userCancelOrder:)]){
            [_delegate userCancelOrder:entity];
        }
    }
}

@end
