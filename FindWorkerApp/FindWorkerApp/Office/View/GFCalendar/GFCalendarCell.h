//
//  GFCalendarCell.h
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFCalendarCell : UICollectionViewCell

@property (nonatomic, strong) UIView *todayCircle; //!< 标示'今天'
@property (nonatomic, strong) UILabel *todayLabel; //!< 标示日期（几号）

@property (nonatomic, strong) UIView *signView; //!< 标记 事件

@end
