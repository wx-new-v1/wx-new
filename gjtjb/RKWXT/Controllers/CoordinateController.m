//
//  CoordinateController.m
//  Woxin2.0
//
//  Created by le ting on 7/15/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "CoordinateController.h"
#import "SignViewController.h"
#import "OrderPayVC.h"
#import "RechargeVC.h"
#import "AboutShopVC.h"
#import "JPushMessageCenterVC.h"
#import "JPushMessageInfoVC.h"
#import "FindCommonVC.h"
@implementation CoordinateController

+ (CoordinateController*)sharedCoordinateController{
    static dispatch_once_t onceToken;
    static CoordinateController *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoordinateController alloc] init];
    });
    return sharedInstance;
}

+ (WXUINavigationController*)sharedNavigationController{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    WXUINavigationController *navigationController = appDelegate.navigationController;
    return navigationController;
}

-(void)toGuideView:(id)sender animated:(BOOL)animated{
    
}

-(void)toSignVC:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    SignViewController *signVC = [[SignViewController alloc] init];
    [vc.wxNavigationController pushViewController:signVC];
}

-(void)toRechargeVC:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    RechargeVC *rechargeVC = [[RechargeVC alloc] init];
    [vc.wxNavigationController pushViewController:rechargeVC];
}

-(void)toOrderList:(id)sender selectedShow:(NSInteger)number animated:(BOOL)animated{
}

-(void)toLuckyOrderList:(id)sender animated:(BOOL)animated{
}

-(void)toGoodsInfoVC:(id)sender goodsID:(NSInteger)goodsID animated:(BOOL)animated{
}

-(void)toUserBonusVC:(id)sender animated:(BOOL)animated{
}

-(void)toMakeOrderVC:(id)sender orderInfo:(id)orderInfo animated:(BOOL)animated{
}

-(void)toOrderPayVC:(id)sender orderInfo:(id)orderInfo animated:(BOOL)animated{
}

-(void)toRefundVC:(id)sender goodsInfo:(id)goodsInfo animated:(BOOL)animated{
}

-(void)toRefundInfoVC:(id)sender orderEntity:(id)orderEntity animated:(BOOL)animated{
}

-(void)toOrderInfoVC:(id)sender orderEntity:(id)orderEntity animated:(BOOL)animated{
}

-(void)toAboutShopVC:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    AboutShopVC *shopVC = [[AboutShopVC alloc] init];
    [vc.wxNavigationController pushViewController:shopVC];
}

-(void)toJPushCenterVC:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    JPushMessageCenterVC *centerVC = [[JPushMessageCenterVC alloc] init];
    [vc.wxNavigationController pushViewController:centerVC];
}

-(void)toJPushMessageInfoVC:(id)sender messageID:(NSInteger)messageID animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    JPushMessageInfoVC *infoVC = [[JPushMessageInfoVC alloc] init];
    infoVC.messageID = messageID;
    [vc.wxNavigationController pushViewController:infoVC];
}

-(void)toWebVC:(id)sender url:(NSString *)webUrl title:(NSString *)title animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    FindCommonVC *webVC = [[FindCommonVC alloc] init];
    webVC.webURl = webUrl;
    webVC.name = title;
    [vc.wxNavigationController pushViewController:webVC];
}

@end
