//
//  ContractCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/23.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ContractCell.h"
#import "CXZ.h"

@interface ContractCell()

@property(nonatomic , strong)UILabel *titleLabel;

@property(nonatomic , strong)UILabel *nameLabel;

@property(nonatomic , strong)UILabel *timeLabel;

@end

@implementation ContractCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-16, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_titleLabel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTitle:)];
        _titleLabel.userInteractionEnabled = YES;
        [_titleLabel addGestureRecognizer:tap];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom, _titleLabel.width, _titleLabel.height)];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.left, _nameLabel.bottom, _nameLabel.width, _nameLabel.height)];
        _timeLabel.textColor = SUBTITLECOLOR;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLabel];
        
    }
    return self;
}

-(void)clickTitle:(UITapGestureRecognizer*)tap
{
    UILabel *label = (UILabel*)tap.view;
    NSInteger tag = ((ContractCell*)[[label superview] superview]).tag;
    [self.delegate clickTitleWithTag:tag];
}

-(void)showCompanyContract:(NSDictionary *)dict
{
    NSString *title = dict[@"title"];
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:dict[@"title"]];
    [titleStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, title.length)];
    self.titleLabel.attributedText = titleStr;
    self.nameLabel.text = [NSString stringWithFormat:@"甲方：%@",dict[@"employ_name"]];
    self.timeLabel.text = dict[@"add_time"];
}


-(void)showPersonalContract:(NSDictionary *)dict
{
    NSString *title = dict[@"title"];
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:dict[@"title"]];
    [titleStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, title.length)];
    self.titleLabel.attributedText = titleStr;
    self.nameLabel.text = [NSString stringWithFormat:@"乙方：%@",dict[@"worker_name"]];
    self.timeLabel.text = dict[@"add_time"];
}


- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
