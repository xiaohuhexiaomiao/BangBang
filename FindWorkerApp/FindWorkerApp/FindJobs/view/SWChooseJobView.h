//
//  SWChooseJobView.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/6.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SWChooseItemDelegate <NSObject>

- (void)selectItem:(NSString *)itemName;

- (void)selectTypeItem:(NSString *)wid;

@end

@interface SWChooseJobView : UIView

//隐藏菜单
- (void)hiddenMenu;

@property (nonatomic, weak) id<SWChooseItemDelegate> itemDelegate;

@end
