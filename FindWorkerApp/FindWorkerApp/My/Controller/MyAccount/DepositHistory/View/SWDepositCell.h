//
//  SWDepositCell.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWDepositCell : UITableViewCell

- (void)showData:(NSString *)time money:(NSString *)money state:(NSInteger)state;

+ (instancetype)initWithTableViewCell:(UITableView *)tableView;

@end
