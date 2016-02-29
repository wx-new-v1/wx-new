//
//  ClassifySearchVC.m
//  RKWXT
//
//  Created by app on 16/2/29.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ClassifySearchVC.h"
#import "CoverSearchView.h"
#import "CLassifySearchModel.h"
#import "ClassifySrarchListCell.h"
#import "ClassifyHistoryCell.h"
#import "WXGoodsInfoVC.h"
#import "SearchResultEntity.h"

#define Size self.bounds.size

@interface ClassifySearchVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,CLassifySearchModelDelegate>
@property (nonatomic,strong)WXUITextField *textField;
@property (nonatomic,strong)UIButton *titleBtn;
@property (nonatomic,assign,getter=isSwitch)BOOL titSwitch;  // 0 : 商店     1 ：商品
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel *searchLabel;
@property (nonatomic,strong)CoverSearchView *coverView;
@property (nonatomic,strong)CLassifySearchModel *searchModer;
@property (nonatomic,assign,getter=isSwitchSource)BOOL switchSource;//0:搜索历史  1:搜索数据
@end

@implementation ClassifySearchVC

- (NSArray*)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"商品",@"商家"];
    }
    return _titleArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   [self setCSTNavigationViewHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    self.switchSource = NO;
    
    CGFloat labelH = 44;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 66 + labelH, Size.width, Size.height-66 - labelH)];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    
    self.searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 66, Size.width, labelH)];
    self.searchLabel.text = [NSString stringWithFormat:@"历史搜索（%d条）",self.searchModer.historyArr.count];
    self.searchLabel.textColor = [UIColor grayColor];
    self.searchLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.searchLabel];
    
    UIView *didView = [[UIView alloc]initWithFrame:CGRectMake(5,labelH - 0.5, Size.width, 0.5)];
    didView.backgroundColor = [UIColor grayColor];
    [self.searchLabel addSubview:didView];
    
    self.searchModer = [[CLassifySearchModel alloc]init];
    self.searchModer.delegate = self;
    self.searchModer.searchType = Search_Type_Goods;
}

-(void)createNavigationBar{
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, Size.width, 66);
    [imgView setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:imgView];
    
    CGFloat xOffset = 15;
    CGFloat yOffset = 40;
    UIImage *img = [UIImage imageNamed:@"T_BackWhite.png"];
    WXTUIButton *backBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xOffset, yOffset, img.size.width, img.size.height);
    [backBtn setImage:img forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn addTarget:self action:@selector(backToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    [self createDropListViewBtn:xOffset+img.size.width with:yOffset];
}

-(void)createDropListViewBtn:(CGFloat)xGap with:(CGFloat)yGap{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"商品" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(xGap + 10, yGap, 50, 20);
    [btn setImage:[UIImage imageNamed:@"ClassifySearchBtnImg.png"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchDown];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 45, 0, 0)];
    [self addSubview:btn];
    
    CGFloat offsetX = CGRectGetMaxX(btn.frame);
    self.textField = [[WXUITextField alloc]initWithFrame:CGRectMake(offsetX + 8, yGap, Size.width-offsetX *2 - 2 * 10, 20)];
    self.textField.delegate =self;
    self.textField.placeholder = @"搜索";
    self.textField.tintColor = [UIColor whiteColor];
    self.textField.textColor = [UIColor whiteColor];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.textField becomeFirstResponder];
    [self.textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.textField addTarget:self action:@selector(changeInputTextfield) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.textField];
    
    [self isBtnTitle:btn];
}

#pragma mark ----------  系统方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (self.isSwitch) {  //商品
        count = [self tableViewSources];
    }else{  //商店
       count = [self tableViewSources];
    }
    return count;
}

- (WXUITableViewCell*)tableViewForSearchListCellAt:(NSInteger)row{
    ClassifySrarchListCell *cell = [ClassifySrarchListCell classIfySrarchListCellWithTabelview:self.tableView];
    cell.entity = self.searchModer.searchResultArr[row];
    return cell;
}
-(WXUITableViewCell *)tableViewForHistoryListCellAt:(NSInteger)row{
    ClassifyHistoryCell *cell = [ClassifyHistoryCell classIfyHistoryCellWithTabelview:self.tableView];
   cell.entity = self.searchModer.historyArr[row];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    if (self.isSwitchSource) { //搜索数据
        cell = [self tableViewForSearchListCellAt:row];
    }else{
        cell = [self tableViewForHistoryListCellAt:row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger goodsID = 0;
    if (self.switchSource) { //搜索数据
        SearchResultEntity *entity = [self.searchModer.searchResultArr objectAtIndex:indexPath.row];
        goodsID = entity.goodsID;
    }else{
        SearchResultEntity *entity = [self.searchModer.historyArr objectAtIndex:indexPath.row];
        goodsID = entity.goodsID;
    }
    
    //去详情页面
    WXGoodsInfoVC *goodsInfoVC = [[WXGoodsInfoVC alloc] init];
    [goodsInfoVC setGoodsId:goodsID];
    [self.wxNavigationController pushViewController:goodsInfoVC];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.searchModer classifySearchWith:self.textField.text];
}

#pragma mark  ------------  其他
- (void)clickTitleBtn:(UIButton*)btn{
  
    [self.view becomeFirstResponder];
    
    CGFloat X = btn.frame.size.width + btn.frame.origin.x;
    CGFloat Y = btn.frame.size.height + btn.frame.origin.y;
    CGRect rect = CGRectMake(100,100, 120, 60);
    self.coverView = [[CoverSearchView alloc]initWithFrame:[UIScreen mainScreen].bounds sourceArr:self.titleArr dropListFrame:rect];
    [self.view addSubview:self.coverView];
   
    [self isBtnTitle:btn];
}
- (void)isBtnTitle:(UIButton*)btn{
    if ([btn.titleLabel.text isEqualToString:@"商品"]) {
        self.titSwitch = YES;
        self.searchModer.searchType = Search_Type_Goods;
    }else{
        self.titSwitch = NO;
        self.searchModer.searchType = Search_Type_Shop;
    }
}

- (NSInteger)tableViewSources{
    NSInteger count = 0;
    if (self.isSwitchSource) { // 正在搜索的数据
        count = [self.searchModer.searchResultArr  count];
    }else{ // 历史记录
        count = [self.searchModer.historyArr  count];
    }
    return count;
}


- (void)setLabelTextWithTextField:(NSString*)textField{
    NSString *str = nil;
    if ([textField isEqualToString:@""]) { // 没有输入字符
        if (self.searchModer.historyArr.count != 0) {
            str =[NSString stringWithFormat:@"历史搜索 共有(%d条)",self.searchModer.historyArr.count];
        }else{
            str = @"没有历史查询记录";
        }
        self.switchSource = NO;
    }else{ //输入了
        if (self.searchModer.searchResultArr.count != 0) {
            str = [NSString stringWithFormat:@"搜索结果 共有(%d条)",self.searchModer.searchResultArr.count];
        }else{
            str = @"没有查询到您想要的结果";
        }
        self.switchSource = YES;
    }
    self.searchLabel.text = str;
}

- (void)textFieldDone:(UITextField*)textField{
    [self.searchModer classifySearchWith:self.textField.text];
}

- (void)changeInputTextfield{
    [self.searchModer classifySearchWith:self.textField.text];
    
}


#pragma mark ------ 其他的代理方法
- (void)classifySearchResultSucceed{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self setLabelTextWithTextField:self.textField.text];
}

- (void)classifySearchResultClearSource{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self setLabelTextWithTextField:self.textField.text];
}



- (void)backToLastPage{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}


@end
