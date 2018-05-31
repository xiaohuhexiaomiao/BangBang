//
//  SWBaseTopView.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PAGE_CHANGE @"PAGE_CHANGE"

@interface SWBaseTopView : UIView

@property (nonatomic, assign) NSInteger totalPage; //总共页数

@property (nonatomic, retain) NSArray *titleArr;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) BOOL isClick; //判断是不是点击还是滑动

@end
