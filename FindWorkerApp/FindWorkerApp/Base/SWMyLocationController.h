//
//  SWMyLocationController.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/28.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@protocol MyLocationControllerDelegate <NSObject>

-(void)clickMyLocation:(NSString*)addressString;

@end

@interface SWMyLocationController : UIViewController

@property(nonatomic ,weak) id <MyLocationControllerDelegate> delegate;

@end
