//
//  UserInfoDef.h
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_UserInfoDef_h
#define RKWXT_UserInfoDef_h

#import "PersonalInfoOrderListCell.h"
#import "PersonalOrderInfoCell.h"
#import "PersonalMoneyCell.h"
#import "PersonalCallCell.h"
#import "UserInfoCommonCell.h"

#import "UserBalanceVC.h"
#import "SignViewController.h"
#import "AboutWxtInfoVC.h"
#import "NewSystemSettingVC.h"
#import "BaseInfoVC.h"
#import "WXUserQuestionVC.h"
#import "WXHomeOrderListVC.h"
#import "ShoppingCartVC.h"

enum{
    PersonalInfo_Order = 0,
    PersonalInfo_SharkOrder,
    PersonalInfo_Call,
    PersonalInfo_CutAndShare,
    PersonalInfo_System,
    
    PersonalInfo_Invalid
};

//订单
enum{
    Order_listAll = 0,
    Order_Category,
    
    Order_Invalid
};
//抽奖
enum{
    Shark_OrderList = 0,
    Shark_Collection,
    
    Shark_Invalid,
};
//钱包
enum{
    Money_listAll = 0,
    Money_Category,
    
    Money_Invalid
};

enum{
    Call_Recharge,
    Call_Sign,
    
    Call_Invalid
};

//系统
enum{
    System_About = 0,
    System_Question,
    System_Setting,
    
    System_Invalid
};

//提成
enum{
    User_Cut = 0,
    User_Share,
    
    User_Invalid
};

#endif
