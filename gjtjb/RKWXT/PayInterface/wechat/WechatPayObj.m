//
//  WechatPayObj.m
//  RKWXT
//
//  Created by SHB on 15/6/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WechatPayObj.h"
#import "payRequsestHandler.h"
#import "WXApi.h"
#import "WechatDef.h"
#import "WechatEntity.h"

@interface WechatPayObj()<WXApiDelegate>

@end

@implementation WechatPayObj

+ (WechatPayObj*)sharedWxPayOBJ{
    static dispatch_once_t onceToken;
    static WechatPayObj *sharedOBJ = nil;
    dispatch_once(&onceToken, ^{
        sharedOBJ = [[WechatPayObj alloc] init];
    });
    return sharedOBJ;
}

//注册App
- (void)registerApp{
    NSArray *arr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    NSDictionary *dic = [arr objectAtIndex:1];
    NSString *appId = [[dic objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
    if([WXApi registerApp:appId withDescription:@"wx_pay"]){
        KFLog_Normal(YES, @"微信注册成功");
    }else{
        KFLog_Normal(YES, @"微信注册失败");
    }
}

- (void)handleOpenURL:(NSURL*)url{
    [WXApi handleOpenURL:url delegate:self];
}

-(void)wechatPayWith:(WechatEntity*)entity{
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = entity.partnerid;
    req.prepayId = entity.prepayid;
    req.nonceStr = entity.noncestr;
    req.timeStamp = entity.timestamp;
    req.package = entity.package;
    req.sign = entity.sign;
    [WXApi sendReq:req];
}

-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                [UtilTool showAlertView:nil message:@"恭喜您,支付成功" delegate:self tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
                break;
            case WXErrCodeUserCancel:
                [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_WechatPayCancel object:nil];
                break;
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_WechatPayFailed object:nil];
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_WechatPaySucceed object:nil];
}

@end
