//
//  NormalCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/12/6.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalCell : UITableViewCell

@property(nonatomic ,strong) UILabel *subtitleLabel;

-(void)setImageViewWithImage:(NSString*)imgString Title:(NSString*)title SubTitle:(NSString*)subtitle;


@end
