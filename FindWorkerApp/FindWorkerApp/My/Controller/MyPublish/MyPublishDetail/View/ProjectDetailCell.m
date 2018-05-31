//
//  ProjectDetailCell.m
//  FindWorkerApp
//
//  Created by cxz on 2018/3/30.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "ProjectDetailCell.h"
#import "CXZ.h"
#import "SWMyPublishDetailData.h"
#import "SWFindWorkType.h"

#define padding 10

#define cellHeight 55.0f

@implementation ProjectDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void)showProjectDetail:(SWMyPublishDetailData *)detailData
{
        UIView *headerView = [[UIView alloc] init];
        headerView.frame   = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        headerView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:headerView];
      
        NSMutableString *str = [NSMutableString string];
        
        for (SWFindWorkType *workerType in detailData.worker) {
            
            [str appendString:[NSString stringWithFormat:@"%@(%@名) ",workerType.type,workerType.num]];
            
        }
        
        NSString *remark = detailData.remark;
        if(IS_EMPTY(detailData.remark)) {
            
            remark = @"无";
            
        }
        NSArray *titleArr = @[@"位置",@"开始时间",@"用工数",@"总预算",@"工期",@"有效期",@"备注"];
        NSArray *contentArr = @[detailData.address,detailData.start_time,str,[NSString stringWithFormat:@"%@元",detailData.budget],detailData.schedule,@"3天",remark];
        
        CGFloat contentX = 0;
        CGFloat contentY = padding;
        
        for (int i = 0; i < titleArr.count; i++) {
            
            CGFloat nowY = [self showLabel:headerView frame:CGRectMake(contentX, contentY, 0, 0) title:titleArr[i] content:contentArr[i]];
            
            contentY = nowY + padding;
            
        }
        
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, contentY);
        self.height = contentY;

    
}

//显示信息
- (CGFloat)showLabel:(UIView *)contentView frame:(CGRect)frame title:(NSString *)title content:(NSString *)content {
    
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.frame    = CGRectMake(padding, frame.origin.y, titleSize.width, titleSize.height);
    titleLbl.text     = title;
    titleLbl.font     = [UIFont systemFontOfSize:12];
    titleLbl.textColor = [UIColor colorWithRed:0.17 green:0.18 blue:0.19 alpha:1.00];
    [contentView addSubview:titleLbl];
    
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH - 3 * padding - titleSize.width];
    
    UILabel *contentLbl = [[UILabel alloc] init];
    contentLbl.frame    = CGRectMake(SCREEN_WIDTH - padding - contentSize.width, frame.origin.y, contentSize.width, contentSize.height);
    contentLbl.text     = content;
    contentLbl.numberOfLines = 0;
    contentLbl.textColor = [UIColor colorWithRed:0.05 green:0.07 blue:0.09 alpha:1.00];
    contentLbl.font     = [UIFont systemFontOfSize:12];
    [contentView addSubview:contentLbl];
    
    return CGRectGetMaxY(contentLbl.frame) + padding;
    
}

@end
