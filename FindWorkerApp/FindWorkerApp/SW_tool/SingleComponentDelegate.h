//
//  SingleComponentDelegate.h
//  DataSourceDelegate
//
//  Created by 闫建刚 on 15/6/3.
//  Copyright (c) 2015年 闫建刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SingleComponentDelegate : NSObject<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSArray *dataSource;

@property (nonatomic) NSInteger lastSelectedIndex;

@property (nonatomic,copy) void (^ selectedRowChanged)(NSString *rowInfo,NSInteger index);


@end
