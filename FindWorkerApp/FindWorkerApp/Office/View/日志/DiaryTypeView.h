//
//  DiaryTypeView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/7.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DiaryViewDelegate <NSObject>

-(void)close;

-(void)clickViewType:(NSInteger)tag;

@end

@interface DiaryTypeView : UIView

@property(nonatomic ,weak)id <DiaryViewDelegate> delegate;

@end
