//
//  CoverSearchView.m
//  RKWXT
//
//  Created by app on 16/2/29.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "CoverSearchView.h"

@interface CoverSearchView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray *sourceArr;
@property (nonatomic,assign)CGRect originListRect;
@property (nonatomic,strong)UIView *clipeView;
@property (nonatomic,strong)WXUITableView *tableView;
@property (nonatomic,strong)UIView *bjView;
@end

@implementation CoverSearchView

- (instancetype)initWithFrame:(CGRect)frame  sourceArr:(NSArray *)sourceArr dropListFrame:(CGRect)dropListFrame{
    if (self = [super initWithFrame:frame]) {
        self.bjView = [[UIView alloc]initWithFrame:frame];
        self.bjView.backgroundColor = [UIColor blackColor];
        self.bjView.alpha = 0.5;
        [self addSubview:self.bjView];
        
        [self addSelfTap];
        self.originListRect = dropListFrame;
        
        if (sourceArr.count != 0) {
            self.sourceArr = sourceArr;
            
            [UIView animateWithDuration:1.0 animations:^{
//                self.clipeView  = [[UIView alloc]initWithFrame:CGRectMake(dropListFrame.origin.x, dropListFrame.origin.y, 0, 0)];
                self.clipeView  = [[UIView alloc]initWithFrame:dropListFrame];
                self.clipeView.clipsToBounds = YES;
                [self addSubview:self.clipeView];
                
                WXUITableView *tableView = [[WXUITableView alloc]initWithFrame:self.clipeView.bounds style:UITableViewStylePlain];
                tableView.dataSource = self;
                tableView.delegate = self;
                tableView.layer.cornerRadius = 5;
                tableView.backgroundColor = [UIColor whiteColor];
                [self addSubview:tableView];
                self.tableView = tableView;
                
            }];
        }
    }
    return self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    cell.textLabel.text = self.sourceArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self currentRowHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self clickSelfTap];
}

- (CGFloat)currentRowHeight{
    NSInteger count = [self.sourceArr count];
    CGFloat height = 0.0;
    if (count > 0) {
        height = self.originListRect.size.height / count;
    }
    return height;
}

- (void)addSelfTap{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(clickSelfTap)];
    [self addGestureRecognizer:tap];
}

- (void)clickSelfTap{
    [self removeFromSuperview];
}

- (void)unshow:(BOOL)animated{
    CGRect rect ;
    if (animated) {
        [UIView animateWithDuration:1.0 animations:^{
            self.clipeView.frame = CGRectMake(100, 100, 120, 60);
            self.tableView.frame = self.clipeView.bounds;
        }];
    }
    
    
//    if(_dropDirection == E_DropDirection_Right){
//        rect.origin = _originListRect.origin;
//    }else{
//        rect.origin = CGPointMake(_originListRect.origin.x + _originListRect.size.width, _originListRect.origin.y);
//    }
//    rect.origin = _originListRect.origin;
//    if(animated){
//        [UIView animateWithDuration:0.5 animations:^{
//            [_clipeView setFrame:rect];
//        } completion:^(BOOL finished) {
//            [self setHidden:YES];
//        }];
//    }else{
//        [_clipeView setFrame:rect];
//        [self setHidden:YES];
//    }

}




@end
