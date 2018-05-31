//
//  CustomView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/7.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CustomView.h"

#define UIColorFromRGB(rValue,gValue,bValue) [UIColor colorWithRed:rValue / 255.0 green:gValue / 255.0 blue:bValue / 255.0 alpha:1]

@implementation CustomView
+(UILabel*)customTitleUILableWithContentView:(UIView*)contentView title:(NSString*)title
{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = UIColorFromRGB(152, 152, 152);
    label.font = [UIFont systemFontOfSize:14];
    if (title) {
        label.text = title;
    }
    
    [contentView addSubview:label];
    return label;
}

+(UILabel*)customContentUILableWithContentView:(UIView*)contentView title:(NSString*)title
{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = UIColorFromRGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:14];
    if (title) {
        label.text = title;
    }
    label.numberOfLines = 0;
    [contentView addSubview:label];
    return label;
}

+(RTLabel*)customRTLableWithContentView:(UIView*)contentView title:(NSString*)title;
{
    RTLabel *label = [[RTLabel alloc]init];
    [contentView addSubview:label];
    label.lineSpacing = 0;
    
    if (title) {
        label.text = title;
    }
    label.font = [UIFont systemFontOfSize:14];
    label.textColor =  UIColorFromRGB(51, 51, 51);
   
    
    return label;
}


+(UIButton*)customButtonWithContentView:(UIView*)contentView image:(NSString*)imageStr title:(NSString*)title
{
   
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (imageStr) {
        [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1.00] forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    [contentView addSubview:button];
    return button;
}

+(UITextField*)customUITextFieldWithContetnView:(UIView*)contentView placeHolder:(NSString*)placeholderString
{
    UITextField *textfield = [[UITextField alloc]init];
    textfield.font = [UIFont systemFontOfSize:14];
    textfield.textColor = UIColorFromRGB(51, 51, 51);
    if (placeholderString) {
        textfield.placeholder = placeholderString;
    }
    [contentView addSubview:textfield];
    return textfield;
}

+(UITextView*)customUITextViewWithContetnView:(UIView*)contentView placeHolder:(NSString*)placeholderString
{
    UITextView *textView = [[UITextView alloc]init];
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = UIColorFromRGB(51, 51, 51);
    if (placeholderString) {
        textView.text = placeholderString;
    }
    [contentView addSubview:textView];
    return textView;
}

+(UIView*)customLineView:(UIView*)contentView
{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(224, 223, 226);
    [contentView addSubview:line];
    return line;
}

@end
