//
//  SWBaseItem.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWBaseItem;

@protocol SWBaseItemDelegate <NSObject>

- (void)selectSWItem:(SWBaseItem *)item;

@end

@interface SWBaseItem : UIView

@property (nonatomic, retain) NSString *title; //显示标题

@property (nonatomic, retain) UIColor *UnselectColor; //未选中的颜色

@property (nonatomic, retain) UIColor *SelectColor; //选中的颜色

@property (nonatomic, assign) NSInteger page; //这个item是表示第几页

@property (nonatomic, weak) id<SWBaseItemDelegate> SWBasedelegate;

- (void)setSelect:(BOOL)select;

- (void)showData;

@end
