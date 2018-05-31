//
//  ColorView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/5.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorView : UIView

@property(nonatomic ,copy)void (^DidClickColorCard)(NSString *colorString);

-(void)setColorCardView:(NSArray *)colorArray;

@end
