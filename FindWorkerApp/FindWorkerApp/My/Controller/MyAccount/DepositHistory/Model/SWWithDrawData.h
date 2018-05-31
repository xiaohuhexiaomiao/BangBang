//
//  SWWithDrawData.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@interface SWWithDrawData : Jastor

@property (nonatomic, retain) NSString *time;

/**
 0 待审核，1通过审核 2未通过审核 3.提现完成
 */
@property (nonatomic, assign) NSInteger money_status;

@property (nonatomic, retain) NSString *money;

@end
