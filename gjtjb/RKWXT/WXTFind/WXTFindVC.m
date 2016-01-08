//
//  WXTFindVC.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.


#import "WXTFindVC.h"
#import "FindCommonVC.h"
#import "WXHomeTopGoodCell.h"
#import "WXTFindCommonCell.h"
#import "WXTFindModel.h"

#define Size self.bounds.size

@interface WXTFindVC()<UITableViewDataSource,UITableViewDelegate,WXHomeTopGoodCellDelegate,WXTFindCommonCellCellDelegate,wxtFindModelDelegate>{
    UITableView *_tableView;
    WXTFindModel *_comModel;
    NSArray *commonImgArr;
}
@end

@implementation WXTFindVC

-(id)init{
    self = [super init];
    if(self){
        _comModel = [[WXTFindModel alloc] init];
        [_comModel setFindDelegate:self];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"发现"];
    self.backgroundColor = WXColorWithInteger(0xefeff4);
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [_comModel loadFindData];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if(indexPath.section == 0){
        height = IPHONE_SCREEN_WIDTH/3;
    }else{
        height = ([commonImgArr count]/3+([commonImgArr count]%3>0?1:0))*IPHONE_SCREEN_WIDTH/3;
    }
    return height;
}

///顶部导航
-(WXUITableViewCell*)headImgCell{
    static NSString *identifier = @"headImg";
    WXHomeTopGoodCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXHomeTopGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDelegate:self];
    //    [cell setCellInfo:_model.top.data];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)commonWebImgCell{
    static NSString *identfier = @"commonCell";
    WXTFindCommonCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[WXTFindCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([commonImgArr count] > 0){
        [cell setCellInfo:commonImgArr];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
            cell = [self headImgCell];
            break;
        case 1:
            cell = [self commonWebImgCell];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark findData
-(void)initFinddataSucceed{
    [self unShowWaitView];
    commonImgArr = _comModel.findDataArr;
    [_tableView reloadData];
}

-(void)initFinddataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"加载数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

@end
