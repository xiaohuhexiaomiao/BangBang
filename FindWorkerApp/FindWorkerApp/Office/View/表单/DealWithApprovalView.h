//
//  DealWithApprovalView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/8/18.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealWithApprovalView : UIView

@property(nonatomic ,strong)UIButton *photoBtn;

@property(nonatomic ,assign)BOOL is_sepcial;//YES 有特权

@property(nonatomic ,assign)BOOL is_cashier;//YES c财务回执

@property(nonatomic , assign) BOOL is_sign;// 是否需签字

@property(nonatomic , assign) NSInteger canApproval;

@property(nonatomic ,copy)NSString *approvalID;

@property(nonatomic ,copy)NSString *participation_id;

@property(nonatomic ,copy)NSString *personal_id;

@property(nonatomic ,copy)NSString *company_ID;

@property(nonatomic ,assign)NSInteger formType;//0 公司审批 1 个人审批

@property(nonatomic ,copy)NSString *approval_personal_id;// 个人审批id

-(void)setApprovalMenueView;

@end
