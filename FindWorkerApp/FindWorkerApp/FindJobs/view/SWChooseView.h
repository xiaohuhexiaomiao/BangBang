//
//  SWChooseView.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/18.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SWChooseItemDelegate <NSObject>

- (void)selectItem:(NSString *)itemName;

- (void)selectTypeItem:(NSString *)wid;

- (void)selectAddressItem:(NSString *)wid;

@end

@interface SWChooseView : UIView



//隐藏菜单
- (void)hiddenMenu;

@property (nonatomic, weak) id<SWChooseItemDelegate> itemDelegate;

@end
