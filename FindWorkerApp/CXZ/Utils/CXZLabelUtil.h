//
//  LabelUtil.h
//  SkylineLibrary-ios
//
//  Created by waikeungshen on 15/5/28.
//  Copyright (c) 2015年 waikeungshen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CXZLabelUtil : NSObject

/**
 *  得到单例
 *
 *  @return 单例的对象
 */
+ (id)getInstance;

/**
 *  根据label文字自适应label的高度
 *
 *  @param label 要自适应的label
 *
 *  @return 自适应后label的高度
 */
- (CGFloat)fitLabelHeight:(UILabel *)label;

/**
 *  根据label文字自适应label的宽度
 *
 *  @param label 要自适应的label
 *
 *  @return 自适应后label的宽度
 */
- (CGFloat)fitLabelWidth:(UILabel *)label;

@end
