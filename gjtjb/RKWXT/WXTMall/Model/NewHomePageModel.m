//
//  NewHomePageModel.m
//  RKWXT
//
//  Created by SHB on 16/1/15.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "NewHomePageModel.h"
#import "HomePageTop.h"

@interface NewHomePageModel(){
    HomePageTop *_top;
    HomePageRecModel *_recommend;
    HomePageSurpModel *_surprise;
}
@end

@implementation NewHomePageModel

-(id)init{
    self = [super init];
    if(self){
        _top = [[HomePageTop alloc] init];
        _recommend = [[HomePageRecModel alloc] init];
        _surprise = [[HomePageSurpModel alloc] init];
    }
    return self;
}

-(void)toInit{
    [_top toInit];
    [_recommend toInit];
    [_surprise toInit];
}

-(void)setDelegate:(id<HomePageTopDelegate,HomePageRecDelegate,HomePageSurpDelegate>)delegate{
    [_top setDelegate:delegate];
    [_recommend setDelegate:delegate];
    [_surprise setDelegate:delegate];
}

-(BOOL)isSomeDataNeedReload{
    return [_top dataNeedReload] || [_recommend dataNeedReload] || [_surprise dataNeedReload];
}

-(void)loadData{
    [_top loadData];
    [_recommend loadData];
    [_surprise loadData];
}

@end
