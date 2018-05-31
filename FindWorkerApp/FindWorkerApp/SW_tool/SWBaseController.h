//
//  SWBaseController.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface SWBaseController : CXZBaseViewController<UIScrollViewDelegate>

@property (nonatomic, retain) NSArray *titles;

@property (nonatomic, retain) UIScrollView *contentView;

@end
