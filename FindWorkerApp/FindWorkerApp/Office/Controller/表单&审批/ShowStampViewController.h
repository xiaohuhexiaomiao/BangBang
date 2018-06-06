//
//  ShowStampViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2018/3/30.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"
@class StampModel;
@protocol StampViewControllerDelegate <NSObject>

-(void)copyStampAll:(StampModel*)StampModel;

@end
@interface ShowStampViewController : CXZBaseViewController

@property(nonatomic ,assign)BOOL is_aready_approval;// YES  已处理 No 未处理

@property(nonatomic ,assign)BOOL is_cancel;// YES  可以取消审批

@property(nonatomic ,assign)BOOL is_sepcial;//YES 有特权

@property(nonatomic ,assign)BOOL is_copy;//YES 复制全部

@property(nonatomic ,assign)BOOL is_reply;// YES  可回复  NO 不可回复

@property(nonatomic ,assign)BOOL is_cashier;//YES 表单回执 NO 处理审批

@property(nonatomic , copy)NSString *personal_id;

@property(nonatomic ,copy)NSString *approvalID;

@property(nonatomic ,assign)NSInteger form_type;//0 公司审批 1 个人审批

@property(nonatomic ,weak) id<StampViewControllerDelegate>delegate;

@end
