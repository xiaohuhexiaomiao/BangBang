//
//  SWEvaluateCell.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWEvaluteFrame.h"

@interface SWEvaluateCell : UITableViewCell

@property (nonatomic, retain) SWEvaluteFrame *itemFrame;

+ (instancetype)initWithTableViewCell:(UITableView *)tableView;

- (void)showData:(NSString *)icon phone:(NSString *)phone time:(NSString *)time content:(NSString *)content state:(NSString *)state;

@end
