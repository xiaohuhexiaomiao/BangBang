//
//  SWJobDetailController.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/23.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface SWJobDetailController : CXZBaseViewController

@property (nonatomic, retain) NSString *iid;

/** 0代表申请列表，1代表雇佣列表 2代表待开始 3代表进行中 4代表已完成 5代表待响应*/
@property (nonatomic, assign) NSInteger type;


/**
 等待确认付款状态位0 已确认付款状态位1
 */
@property (nonatomic, assign) NSInteger waitingStatus;

/**
等待确认完成状态位2 已确认完成状态位3
 */
@property (nonatomic, assign) NSInteger ongoingStatus;

@property (nonatomic, retain) NSString *eid;

@property (nonatomic, retain) NSString *detailTitle;

@end
