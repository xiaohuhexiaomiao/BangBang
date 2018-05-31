//
//  ApprovalContentView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/15.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PersonalApprovalResultModel.h"

@interface ApprovalContentView : UIView

-(CGFloat)setApprovalContentWith:(PersonalApprovalResultModel*)model;

-(CGFloat)setApprovalContentWithDictinary:(NSDictionary*)dict;

@end
