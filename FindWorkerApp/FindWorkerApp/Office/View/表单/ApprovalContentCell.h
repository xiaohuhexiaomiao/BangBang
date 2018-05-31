//
//  ApprovalContentCell.h
//  FindWorkerApp
//
//  Created by cxz on 2018/4/9.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApprovalContentModel;
@protocol ApprovalContentCellDelegate <NSObject>

-(void)clickReplyButton:(ApprovalContentModel*)contentModel;

@end

@interface ApprovalContentCell : UITableViewCell

@property(nonatomic ,assign) CGFloat cellHeight;

@property (nonatomic ,assign) BOOL is_reply;//yes 可回复

@property(nonatomic, weak) id<ApprovalContentCellDelegate> delegate;

-(void)setApprovalContentWith:(NSDictionary*)dict; // 审批内容

-(void)setCashierReplyContentWith:(NSDictionary*)dict; //  是表单回执内容

-(void)setApprovalProtocolWithDictionary:(NSDictionary*)dict; // 协议内容

@end
