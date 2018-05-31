//
//  SWNearbyWorkerView.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/20.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWWorkerData.h"
@protocol NearbyWorkerViewDelegate <NSObject>

-(void)clickPhoneWithData:(SWWorkerData*)workData;

@end

@interface SWNearbyWorkerView : UIView

@property (nonatomic, retain) NSString *phone;

@property (nonatomic, assign) NSInteger is_Vip;

@property (nonatomic, strong) SWWorkerData *workData;

@property (nonatomic, weak) id<NearbyWorkerViewDelegate> delegate;
//展示数据
//image:头像
//name:姓名
//phone:手机
//jobs:工种
//distance:距离
- (void)showData:(NSString *)imageName name:(NSString *)name distance:(NSString *)distance jobs:(NSArray *)Jobarr phone:(NSString *)phone year:(NSString*)year;

@end
