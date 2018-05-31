//
//  SWPublishFinishedController.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWPublishFinishedController.h"
#import "SWPublishFinishedView.h"

#import "CXZ.h"

#define VIEW_WIDTH self.view.frame.size.width

#define VIEW_HEIGHT self.view.frame.size.height

@interface SWPublishFinishedController ()

@end

@implementation SWPublishFinishedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SWPublishFinishedView *finishedView = [[SWPublishFinishedView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    
    [self.view addSubview:finishedView];
    
}



@end
