//
//  OrderInfoVC.m
//  RKWXT
//
//  Created by SHB on 16/1/21.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "OrderInfoVC.h"
#import "OrderInfoOrderStateCell.h"
#import "OrderInfoUserAddressCell.h"
#import "OrderInfoShopCell.h"
#import "OrderInfoGoodsListCell.h"
#import "OrderInfoMoneyCell.h"
#import "OrderInfoContactShopCell.h"
#import "OrderInfoOrderTimeCell.h"
#import "AllOrderListEntity.h"
#import "CallBackVC.h"

#define Size self.bounds.size

enum{
    OrderInfo_Section_OrderState = 0,
    OrderInfo_Section_UserAddress,
    OrderInfo_Section_ShopName,
    OrderInfo_Section_GoodsList,
    OrderInfo_Section_GoodsMoney,
    OrderInfo_Section_ContactShop,
    OrderInfo_Section_OrderTime,
    
    OrderInfo_Section_Invalid,
};

@interface OrderInfoVC()<UITableViewDataSource,UITableViewDelegate,OrderInfoContactShopCellDelegate,UIActionSheetDelegate>{
    UITableView *_tableView;
    AllOrderListEntity *entity;
    NSString *shopPhone;
}
@end

@implementation OrderInfoVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"订单详情"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    entity = _orderEntity;
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:_tableView];
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
    return OrderInfo_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if(section == OrderInfo_Section_GoodsList){
        row = [entity.goodsListArr count];
    }else{
        row = 1;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    switch (section) {
        case OrderInfo_Section_OrderState:
            height = OrderInfoOrderStateCellHeight;
            break;
        case OrderInfo_Section_UserAddress:
            height = [OrderInfoUserAddressCell cellHeightOfInfo:entity];
            break;
        case OrderInfo_Section_ShopName:
            height = OrderInfoShopCellHeight;
            break;
        case OrderInfo_Section_GoodsList:
            height = OrderInfoGoodsListCellHeight;
            break;
        case OrderInfo_Section_GoodsMoney:
            height = OrderInfoMoneyCellHeight;
            break;
        case OrderInfo_Section_ContactShop:
            height = OrderInfoContactShopCellHeight;
            break;
        case OrderInfo_Section_OrderTime:
            height = OrderInfoOrderTimeCellHieght;
            break;
        default:
            break;
    }
    return height;
}

//订单状态
-(WXUITableViewCell*)orderStateCell{
    static NSString *identifier = @"stateCell";
    OrderInfoOrderStateCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderInfoOrderStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

//收货人信息
-(WXUITableViewCell*)userInfoCell{
    static NSString *identifier = @"userInfoCell";
    OrderInfoUserAddressCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderInfoUserAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

//店铺名称
-(WXUITableViewCell*)shopNameCell{
    static NSString *identifier = @"shopNameCell";
    OrderInfoShopCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderInfoShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

//商品列表
-(WXUITableViewCell*)goodsListCell:(NSInteger)row{
    static NSString *identifier = @"goodsListCell";
    OrderInfoGoodsListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderInfoGoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellInfo:[entity.goodsListArr objectAtIndex:row]];
    [cell load];
    return cell;
}

//商品价格
-(WXUITableViewCell*)orderMoneyCell{
    static NSString *identifier = @"orderMoneyCell";
    OrderInfoMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderInfoMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

//联系卖家
-(WXUITableViewCell*)contactShopCell{
    static NSString *identifier =  @"contactShopCell";
    OrderInfoContactShopCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderInfoContactShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

//订单信息
-(WXUITableViewCell*)orderInfoCell{
    static NSString *identifier = @"orderInfoCell";
    OrderInfoOrderTimeCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderInfoOrderTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case OrderInfo_Section_OrderState:
            cell = [self orderStateCell];
            break;
        case OrderInfo_Section_UserAddress:
            cell = [self userInfoCell];
            break;
        case OrderInfo_Section_ShopName:
            cell = [self shopNameCell];
            break;
        case OrderInfo_Section_GoodsList:
            cell = [self goodsListCell:row];
            break;
        case OrderInfo_Section_GoodsMoney:
            cell = [self orderMoneyCell];
            break;
        case OrderInfo_Section_ContactShop:
            cell = [self contactShopCell];
            break;
        case OrderInfo_Section_OrderTime:
            cell = [self orderInfoCell];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == OrderInfo_Section_ShopName){

    }
    if(section == OrderInfo_Section_GoodsList){
        AllOrderListEntity *ent = [entity.goodsListArr objectAtIndex:row];
        [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:ent.goodsID animated:YES];
    }
}

#pragma mark contactShop
-(void)userRefundBtnClicked{
}

-(void)refundBtnClicked:(id)sender{
}

-(void)contactSellerWith:(NSString *)phone{
    NSString *phoneStr = [self phoneWithoutNumber:entity.shopPhone];
    shopPhone = phoneStr;
    [self showAlertView:shopPhone];
}

-(void)showAlertView:(NSString*)phone{
    NSString *title = [NSString stringWithFormat:@"联系商家:%@",phone];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:title
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:[NSString stringWithFormat:@"使用%@",kMerchantName]
                                  otherButtonTitles:@"系统", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex > 2){
        return;
    }
    if(shopPhone.length == 0){
        return;
    }
    if(buttonIndex == 1){
        [UtilTool callBySystemAPI:shopPhone];
        return;
    }
    if(buttonIndex == 0){
        CallBackVC *backVC = [[CallBackVC alloc] init];
        backVC.phoneName = kMerchantName;
        if([backVC callPhone:shopPhone]){
            [self presentViewController:backVC animated:YES completion:^{
            }];
        }
    }
}

-(NSString*)phoneWithoutNumber:(NSString*)phone{
    NSString *new = [[NSString alloc] init];
    for(NSInteger i = 0; i < phone.length; i++){
        char c = [phone characterAtIndex:i];
        if(c >= '0' && c <= '9'){
            new = [new stringByAppendingString:[NSString stringWithFormat:@"%c",c]];
        }
    }
    return new;
}

@end
