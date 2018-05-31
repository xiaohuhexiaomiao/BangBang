//
//  ApprovalResultModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/10/18.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApprovalResultModel : NSObject

@property(nonatomic ,assign)BOOL can_approval;

@property(nonatomic ,strong)NSArray *content;

@property(nonatomic ,strong)NSDictionary *finance;//回执

@property(nonatomic ,strong)NSDictionary *supply;//呈批协议

@property(nonatomic ,strong)NSString *found_name;

@property(nonatomic ,assign)NSInteger is_ok;

@property(nonatomic ,strong)NSArray *list;

@property(nonatomic ,strong)NSString *participation_id;

@end
