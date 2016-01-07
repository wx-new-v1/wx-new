//
//  WXHomeBaseFunctionCell.h
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

typedef enum{
    T_BaseFunction_Init = -1,
    T_BaseFunction_Shark,
    T_BaseFunction_Sign,
    T_BaseFunction_Wallet,
    T_BaseFunction_Invate,
    T_BaseFunction_Game,
    T_BaseFunction_Side,
    T_BaseFunction_Cut,
    T_BaseFunction_Union,
    
    T_BaseFunction_Invalid,
}T_BaseFunction;

@protocol WXHomeBaseFunctionCellBtnClicked;

@interface WXHomeBaseFunctionCell : WXUITableViewCell
@property (nonatomic,assign) id<WXHomeBaseFunctionCellBtnClicked>delegate;
@end

@protocol WXHomeBaseFunctionCellBtnClicked <NSObject>
-(void)wxHomeBaseFunctionBtnClickedAtIndex:(T_BaseFunction)index;

@end
