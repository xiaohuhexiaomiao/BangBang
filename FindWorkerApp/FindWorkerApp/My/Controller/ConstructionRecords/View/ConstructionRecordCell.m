//
//  ConstructionRecordCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/5/10.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ConstructionRecordCell.h"
#import "CXZ.h"
@interface ConstructionRecordCell()

@property (nonatomic , strong)UILabel *titleLabel;

@property (nonatomic , strong)UILabel *nameLabel;

@property (nonatomic , strong)UILabel *timeLabel;

@end

@implementation ConstructionRecordCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 8, SCREEN_WIDTH, 18)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_titleLabel];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom+8, 150, 15)];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.right,_nameLabel.top, SCREEN_WIDTH-_nameLabel.right-8, 15)];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = SUBTITLECOLOR;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview: _timeLabel];
        
    }
    return self;
}

-(void)setiConstuctionRecordCellWithModel:(RecordsListModel*)listModel
{
    self.titleLabel.text = listModel.contract_name;
    if (listModel.user_type == 1) {
        self.nameLabel.text = [NSString stringWithFormat:@"乙方：%@",listModel.b_name];
    }else
    {
      self.nameLabel.text = [NSString stringWithFormat:@"甲方：%@",listModel.a_name];
    }
    self.timeLabel.text = listModel.sign_time;
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
