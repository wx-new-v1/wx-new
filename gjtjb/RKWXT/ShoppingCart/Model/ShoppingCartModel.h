//
//  ShoppingCartModel.h
//  RKWXT
//
//  Created by SHB on 16/1/19.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

#define D_Notification_LoadShoppingCartList_Succeed @"D_Notification_LoadShoppingCartList_Succeed"
#define D_Notification_LoadShoppingCartList_Failed  @"D_Notification_LoadShoppingCartList_Failed"
#define D_Notification_AddGoodsShoppingCart_Succeed @"D_Notification_AddGoodsShoppingCart_Succeed"
#define D_Notification_AddGoodsShoppingCart_Failed  @"D_Notification_AddGoodsShoppingCart_Failed"
#define D_Notification_DeleteOneGoodsInShoppingCartList_Succeed @"D_Notification_DeleteOneGoodsInShoppingCartList_Succeed"
#define D_Notification_DeleteOneGoodsInShoppingCartList_Failed  @"D_Notification_DeleteOneGoodsInShoppingCartList_Failed"

@interface ShoppingCartModel : T_HPSubBaseModel
@property (nonatomic,strong) NSArray *shoppingCartListArr;

+(ShoppingCartModel*)shareShoppingCartModel;
-(void)loadShoppingCartList;
-(void)insertOneGoodsToShoppingCart:(NSInteger)stockID num:(NSInteger)number;
-(void)deleteOneGoodsInShoppingCartList:(NSInteger)cartID;

-(BOOL)shouldDataReload;

@end
