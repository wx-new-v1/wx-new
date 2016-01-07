//
//  WXTMallViewController.m
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/23.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTMallViewController.h"
#import "NewHomePageCommonDef.h"

@interface WXTMallViewController ()<UITableViewDelegate,UITableViewDataSource,WXSysMsgUnreadVDelegate>{
    UITableView *_tableView;
    WXSysMsgUnreadV * _unreadView;
}
@end

@implementation WXTMallViewController

-(void)dealloc{
    RELEASE_SAFELY(_tableView);
    [super dealloc];
}

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
    
    [self createTopBtn];
}

-(void)createTopBtn{
    WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 6, 30, 30);
    [leftBtn setImage:[UIImage imageNamed:@"HomePageLeftBtn.png"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(homePageToCategaryView) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftNavigationItem:leftBtn];
    
    _unreadView = [[WXSysMsgUnreadV alloc] initWithFrame:CGRectMake(0, 0, kDefaultNavigationBarButtonSize.width, kDefaultNavigationBarButtonSize.height)];
    [_unreadView setDelegate:self];
    [_unreadView showSysPushMsgUnread];
    [self setRightNavigationItem:_unreadView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    return height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return T_HomePage_Invalid;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    return cell;
}

#pragma mark 消息推送
- (void)toSysPushMsgView{
    [[CoordinateController sharedCoordinateController] toJPushCenterVC:self animated:YES];
}

@end