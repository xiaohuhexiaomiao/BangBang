//
//  UITableView+NoneData.h
//  YiYiPai
//
//  Created by Zhengyumin on 15-3-31.
//  Copyright (c) 2015年 卢明渊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(NoneData)

- (void)createNoDataView;
- (void)createNoDataWithFrame:(CGRect)frame;
- (void)createNoDataText:(CGRect)frame;
- (void)hideView;
@end
