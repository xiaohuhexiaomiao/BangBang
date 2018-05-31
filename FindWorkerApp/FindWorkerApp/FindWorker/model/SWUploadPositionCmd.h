//
//  SWUploadPositionCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/3.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWUploadPositionCmd : BaseCommand

@property (nonatomic, retain) NSString *uid;

@property (nonatomic, assign) CGFloat longitude; //经度

@property (nonatomic, assign) CGFloat latitude; //纬度

@property (nonatomic, assign) NSString *region; //城市

@end
