//
//  SWPublishOngoingController.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWPublishOngoingController.h"
#import "SWPublishOngoingView.h"

#import "CXZ.h"

#define VIEW_WIDTH self.view.frame.size.width

#define VIEW_HEIGHT self.view.frame.size.height

@interface SWPublishOngoingController ()

@end

@implementation SWPublishOngoingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SWPublishOngoingView *ongoingView = [[SWPublishOngoingView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT - 49)];
    
    [self.view addSubview:ongoingView];
    
}


@end
