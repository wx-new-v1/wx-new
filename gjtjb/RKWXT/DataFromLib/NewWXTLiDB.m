//
//  NewWXTLiDB.m
//  RKWXT
//
//  Created by SHB on 15/6/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewWXTLiDB.h"
#import "NewUserAddressModel.h"
#import "UserHeaderModel.h"

@implementation NewWXTLiDB

+(NewWXTLiDB*)sharedWXLibDB{
    static dispatch_once_t onceToken;
    static NewWXTLiDB *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NewWXTLiDB alloc] init];
    });
    return sharedInstance;
}

-(void)loadData{
    [NewUserAddressModel shareUserAddress].address_type = UserAddress_Type_Search;
    [[NewUserAddressModel shareUserAddress] loadUserAddress];
//    [[UserHeaderModel shareUserHeaderModel] loadUserHeaderImageWith];
}

@end
