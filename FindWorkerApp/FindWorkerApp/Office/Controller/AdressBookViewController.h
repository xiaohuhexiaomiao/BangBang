//
//  AdressBookViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@protocol AdressBookDelegate <NSObject>

-(void)saveAdressBook:(NSMutableArray*)selectedArray;

-(void)selectedPorjectManager:(NSDictionary*)dict;



@end

@interface AdressBookViewController : CXZBaseViewController

@property(nonatomic ,assign)BOOL isSelect;


@property(nonatomic ,assign)BOOL isAddManager;//添加管理员

@property(nonatomic ,assign)BOOL isSelectedManager;//添加项目负责人

@property(nonatomic ,assign)NSInteger loadDataType;//1 加载部门人员 2 加载全部公司人员 3 加载抄送范围 4 加载APP所有人员

@property(nonatomic ,assign) NSInteger departid;//部门id

@property(nonatomic ,assign)BOOL is_set_receipt;//YES 设置回执人员
@property(nonatomic ,assign)NSInteger setType;// 设置回执人员 表单leix


@property(nonatomic ,copy) NSString *companyid;

@property(nonatomic ,copy) NSString *publishID;//加载抄送范围时用

@property(nonatomic ,strong)NSArray *areadySelectArray;

@property(nonatomic ,weak) id <AdressBookDelegate> delegate;

@end
