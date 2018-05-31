//
//  SWButton.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/28.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWButton.h"

@implementation SWButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat midX = self.frame.size.width / 2;
    CGFloat midY = self.frame.size.height/ 2 ;
    self.titleLabel.center = CGPointMake(midX, midY + 28);
    self.imageView.center = CGPointMake(midX, midY - 10);
    
}

@end
