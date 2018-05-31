//
//  SWPublishWaitingController.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWPublishWaitingController.h"
#import "SWPublishWaitingView.h"

#import "CXZ.h"

#define VIEW_WIDTH self.view.frame.size.width

#define VIEW_HEIGHT self.view.frame.size.height

@interface SWPublishWaitingController ()

@end

@implementation SWPublishWaitingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SWPublishWaitingView *waitingView = [[SWPublishWaitingView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT - 49)];
    
    [self.view addSubview:waitingView];
    
}


@end
