//
//  SMSlider.m
//  dongman
//
//  Created by apple on 16/9/10.
//  Copyright (c) 2016 cxz. All rights reserved.
//

#import "SMSlider.h"

@implementation SMSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    //y轴方向改变手势范围
    rect.origin.y = rect.origin.y - 10;
    rect.size.height = rect.size.height + 20;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 10 ,10);
}

@end
