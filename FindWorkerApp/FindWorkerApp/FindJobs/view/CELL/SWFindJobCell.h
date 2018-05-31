//
//  SWFindJobCell.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/18.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWFindJobCell : UITableViewCell

//展示数据
//image:头像
//name:姓名
//money:预算
//job:需要工种
//time:发布时间
- (void)showData:(NSString *)imageName name:(NSString *)name money:(NSString *)money job:(NSString *)job time:(NSString *)time;

@end
