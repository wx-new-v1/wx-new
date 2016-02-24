//
//  AllOrderListVC.m
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "AllOrderListVC.h"
#import "AllOrderListStateCell.h"
#import "AllOrderListGoodsCell.h"
#import "AllOrderListMoneyCell.h"
#import "AllOrderListHandleCell.h"
#import "MJRefresh.h"
#import "AliPayControl.h"

#import "AllOrderListEntity.h"
#import "AllOrderListModel.h"
#import "DealOrderModel.h"

#import "OrderListCommonDef.h"

#define EveryTimeLoad (10)

enum{
    Order_Show_State = 0,
    Order_Show_Goods,
    Order_Show_Money,
    Order_Shop_UserHandle,
    
    Order_Show_Invalid
};

@interface AllOrderListVC()<UITableViewDataSource,UITableViewDelegate,AllOrderListModelDelegate,AllOrderListHandleCellDelegate>{
    UITableView *_tableView;
    NSArray *orderListArr;
    AllOrderListModel *_model;
    
    BOOL isRefresh;
}
@end

@implementation AllOrderListVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[AllOrderListModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupRefresh];
    [self addOBS];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(payOrderListSucceed) name:D_Notification_Name_AliPaySucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(cancelOrderListSucceed:) name:K_Notification_UserOderList_CancelSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(cancelOrderListFailed:) name:K_Notification_UserOderList_CancelFailed object:nil];
    [notificationCenter addObserver:self selector:@selector(completeOrderListSucceed:) name:K_Notification_UserOderList_CompleteSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(completeOrderListFailed:) name:K_Notification_UserOderList_CompleteFailed object:nil];
//    [notificationCenter addObserver:self selector:@selector(userEvaluateOrderSucceed:) name:K_Notification_Name_UserEvaluateOrderSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(applyRefundSucceed) name:K_Notification_Name_RefundSucceed object:nil];
}

//集成刷新控件
-(void)setupRefresh{
    //1.下拉刷新(进入刷新状态会调用self的headerRefreshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //设置文字
    _tableView.headerPullToRefreshText = @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开刷新";
    _tableView.headerRefreshingText = @"刷新中";
    
    _tableView.footerPullToRefreshText = @"上拉加载";
    _tableView.footerReleaseToRefreshText = @"松开加载";
    _tableView.footerRefreshingText = @"加载中";
}

//改变cell分割线置顶
-(void)viewDidLayoutSubviews{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [orderListArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self numberOfRowInSection:section];
}

-(NSInteger)numberOfRowInSection:(NSInteger)section{
    AllOrderListEntity *entity = [orderListArr objectAtIndex:section];
    return Order_Show_Invalid+[entity.goodsListArr count]-1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row == Order_Show_State){
        height = AllOrderListStateCellHeight;
    }
    if(row == [self numberOfRowInSection:section]-1){
        height = AllOrderListHandleCellHeight;
    }
    if(row == [self numberOfRowInSection:section]-2){
        height = AllOrderListMoneyCellHeight;
    }
    if(row > Order_Show_State && row < [self numberOfRowInSection:section]-2){
        height = AllOrderListGoodsCellHeight;
    }
    return height;
}

//订单状态
-(WXUITableViewCell*)orderStateCell:(NSInteger)section{
    static NSString *identifier = @"stateCell";
    AllOrderListStateCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[AllOrderListStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([orderListArr count] > 0){
        [cell setCellInfo:[orderListArr objectAtIndex:section]];
    }
    [cell load];
    return cell;
}

//商品列表
-(WXUITableViewCell*)orderGoodsListCell:(NSInteger)section atRow:(NSInteger)row{
    static NSString *identfier = @"goodsListCell";
    AllOrderListGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[AllOrderListGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    if([orderListArr count] > 0){
        AllOrderListEntity *entity = [orderListArr objectAtIndex:section];
        [cell setCellInfo:[entity.goodsListArr objectAtIndex:row-1]];
    }
    [cell load];
    return cell;
}

//订单金额
-(WXUITableViewCell*)orderMoneyCell:(NSInteger)section{
    static NSString *identfier = @"moneyCell";
    AllOrderListMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[AllOrderListMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([orderListArr count] > 0){
        [cell setCellInfo:[orderListArr objectAtIndex:section]];
    }
    [cell load];
    return cell;
}

//用户操作
-(WXUITableViewCell*)userHandleCell:(NSInteger)section{
    static NSString *identifier = @"handleCell";
    AllOrderListHandleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[AllOrderListHandleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([orderListArr count] > 0){
        [cell setCellInfo:[orderListArr objectAtIndex:section]];
    }
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row == Order_Show_State){
        cell = [self orderStateCell:section];
    }
    if(row == [self numberOfRowInSection:section]-1){
        cell = [self userHandleCell:section];
    }
    if(row == [self numberOfRowInSection:section]-2){
        cell = [self orderMoneyCell:section];
    }
    if(row > Order_Show_State && row < [self numberOfRowInSection:section]-2){
        cell = [self orderGoodsListCell:section atRow:row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    AllOrderListEntity *entity = [orderListArr objectAtIndex:section];
    if(row == Order_Show_State || row == [self numberOfRowInSection:section]-1 || row == [self numberOfRowInSection:section]-2){
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_JumpToOrderInfo object:entity];
}

-(NSInteger)indexPathOfOptCellWithOrder:(AllOrderListEntity*)orderEntity{
    NSInteger index = 0;
    if (orderEntity){
        index = [orderListArr indexOfObject:orderEntity];
    }
    return index;
}

#pragma mark mjRefresh
-(void)headerRefreshing{
    isRefresh = YES;
    if([orderListArr count] == 0){
        [_model loadOrderList:0 andLength:EveryTimeLoad type:OrderList_Type_All];
    }else{
        [_model loadOrderList:0 andLength:[orderListArr count] type:OrderList_Type_All];
    }
}

-(void)footerRefreshing{
    isRefresh = NO;
    [_model loadOrderList:[orderListArr count] andLength:EveryTimeLoad type:OrderList_Type_All];
}

-(void)loadAllOrderlistSucceed{
    orderListArr = _model.orderList;
    
    if(isRefresh){
        [_tableView headerEndRefreshing];
    }else{
        [_tableView footerEndRefreshing];
    }
    [_tableView reloadData];
}

-(void)loadAllOrderlistFailed:(NSString *)errorMsg{
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
    
    if(isRefresh){
        [_tableView headerEndRefreshing];
    }
    if(!isRefresh){
        [_tableView footerEndRefreshing];
    }
}

#pragma mark userhandle
//取消订单
-(void)userCancelOrder:(id)sender{
    AllOrderListEntity *entity = sender;
    [[DealOrderModel shareOrderDealModel] cancelUserOrder:entity.orderId];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

//确认收货
-(void)userCompleteOrder:(id)sender{
    AllOrderListEntity *entity = sender;
    [[DealOrderModel shareOrderDealModel] completeUserOrder:entity.orderId];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

//去支付
-(void)userPayOrder:(id)sender{
    AllOrderListEntity *entity = sender;
    [DealOrderModel shareOrderDealModel].orderID = [NSString stringWithFormat:@"%ld",(long)entity.orderId];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_JumpToPay object:entity];
}

//去评价
-(void)userEvaluateOrder:(id)sender{
    AllOrderListEntity *entity = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_JumpToEvaluate object:entity];
}

#pragma mark notification
//取消订单成功
-(void)cancelOrderListSucceed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *orderID = notification.object;
    for(AllOrderListEntity *entity in orderListArr){
        if(entity.orderId == [orderID integerValue]){
            entity.orderState = Order_State_Cancel;
            NSInteger index = [self indexPathOfOptCellWithOrder:entity];
            if (index>=0){
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

-(void)cancelOrderListFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"取消订单失败";
    }
    [UtilTool showAlertView:message];
}

//支付成功
-(void)payOrderListSucceed{
    for(AllOrderListEntity *entity in orderListArr){
        if(entity.orderId == [[DealOrderModel shareOrderDealModel].orderID integerValue]){
            entity.payType = Order_PayType_HasPay;
            NSInteger index = [self indexPathOfOptCellWithOrder:entity];
            if (index>=0){
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

//确认收货成功
-(void)completeOrderListSucceed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *orderID = notification.object;
    for(AllOrderListEntity *entity in orderListArr){
        if(entity.orderId == [orderID integerValue]){
            entity.orderState = Order_State_None;  //确认收货完成为处理中
            NSInteger index = [self indexPathOfOptCellWithOrder:entity];
            if (index>=0){
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

-(void)completeOrderListFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"取消订单失败";
    }
    [UtilTool showAlertView:message];
}

//评价成功
-(void)userEvaluateOrderSucceed:(NSNotification*)notification{
    AllOrderListEntity *entity = notification.object;
    for(AllOrderListEntity *ent in orderListArr){
        if(entity.orderId == ent.orderId){
            entity.evaluate = Order_Evaluate_Done;
            NSInteger index = [self indexPathOfOptCellWithOrder:entity];
            if(index>=0){
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

//申请退款成功
-(void)applyRefundSucceed{
    [self setupRefresh];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_Notification_UserOderList_CancelSucceed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_Notification_UserOderList_CancelFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_Notification_UserOderList_CompleteFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_Notification_UserOderList_CompleteSucceed object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_Notification_Name_UserEvaluateOrderSucceed object:nil];
}

@end
