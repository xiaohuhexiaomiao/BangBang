//
//  ApprovalContentModel.h
//  FindWorkerApp
//
//  Created by cxz on 2018/4/9.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApprovalContentModel : NSObject

@property(nonatomic ,strong)NSString *name;

@property(nonatomic ,strong)NSString *department_name;

@property(nonatomic ,strong)NSString *add_time;

@property(nonatomic ,assign)BOOL is_agree;

@property(nonatomic ,strong)NSString *opinion;

@property(nonatomic ,strong)NSString *picture;

@property(nonatomic ,strong)NSArray *replys;

@property(nonatomic ,strong)NSString *uid;

@property(nonatomic ,strong)NSString *participation_id;

@end
