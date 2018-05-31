//
//  DiaryRemindCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/12/5.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReplyApprovalContentModel;
@class RemindDetailModel;

@interface DiaryRemindCell : UITableViewCell

@property(nonatomic, assign) CGFloat height;

-(void)setDiaryRemindCellWithCommentModel:(RemindDetailModel*)remind;

-(void)setDiaryRemindCellWithZanModel:(RemindDetailModel*)remind;

-(void)setDiaryRemindCellWithReplyContentModel:(ReplyApprovalContentModel*)remind;

@end
