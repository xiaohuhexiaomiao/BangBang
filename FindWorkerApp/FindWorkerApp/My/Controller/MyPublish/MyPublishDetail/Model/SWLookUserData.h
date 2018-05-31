//
//  SWLookUserData.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@interface SWLookUserData : Jastor

@property (nonatomic, retain) NSString *uid;

@property (nonatomic, retain) NSString *avatar;

@property (nonatomic, retain) NSArray *type;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *aid;

@property (nonatomic, retain) NSString *iid;

@property (nonatomic, retain) NSString *eid;

@property (nonatomic, assign) NSInteger collect;//0 未收藏， 1 收藏

@property (nonatomic, assign) BOOL rate;


@property (nonatomic, assign) BOOL is_contract;

/** 0:未处理 1:同意 2:拒绝 */
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *univalent;//价格
//@property (nonatomic, copy) NSString *payment_ratio;//付款比例

@end
