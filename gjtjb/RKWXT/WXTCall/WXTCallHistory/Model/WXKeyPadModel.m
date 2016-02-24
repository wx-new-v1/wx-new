//
//  WXKeyPadModel.m
//  Woxin2.0
//
//  Created by le ting on 8/1/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXKeyPadModel.h"
#import "CallRecord.h"
#import "CallHistoryEntityExt.h"
#import "StrangerEntity.h"
#import "SysContacterEntityEx.h"
#import "WXTDatabase.h"

@interface WXKeyPadModel()
{
    NSMutableArray *_callHistoryList;
    NSMutableArray *_contacterFilter;
    NSArray * _list; //通话记录
    
    NSMutableArray *lastSearchArr;  //临时数组
    
    //T9搜索
    NSMutableDictionary *numLetters;//字母数值对应字典
    NSMutableArray *chineseHeadArr ;//中文首字母数组
    NSMutableArray *arrayLetters;//输入的字母组
    NSMutableString *mutString; //
    NSString *lastSearchString;
}
@end

@implementation WXKeyPadModel

- (void)dealloc{
    _delegate = nil;
    [self removeOBS];
}

- (id)init{
    if(self = [super init]){
        _callHistoryList = [[NSMutableArray alloc] init];
        _contacterFilter = [[NSMutableArray alloc] init];
        lastSearchArr = [[NSMutableArray alloc] init];
        
        numLetters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"", @"1", @"abc", @"2"
                       , @"def", @"3", @"ghi", @"4", @"jkl", @"5", @"mno", @"6", @"pqrs", @"7", @"tuv", @"8"
                      , @"wxyz", @"9", @"", @"0", nil];
        chineseHeadArr = [[NSMutableArray alloc] init];
        
        [self loadHistory];
        [self addOBS];
    }
    return self;
}

- (void)loadHistory{
    [_callHistoryList removeAllObjects];
    
    _list = [CallRecord sharedCallRecord].callHistoryList;
    CallHistoryEntityExt *entityExt = nil;
    for(CallHistoryEntity *entity in _list){
        NSString *phoneNumber = entity.phoneNumber;
        if(!phoneNumber || [phoneNumber length] < 6){
            continue;
        }
        
        if(entity.historyType == E_CallHistoryType_MakingReaded_Invalid){
            continue;
        }
        if(entityExt){
            if([entityExt canMergeRecord:entity]){
                [entityExt addRecord:entity];
            }else{
                entityExt = nil;
            }
        }
        
        if(!entityExt){
            entityExt = [[CallHistoryEntityExt alloc] init] ;
            [entityExt addRecord:entity];
            [_callHistoryList addObject:entityExt];
            WXContacterEntity *entity = [[WXContactMonitor sharedWXContactMonitor] entityForPhonNumber:phoneNumber];
            if(entity){
                [entityExt setContacterEntity:entity];
            }else{
                ContacterEntity *entity = [[AddressBook sharedAddressBook] contacterEntityForNumber:phoneNumber];
                if(entity){
                    [entityExt setContacterEntity:entity];
                }else{
                    StrangerEntity *stranger =  [[StrangerEntity alloc] init];
                    [stranger setPhoneNumber:phoneNumber];
                    [entityExt setContacterEntity:stranger];
                }
            }
        }
    }
}

- (void)searchContacter:(NSString*)searchString{
    if([searchString isEqualToString:@""]){
        [arrayLetters removeAllObjects];
        mutString = nil;
        return;
    }
    BOOL isPlus = NO;  //是否在按删除键
    BOOL isLarger = NO;  //超过4位默认不再匹配名字
    
    if(searchString.length > 3){
        isLarger = YES;
    }
    if(lastSearchString.length > searchString.length){
        NSRange range ;
        range.location = [mutString length]-1;
        range.length = 1;
        [mutString deleteCharactersInRange:range];
        [arrayLetters removeAllObjects];
        
        lastSearchString = searchString;
        for (NSInteger i = 0; i < [mutString length]; i++) {
            char letter = [mutString characterAtIndex:i];
            NSString *str = [NSString stringWithFormat:@"%c",letter];
            [self SelectName:str larger:isLarger];
            isPlus = YES;
        }
    }
    
    //如果是在删除，那么调用后面的方法
    if(isPlus){
        return;
    }
    
    lastSearchString = searchString;
    NSInteger length = searchString.length;
    NSString *keyNum = [searchString substringWithRange:NSMakeRange(length-1, 1)];
    [_contacterFilter removeAllObjects];
    if (!mutString) {
        mutString = [[NSMutableString alloc] init];
    }
    if (!arrayLetters) {
        arrayLetters = [[NSMutableArray alloc] init];
    }
    
    NSString *letters = [numLetters objectForKey:keyNum];
    if (!letters) {
        [mutString appendString:keyNum];
    }else{
        if (0 == [arrayLetters count]) {
            for (NSInteger i = 0; i < [letters length]; i++) {
                char letter = [letters characterAtIndex:i];
                NSString *str = [NSString stringWithFormat:@"%c",letter];
                [arrayLetters addObject:str];
            }
        }else{
            NSMutableArray *tmpArray=nil;
            tmpArray = [self mergeArray:arrayLetters Behind:letters];
            [arrayLetters removeAllObjects];
            [arrayLetters addObjectsFromArray:tmpArray];
            [tmpArray removeAllObjects];
        }
        [mutString appendString:keyNum];
    }
    
    if(!isLarger){
        for (id word in arrayLetters) {
            [[AddressBook sharedAddressBook].chineceHeadArr enumerateObjectsUsingBlock:^(id chineseHead,NSUInteger idx,BOOL *stop){
                NSRange range = [chineseHead rangeOfString:word];
                if (range.length != 0) {//存在匹配的声母
                    ContacterEntity *entity = [[AddressBook sharedAddressBook].contactNameDic objectForKey:chineseHead];
                    SysContacterEntityEx *sysContacterEntityEx = [[SysContacterEntityEx alloc] init];
                    [sysContacterEntityEx setContactEntity:entity];
                    [sysContacterEntityEx setPhoneMatched:[entity.phoneNumbers objectAtIndex:0]];
                    [_contacterFilter addObject:sysContacterEntityEx];
                }
            }];
        }
    }

    NSArray *list = [AddressBook sharedAddressBook].contactList;
    for(ContacterEntity *entity in list){
        //针对号码搜索
        NSArray *phoneNumbers = entity.phoneNumbers;
        for(NSString *phone in phoneNumbers){
            if([phone rangeOfString:searchString].location != NSNotFound){
                SysContacterEntityEx *sysContacterEntityEx = [[SysContacterEntityEx alloc] init];
                [sysContacterEntityEx setContactEntity:entity];
                [sysContacterEntityEx setPhoneMatched:phone];
                [_contacterFilter addObject:sysContacterEntityEx];
            }
        }
    }
}

//首字母组合数组
-(NSMutableArray*)mergeArray:(NSArray *)aheadarray Behind:(NSString*)behind{
    NSInteger behindLen = [behind length];
    NSMutableArray *rarray = [[NSMutableArray alloc] init];
    for (id word in aheadarray) {
        for (NSInteger j = 0; j<behindLen; j++) {
            char cbehind = [behind characterAtIndex:j];
            NSString *str = [NSString stringWithFormat:@"%@%c",word,cbehind];
            [rarray addObject:str];
        }
    }
    return rarray;
}

//删除
//搜索算法
-(void)SelectName:(NSString*)KeyNum larger:(BOOL)isLarger{
    if (!arrayLetters) {
        arrayLetters = [[NSMutableArray alloc] init];
    }
    
    NSString *letters = [numLetters objectForKey:KeyNum];
    
    if (0 == [arrayLetters count]) {
        for (NSInteger i = 0; i < [letters length]; i++) {
            char letter = [letters characterAtIndex:i];
            NSString *str = [NSString stringWithFormat:@"%c",letter];
            [arrayLetters addObject:str];
        }
    }else{
        NSMutableArray *tmpArray = nil;
        tmpArray = [self mergeArray:arrayLetters Behind:letters];
        [arrayLetters removeAllObjects];
        [arrayLetters addObjectsFromArray:tmpArray];
        [tmpArray removeAllObjects];
    }
    [_contacterFilter removeAllObjects];
    
    //查找首字母匹配的记录
    if(!isLarger){
        for (id word in arrayLetters) {
            for (id chineseHead in [AddressBook sharedAddressBook].chineceHeadArr) {
                NSRange range = [chineseHead rangeOfString:word];
                if (range.length != 0) {//存在匹配的声母
                    ContacterEntity *entity = [[AddressBook sharedAddressBook].contactNameDic objectForKey:chineseHead];
                    SysContacterEntityEx *sysContacterEntityEx = [[SysContacterEntityEx alloc] init];
                    [sysContacterEntityEx setContactEntity:entity];
                    [sysContacterEntityEx setPhoneMatched:[entity.phoneNumbers objectAtIndex:0]];
                    [_contacterFilter addObject:sysContacterEntityEx];
                }
            }
        }
    }
    
    NSArray *list = [AddressBook sharedAddressBook].contactList;
    for(ContacterEntity *entity in list){
        //针对号码搜索
        NSArray *phoneNumbers = entity.phoneNumbers;
        for(NSString *phone in phoneNumbers){
            if([phone rangeOfString:lastSearchString].location != NSNotFound){
                SysContacterEntityEx *sysContacterEntityEx = [[SysContacterEntityEx alloc] init];
                [sysContacterEntityEx setContactEntity:entity];
                [sysContacterEntityEx setPhoneMatched:phone];
                [_contacterFilter addObject:sysContacterEntityEx];
            }
        }
    }
}

#pragma mark 删除通话记录
- (void)deleteCallRecords:(CallHistoryEntityExt*)ext{
    for(CallHistoryEntity *record in ext.recordArray){
        [[CallRecord sharedCallRecord] deleteCallRecord:record.UID];
    }
}

- (void)deleteCallRecordsAtRow:(NSInteger)row{
    CallHistoryEntityExt *entity = [self.callHistoryList objectAtIndex:row];
    [self deleteCallRecords:entity];
    [_callHistoryList removeObjectAtIndex:row];
    if ([_callHistoryList count] == 0){
        if (_delegate && [_delegate respondsToSelector:@selector(callRecordHasCleared)]){
            [_delegate callRecordHasCleared];
        }
    }
}

- (void)clearAllRecords{
	for (CallHistoryEntityExt *ext in _callHistoryList) {
		[self deleteCallRecords:ext];
	}
	[_callHistoryList removeAllObjects];
}


#pragma mark 查找~

- (CallHistoryEntityExt*)callHistoryExtAtRow:(NSInteger)row{
    NSInteger callHistoryCount = [_callHistoryList count];
    if(row >= callHistoryCount){
        KFLog_Normal(YES, @"无效的号码");
        return nil;
    }
    CallHistoryEntityExt *entity = [_callHistoryList objectAtIndex:row];
    return entity;
}

- (NSString*)callHistoryPhoneAtRow:(NSInteger)row{
    CallHistoryEntityExt *entity = [self callHistoryExtAtRow:row];
    return entity.callHistoryEntity.phoneNumber;
}

- (SysContacterEntityEx*)contactEntityExAtRow:(NSInteger)row{
    NSInteger contacterCount = [_contacterFilter count];
    if(row >= contacterCount){
        KFLog_Normal(YES, @"无效的号码");
        return nil;
    }
    SysContacterEntityEx *entity = [_contacterFilter objectAtIndex:row];
    return entity;
}

- (NSString*)contactPhoneAtRow:(NSInteger)row{
    SysContacterEntityEx *entity = [self contactEntityExAtRow:row];
    return entity.phoneMatched;
}

- (ContactBaseEntity*)callhistoryContactEntityAtRow:(NSInteger)row{
    CallHistoryEntityExt *entity = [self callHistoryExtAtRow:row];
    ContactBaseEntity *contactEntity = entity.contacterEntity;
    if(!contactEntity){
        KFLog_Normal(YES, @"陌生人~");
        contactEntity = [[StrangerEntity alloc] init] ;
        [(StrangerEntity*)contactEntity setPhoneNumber:entity.callHistoryEntity.phoneNumber];
    }
    return contactEntity;
}

- (ContactBaseEntity*)searchContactEntityAtRow:(NSInteger)row{
    SysContacterEntityEx *entity = [_contacterFilter objectAtIndex:row];
    return entity.contactEntity;
}

- (void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(callRecordLoadFinished:) name:D_Notification_Name_CallRecordLoadFinished object:nil];
    [notificationCenter addObserver:self selector:@selector(callRecordChanged:) name:D_Notification_Name_CallRecordAdded object:nil];
}

- (void)callRecordLoadFinished:(NSNotification*)notification{
    [self loadHistory];
    if(_delegate && [_delegate respondsToSelector:@selector(callHistoryChanged)]){
        [_delegate callHistoryChanged];
    }
}

- (void)callRecordChanged:(NSNotification*)notification{
    [self loadHistory];
    if(_delegate && [_delegate respondsToSelector:@selector(callHistoryChanged)]){
        [_delegate callHistoryChanged];
    }
}

- (void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
