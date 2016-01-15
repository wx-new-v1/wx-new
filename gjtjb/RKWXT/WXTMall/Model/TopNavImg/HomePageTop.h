//
//  HomePageTop.h
//  RKWXT
//
//  Created by SHB on 16/1/15.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"
#import "HomePageTopEntity.h"

@protocol HomePageTopDelegate;

@interface HomePageTop : T_HPSubBaseModel
@property (nonatomic,assign) id<HomePageTopDelegate>delegate;
@end

@protocol HomePageTopDelegate <NSObject>
-(void)homePageTopLoadedSucceed;
-(void)homePageTopLoadedFailed:(NSString*)error;

@end
