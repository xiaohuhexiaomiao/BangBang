//
//  SWChooseItem.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/18.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWChooseItem;

@protocol SWChooseItemDelegate <NSObject>

//选择当前项目
//当前的item
- (void)selectItem:(SWChooseItem *)item;

@end


@interface SWChooseItem : UIView

//标题
@property (nonatomic, retain) NSString *title;

//子内容
@property (nonatomic, retain) NSArray *itemArr;

//包含工种的子内容
@property (nonatomic, retain) NSArray *typeArr;

@property (nonatomic, retain) NSArray *addressArr;

//是否选中
@property (nonatomic, assign, readonly) BOOL isSelect;

@property (nonatomic, weak) id<SWChooseItemDelegate> Choosedelegate;



//设置强制选择
//select：是否选择
- (void)setSelect:(BOOL)select;

@end
