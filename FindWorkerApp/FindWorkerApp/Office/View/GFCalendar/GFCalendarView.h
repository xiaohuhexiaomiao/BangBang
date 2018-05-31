//
//  GFCalendarView.h
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectDayHandler)(NSInteger, NSInteger, NSInteger);

typedef void (^DidCurrentMounthHandler)(NSInteger, NSInteger);

@interface GFCalendarView : UIView


/**
 *  构造方法
 *
 *  @param origin calendar 的位置
 *  @param width  calendar 的宽度（高度会根据给定的宽度自动计算）
 *
 *  @return bannerView对象
 */
- (instancetype)initWithFrameOrigin:(CGPoint)origin width:(CGFloat)width;


/**
 *  calendar 的高度（只读属性）
 */
@property (nonatomic, assign, readonly) CGFloat calendarHeight;


/**
 *  calendar 基本颜色
 */
@property (nonatomic, strong) UIColor *calendarBasicColor;

@property (nonatomic, assign) BOOL is_rounded_Corner;//是否圆角

/**
 *  日期点击回调
 *  block 的参数表示当前日期的 NSDate 对象
 */
@property (nonatomic, copy) DidSelectDayHandler didSelectDayHandler;

/**
 *  日期点击回调
 *  左右滑动 月份回调
 */
@property (nonatomic, copy) DidCurrentMounthHandler didCurrentMounthHandler;

/**
 *  刷新标记日期
 */

-(void)reloadSignDay:(NSArray*)calendarArray;

-(void)setIs_rounded_Corner:(BOOL)is_rounded_Corner;

@end
