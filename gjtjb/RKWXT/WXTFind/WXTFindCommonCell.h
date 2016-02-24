//
//  WXTFindCommonCell.h
//  RKWXT
//
//  Created by SHB on 16/1/8.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol WXTFindCommonCellCellDelegate;
@interface WXTFindCommonCell : WXUITableViewCell
@property (nonatomic,assign)id<WXTFindCommonCellCellDelegate>delegate;

@end

@protocol WXTFindCommonCellCellDelegate <NSObject>
- (void)clickClassifyBtnAtIndex:(NSInteger)index;

@end
