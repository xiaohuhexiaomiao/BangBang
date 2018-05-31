//
//  SWOngoingController.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWOngoingController.h"
#import "SWOngoingView.h"

#import "CXZ.h"

#define VIEW_WIDTH self.view.frame.size.width

#define VIEW_HEIGHT self.view.frame.size.height

@interface SWOngoingController ()

@end

@implementation SWOngoingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    SWOngoingView *ongoingView = [[SWOngoingView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT - 49)];
    
    [self.view addSubview:ongoingView];
}


@end
