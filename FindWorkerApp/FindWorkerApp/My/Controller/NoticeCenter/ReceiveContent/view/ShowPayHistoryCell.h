//
//  ShowPayHistoryCell.h
//  FindWorkerApp
//
//  Created by cxz on 2018/5/10.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowPayHistoryModel;

@interface ShowPayHistoryCell : UITableViewCell

@property(nonatomic ,assign)NSInteger cellType;// 0 乙方 等待付款 1 甲方去付款

-(void)setShowPayHistoryCellWithModel:(ShowPayHistoryModel*)payModel;

@end
