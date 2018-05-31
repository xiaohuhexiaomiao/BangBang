//
//  RecordDetailCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/5/10.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordsDetailListModel.h"

@protocol RecordDetailCellDelegate <NSObject>

-(void)clickRecordImageWithRow:(NSInteger)row index:(NSInteger)index;

@end

@interface RecordDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *recordsImageArray;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *commendNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locoalImageview;

@property (nonatomic , assign) CGFloat recordDetailCellHeight;
@property (weak, nonatomic) id <RecordDetailCellDelegate>delegate;

-(void)setRecordsDetailListCellWithModel:(RecordsDetailListModel*)model;

@end
