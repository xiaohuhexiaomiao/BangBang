//
//  DiarySendRangeView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/17.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiarySendRangeView : UIView

@property(nonatomic ,strong) UIButton *commentsButton;

@property(nonatomic ,copy)NSString *company_id;

@property(nonatomic ,copy)NSString *reviewer_id;//点评人id

@property(nonatomic ,copy)NSArray *rangeArray;//抄送范围[ { "id":17,"type":2}, { "id":10,"type":1} ] 3：公司，2：部门，1：个人

@end
