//
//  SWFinishedController.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWFinishedController.h"
#import "SWFinishedView.h"

#import "CXZ.h"

#define VIEW_WIDTH self.view.frame.size.width

#define VIEW_HEIGHT self.view.frame.size.height

@interface SWFinishedController ()

@end

@implementation SWFinishedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SWFinishedView *finishedView = [[SWFinishedView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT - 49)];
    
    [self.view addSubview:finishedView];

}


@end
