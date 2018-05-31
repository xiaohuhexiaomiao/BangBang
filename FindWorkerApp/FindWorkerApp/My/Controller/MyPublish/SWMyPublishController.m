
//
//  SWMyPublishController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMyPublishController.h"

#import "CXZ.h"

#import "SWPublishWaitingView.h"
#import "SWPublishOngoingView.h"
#import "SWPublishFinishedView.h"

#import "SWPublishWaitingController.h"
#import "SWPublishOngoingController.h"
#import "SWPublishFinishedController.h"

@interface SWMyPublishController ()

@end

@implementation SWMyPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segmentHighlightColor = TOP_GREEN;
   
    [self setupBackw];
    
    [self setupTitleWithString:@"我发布的工程" withColor:[UIColor whiteColor]];
    
//    self.titles = @[@"待开始",@"施工中",@"已完成"];
//    
//    SWPublishWaitingView *view = [[SWPublishWaitingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.contentView.frame.size.height)];
//    [self.contentView addSubview:view];
//    
//    SWPublishOngoingView *view1 = [[SWPublishOngoingView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.contentView.frame.size.height)];
//    [self.contentView addSubview:view1];
   
//    SWPublishFinishedView *view2 = [[SWPublishFinishedView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, self.contentView.frame.size.height)];
//    [self.contentView addSubview:view2];
    
    SWPublishWaitingController *waitingController = [[SWPublishWaitingController alloc] init];
    waitingController.title = @"进行中";
    
//    SWPublishOngoingController *ongoingController = [[SWPublishOngoingController alloc] init];
//    ongoingController.title = @"进行中";
    
    SWPublishFinishedController *finishedController = [[SWPublishFinishedController alloc] init];
    finishedController.title = @"已结束";
    
    self.viewControllers = @[waitingController,finishedController];
    
}


@end
