//
//  WechatPayObj.h
//  RKWXT
//
//  Created by SHB on 15/6/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#define D_Notification_Name_WechatPaySucceed @"D_Notification_Name_WechatPaySucceed"
#define D_Notification_Name_WechatPayCancel @"D_Notification_Name_WechatPayCancel"
#define D_Notification_Name_WechatPayFailed @"D_Notification_Name_WechatPayFailed"

#import <Foundation/Foundation.h>
@class WechatEntity;

@interface WechatPayObj : NSObject

+ (WechatPayObj*)sharedWxPayOBJ;

-(void)registerApp;
-(void)handleOpenURL:(NSURL*)url;
-(void)wechatPayWith:(WechatEntity*)entity;

@end
