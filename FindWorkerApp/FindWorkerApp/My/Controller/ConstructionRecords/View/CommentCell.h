//
//  CommentCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/5/12.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (nonatomic, assign)CGFloat commentCellHeight;

-(void)setCommentCellWithDictionary:(NSDictionary*)dict;

@end
