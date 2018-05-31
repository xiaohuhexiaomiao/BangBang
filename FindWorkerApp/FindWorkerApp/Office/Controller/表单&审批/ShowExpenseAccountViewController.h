//
//  ShowExpenseAccountViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2018/1/5.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@class ExpenseAccountModel;

@protocol ShowExpenseAccountViewControllerDelegate <NSObject>

-(void)copyExpenseAccountFormAll:(ExpenseAccountModel*)expenseAccountModel;

@end

@interface ShowExpenseAccountViewController : CXZBaseViewController

@property(nonatomic ,assign)BOOL is_aready_approval;// YES  已处理 No 未处理

@property(nonatomic ,assign)BOOL is_cancel;// YES  可以取消审批

@property(nonatomic ,assign)BOOL is_sepcial;//YES 有特权

@property(nonatomic ,assign)BOOL is_copy;//YES 可复制

@property(nonatomic ,assign)BOOL is_cashier;//YES 表单回执 NO 处理审批

@property(nonatomic ,assign)BOOL is_reply;// YES  可回复  NO 不可回复

@property(nonatomic ,copy)NSString *approvalID;

@property(nonatomic , copy)NSString *personal_id;

@property(nonatomic ,assign)NSInteger form_type;//0 公司审批 1 个人审批

@property(nonatomic , weak) id <ShowExpenseAccountViewControllerDelegate> delegate;

@end
