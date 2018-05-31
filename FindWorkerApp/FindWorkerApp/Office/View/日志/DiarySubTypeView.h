//
//  DiarySubTypeView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/12/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DiarySubTypeViewDelegate <NSObject>

-(void)selectedDiarySubType:(NSDictionary*)typeDict type:(NSInteger)type;

@end

@interface DiarySubTypeView : UIView

@property(nonatomic ,assign) NSInteger diaryType;//发表类型；1 日志，2周志，3月志

@property(nonatomic ,weak)id <DiarySubTypeViewDelegate> delegate;

-(void)loadDiaryType;

@end
