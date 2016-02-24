//
//  HomeLimitBuyCell.m
//  RKWXT
//
//  Created by SHB on 16/1/18.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomeLimitBuyCell.h"
#import "WXRemotionImgBtn.h"
#import "NewHomePageCommonDef.h"

#define kTimerInterval (5.0)
#define kOneCellShowNumber (5)
@interface HomeLimitBuyCell ()<UIScrollViewDelegate,WXRemotionImgBtnDelegate>{
    UIScrollView *_browser;
    NSArray *classifyArr;
    NSInteger count;
    
    NSMutableArray *_merchantImgViewArray;
}
@end

@implementation HomeLimitBuyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setUserInteractionEnabled:YES];
        CGRect rect = [self bounds];
        rect.size.height = T_HomePageLimitBuyHeight;
        _browser = [[UIScrollView alloc] initWithFrame:rect];
        [_browser setDelegate:self];
        [_browser setShowsHorizontalScrollIndicator:NO];
        [self.contentView addSubview:_browser];
        
        _merchantImgViewArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)load{
    if([_merchantImgViewArray count] > 0){
        return;
    }
    
    classifyArr = self.cellInfo;
    
    CGFloat xOffset = 10;
    CGFloat btnWidth = 90;
    CGFloat btnHeight = btnWidth;
    for(NSInteger i = 0; i < [classifyArr count]; i++){
        if(count > [classifyArr count]-1){
            break;
        }
//        ShopUnionClassifyEntity *entity = [classifyArr objectAtIndex:count];
        
        WXRemotionImgBtn *bgImgBtn = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (T_HomePageLimitBuyHeight-btnHeight)/2, btnWidth, btnHeight)];
        [bgImgBtn setUserInteractionEnabled:YES];
        [bgImgBtn setDelegate:self];
        [bgImgBtn setBackgroundColor:WXColorWithInteger(0xffffff)];
//        [bgImgBtn setTag:entity.industryID];
        [_browser addSubview:bgImgBtn];
        [_merchantImgViewArray addObject:_browser];
        
        xOffset += btnWidth+10;
        count++;
    }
    [_browser setContentSize:CGSizeMake(xOffset, T_HomePageLimitBuyHeight)];
}

-(void)buttonImageClicked:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(clickClassifyBtnAtIndex:)]){
        [_delegate clickClassifyBtnAtIndex:0];
    }
}

@end
