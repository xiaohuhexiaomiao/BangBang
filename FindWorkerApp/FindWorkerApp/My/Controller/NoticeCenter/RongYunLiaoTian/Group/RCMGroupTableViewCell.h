//
//  RCMGroupTableViewCell.h
//  FindWorkerApp
//
//  Created by cxz on 2018/5/10.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCDGroupInfo;

@interface RCMGroupTableViewCell : UITableViewCell
/**
 *  给控件填充数据
 *
 *  @param group 设置群组模型
 */
- (void)setModel:(RCDGroupInfo *)group;

/**
 *  群组名称label
 */
@property(nonatomic, strong) UILabel *lblGroupName;

/**
 *  群组头像
 */
@property(nonatomic, strong) UIImageView *imvGroupPort;

/**
 *  群组介绍
 */
@property(nonatomic, strong) UILabel *introduceLabel;

@end
