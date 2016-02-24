//
//  WXHomeTopGoodCell.h
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

//商家图片的Cell
@protocol WXHomeTopGoodCellDelegate;
@interface WXHomeTopGoodCell : WXUITableViewCell
@property (nonatomic,assign)id<WXHomeTopGoodCellDelegate>delegate;

@end

@protocol WXHomeTopGoodCellDelegate <NSObject>
- (void)clickTopGoodAtIndex:(NSInteger)index;

@end
