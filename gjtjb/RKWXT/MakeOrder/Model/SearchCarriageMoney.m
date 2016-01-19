//
//  SearchCarriageMoney.m
//  RKWXT
//
//  Created by SHB on 15/11/6.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "SearchCarriageMoney.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation SearchCarriageMoney

-(void)searchCarriageMoneyWithProvinceID:(NSInteger)provinceID goodsInfo:(NSString *)goodsInfo{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.shopID, @"shop_id", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:(int)provinceID], @"provincial_id", goodsInfo, @"goods_info", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.shopID, @"shop_id", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:(int)provinceID], @"provincial_id", goodsInfo, @"goods_info", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_SearchCarriageMoney httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(searchCarriageMoneyFailed:)]){
                [_delegate searchCarriageMoneyFailed:retData.errorDesc];
            }
        }else{
            [self setCarriageMoney:[[[retData.data objectForKey:@"data"] objectForKey:@"postage"] floatValue]];
            if(_delegate && [_delegate respondsToSelector:@selector(searchCarriageMoneySucceed)]){
                [_delegate searchCarriageMoneySucceed];
            }
        }
    }];
}

@end
