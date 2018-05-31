//
//  SWEvaluteFrame.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SWEvaluateData.h"

@interface SWEvaluteFrame : NSObject

@property (nonatomic, assign) CGRect iconF; // 图标的frmae值

@property (nonatomic, assign) CGRect phoneF; // 手机号码得frame值

@property (nonatomic, assign) CGRect timeF; // 时间的frame值

@property (nonatomic, assign) CGRect contentF; // 内容的frame值

@property (nonatomic, assign) CGRect stateF; // 状态的frame值

@property (nonatomic, assign) CGFloat cellH; // 行高

@property (nonatomic, retain) SWEvaluateData *evaluateData;

- (void)showData:(NSString *)icon phone:(NSString *)phone time:(NSString *)time content:(NSString *)content state:(NSString *)state;

@end
