//
//  SponsorTableViewCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/17.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewListModel.h"

@protocol SponsorTableViewCellDelegate <NSObject>

-(void)clickSeeDetail:(NSInteger)index;

@end

@interface SponsorTableViewCell : UITableViewCell

@property(nonatomic ,assign)BOOL is_show_eyebutton;

@property(nonatomic ,assign)CGFloat cellHeight;

@property(nonatomic ,weak)id <SponsorTableViewCellDelegate> delegate;

-(void)setSponsorCellWith:(ReviewListModel*)reviewModel;

-(void)setPersonalSponsorCellWith:(ReviewListModel*)reviewModel;

@end
