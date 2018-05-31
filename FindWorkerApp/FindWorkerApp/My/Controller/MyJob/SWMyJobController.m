//
//  SWMyJobController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMyJobController.h"

#import "CXZ.h"

#import "SWWaitingView.h"
#import "SWOngoingView.h"
#import "SWFinishedView.h"

#import "SWWaitingController.h"
#import "SWOngoingController.h"
#import "SWFinishedController.h"
#import "SWRepeatController.h"

@interface SWMyJobController ()

@end

@implementation SWMyJobController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackw];
    
    [self setupTitleWithString:@"我的任务" withColor:[UIColor whiteColor]];
    
//    self.titles = @[@"待响应",@"进行中",@"已完成"];
//    
//    SWWaitingView *view = [[SWWaitingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.contentView.frame.size.height)];
//    [self.contentView addSubview:view];
//    
//    SWOngoingView *view1 = [[SWOngoingView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.contentView.frame.size.height)];
//    [self.contentView addSubview:view1];
//    
//    SWFinishedView *view2 = [[SWFinishedView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, self.contentView.frame.size.height)];
//    [self.contentView addSubview:view2];
    self.segmentHighlightColor = TOP_GREEN;
    
    SWRepeatController *repeatController = [[SWRepeatController alloc] init];
    repeatController.title = @"待响应";
    
    SWWaitingController *waitingController = [[SWWaitingController alloc] init];
    waitingController.title = @"待开始";
    
    SWOngoingController *ongoingController = [[SWOngoingController alloc] init];
    ongoingController.title = @"进行中";
    
    SWFinishedController *finishedController = [[SWFinishedController alloc] init];
    finishedController.title = @"已完成";
    
    self.viewControllers = @[repeatController,waitingController,ongoingController,finishedController];
    
}



@end
