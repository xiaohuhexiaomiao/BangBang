//
//  RCMAddMemberTableViewCell.h
//  FindWorkerApp
//
//  Created by cxz on 2018/5/10.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SWWorkerData;
@class RCUserInfo;
@protocol RCMAddMemberCellDelegate <NSObject>

-(void)clickSelected:(NSInteger)tag is_seleted:(BOOL)is_selected;

@end

@interface RCMAddMemberTableViewCell : UITableViewCell

@property (nonatomic , strong)UIButton *selectBtn;

@property (nonatomic , weak)id<RCMAddMemberCellDelegate> delegate;

-(void)setModel:(SWWorkerData*)model;

-(void)setMemberModel:(RCUserInfo*)model;

@end
