//
//  WXTURLFeedOBJ.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTURLFeedOBJ.h"

@implementation WXTURLFeedOBJ

+ (WXTURLFeedOBJ*)sharedURLFeedOBJ{
    static dispatch_once_t onceToken;
    static WXTURLFeedOBJ *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WXTURLFeedOBJ alloc] init];
    });
    return sharedInstance;
}

- (NSString*)rootURL:(WXT_UrlFeed_Type)type{
    NSString *url = nil;
    NSString *newRootUrl = [NSString stringWithFormat:@"%@wx10api",WXTBaseUrl];   //商城模块
    NSString *allUrl = nil;
    switch (type) {
        case WXT_UrlFeed_Type_LoadBalance:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Recharge:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Sign:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Login:
            url = @"/login.php";
            break;
        case WXT_UrlFeed_Type_Regist:
            url = @"/app_register.php";
            break;
        case WXT_UrlFeed_Type_FetchPwd:
            url = @"";
            break;
        case WXT_UrlFeed_Type_GainNum:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Version:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Call:
            url = @"";
            break;
        case WXT_UrlFeed_Type_HungUp:
            url = @"/hangup.php";
            break;
        case WXT_UrlFeed_Type_ResetPwd:
            url = @"/modify_pwd.php";
            break;
        case WXT_UrlFeed_Type_NewMall_UserAddress:
            url = @"/get_user_address.php";
            break;
        case WXT_UrlFeed_Type_New_LoadUserBonus:
            url = @"/get_user_red_packet.php";
            break;
        case WXT_UrlFeed_Type_New_Code:
            url = @"/get_rcode.php";
            break;
        case WXT_UrlFeed_Type_New_ResetNewPwd:
            url = @"/reset_pwd.php";
            break;
        case WXT_UrlFeed_Type_New_AboutShop:
            url = @"/get_seller_detail.php";
            break;
        case WXT_UrlFeed_Type_New_Version:
            url = @"/version.php";
            break;
        case WXT_UrlFeed_Type_New_Balance:
            url = @"/telephone_fare.php";
            break;
        case WXT_UrlFeed_Type_New_JPushMessageInfo:
            url = @"/get_message_detail.php";
            break;
        case WXT_UrlFeed_Type_New_Call:
            url = @"/callback.php";
            break;
        case WXT_UrlFeed_Type_New_Sign:
            url = @"/sign_in.php";
            break;
        case WXT_UrlFeed_Type_New_PersonalInfo:
            url = @"/userinfo.php";
            break;
        case WXT_UrlFeed_Type_New_Recharge:
            url = @"/recharge.php";
            break;
        case WXT_UrlFeed_Type_UserQuestion:
            url = @"/question.php";
            break;
        case WXT_UrlFeed_Type_New_Wechat:
//            url = @"/get_prepay_id.php";
            allUrl = @"wx10order/wx10WeixinPay/app_prepay_id.php";
            break;
        case WXT_UrlFeed_Type_New_RechargeList:
            url = @"/insert_recharge_order.php";
            break;
        case WXT_UrlFeed_Type_New_LoadJPushMessage:
            url = @"/get_new_message.php";
            break;
        case WXT_UrlFeed_Type_New_SharedSucceed:
            url = @"/get_share_award.php";
            break;
        case WXT_UrlFeed_Type_New_UserLoginShopInfo:
            url = @"/get_shoplist.php";
            break;
        case WXT_UrlFeed_Type_New_UpdateUserHeader:
            url = @"/app_upload_userpic.php";
            break;
        case WXT_UrlFeed_Type_New_LoadUserHeader:
            url = @"/get_user_pic.php";
            break;
        case WXT_UrlFeed_Type_New_UpdapaOrderID:
            url = @"/get_pay_status.php";
            break;
        case WXT_UrlFeed_Type_New_FindData:
            url = @"/discover.php";
            break;
        case WXT_UrlFeed_Type_Home_OrderList:
            url = @"/order_list.php";
            break;
        case WXT_UrlFeed_Type_New_UserBonus:
            url = @"";
            break;
        case WXT_UrlFeed_Type_New_GainBonus:
            url = @"";
            break;
        case WXT_UrlFeed_Type_NewMall_TopImg:
            url = @"/top_images.php";
            break;
        case WXT_UrlFeed_Type_NewMall_Recommond:
            url = @"/home_recommend.php";
            break;
        case WXT_UrlFeed_Type_NewMall_Surprise:
            url = @"/home_youlike.php";
            break;
        case WXT_UrlFeed_Type_New_LoadClassifyData:
            url = @"/top_category.php";
            break;
        case WXT_UrlFeed_Type_New_LoadClassifyGoodsList:
            url = @"/category_goods.php";
            break;
        case WXT_UrlFeed_Type_Home_GoodsInfo:
            url = @"/single_goods_info.php";
            break;
        case WXT_UrlFeed_Type_NewMall_ImgAndText:
            url = @"";
            break;
        case WXT_UrlFeed_Type_New_CheckAreaVersion:
            url = @"/get_area_version.php";
            break;
        case WXT_UrlFeed_Type_New_LoadAreaData:
            url = @"/area.php";
            break;
        case WXT_UrlFeed_Type_NewMall_NewUserAddress:
            url = @"/user_address.php";
            break;
        case WXT_UrlFeed_Type_NewMall_ShoppingCart:
            url = @"/shopping_cart.php";
            break;
        case WXT_UrlFeed_Type_New_SearchCarriageMoney:
            url = @"/postage.php";
            break;
        case WXT_UrlFeed_Type_New_MakeOrder:
            url = @"/insert_order.php";
            break;
        case WXT_UrlFeed_Type_New_CancelOrder:
            url = @"/cancel_order.php";
            break;
        case WXT_UrlFeed_Type_New_CompleteOrder:
            url = @"/ack_receiving.php";
            break;
        case WXT_UrlFeed_Type_New_LoadMyClientInfo:
            url = @"";
            break;
        case WXT_UrlFeed_Type_New_LoadUserAliAccount:
            url = @"";
            break;
        case WXT_UrlFeed_Type_New_LoadMyClientPerson:
            url = @"";
            break;
        case WXT_UrlFeed_Type_New_LoadMyCutInfo:
            url = @"";
            break;
        case WXT_UrlFeed_Type_New_JuniorList:
            url = @"";
            break;
        case WXT_UrlFeed_Type_New_UserCutSource:
            url = @"";
            break;
        case WXT_UrlFeed_Type_New_ApplyAliMoney:
            url = @"";
            break;
        case WXT_UrlFeed_Type_New_SubmitUserAliAcount:
            url = @"";
            break;
        case WXT_UrlFeed_Type_New_LoadAliRecordList:
            url = @"";
            break;
        case WXT_UrlFeed_Type_New_SearchGoodsOrShop:
            url = @"/search.php";
            break;
        default:
            break;
    }
    if(allUrl){
        return [NSString stringWithFormat:@"%@%@",WXTBaseUrl,allUrl];
    }
    NSString *compURL = nil;
    if(![url isEqualToString:@""]){
        return [NSString stringWithFormat:@"%@%@",newRootUrl,url];
    }
    return compURL;
}

- (NSString*)urlRequestParamFrom:(NSDictionary*)dic{
    NSArray *keys = [dic allKeys];
    if ([keys count] == 0){
        return nil;
    }
    
    NSMutableString *mutString = [NSMutableString string];
    for (NSString *key in keys){
        id value = [dic objectForKey:key];
        if (!value){
            KFLog_Normal(YES, @"无效的参数 key = %@",key);
            continue;
        }
        if ([keys indexOfObject:key] != 0){
            [mutString appendString:@"&"];
        }
        [mutString appendFormat:@"%@=%@",key,value];
    }
    return mutString;
}

@end
