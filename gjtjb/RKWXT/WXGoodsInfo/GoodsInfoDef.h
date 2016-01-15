//
//  GoodsInfoDef.h
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#ifndef GoodsInfoDef_h
#define GoodsInfoDef_h

#define Size self.bounds.size
#define DownViewHeight (44)
#define TopNavigationViewHeight (64)

#define GoodsInfoTitleHeaderViewHeight (45)
#define GoodsOtherHeaderViewHeight (36)
#define LMGoodsBaseInfoCellHeight (33)
#define GoodsSellerInfoCellHeight (53)

enum{
    GoodsInfo_Section_TopImg = 0,
    GoodsInfo_Section_GoodsDesc,
    GoodsInfo_Section_GoodsInfo,
    GoodsInfo_Section_SellerInfo,
    GoodsInfo_Section_OtherShop,
//    GoodsInfo_Section_Evaluate,
    
    GoodsInfo_Section_Invalid,
};

#import "MerchantImageCell.h"
#import "GoodsInfoDesCell.h"
#import "GoodsIBasenfoCell.h"
#import "GoodsSellerCell.h"
#import "GoodsOtherSellerCell.h"
#import "GoodsEvaluateCell.h"

#import "GoodsStockView.h"
#import "NewImageZoomView.h"
#import "WXRemotionImgBtn.h"
#import "NewGoodsInfoWebViewViewController.h"
//分享
#import "WXWeiXinOBJ.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "CDSideBarController.h"

#import "GoodsInfoModel.h"
#import "GoodsInfoEntity.h"

enum{
    Share_Qq,
    Share_Qzone,
    Share_Friends,
    Share_Clrcle,
    
    Share_Invalid,
};


#endif /* GoodsInfoDef_h */
