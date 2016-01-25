//
//  BaseInfoHeadCell.m
//  RKWXT
//
//  Created by SHB on 15/6/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BaseInfoHeadCell.h"
#import "WXRemotionImgBtn.h"
#import "UserHeaderImgModel.h"

@interface BaseInfoHeadCell(){
    WXRemotionImgBtn *headImg;
}

@end

@implementation BaseInfoHeadCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 18;
        CGFloat headImgWith = 60;
        headImg = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(size.width-xOffset-headImgWith-10, (81-headImgWith)/2, headImgWith, headImgWith)];
        [headImg setUserInteractionEnabled:NO];
        [headImg setBorderRadian:30.0 width:1.0 color:[UIColor clearColor]];
        [headImg setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:headImg];
    }
    return self;
}

-(void)load{
    NSString *iconName = self.cellInfo;
    if(_img){
        [headImg setImage:_img];
    }else{
        if(iconName.length > 5){
            [headImg setCpxViewInfo:iconName];
            [headImg load];
        }else{
            if([self userIconImage]){
                [headImg setImage:[self userIconImage]];
            }else{
                [headImg setImage:[UIImage imageNamed:@"PersonalInfo.png"]];
            }
        }
    }
}

-(UIImage*)userIconImage{
    NSString *iconPath = [NSString stringWithFormat:@"%@",[[UserHeaderImgModel shareUserHeaderImgModel] userIconPath]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:iconPath]){
        UIImage *img = [UIImage imageWithContentsOfFile:iconPath];
        return img;
    }
    return nil;
}

@end
