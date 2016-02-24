//
//  AllOrderListEntity.h
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

//订单是否付款
typedef enum{
    Order_PayType_WaitPay = 0,  //未支付
    Order_PayType_HasPay,       //已支付
}Order_PayType;

//订单是否发货
typedef enum{
    Order_SendType_WaitSend = 0,     //未发货
    Order_SendType_HasSend,         //已发货
}Order_SendType;

//订单状态
typedef enum{
    Order_State_Normal = 0, //订单可操作
    Order_State_Complete, // 订单已完成
    Order_State_Cancel,    //订单已取消
    Order_State_None,      //订单不可操作（可能由退款导致，此订单尚未交易完成）
}Order_State;

//订单评价
typedef enum{
    Order_Evaluate_None = 0,  //未评价
    Order_Evaluate_Done,      //已评价
}Order_Evaluate;

//退款
typedef enum{
    Refund_State_Normal = 0,  //未申请
    Refund_State_Being,       //已申请，如果商家同意则为退款中
    Refund_State_HasDone,     //已退款
}Refund_State;

//商家处理退款
typedef enum{
    ShopDeal_Refund_Normal = 0,  //未处理
    ShopDeal_Refund_Agree,       //同意
    ShopDeal_Refund_Refuse,      //不同意
}ShopDeal_State;

@interface AllOrderListEntity : NSObject
//订单信息
@property (nonatomic,assign) NSInteger addTime;          //下单时间
@property (nonatomic,strong) NSString *userAddress;      //用户收货地址
@property (nonatomic,strong) NSString *userPhone;        //用户联系方式
@property (nonatomic,strong) NSString *userName;         //用户姓名
@property (nonatomic,assign) CGFloat payMoney;           //实付金额
@property (nonatomic,assign) Order_PayType payType;      //支付状态
@property (nonatomic,assign) Order_SendType sendType;    //发货状态
@property (nonatomic,assign) Order_State orderState;     //订单状态
@property (nonatomic,assign) Order_Evaluate evaluate;    //订单评价
@property (nonatomic,assign) NSInteger orderId;          //订单号
@property (nonatomic,assign) CGFloat orderMoney;         //商品总金额
@property (nonatomic,assign) CGFloat carriageMoney;      //邮费
@property (nonatomic,assign) CGFloat redpacket;          //使用红包   (商家联盟暂时不可用)
@property (nonatomic,strong) NSString *userRemark;       //用户留言
@property (nonatomic,strong) NSString *sendName;         //快递名称
@property (nonatomic,strong) NSString *sendNumber;       //快递单号
@property (nonatomic,assign) NSInteger shopID;           //订单所属店铺id
@property (nonatomic,strong) NSString *shopName;         //订单所属店铺名字
@property (nonatomic,strong) NSString *shopPhone;        //店铺联系方式

//商品信息
@property (nonatomic,strong) NSArray *goodsListArr;          //订单所有商品存数组
@property (nonatomic,assign) Refund_State refundState;       //用户是否申请退款
@property (nonatomic,assign) ShopDeal_State shopDealType;    //商家处理退款状态
@property (nonatomic,assign) CGFloat refundMoney;            //退款金额
@property (nonatomic,assign) CGFloat goodsShouldPay;         //商品应付金额
@property (nonatomic,assign) CGFloat goodsValue;             //商品实际付款
@property (nonatomic,assign) CGFloat goodsRedPacket;         //商品实际使用红包
@property (nonatomic,assign) NSInteger goodsID;              //商品id
@property (nonatomic,strong) NSString *goodsName;            //商品名称
@property (nonatomic,strong) NSString *goodsImg;             //商品图片
@property (nonatomic,assign) NSInteger stockID;              //属性id
@property (nonatomic,strong) NSString *stockName;            //属性名称
@property (nonatomic,assign) NSInteger goodsSendType;        //商品是否发货 (暂时没用到)
@property (nonatomic,assign) NSInteger orderGoodsState;      //退款商品状态 (暂时没用到)
@property (nonatomic,assign) NSInteger orderGoodsID;         //退款商品所属id
@property (nonatomic,assign) NSInteger goodsOrderID;         //商品订单id
@property (nonatomic,assign) NSInteger buyNumber;            //购买数量
@property (nonatomic,assign) CGFloat stockPrice;             //属性单价

//商品退款使用临时变量
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) BOOL selectAll;

+(AllOrderListEntity*)initOrderInfoEntity:(NSDictionary*)dic;
+(AllOrderListEntity*)initOrderGoodsListEntity:(NSDictionary*)dic;

@end
