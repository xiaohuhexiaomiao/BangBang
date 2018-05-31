//
//  ProjectDetailCell.h
//  FindWorkerApp
//
//  Created by cxz on 2018/3/30.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SWMyPublishDetailData;
@interface ProjectDetailCell : UITableViewCell

@property(nonatomic, assign)CGFloat height;

-(void)showProjectDetail:(SWMyPublishDetailData*)detailData;

@end
