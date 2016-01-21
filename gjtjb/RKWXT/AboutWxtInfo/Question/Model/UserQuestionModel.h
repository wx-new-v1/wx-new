//
//  UserQuestionModel.h
//  RKWXT
//
//  Created by SHB on 16/1/21.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserQuestionModelDelegate;

@interface UserQuestionModel : NSObject
@property (nonatomic,assign) id<UserQuestionModelDelegate>delegate;
-(void)submitUserQuestion:(NSString*)question phone:(NSString*)userPhone;

@end

@protocol UserQuestionModelDelegate <NSObject>
-(void)submitUserQuestionSucceed;
-(void)submitUserQuestionFailed:(NSString*)errorMsg;

@end
