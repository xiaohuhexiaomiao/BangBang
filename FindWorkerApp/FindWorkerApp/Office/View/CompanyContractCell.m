//
//  CompanyContractCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/16.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CompanyContractCell.h"
#import "CXZ.h"
@interface CompanyContractCell()

@property(nonatomic , strong) UILabel *contractTitleLabel;

@property(nonatomic , strong) UILabel *firstLabel;

@property(nonatomic , strong) UILabel *secondLabel;

@property(nonatomic , strong) UILabel *singnTimeLabel;

@property(nonatomic , strong) UIButton *eyeButton;

@end
@implementation CompanyContractCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _contractTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-16, 20)];
        _contractTitleLabel.font = [UIFont systemFontOfSize:12];
        _contractTitleLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_contractTitleLabel];
        
        _firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(_contractTitleLabel.left, _contractTitleLabel.bottom, 100, _contractTitleLabel.height)];
        _firstLabel.font = _contractTitleLabel.font;
        _firstLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_firstLabel];
        
        _singnTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_firstLabel.left, _firstLabel.bottom, 100, 15)];
        _singnTimeLabel.font = [UIFont systemFontOfSize:12];
        _singnTimeLabel.textColor = SUBTITLECOLOR;
        [self.contentView addSubview:_singnTimeLabel];
        
        
        _eyeButton = [CustomView customButtonWithContentView:self.contentView image:@"eye" title:nil];
        _eyeButton.frame = CGRectMake(SCREEN_WIDTH-30, _singnTimeLabel.top-10, 24, 16);
        _eyeButton.hidden = YES;
        [_eyeButton addTarget:self action:@selector(clickSeeDetailButton) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)setSendContractCell:(CompanyContractModel *)company//甲方
{
//    NSLog(@"***%@",company.title);
    self.contractTitleLabel.text = [NSString stringWithFormat:@"合同名称：%@",company.contract_name];
    self.firstLabel.text = [NSString stringWithFormat:@"乙方：%@",company.b_name];
    self.singnTimeLabel.text = company.add_time;
    if (self.isSelected) {
        self.eyeButton.hidden = NO;
    }
    
}
-(void)clickSeeDetailButton
{
    [self.delegate clickSelected:self.tag];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
