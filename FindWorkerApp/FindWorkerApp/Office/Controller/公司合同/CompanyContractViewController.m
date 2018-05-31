//
//  CompanyContractViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/16.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CompanyContractViewController.h"
#import "CXZ.h"
#import "Company_SendViewController.h"
#import "ListViewController.h"
@interface CompanyContractViewController ()

@end

@implementation CompanyContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.segmentHighlightColor = TOP_GREEN;
    
    [self setupBackw];
    
    [self setupTitleWithString:@"公司合同" withColor:[UIColor whiteColor]];
//    NSLog(@"uid %@**%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],self.companyID);
    Company_SendViewController *mySendController = [[Company_SendViewController alloc] init];
    mySendController.companyID = self.company_ID;
    mySendController.title =  @"拟呈批合同";
    
    ListViewController *myReceiveController = [[ListViewController alloc] init];
    myReceiveController.title = @"合同模板";
    
    self.viewControllers = @[myReceiveController,mySendController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
