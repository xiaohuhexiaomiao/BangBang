//
//  UITableView+NoneData.m
//  YiYiPai
//
//  Created by Zhengyumin on 15-3-31.
//  Copyright (c) 2015年 卢明渊. All rights reserved.
//

#import "UITableView+NoneData.h"
#import "CXZ.h"
@implementation UITableView(NoneData)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)createNoDataView
{
    UIView*view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor=[UIColor clearColor];
    UILabel*labl=[[UILabel alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 20)];
    labl.text=@"pull to refresh, reload data";
    labl.textColor=HexRGB(0xa8a8a8);
    labl.font=[UIFont systemFontOfSize:14];
    labl.textAlignment=NSTextAlignmentCenter;
    [view addSubview:labl];
    [self setTableHeaderView:view];
  
}

- (void)hideView
{
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIView class]]&& v.tag == 100) {
            [v removeFromSuperview];
        }
    }
}

- (void)createNoDataText:(CGRect)frame
{
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor clearColor];
    CGFloat y = (bgView.frame.size.height - 30)/2;
    CGFloat x = (bgView.frame.size.width - 100)/2;

    UILabel *nodataLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y , 100, 30)];
    nodataLabel.textAlignment = NSTextAlignmentCenter;
    nodataLabel.text = @"No data!";
    [bgView addSubview:nodataLabel];
    [self setTableHeaderView:bgView];
    
    
    
}

- (void)createNoDataWithFrame:(CGRect)frame
{
    CGFloat picH = 150 ;
    CGFloat picW = 100 ;
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor clearColor];
    CGFloat x = (bgView.frame.size.width - picW)/2;
    UILabel *nodataLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 150 , 100, 30)];
    nodataLabel.textAlignment = NSTextAlignmentCenter;
    nodataLabel.text = @"No data!";
    nodataLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:nodataLabel];
    [self setTableHeaderView:bgView];
    
}
@end
