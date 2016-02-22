//
//  WithdrawalsRecordListVC.m
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WithdrawalsRecordListVC.h"
#import "WithdrawadsRecordListModel.h"
#import "AliRecordListCell.h"
#import "MJRefresh.h"

#define size self.bounds.size
#define EveryTimeLoadDataNumber 10

@interface WithdrawalsRecordListVC()<UITableViewDataSource,UITableViewDelegate,WithdrawadsRecordListModelDelegate>{
    UITableView *_tableView;
    
    WithdrawadsRecordListModel *_model;
    NSArray *listArr;
    
    BOOL isRefresh;
}
@end

@implementation WithdrawalsRecordListVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[WithdrawadsRecordListModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"提现记录"];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self setupRefresh];
    
    [_model loadUserWithdrawadlsRecordList:0 With:EveryTimeLoadDataNumber];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

//集成刷新控件
-(void)setupRefresh{
    //1.下拉刷新(进入刷新状态会调用self的headerRefreshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AliRecordListCellHeight;
}

-(WXUITableViewCell *)tableViewForRecordListCell:(NSInteger)row{
    static NSString *identifier = @"recordListCell";
    AliRecordListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[AliRecordListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setUserInteractionEnabled:NO];
    if([listArr count] > 0){
        [cell setCellInfo:[listArr objectAtIndex:row]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForRecordListCell:row];
    return cell;
}

#pragma mark mjRefresh
-(void)headerRefreshing{
    isRefresh = YES;
    if([listArr count] == 0){
        [_model loadUserWithdrawadlsRecordList:0 With:EveryTimeLoadDataNumber];
    }else{
        [_model loadUserWithdrawadlsRecordList:0 With:[listArr count]];
    }
}

-(void)footerRefreshing{
    isRefresh = NO;
    [_model loadUserWithdrawadlsRecordList:[listArr count] With:EveryTimeLoadDataNumber];
}

-(void)loadUserWithdrawadlsRecordListSucceed{
    [self unShowWaitView];
    listArr = _model.recordListArr;
    
    if(isRefresh){
        [_tableView headerEndRefreshing];
    }else{
        [_tableView footerEndRefreshing];
    }
    [_tableView reloadData];
}

-(void)loadUserWithdrawadlsRecordListFailed:(NSString *)errorMsg{
    [self unShowWaitView];
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

@end
