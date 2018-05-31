//
//  SalaryView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/21.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SalaryView;
@protocol SalaryViewDelegate <NSObject>

-(void)clickAddWorkerContract:(NSInteger)tag;

-(void)clickDeleteWorkerWithTag:(NSInteger)tag;

-(void)addPhoto:(NSInteger)tag;

-(void)checkContract:(NSInteger)tag;//查看合同附件

@end

@interface SalaryView : UIView

@property(nonatomic ,strong)NSMutableDictionary *dataDict;

@property(nonatomic , weak)id <SalaryViewDelegate> delegate;

-(void)setSalaryViewWith:(NSMutableArray*)imgArray;//上传附件

-(void)setSalaryViewWithName:(NSDictionary*)dict type:(NSInteger)type;//合同附件

-(void)showSalaryViewWithDict:(NSDictionary*)dict;//展示

-(void)showCopySalaryViewWithDict:(NSDictionary*)dict;//展示

@end
