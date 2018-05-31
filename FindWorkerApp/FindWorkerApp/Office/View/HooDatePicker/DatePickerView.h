//
//  DatePickerView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/23.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic ,copy)NSString *yearString;

@property(nonatomic ,copy)NSString *monthString;

@property(nonatomic ,assign)NSInteger datePickerType;//0 年月 1 只有年 2 月

@end
