//
//  AppDelegate.m
//  RKWXT
//
//  Created by Elty on 15/3/7.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "AppDelegate.h"
#import "WXUITabBarVC.h"
#import "DDFileLogger.h"
#import "LoginVC.h"
#import "WXTVersion.h"
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import "ContactUitl.h"
#import "APService.h"
#import "WXTUITabbarVC.h"
#import "CallViewController.h"
#import "NewWXTLiDB.h"
#import "AliPayControl.h"
#import "JPushMessageModel.h"
#import <AudioToolbox/AudioToolbox.h>

#import "WXWeiXinOBJ.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "UserInfoVC.h"
#import "ShareSucceedModel.h"
#import <AlipaySDK/AlipaySDK.h>

#import "AllAreaDataModel.h"
#import "BaiduMobStat.h"
#import "MobClick.h"
#import "WechatPayObj.h"

@interface AppDelegate (){
    CTCallCenter *_callCenter;
    BOOL hasDeal;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AddressBook sharedAddressBook] loadContact];
    [ContactUitl shareInstance];
    [self startBaiduMobStat];
	[self initUI];
    //监听电话
    [self listenSystemCall];
    // 集成极光推送功能
    [self initJPushApi];
    [APService setupWithOption:launchOptions];
    
    //向微信注册
    [[WXWeiXinOBJ sharedWeiXinOBJ] registerApp];
    [[WechatPayObj sharedWxPayOBJ] registerApp];
    //向qq注册
    id result = [[TencentOAuth alloc] initWithAppId:@"1104707907" andDelegate:nil];
    if(result){}
    
    //友盟
    [MobClick startWithAppkey:@"56c171cf67e58ef17d001152" reportPolicy:BATCH   channelId:@"IOS"];
    
	return YES;
}

-(void)initUI{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];
    
    BOOL userInfo = [self checkUserInfo];
    if(userInfo){
        WXTUITabbarVC *tabbarVC = [[WXTUITabbarVC alloc] init];
        self.navigationController = [[WXUINavigationController alloc] initWithRootViewController:tabbarVC];
        [self.window setRootViewController:self.navigationController];
        [self.window makeKeyAndVisible];
        
        [[NewWXTLiDB sharedWXLibDB] loadData];
        [self checkVersion];
        [self checkAreaVersion];
        //自动登录
        WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
//        LoginModel *_loginModel = [[LoginModel alloc] init];
//        [_loginModel loginWithUser:userDefault.user andPwd:userDefault.pwd];
        
        NSSet *set1 = [NSSet setWithObjects:[NSString stringWithFormat:@"%@",userDefault.user], [NSString stringWithFormat:@"seller_%@",userDefault.sellerID], nil];
        [APService setTags:set1 alias:nil callbackSelector:nil object:nil];
    }else{
        WXUIViewController *vc = [[LoginVC alloc] init];
        self.navigationController = [[WXUINavigationController alloc] initWithRootViewController:vc];
        [vc.navigationController setNavigationBarHidden:YES];
        [self.window setRootViewController:self.navigationController];
        [self.window makeKeyAndVisible];
    }
}

- (void)startBaiduMobStat {
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.shortAppVersion  = [UtilTool currentVersion];
    [statTracker startWithAppId:@"931d157a8a"]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
}

-(BOOL)checkUserInfo{
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    if(!userDefault.user || !userDefault.pwd || !userDefault.wxtID){
        return NO;
    }
    return YES;
}

-(void)listenSystemCall{
    //监听手机通话状态,私有API
    _callCenter = [[CTCallCenter alloc] init];
    _callCenter.callEventHandler = ^(CTCall *call){
        if ([call.callState isEqualToString:CTCallStateIncoming]){
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:D_Notification_Name_SystemCallIncomming object:nil userInfo:nil];
        }else if ([call.callState isEqualToString:CTCallStateDisconnected]){
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:D_Notification_Name_SystemCallFinished object:nil userInfo:nil];
        }
    };
}

-(void)checkVersion{
    WXTVersion *version = [WXTVersion sharedVersion];
    [version setCheckType:Version_CheckType_System];
    [version checkVersion];
}

-(void)checkAreaVersion{
    AllAreaDataModel *model = [AllAreaDataModel shareAllAreaData];
    [model checkAllAreaVersion];
}

#pragma mark 极光推送功能
-(void)initJPushApi{
    // Required
    #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //categories
            [APService
             registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                 UIUserNotificationTypeSound |
                                                 UIUserNotificationTypeAlert)
             categories:nil];
        } else {
            //categories nil
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#else
             //categories nil
             categories:nil];
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#endif
             // Required
             categories:nil];
        }
    [self addObserver];
}

-(void)addObserver{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}

- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}

- (void)networkDidSetup:(NSNotification *)notification {
    DDLogDebug(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    DDLogDebug(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    DDLogDebug(@"已注册RegistrationID:%@",[[notification userInfo] valueForKey:@"RegistrationID"]);
}

- (void)networkDidLogin:(NSNotification *)notification {
    DDLogDebug(@"已登录");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {  //应用内消息,由锁屏进入应用内
    NSDictionary *userInfo = [notification userInfo];
//    [APService handleRemoteNotification:userInfo];
    [[JPushMessageModel shareJPushModel] initJPushWithCloseDic:userInfo];
}

- (void)serviceError:(NSNotification *)notification {
    DDLogDebug(@"error:%@", [[notification userInfo] valueForKey:@"error"]);
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {   //锁屏状态APNS,字段和应用内不同
    // Required
    [APService handleRemoteNotification:userInfo];
    [[JPushMessageModel shareJPushModel] initJPushWithCloseDic:userInfo];
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo  //点击锁屏消息打开应用收到的消息或者在应用内收到的消息
fetchCompletionHandler:(void
                        (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    hasDeal = YES;
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [[JPushMessageModel shareJPushModel] initJPushWithDic:userInfo];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in Jpush registration. Error: %@", err);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application {
    CallViewController *callVC = [[CallViewController alloc] init];
    [callVC setEmptyText];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    hasDeal = NO;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];  //设置图标0
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if(!hasDeal){
        [[JPushMessageModel shareJPushModel] loadJPushMessageFromService];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark handle
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    //支付宝
//    [[AliPayControl sharedAliPayOBJ] handleAliPayURL:url];
    //微支付
    [WXApi handleOpenURL:url delegate:self];
    //微信
    [[WXWeiXinOBJ sharedWeiXinOBJ] handleOpenURL:url];
    //qq
    [TencentOAuth HandleOpenURL:url];
    
    UserInfoVC *infoVC = [[UserInfoVC alloc] init];
    [QQApiInterface handleOpenURL:url delegate:infoVC];
    return YES;
}

//微信分享回调
-(void)onResp:(BaseResp*)resp{
    if([resp isKindOfClass:[SendMessageToWXResp class]]){
        NSInteger error = resp.errCode;
        if(error != 0){
            NSString *msgError = resp.errStr;
            if(msgError){
                [UtilTool showAlertView:nil message:msgError delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
            }
        }else{
            [[ShareSucceedModel sharedSucceed] sharedSucceed];
            [UtilTool showAlertView:nil message:@"微信分享成功" delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
    }];
    [[WechatPayObj sharedWxPayOBJ] handleOpenURL:url];
    return YES;
}

@end
