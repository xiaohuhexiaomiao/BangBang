//
//  PayRecordsCell.h
//  FindWorkerApp
//
//  Created by cxz on 2018/3/21.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayRecordsModel;
@interface PayRecordsCell : UITableViewCell

@property(nonatomic, assign) CGFloat cellHeight;

-(void)setPayRecordsWithModel:(PayRecordsModel*)model;

@end
