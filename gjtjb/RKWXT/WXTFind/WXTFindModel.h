//
//  WXTFindModel.h
//  RKWXT
//
//  Created by SHB on 15/3/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol wxtFindModelDelegate;
@interface WXTFindModel : NSObject
@property (nonatomic,strong) NSArray *findDataArr;
@property (nonatomic,assign) id<wxtFindModelDelegate>findDelegate;

-(void)loadFindData;
@end

@protocol wxtFindModelDelegate <NSObject>
-(void)initFinddataSucceed;
-(void)initFinddataFailed:(NSString*)errorMsg;

@end
