//
//  WXTFindVC.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.


#import "WXTFindVC.h"
#import "WXTFindCommmonCell.h"
#import "FindCommonVC.h"

#define Size self.bounds.size

enum{
    Find_Section_ShopUnion = 0,
    Find_Section_Weather,
    
    Find_Section_Invalid,
};

@interface WXTFindVC()<UIWebViewDelegate>{
}
@end

@implementation WXTFindVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"发现"];
    self.backgroundColor = WXColorWithInteger(0xefeff4);
}

@end
