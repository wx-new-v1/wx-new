//
//  CLassifySearchModel.h
//  RKWXT
//
//  Created by app on 16/2/29.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    Search_Type_Goods = 1,
    Search_Type_Shop,
}Search_Type;

@protocol CLassifySearchModelDelegate <NSObject>
-(void)classifySearchResultSucceed;
- (void)classifySearchResultClearSource;
@end

@interface CLassifySearchModel : NSObject
@property (nonatomic,strong) NSMutableArray *searchResultArr;
@property (nonatomic,strong)NSArray *historyArr;
@property (nonatomic,assign) Search_Type searchType;
@property (nonatomic,assign) id<CLassifySearchModelDelegate>delegate;
-(void)classifySearchWith:(NSString*)searchStr;
@end
