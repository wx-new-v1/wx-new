//
//  WechatEntity.m
//  RKWXT
//
//  Created by SHB on 15/7/31.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WechatEntity.h"

@implementation WechatEntity

+(WechatEntity*)initWechatEntityWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *nonceStr = [dic objectForKey:@"noncestr"];
        [self setNoncestr:nonceStr];
        
        NSString *partnerid = [dic objectForKey:@"partnerid"];
        [self setPartnerid:partnerid];
        
        NSString *package = [dic objectForKey:@"package"];
        [self setPackage:package];
        
        NSString *prepayid = [dic objectForKey:@"prepayid"];
        [self setPrepayid:prepayid];
        
        NSString *sign = [dic objectForKey:@"sign"];
        [self setSign:sign];
        
        NSInteger timestamp = [[dic objectForKey:@"timestamp"] integerValue];
        [self setTimestamp:timestamp];
    }
    return self;
}

@end
