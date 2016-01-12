//
//  WXTMallViewController.m
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/23.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTMallViewController.h"
#import "NewHomePageCommonDef.h"

@interface WXTMallViewController ()<UITableViewDelegate,UITableViewDataSource,WXSysMsgUnreadVDelegate,WXHomeTopGoodCellDelegate,WXHomeBaseFunctionCellBtnClicked,HomeLimitBuyInfoCellDelegate,HomeRecommendInfoCellDelegate,ShareBrowserViewDelegate>{
    UITableView *_tableView;
    WXSysMsgUnreadV * _unreadView;
}
@end

@implementation WXTMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:kMerchantName];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setAllowsSelection:NO];
    [self addSubview:_tableView];
    [self setupRefresh];
    [self createTopBtn];
}

-(void)createTopBtn{
    WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 6, 30, 30);
    [leftBtn setImage:[UIImage imageNamed:@"HomePageLeftBtn.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(homePageToCategaryView) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftNavigationItem:leftBtn];
    
    _unreadView = [[WXSysMsgUnreadV alloc] initWithFrame:CGRectMake(0, 0, kDefaultNavigationBarButtonSize.width, kDefaultNavigationBarButtonSize.height)];
    [_unreadView setDelegate:self];
    [_unreadView showSysPushMsgUnread];
    [self setRightNavigationItem:_unreadView];
}

//集成刷新控件
-(void)setupRefresh{
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //设置文字
    _tableView.headerPullToRefreshText = @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开刷新";
    _tableView.headerRefreshingText = @"刷新中";
    
    _tableView.footerPullToRefreshText = @"上拉加载";
    _tableView.footerReleaseToRefreshText = @"松开加载";
    _tableView.footerRefreshingText = @"加载中";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return T_HomePage_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case T_HomePage_TopImg:
        case T_HomePage_BaseFunction:
        case T_HomePage_LimitBuyTitle:
        case T_HomePage_RecomendTitle:
        case T_HomePage_GuessTitle:
            row = 1;
            break;
        case T_HomePage_LimitBuyInfo:
            row = 0;
            break;
        case T_HomePage_RecomendInfo:
            row = 0;
            break;
        case T_HomePage_GuessInfo:
            row = 0;
            break;
        default:
            break;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    switch (section) {
        case T_HomePage_TopImg:
            height = T_HomePageTopImgHeight;
            break;
        case T_HomePage_BaseFunction:
            height = T_HomePageBaseFunctionHeight;
            break;
        case T_HomePage_LimitBuyTitle:
        case T_HomePage_RecomendTitle:
        case T_HomePage_GuessTitle:
            height = T_HomePageTextSectionHeight;
            break;
        case T_HomePage_LimitBuyInfo:
            height = T_HomePageLimitBuyHeight;
            break;
        case T_HomePage_RecomendInfo:
            height = T_HomePageRecommendHeight;
            break;
        case T_HomePage_GuessInfo:
            height = T_HomePageGuessInfoHeight;
            break;
        default:
            break;
    }
    return height;
}

#pragma mark cell
///顶部导航
-(WXUITableViewCell*)headImgCell{
    static NSString *identifier = @"headImg";
    WXHomeTopGoodCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[WXHomeTopGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setDelegate:self];
//    [cell setCellInfo:_model.top.data];
    [cell load];
    return cell;
}

//基本功能入口
-(WXUITableViewCell*)tableViewForBaseFunctionCell{
    static NSString *identifier = @"baseFunctionCell";
    WXHomeBaseFunctionCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[WXHomeBaseFunctionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell load];
    [cell setDelegate:self];
    return cell;
}

//秒杀
-(WXUITableViewCell*)tableViewForLimitBuyTitleCell{
    static NSString *identifier = @"limitBuyTitle";
    HomeLimitBuyTitleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[HomeLimitBuyTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForLimitBuy:(NSInteger)row{
    static NSString *identifier = @"limitBuyCell";
    HomeLimitBuyInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[HomeLimitBuyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*LimitBuyShow;
    NSInteger count = [nil count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*LimitBuyShow; i < max; i++){
        [rowArray addObject:[nil objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    [cell load];
    return cell;
}

//为我推荐
-(WXUITableViewCell*)tableViewForMeCell{
    static NSString *identifier = @"recommendTitleCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_None];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    [cell.textLabel setText:@"为我推荐"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:TextFont]];
    return cell;
}

-(WXUITableViewCell*)tableViewForRecommendCell:(NSInteger)row{
    static NSString *identifier = @"recommendInfoCell";
    HomeRecommendInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[HomeRecommendInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*RecommendShow;
    NSInteger count = [nil count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*RecommendShow; i < max; i++){
        [rowArray addObject:[nil objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    [cell load];
    return cell;
}

//猜你喜欢
-(WXUITableViewCell*)tableViewForGuessCell{
    static NSString *identifier = @"guessTitleCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_None];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    [cell.textLabel setText:@"猜你喜欢"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:TextFont]];
    return cell;
}

-(WXUITableViewCell*)tableViewForGuessInfoCell:(NSInteger)row{
    static NSString *identifier = @"guessInfoCell";
    HomeGuessInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[HomeGuessInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case T_HomePage_TopImg:
            cell = [self headImgCell];
            break;
        case T_HomePage_BaseFunction:
            cell = [self tableViewForBaseFunctionCell];
            break;
        case T_HomePage_LimitBuyTitle:
            cell = [self tableViewForLimitBuyTitleCell];
            break;
        case T_HomePage_LimitBuyInfo:
            cell = [self tableViewForLimitBuy:row];
            break;
        case T_HomePage_RecomendTitle:
            cell = [self tableViewForMeCell];
            break;
        case T_HomePage_RecomendInfo:
            cell = [self tableViewForRecommendCell:row];
            break;
        case T_HomePage_GuessTitle:
            cell = [self tableViewForGuessCell];
            break;
        case T_HomePage_GuessInfo:
            cell = [self tableViewForGuessInfoCell:row];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark 导航
- (void)toSysPushMsgView{
    [[CoordinateController sharedCoordinateController] toJPushCenterVC:self animated:YES];
}

-(void)homePageToCategaryView{
    
}

#pragma mark topimg
-(void)clickTopGoodAtIndex:(NSInteger)index{
    
}

#pragma mark baseFunction
-(void)wxHomeBaseFunctionBtnClickedAtIndex:(T_BaseFunction)index with:(UIView *)view{
    if(index >= T_BaseFunction_Invalid){
        return;
    }
    switch (index) {
        case T_BaseFunction_Invate:
        {
            ShareBrowserView *pictureBrowse = [[ShareBrowserView alloc] init];
            pictureBrowse.delegate = self;
            [pictureBrowse showShareThumbView:view toDestview:self.view withImage:[UIImage imageNamed:@"TwoDimension.png"]];
        }
            break;
        case T_BaseFunction_Wallet:
        {
            UserBonusVC *bonusVC = [[UserBonusVC alloc] init];
            bonusVC.selectedNum = 0;
            [self.wxNavigationController pushViewController:bonusVC];
        }
            break;
        case T_BaseFunction_Sign:
        {
            SignViewController *signVC = [[SignViewController alloc] init];
            [self.wxNavigationController pushViewController:signVC];
        }
            break;
        default:
            break;
    }
}

#pragma mark limitbuy
-(void)homeLimitBuyCellbtnClicked:(id)sender{

}

#pragma mark recommend
-(void)homeRecommendCellbtnClicked:(id)sender{
    
}

#pragma mark refresh
-(void)headerRefreshing{
    
}

-(void)footerRefreshing{
    
}

@end