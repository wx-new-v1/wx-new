//
//  WXHomeOrderListVC.m
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXHomeOrderListVC.h"
#import "DLTabedSlideView.h"
#import "OrderListCommonDef.h"


@interface WXHomeOrderListVC()<DLTabedSlideViewDelegate>{
    DLTabedSlideView *tabedSlideView;
    NSInteger showNumber;
}
@end

@implementation WXHomeOrderListVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"我的订单"];
    
    tabedSlideView = [[DLTabedSlideView alloc] init];
    tabedSlideView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [tabedSlideView setDelegate:self];
    
    [tabedSlideView setBaseViewController:self];
    [tabedSlideView setTabItemNormalColor:WXColorWithInteger(0x000000)];
    [tabedSlideView setTabItemSelectedColor:WXColorWithInteger(0xf74f35)];
    [tabedSlideView setTabbarTrackColor:WXColorWithInteger(0xf74f35)];
    [tabedSlideView setTabbarBottomSpacing:3.0];
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"全部" image:nil selectedImage:nil];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"待付款" image:nil selectedImage:nil];
    DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"待发货" image:nil selectedImage:nil];
    DLTabedbarItem *item4 = [DLTabedbarItem itemWithTitle:@"待收货" image:nil selectedImage:nil];
    DLTabedbarItem *item5 = [DLTabedbarItem itemWithTitle:@"已完成" image:nil selectedImage:nil];
    
    [tabedSlideView setTabbarItems:@[item1,item2,item3,item4,item5]];
    [tabedSlideView buildTabbar];
    
    showNumber = [tabedSlideView.tabbarItems count];
    
    tabedSlideView.selectedIndex = _selectedNum;
    [self addSubview:tabedSlideView];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(jumpToPayVC:) name:K_Notification_Name_JumpToPay object:nil];
    [notificationCenter addObserver:self selector:@selector(jumpToOrderInfoVC:) name:K_Notification_Name_JumpToOrderInfo object:nil];
}

-(NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return showNumber;
}

-(UIViewController*)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case OrderList_All:
        {
            AllOrderListVC *listAll = [[AllOrderListVC alloc] init];
            return listAll;
        }
            break;
        case OrderList_Wait_Pay:
        {
            WaitPayOrderVC *payList = [[WaitPayOrderVC alloc] init];
            return payList;
        }
            break;
        case OrderList_Wait_Send:
        {
            WaitSendOrderVC *sendList = [[WaitSendOrderVC alloc] init];
            return sendList;
        }
            break;
        case OrderList_Wait_Receive:
        {
            WaitReceiveOrderVC *receiveList = [[WaitReceiveOrderVC alloc] init];
            return receiveList;
        }
            break;
        case OrderList_Wait_HasDone:
        {
            OrderHasDoneVC *hasDoneList = [[OrderHasDoneVC alloc] init];
            return hasDoneList;
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark pay
-(void)jumpToPayVC:(NSNotification*)notification{
    AllOrderListEntity *entity = notification.object;
    OrderPayVC *payVC = [[OrderPayVC alloc] init];
    payVC.orderpay_type = OrderPay_Type_Order;
    payVC.payMoney = entity.orderMoney+entity.carriageMoney;
    payVC.orderID = [NSString stringWithFormat:@"%ld",(long)entity.orderId];
    [self.wxNavigationController pushViewController:payVC];
}

#pragma mark orderInfo
-(void)jumpToOrderInfoVC:(NSNotification*)notification{
    AllOrderListEntity *entity = notification.object;
    OrderInfoVC *orderInfo = [[OrderInfoVC alloc] init];
    orderInfo.orderEntity = entity;
    [self.wxNavigationController pushViewController:orderInfo];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
