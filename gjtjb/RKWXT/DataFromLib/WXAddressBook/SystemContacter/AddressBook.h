//
//  AddressBook.h
//  Woxin2.0
//
//  Created by le ting on 7/10/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContacterEntity.h"

@interface AddressBook : NSObject
@property (nonatomic,readonly) NSArray *contactList;
//T9搜索
@property (nonatomic,readonly) NSMutableDictionary *contactNameDic;
@property (nonatomic,readonly) NSMutableArray *chineceHeadArr;
@property (nonatomic, getter = isAccessGranted, readonly)BOOL accessGranted;
@property (nonatomic,readonly,assign) NSInteger count;
+ (AddressBook*)sharedAddressBook;

//加载通讯录~
- (void)loadContact;
//上传通讯录~
- (void)uploadSysContacters;
- (ContacterEntity*)contacterEntityForRecordID:(NSInteger)recordID;//通过recordID获取实体~
- (ContacterEntity*)contacterEntityForNumber:(NSString*)phone;//通过号码获取实体
@end
