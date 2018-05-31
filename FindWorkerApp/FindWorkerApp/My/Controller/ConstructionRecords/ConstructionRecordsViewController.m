//
//  ConstructionRecordsViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/5/10.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ConstructionRecordsViewController.h"
#import "CXZ.h"

#import "OnGoingViewController.h"
#import "FinishiedConstructionViewController.h"

@interface ConstructionRecordsViewController ()

@end

@implementation ConstructionRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.segmentHighlightColor = TOP_GREEN;
    [self setupTitleWithString:@"工程" withColor:[UIColor whiteColor]];
    [self setupBackw];
    
    OnGoingViewController *onVC = [[OnGoingViewController alloc]init];
    onVC.title = @"进行中";
    FinishiedConstructionViewController *finishiVC  = [[FinishiedConstructionViewController alloc]init];
    finishiVC.title = @"已结束";
    self.viewControllers = @[onVC,finishiVC];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}




@end
