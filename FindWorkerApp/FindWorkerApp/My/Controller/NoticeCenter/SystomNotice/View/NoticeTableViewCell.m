//
//  NoticeTableViewCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/1/4.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "NoticeTableViewCell.h"
#import "CXZ.h"
@interface NoticeTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation NoticeTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 5, SCREEN_WIDTH-24, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.numberOfLines = 2;
        _timeLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, _titleLabel.bottom, SCREEN_WIDTH-24, 15)];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = SUBTITLECOLOR;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

-(void)setNoticeCell:(NoticeModel *)notice
{
    self.titleLabel.text = notice.message;
    self.titleLabel.numberOfLines = 2;
    self.timeLabel.text = notice.add_time;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
