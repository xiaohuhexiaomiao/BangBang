//
//  NormallSelsectedCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/17.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NormallSelsectedCellDelegate <NSObject>

-(void)selectedCellWith:(BOOL)isSelected Model:(NSDictionary*)model;

-(void)selectedCellWith:(BOOL)isSelected index:(NSInteger)index;

@end

@interface NormallSelsectedCell : UITableViewCell

@property(nonatomic ,strong) UIButton *selectedButton;

@property(nonatomic ,weak)id<NormallSelsectedCellDelegate> delegate;

-(void)setNormalCellWithDictionary:(NSDictionary*)dict;

-(void)setNormalCellWithTitleString:(NSString*)titleString;

@end
