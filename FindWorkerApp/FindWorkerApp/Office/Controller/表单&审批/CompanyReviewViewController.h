//
//  CompanyReviewViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"
@class ReviewDetailModel;
@protocol CompanyReviewControllerDelegate <NSObject>

-(void)copyCompanyReviewAll:(ReviewDetailModel*)detailModel;

@end

@interface CompanyReviewViewController : CXZBaseViewController

@property(nonatomic ,copy)NSString *typeStr;//1 工装 2 家装

@property(nonatomic ,assign)BOOL is_approval;//YES 展示表单 NO 创建表单

@property(nonatomic ,assign)BOOL is_aready_approval;// YES  已处理 No 未处理

@property(nonatomic ,assign)BOOL is_cancel;// YES  可以取消审批

@property(nonatomic ,assign)BOOL is_annex;// YES  不走公司流程 单独添加附件 No 走公司流程

@property(nonatomic ,assign)BOOL is_sepcial;//YES 有特权

@property(nonatomic ,assign)BOOL is_copy;//YES 可复制

@property(nonatomic ,assign)BOOL is_cashier;//YES 表单回执 NO 处理审批

@property(nonatomic ,assign)NSInteger form_type;//0 公司审批 1 个人审批

@property(nonatomic ,copy)NSString *approval_id;//表单id;

@property(nonatomic ,copy)NSString *participation_id;//

@property(nonatomic , copy)NSString *personal_id;

@property(nonatomic ,weak) id<CompanyReviewControllerDelegate>delegate;

//创建表单需要
@property(nonatomic, copy)NSString *com_contract_id;//公司合同id

@property(nonatomic, copy)NSString *company_id;//公司id
//
@property(nonatomic, copy)NSString *contractTitle;//标题



@end
