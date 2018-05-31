//
//  SWWaitingController.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWWaitingController.h"
#import "SWWaitingView.h"

#import "CXZ.h"

#define VIEW_WIDTH self.view.frame.size.width

#define VIEW_HEIGHT self.view.frame.size.height

@interface SWWaitingController ()

@end

@implementation SWWaitingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SWWaitingView *waitingView = [[SWWaitingView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT - 49)];
    
    [self.view addSubview:waitingView];
    

}




@end
