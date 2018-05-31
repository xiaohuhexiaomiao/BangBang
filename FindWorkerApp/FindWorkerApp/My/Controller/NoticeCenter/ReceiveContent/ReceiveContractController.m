//
//  SWMyContractController.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/16.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "ReceiveContractController.h"

#import "StartViewController.h"
#import "NotStartController.h"
#import "ReceiveAcceptDetailController.h"

#import "CXZ.h"

@interface ReceiveContractController ()

@end

@implementation ReceiveContractController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segmentHighlightColor = GREEN_COLOR;
    
    [self setupBackw];
//    [self setupNextWithString:@"haah"];
    
    [self setupTitleWithString:@"我收到的合同" withColor:[UIColor whiteColor]];
    
    NotStartController *notStartVC = [[NotStartController alloc] init];
    notStartVC.title = @"未开始";
    
    StartViewController *myReceiveController = [[StartViewController alloc] init];
    myReceiveController.title = @"已开始";
    
    self.viewControllers = @[notStartVC,myReceiveController];
    
}
-(void)onNext
{
    ReceiveAcceptDetailController *acceptVC = [[ReceiveAcceptDetailController alloc]init];
    [self.navigationController pushViewController:acceptVC animated:YES];
}


@end
