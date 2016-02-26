//
//  WXTMallViewController.m
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/23.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTMallViewController.h"
#import "NewHomePageCommonDef.h"

@interface WXTMallViewController ()<UITableViewDelegate,UITableViewDataSource,WXSysMsgUnreadVDelegate,WXHomeTopGoodCellDelegate,WXHomeBaseFunctionCellBtnClicked,HomeLimitBuyCellDelegate,HomeRecommendInfoCellDelegate,ShareBrowserViewDelegate,HomePageTopDelegate,HomePageRecDelegate,HomePageSurpDelegate>{
    UITableView *_tableView;
    WXSysMsgUnreadV * _unreadView;
    NewHomePageModel *_model;
}
@end

@implementation WXTMallViewController

-(void)dealloc{
    RELEASE_SAFELY(_tableView);
    RELEASE_SAFELY(_model);
    [_model setDelegate:nil];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if(self){
        _model = [[NewHomePageModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:kMerchantName];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    if(userObj.sellerName){
        [self setCSTTitle:userObj.sellerName];
    }
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_tableView];
    [self setupRefresh];
    [self createTopBtn];
    
    [_model loadData];
}

-(void)createTopBtn{
    WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(20, 6, 60, 40);
    [leftBtn setImage:[UIImage imageNamed:@"HomePageLeftBtn.png"] forState:UIControlStateNormal];
    [leftBtn setTitle:@"分类" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:WXFont(10.0)];
    [leftBtn addTarget:self action:@selector(homePageToCategaryView) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftNavigationItem:leftBtn];
    
    CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(leftBtn.titleLabel.bounds), CGRectGetMidY(leftBtn.titleLabel.bounds));
    CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(leftBtn.imageView.bounds));
    CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(leftBtn.bounds)-CGRectGetMidY(leftBtn.titleLabel.bounds));
    CGPoint startImageViewCenter = leftBtn.imageView.center;
    CGPoint startTitleLabelCenter = leftBtn.titleLabel.center;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, imageEdgeInsetsLeft, 40/3, imageEdgeInsetsRight);
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(40*2/3-5, titleEdgeInsetsLeft, 0, titleEdgeInsetsRight);
    
    
    _unreadView = [[WXSysMsgUnreadV alloc] initWithFrame:CGRectMake(0, 0, kDefaultNavigationBarButtonSize.width, kDefaultNavigationBarButtonSize.height)];
    [_unreadView setDelegate:self];
    [_unreadView showSysPushMsgUnread];
//    [self setRightNavigationItem:_unreadView];
}

//集成刷新控件
-(void)setupRefresh{
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
//    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
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
        case T_HomePage_RecomendTitle:
        case T_HomePage_GuessTitle:
            row = 1;
            break;
        case T_HomePage_LimitBuyInfo:
        case T_HomePage_LimitBuyTitle:
            row = 0;
            break;
        case T_HomePage_RecomendInfo:
            row = [_model.recommend.data count]/3+([_model.recommend.data count]%3>0?1:0);
            break;
        case T_HomePage_GuessInfo:
            row = [_model.surprise.data count]/2+([_model.surprise.data count]%2>0?1:0);
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
    [cell setCellInfo:_model.top.data];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForLimitBuy:(NSInteger)row{
    static NSString *identifier = @"limitBuyCell";
    HomeLimitBuyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[HomeLimitBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*LimitBuyShow;
    NSInteger count = [_model.surprise.data count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*LimitBuyShow; i < max; i++){
        [rowArray addObject:[_model.surprise.data objectAtIndex:i]];
    }
    [cell setCellInfo:rowArray];
    [cell setDelegate:self];
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
    [cell.textLabel setTextColor:WXColorWithInteger(0x888888)];
    return cell;
}

-(WXUITableViewCell*)tableViewForRecommendCell:(NSInteger)row{
    static NSString *identifier = @"recommendInfoCell";
    HomeRecommendInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[HomeRecommendInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*RecommendShow;
    NSInteger count = [_model.recommend.data count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*RecommendShow; i < max; i++){
        [rowArray addObject:[_model.recommend.data objectAtIndex:i]];
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
    [cell.textLabel setTextColor:WXColorWithInteger(0x888888)];
    return cell;
}

-(WXUITableViewCell*)tableViewForGuessInfoCell:(NSInteger)row{
    static NSString *identifier = @"guessInfoCell";
    HomeGuessInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[HomeGuessInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    if([_model.surprise.data count] > 0){
        [cell setCellInfo:[_model.surprise.data objectAtIndex:row]];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if(section == T_HomePage_GuessInfo){
        HomePageSurpEntity *entity = [_model.surprise.data objectAtIndex:row];
        [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:entity.goods_id animated:YES];
    }
}

#pragma mark 导航
- (void)toSysPushMsgView{
//    [[CoordinateController sharedCoordinateController] toJPushCenterVC:self animated:YES];
}

-(void)homePageToCategaryView{
    [[CoordinateController sharedCoordinateController] toGoodsClassifyVC:self catID:0 animated:YES];
}

#pragma mark topimg
-(void)clickTopGoodAtIndex:(NSInteger)index{
    HomePageTopEntity *entity = nil;
    if([_model.top.data count] > 0){
        entity = [_model.top.data objectAtIndex:index];
    }
    switch (entity.topAddID) {
        case HomePageJump_Type_Catagary:
        {
            [[CoordinateController sharedCoordinateController] toGoodsClassifyVC:self catID:entity.linkID animated:YES];
        }
            break;
        case HomePageJump_Type_GoodsInfo:
        {
            [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:entity.linkID animated:YES];
        }
            break;
        default:
            break;
    }
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
        case T_BaseFunction_Sign:
        {
            SignViewController *signVC = [[SignViewController alloc] init];
            [self.wxNavigationController pushViewController:signVC];
        }
            break;
        case T_BaseFunction_Cut:
        {
            NewUserCutVC *userCutVC = [[NewUserCutVC alloc] init];
            [self.wxNavigationController pushViewController:userCutVC];
        }
            break;
        case T_BaseFunction_Union:
        {
            FindCommonVC *vc = [[FindCommonVC alloc] init];
            vc.webURl = @"http://oldyun.67call.com/wx_union/index.php/Public/alliance_merchant";
            vc.name = @"商家联盟";
            [self.wxNavigationController pushViewController:vc];
        }
            break;
        default:
            [UtilTool showTipView:@"努力开发中..."];
            break;
    }
}

//share
-(void)sharebtnClicked:(NSInteger)index{
    UIImage *image = [UIImage imageNamed:@"Icon-72.png"];
    if(index == Share_Type_WxFriends){
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_Friend title:kMerchantName description:[UtilTool sharedString] linkURL:[self userShareAppWIthString] thumbImage:image];
    }
    if(index == Share_Type_WxCircle){
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_FriendGroup title:kMerchantName description:[UtilTool sharedString] linkURL:[self userShareAppWIthString] thumbImage:image];
    }
    if(index == Share_Type_Qq){
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[self userShareAppWIthString]] title:kMerchantName description:[UtilTool sharedString] previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        if(sent == EQQAPISENDSUCESS){
            NSLog(@"qq好友分享成功");
        }
    }
    if(index == Share_Type_Qzone){
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[self userShareAppWIthString]] title:kMerchantName description:[UtilTool sharedString] previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        if(sent == EQQAPISENDSUCESS){
            NSLog(@"qq空间分享成功");
        }
    }
}

-(NSString*)userShareAppWIthString{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSString *imgUrlStr = [NSString stringWithFormat:@"%@wx_union/index.php/Register/index?sid=%@&phone=%@",WXTShareBaseUrl,userObj.sellerID,userObj.user];
    return imgUrlStr;
}

#pragma mark HomePageTopDelegate
-(void)homePageTopLoadedSucceed{
    [_tableView headerEndRefreshing];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_TopImg] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)homePageTopLoadedFailed:(NSString *)error{
    [_tableView headerEndRefreshing];
    if(!error){
        error = @"获取置顶图片失败";
    }
    [UtilTool showAlertView:error];
}

#pragma mark limitbuy
-(void)clickClassifyBtnAtIndex:(NSInteger)index{
    GoodsClassifyVC *goodsClassifyVC = [[GoodsClassifyVC alloc] init];
    [self.wxNavigationController pushViewController:goodsClassifyVC];
}

#pragma mark recommend
-(void)homePageRecLoadedSucceed{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_RecomendInfo] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)homePageRecLoadedFailed:(NSString *)errorMsg{
}

-(void)homeRecommendCellbtnClicked:(id)sender{
    HomePageRecEntity *entity = sender;
    [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:entity.goods_id animated:YES];
}

#pragma mark surprice
-(void)homePageSurpLoadedSucceed{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_GuessInfo] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)homePageSurpLoadedFailed:(NSString *)errorMsg{
}

#pragma mark refresh
-(void)headerRefreshing{
    [_model loadData];
}

@end