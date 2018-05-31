//
//  SWNearbyWorkerCell.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/18.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWWorkerData.h"
@protocol NearbyWorkerCellDelegate <NSObject>

-(void)clickPhoneWithPhone:(SWWorkerData*)workData;

@end
@interface SWNearbyWorkerCell : UITableViewCell

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, strong) SWWorkerData *workData;

@property (nonatomic, weak) id<NearbyWorkerCellDelegate> delegate;

@property (nonatomic, assign) NSInteger is_Vip;

//展示数据
//image:头像
//name:姓名
//distance:距离
//jobs:工种
- (void)showData:(NSString *)imageName name:(NSString *)name distance:(NSString *)distance jobs:(NSArray *)Jobarr;

//展示数据
//image:头像
//name:姓名
//phone:手机
//jobs:工种
//distance:距离
- (void)showData:(NSString *)imageName name:(NSString *)name distance:(NSString *)distance jobs:(NSArray *)Jobarr phone:(NSString *)phone year:(NSString*)year;

- (void)setWokerData:(SWWorkerData *)workData;

@end
