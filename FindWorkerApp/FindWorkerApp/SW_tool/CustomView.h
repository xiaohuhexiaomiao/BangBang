//
//  CustomView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/7.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RTLabel.h"
@interface CustomView : NSObject

+(UILabel*)customTitleUILableWithContentView:(UIView*)contentView title:(NSString*)title;


+(UILabel*)customContentUILableWithContentView:(UIView*)contentView title:(NSString*)title;

+(RTLabel*)customRTLableWithContentView:(UIView*)contentView title:(NSString*)title;

+(UIButton*)customButtonWithContentView:(UIView*)contentView image:(NSString*)imageStr title:(NSString*)title;

+(UITextField*)customUITextFieldWithContetnView:(UIView*)contentView placeHolder:(NSString*)placeholderString;

+(UITextView*)customUITextViewWithContetnView:(UIView*)contentView placeHolder:(NSString*)placeholderString;

+(UIView*)customLineView:(UIView*)contentView;



@end
