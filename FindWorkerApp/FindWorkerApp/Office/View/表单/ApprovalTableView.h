//
//  ApprovalTableView.h
//  FindWorkerApp
//
//  Created by cxz on 2018/4/9.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApprovalResultModel;


@interface ApprovalTableView : UIView

@property(nonatomic ,strong)NSString *approvalID;

@property(nonatomic ,strong)NSString *companyID;

@property (nonatomic ,assign) BOOL is_reply;

-(void)setApprovalTableViewWithModel:(ApprovalResultModel*)model;

@end
