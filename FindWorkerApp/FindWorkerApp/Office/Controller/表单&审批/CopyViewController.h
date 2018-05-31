//
//  CopyViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/8/25.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"
@class ReviewListModel;
@protocol CopyDelegate <NSObject>

-(void)copyAll:(id)model;

-(void)copyReviewAll:(id)model;



@end

@interface CopyViewController : CXZBaseViewController

@property(nonatomic ,assign)NSInteger formType;//0 公司 审批 1 个人审批

@property(nonatomic ,strong)NSString *companyID;

@property(nonatomic ,assign)NSInteger type;

@property(nonatomic ,assign)BOOL is_selected_form;//YES选择表单 NO：复制

@property(nonatomic ,copy)NSString *worker_user_id;

@property(nonatomic ,weak) id <CopyDelegate>delegate;

@end
