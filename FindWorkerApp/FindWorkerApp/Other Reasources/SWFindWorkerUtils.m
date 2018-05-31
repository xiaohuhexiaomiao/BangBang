//
//  SWFindWorkerUtils.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWFindWorkerUtils.h"
#import "AppDelegate.h"
#import "SWNavController.h"
#import "SWLoginController.h"
#import "SWTabController.h"
#import "SWFindWorkerController.h"
#import "SWFindJobsController.h"
#import "SWMyController.h"
#import "SWDailyOfficeViewController.h"


@implementation SWFindWorkerUtils

+ (void)jumpLogin
{
    SWLoginController *ctrl = [[SWLoginController alloc] init];
    SWNavController *navController = [[SWNavController alloc] initWithRootViewController:ctrl];
    navController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = navController;
    [app.window.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromLeft curve:TransitionCurveEaseInEaseOut duration:0.5f];
    
}

+(void)jumpMain {
    
    //底部TabBar
    SWTabController *tabBarController = [[SWTabController alloc] init];
    tabBarController.selectedIndex = 1;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = tabBarController;
    [app.window.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromLeft curve:TransitionCurveEaseInEaseOut duration:0.5f];
    
    
    
}

@end
