//
//  SWMyContractController.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/16.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMyContractController.h"

#import "SWMyReceiveController.h"
#import "SWMySendController.h"
#import "AcceptDetailController.h"

#import "CXZ.h"

@interface SWMyContractController ()

@end

@implementation SWMyContractController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segmentHighlightColor = GREEN_COLOR;
    
    [self setupBackw];
//    [self setupNextWithString:@"haah"];
    
    [self setupTitleWithString:@"我发出的合同" withColor:[UIColor whiteColor]];
    
    SWMySendController *mySendController = [[SWMySendController alloc] init];
    mySendController.title = @"未开始";
    
    SWMyReceiveController *myReceiveController = [[SWMyReceiveController alloc] init];
    myReceiveController.title = @"已开始";
    
    self.viewControllers = @[mySendController,myReceiveController];
    
}
-(void)onNext
{
    AcceptDetailController *acceptVC = [[AcceptDetailController alloc]init];
    [self.navigationController pushViewController:acceptVC animated:YES];
}


@end
