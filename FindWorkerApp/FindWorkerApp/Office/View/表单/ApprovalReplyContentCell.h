//
//  ApprovalReplyContentCell.h
//  FindWorkerApp
//
//  Created by cxz on 2018/4/9.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApprovalContentModel;
@class ApprovalReplyModel;

@protocol ApprovalReplyContentCellDelegate <NSObject>

-(void)clickReplyButtonOfCellWith:(ApprovalContentModel*)contentModel replyModel:(ApprovalReplyModel*)replyModel;

@end


@interface ApprovalReplyContentCell : UITableViewCell

@property(nonatomic ,assign) CGFloat cellHeight;

@property (nonatomic ,assign) BOOL is_reply;

@property(nonatomic ,strong)ApprovalContentModel *approvalContentModel;//处理审批内容model

@property(nonatomic ,weak) id<ApprovalReplyContentCellDelegate>delegate;

-(void)setApprovalReplyContentWithDict:(NSDictionary*)dict;

@end
