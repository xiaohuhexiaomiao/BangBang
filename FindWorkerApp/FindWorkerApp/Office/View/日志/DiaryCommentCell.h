//
//  DiaryCommentCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/15.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiaryCommentModel;

@interface DiaryCommentCell : UITableViewCell

@property(nonatomic , assign) CGFloat cellHeight;

@property(nonatomic , copy) NSString *company_id;

-(void)setDiaryCommentCellWithModel:(DiaryCommentModel*)commentModel;

@end
