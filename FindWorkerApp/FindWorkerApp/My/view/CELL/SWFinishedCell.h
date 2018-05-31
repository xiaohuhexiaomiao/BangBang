//
//  SWFinishedCell.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWFinishedCellDelegate <NSObject>

-(void)clickApplyPayBtn:(NSInteger)tag;

@end
@interface SWFinishedCell : UITableViewCell

@property(nonatomic, weak) id <SWFinishedCellDelegate> delegate;

+ (instancetype)initWithTableViewCell:(UITableView *)tableView;

- (void)showData:(NSString *)date content:(NSString *)content;

@end
