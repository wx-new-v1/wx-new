//
//  NewHomePageModel.h
//  RKWXT
//
//  Created by SHB on 16/1/15.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomePageTop.h"
#import "HomePageRecModel.h"
#import "HomePageSurpModel.h"

@interface NewHomePageModel : NSObject
@property (nonatomic,assign) id<HomePageTopDelegate,HomePageRecDelegate>delegate;

@property (nonatomic,readonly) HomePageTop *top;
@property (nonatomic,readonly) HomePageRecModel *recommend;
@property (nonatomic,readonly) HomePageSurpModel *surprise;

-(BOOL)isSomeDataNeedReload;
-(void)loadData;
-(void)toInit;

@end
