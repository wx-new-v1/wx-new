//
//  AllOrderListStateCell.m
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "AllOrderListStateCell.h"
#import "AllOrderListEntity.h"

@interface AllOrderListStateCell(){
    WXUILabel *orderIDLabel;
    WXUILabel *orderTimeLabel;
    WXUILabel *orderStateLabel;
}
@end

@implementation AllOrderListStateCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat labelWidth = 140;
        CGFloat labelHeight = 18;
        orderIDLabel = [[WXUILabel alloc] init];
        orderIDLabel.frame = CGRectMake(xOffset, (AllOrderListStateCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [orderIDLabel setBackgroundColor:[UIColor clearColor]];
        [orderIDLabel setTextAlignment:NSTextAlignmentLeft];
        [orderIDLabel setTextColor:WXColorWithInteger(0x000000)];
        [orderIDLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:orderIDLabel];
        
        CGFloat yOffset = 6;
        CGFloat height = 11;
        orderTimeLabel = [[WXUILabel alloc] init];
        orderTimeLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-labelWidth, yOffset, labelWidth, height);
        [orderTimeLabel setBackgroundColor:[UIColor clearColor]];
        [orderTimeLabel setTextAlignment:NSTextAlignmentRight];
        [orderTimeLabel setTextColor:WXColorWithInteger(0x000000)];
        [orderTimeLabel setFont:WXFont(10.0)];
        [self.contentView addSubview:orderTimeLabel];
        
        yOffset += height+8;
        orderStateLabel = [[WXUILabel alloc] init];
        orderStateLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-labelWidth, yOffset, labelWidth, height);
        [orderStateLabel setBackgroundColor:[UIColor clearColor]];
        [orderStateLabel setTextAlignment:NSTextAlignmentRight];
        [orderStateLabel setTextColor:WXColorWithInteger(0xf74f35)];
        [orderStateLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:orderStateLabel];
    }
    return self;
}

-(void)load{
    AllOrderListEntity *entity = self.cellInfo;
    [orderIDLabel setText:[NSString stringWithFormat:@"订单号: %ld",(long)entity.orderId]];
    [orderTimeLabel setText:[UtilTool getDateTimeFor:entity.addTime type:1]];
    
    [orderStateLabel setText:[self orderState:entity]];
}

-(NSString*)orderState:(AllOrderListEntity*)entity{
    NSString *orderState = nil;
    if(entity.orderState == Order_State_Cancel){
        return @"已关闭";
    }
    if(entity.orderState == Order_State_Complete){
        return @"已完成";
    }
    //订单可操作，未付款
    if(entity.orderState == Order_State_Normal && entity.payType == Order_PayType_WaitPay){
        return @"待付款";
    }
    //订单已付款，可操作，未发货
    if(entity.orderState == Order_State_Normal && entity.payType == Order_PayType_HasPay && entity.sendType == Order_SendType_WaitSend){
        return @"待发货";
    }
    //订单已付款，可操作，已发货
    if(entity.orderState == Order_State_Normal && entity.payType == Order_PayType_HasPay && entity.sendType == Order_SendType_HasSend){
        return @"已发货";
    }
    //订单不可操作、已付款、未发货
    if(entity.orderState == Order_State_None && entity.payType == Order_PayType_HasPay){
        NSInteger number1 = 0;
        NSInteger number2 = 0;
        NSInteger number3 = 0;
        NSInteger number4 = 0;
        for(AllOrderListEntity *ent in entity.goodsListArr){
            if(ent.refundState == Refund_State_Being && ent.shopDealType == ShopDeal_Refund_Normal){
                number1++;
            }
            if(number1==entity.goodsListArr.count){
                return @"已申请退款";
            }
            if(ent.refundState == Refund_State_Being && ent.shopDealType == ShopDeal_Refund_Refuse){
                number2++;
            }
            if(number2==entity.goodsListArr.count){
                return @"卖家拒绝退款";
            }
            if(ent.refundState == Refund_State_HasDone){
                number3++;
            }
            if(number3==entity.goodsListArr.count){
                return @"已退款";
            }
            if(ent.refundState == Refund_State_Being && ent.shopDealType == ShopDeal_Refund_Agree){
                number4++;
            }
            if(number4==entity.goodsListArr.count){
                return @"退款中";
            }
        }
        return @"交易中";
    }
    
    return orderState;
}

@end
