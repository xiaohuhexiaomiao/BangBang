//
//  SWTabController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/17.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWTabController.h"
#import "SWFindWorkerController.h"
#import "SWFindJobsController.h"
#import "SWDailyOfficeViewController.h"
#import "SWMyController.h"
#import "SWNearbyWorkerController.h"
#import "NearbyCompanyViewController.h"

@interface SWTabController ()


@end

@implementation SWTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpAllChildViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpAllChildViewController
{
    
    //    // 2.找活干
    NearbyCompanyViewController *growingVC = [[NearbyCompanyViewController alloc] init];
    [self setUpOneChildViewController:growingVC image:[UIImage imageNamed:@"findjob_unselect"] selectedimage:[UIImage imageNamed:@"findjob_select"] title:@"附近公司"];
    
    SWNearbyWorkerController *workerController = [[SWNearbyWorkerController alloc] init];
    [self setUpOneChildViewController:workerController image:[UIImage imageNamed:@"findworker_unselect"] selectedimage:[UIImage imageNamed:@"findworker_select"] title:@"附近工人"];
    
    // 1.找工人
    SWFindJobsController *findController = [[SWFindJobsController alloc] init];
    [self setUpOneChildViewController:findController image:[UIImage imageNamed:@"unselected_production"] selectedimage:[UIImage imageNamed:@"selected_production"] title:@"附近工程"];

    
    // 3.办公
    SWDailyOfficeViewController *officeVC = [[SWDailyOfficeViewController alloc]init];
    [self setUpOneChildViewController:officeVC image:[UIImage imageNamed:@"Office"] selectedimage:[UIImage imageNamed:@"OfficeSelected"]  title:@"日常办公"];
    
    
    // 4.广场
    SWMyController *myController = [[SWMyController alloc] init];
    [self setUpOneChildViewController:myController image:[UIImage imageNamed:@"my_unselect"] selectedimage:[UIImage imageNamed:@"my_select"] title:@"我的"];
    
    
}





- (void)setUpOneChildViewController:(UIViewController *)viewController image:(UIImage *)image selectedimage:(UIImage *)selectedimage title:(NSString *)title
{
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:viewController];
    self.tabBar.barTintColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00]];
    navC.title = title;
    
    
    UIImage * imageNormal = image;
    UIImage* imageSelected = selectedimage;
    navC.tabBarItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navC.tabBarItem.image = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [navC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState: UIControlStateNormal];
    [navC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1.00]} forState: UIControlStateSelected];
    
    viewController.navigationItem.title = title;
    viewController.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1.00],NSFontAttributeName:[UIFont systemFontOfSize:20.f]};
    [self addChildViewController:navC];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
