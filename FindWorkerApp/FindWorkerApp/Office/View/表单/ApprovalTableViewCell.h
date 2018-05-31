//
//  ApprovalTableViewCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewListModel.h"

@interface ApprovalTableViewCell : UITableViewCell

@property (nonatomic ,strong) UILabel *companyName;

@property (nonatomic ,strong) UILabel *timeLabel;

@property(nonatomic ,assign) BOOL is_More;//是否多公司

@property(nonatomic ,assign) NSInteger formType;//0公司 1 个人

@property(nonatomic ,assign)CGFloat cellHeight;

-(void)setApprovalCellWith:(ReviewListModel*)reviewModel;

-(void)setSearchApprovalCellWith:(ReviewListModel*)reviewModel;

-(void)setCashierApprovalCellWith:(ReviewListModel*)reviewModel;


@end
