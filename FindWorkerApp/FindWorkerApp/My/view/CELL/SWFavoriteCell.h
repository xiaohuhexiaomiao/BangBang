//
//  SWFavoriteCell.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMyFavoriteWorker.h"

@interface SWFavoriteCell : UITableViewCell


@property (nonatomic, retain) SWMyFavoriteWorker *favoriteWorker;

//展示数据
//image:头像
//name:姓名
//distance:距离
//jobs:工种
- (void)showData:(NSString *)imageName name:(NSString *)name jobs:(NSArray *)Jobarr;

+ (instancetype)initWithTableViewCell:(UITableView *)tableView;

@end
