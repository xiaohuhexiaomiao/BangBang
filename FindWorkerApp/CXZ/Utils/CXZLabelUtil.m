//
//  LabelUtil.m
//  SkylineLibrary-ios
//
//  Created by waikeungshen on 15/5/28.
//  Copyright (c) 2015年 waikeungshen. All rights reserved.
//

#import "CXZLabelUtil.h"

@implementation CXZLabelUtil

+ (id)getInstance {
    __strong static CXZLabelUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CXZLabelUtil alloc] init];
    });
    return instance;
}

- (CGFloat)fitLabelHeight:(UILabel *)label {
    //label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, 0)];
    //[label.text sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    CGSize labelSize = [label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    
    CGRect frame = label.frame;
    //frame.size.height =size.height;
    frame.size.height = labelSize.height;
    label.frame = frame;
    
    return label.frame.size.height;
}

- (CGFloat)fitLabelWidth:(UILabel *)label {
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(0, label.frame.size.height)];
    // [label.text sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    CGSize labelSize = [label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    
    CGRect frame = label.frame;
    //frame.size.width = size.width;
    frame.size.width = labelSize.height;
    label.frame = frame;
    
    return label.frame.size.width;
}

@end
