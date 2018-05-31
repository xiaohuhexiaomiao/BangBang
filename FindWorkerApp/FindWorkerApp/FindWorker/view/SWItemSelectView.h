//
//  SWItemSelectView.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/18.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWWorkerTypeData.h"

@class SWItemSelectView;

@protocol SWItemSeleceDelegate <NSObject>

- (void)selectItem:(SWItemSelectView *)itemView;

- (void)deselectItem:(SWItemSelectView *)itemView;

@end

@interface SWItemSelectView : UIView

@property (nonatomic, weak) id<SWItemSeleceDelegate> selectViewDelegate;

-(CGFloat)showView:(SWWorkerTypeData *)typeData;

@property (nonatomic, assign) NSInteger workerNum; //工人数量

@property (nonatomic, retain) SWWorkerTypeData *workerName; //工人名称



@end
