//
//  NewHomePageCommonDef.h
//  RKWXT
//
//  Created by SHB on 15/5/29.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_NewHomePageCommonDef_h
#define RKWXT_NewHomePageCommonDef_h

#define Size self.bounds.size
#define T_HomePageTopImgHeight          (107)
#define T_HomePageBaseFunctionHeight    (128)
#define T_HomePageLimitBuyHeight        (125)
#define T_HomePageTextSectionHeight     (30)
#define T_HomePageRecommendHeight       (145)
#define T_HomePageGuessInfoHeight       (100)

#define BigTextFont   (13.0)
#define TextFont      (15.0)
#define SmallTextFont (12.0)

#define BigTextColor   (0x282828)
#define SmallTextColor (0xa5a3a3)
#define HomePageBGColor (0xffffff)

#define LimitBuyShow    (3)
#define RecommendShow   (3)
#define GuessInfoShow   (2)

//section
enum{
    T_HomePage_TopImg = 0,     //顶部图片
    T_HomePage_BaseFunction,   //基础功能模块
    T_HomePage_LimitBuyTitle,  //秒杀
    T_HomePage_LimitBuyInfo,   //
    T_HomePage_RecomendTitle,  //为我推荐
    T_HomePage_RecomendInfo,   //
    T_HomePage_GuessTitle,     //换一批
    T_HomePage_GuessInfo,      //
    
    T_HomePage_Invalid,
};

#import "WXTMallListWebVC.h"
#import "WXSysMsgUnreadV.h"
#import "MJRefresh.h"

#import "WXHomeTopGoodCell.h"
#import "WXHomeBaseFunctionCell.h"
#import "HomeLimitBuyTitleCell.h"
#import "HomeLimitBuyInfoCell.h"
#import "HomeRecommendInfoCell.h"
#import "HomeGuessInfoCell.h"

#import "JPushMessageCenterVC.h"

#pragma mark 导航跳转
enum{
    HomePageJump_Type_GoodsInfo = 1,    //商品详情
    HomePageJump_Type_Catagary,         //分类列表
    HomePageJump_Type_MessageCenter,    //消息中心
    HomePageJump_Type_MessageInfo,      //消息详情
    HomePageJump_Type_UserBonus,        //红包
    HomePageJump_Type_BusinessAlliance, //商家联盟
    
    HomePageJump_Type_Invalid
};

#endif
