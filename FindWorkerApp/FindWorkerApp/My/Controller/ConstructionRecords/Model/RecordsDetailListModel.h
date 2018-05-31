//
//  RecordsDetailListModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/5/11.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordsDetailListModel : NSObject

@property (nonatomic , copy)NSString *record_id;//施工记录ID

@property (nonatomic , copy)NSString *add_time;

@property (nonatomic , copy)NSString *content;//施工记录内容

@property (nonatomic , copy)NSString *contract_id;//合同ID

@property (nonatomic , assign)NSInteger num;

@property (nonatomic , strong)NSArray *picture;

@property (nonatomic , copy)NSString *position;//位置

@property (nonatomic , copy)NSString *uid;



@end
