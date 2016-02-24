//
//  ClassifyGoodsListVC.m
//  RKWXT
//
//  Created by SHB on 16/1/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "ClassifyGoodsListVC.h"
#import "ClassifyGoodsListCell.h"
#import "ClassifyGoodsModel.h"
#import "ClassiftGoodsEntity.h"

#define Size self.bounds.size

@interface ClassifyGoodsListVC()<UITableViewDataSource,UITableViewDelegate,ClassifyGoodsModelDelegate>{
    UITableView *_tabelView;
    NSArray *listArr;
    WXUIButton *rightBtn;
    BOOL showUp;
    
    ClassifyGoodsModel *_model;
}
@end

@implementation ClassifyGoodsListVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[ClassifyGoodsModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:_titleName];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tabelView = [[UITableView alloc] init];
    _tabelView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tabelView setBackgroundColor:[UIColor whiteColor]];
    [_tabelView setDelegate:self];
    [_tabelView setDataSource:self];
    [self addSubview:_tabelView];
    [_tabelView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self createRightItemBtn];
    
    [_model loadClassifyGoodsListData:_cat_id];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)createRightItemBtn{
    CGFloat btnWidth = 60;
    CGFloat btnHeight = 25;
    rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(Size.width-btnWidth-10, 66-btnHeight-10, btnWidth, 25);
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:@"价格" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:WXFont(14.0)];
    [rightBtn setTitleColor:WXColorWithInteger(0x000000) forState:UIControlStateNormal];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [rightBtn setImage:[UIImage imageNamed:@"GoodsListUpImg.png"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 45, 0, 0)];
    [rightBtn addTarget:self action:@selector(changeListViewShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ClassifyGoodsListCellHeight;
}

-(WXUITableViewCell*)tableViewForGoodsListCellAt:(NSInteger)row{
    static NSString *identifier = @"goodsListCell";
    ClassifyGoodsListCell *cell = [_tabelView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ClassifyGoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([listArr count] > 0){
        [cell setCellInfo:listArr[row]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForGoodsListCellAt:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tabelView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    ClassiftGoodsEntity *entity = [listArr objectAtIndex:row];
    [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:entity.goodsID animated:YES];
}

-(void)changeListViewShow{
    showUp = !showUp;
    if(showUp){
        [rightBtn setImage:[UIImage imageNamed:@"GoodsListDownImg.png"] forState:UIControlStateNormal];
        listArr = [self goodsPriceDownSort];
        [_tabelView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [rightBtn setImage:[UIImage imageNamed:@"GoodsListUpImg.png"] forState:UIControlStateNormal];
        listArr = [self goodsPriceUpSort];
        [_tabelView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//升序排序
-(NSArray*)goodsPriceUpSort{
    NSArray *sortArray = [listArr sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        ClassiftGoodsEntity *entity_0 = obj1;
        ClassiftGoodsEntity *entity_1 = obj2;
        
        if (entity_0.shop_price > entity_1.shop_price){
            return NSOrderedDescending;
        }else if (entity_0.shop_price < entity_1.shop_price){
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return sortArray;
}

//降序排序
-(NSArray*)goodsPriceDownSort{
    NSArray *sortArray = [listArr sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        ClassiftGoodsEntity *entity_0 = obj1;
        ClassiftGoodsEntity *entity_1 = obj2;
        
        if (entity_0.shop_price < entity_1.shop_price){
            return NSOrderedDescending;
        }else if (entity_0.shop_price > entity_1.shop_price){
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return sortArray;
}

#pragma mark modelDelegate
-(void)loadClassifyGoodsListDataSucceed{
    [self unShowWaitView];
    listArr = _model.goodsListArr;
    [_tabelView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)loadClassifyGoodsListDataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取商品列表失败";
    }
    [UtilTool showAlertView:errorMsg];
}

@end
