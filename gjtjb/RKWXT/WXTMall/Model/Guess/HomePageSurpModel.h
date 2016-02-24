//
//  HomePageSurpModel.h
//  RKWXT
//
//  Created by SHB on 16/1/15.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol HomePageSurpDelegate;
@interface HomePageSurpModel : T_HPSubBaseModel
@property (nonatomic,assign) id<HomePageSurpDelegate>delegate;
@end

@protocol HomePageSurpDelegate <NSObject>
-(void)homePageSurpLoadedSucceed;
-(void)homePageSurpLoadedFailed:(NSString*)errorMsg;

@end
