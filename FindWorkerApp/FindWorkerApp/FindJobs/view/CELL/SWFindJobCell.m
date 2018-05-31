//
//  SWFindJobCell.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/18.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWFindJobCell.h"
#import "CXZ.h"

@interface SWFindJobCell ()

@property (nonatomic, retain) UIImageView *icon;

@property (nonatomic, retain) UILabel *name; //姓名

@property (nonatomic, retain) UILabel *money; //预算

@property (nonatomic, retain) UILabel *job; //工作

@property (nonatomic, retain) UILabel *time; //时间

@end

@implementation SWFindJobCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifie {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifie]) {
    
        [self initView];
        
    }
    
    return self;
    
}



//初始化视图
- (void)initView {
    
    _icon = [[UIImageView alloc] init];
    _icon.frame = CGRectMake(5, 12.5, 30, 30);
    _icon.layer.masksToBounds = YES;
    _icon.layer.cornerRadius = _icon.frame.size.height / 2;
    [self.contentView addSubview:_icon];
    
    _name = [[UILabel alloc] init];
    _name.frame = CGRectMake(CGRectGetMaxX(_icon.frame) + 5, _icon.frame.origin.y, 10, 10);
    _name.font = [UIFont systemFontOfSize:12];
    _name.textColor = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00];
    [self.contentView addSubview:_name];
    
    _money = [[UILabel alloc] init];
    _money.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_money];
    
    _job = [[UILabel alloc] init];
    _job.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_job];
    
    
    _time = [[UILabel alloc] init];
    _time.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_time];
    
}

//展示数据
//image:头像
//name:姓名
//money:预算
//job:需要工种
//time:发布时间
- (void)showData:(NSString *)imageName name:(NSString *)name money:(NSString *)money job:(NSString *)job time:(NSString *)time {
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"temp"]];
    
    _name.text = name;
    [_name sizeToFit];
    
    NSMutableAttributedString *moneyAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预算%@",money]];
    
    [moneyAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1.00]} range:NSMakeRange(0, 2)];
    _money.textColor = [UIColor colorWithRed:0.90 green:0.77 blue:0.67 alpha:1.00];
    _money.attributedText = moneyAttr;
    _money.frame = CGRectMake(CGRectGetMaxX(_name.frame) + 10, _name.frame.origin.y, 10, 10);
    [_money sizeToFit];
    
    _job.frame = CGRectMake(_name.frame.origin.x, CGRectGetMaxY(_name.frame) + 5, 10, 10);
    _job.textColor = [UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1.00];
    _job.text = job;
    [_job sizeToFit];
    
    CGSize timeSize = [time sizeWithFont:[UIFont systemFontOfSize:13] width:SCREEN_WIDTH];
    
    _time.frame = CGRectMake(SCREEN_WIDTH - timeSize.width - 10, (55 - timeSize.height) / 2, 10, 10);
    _time.textColor = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1.00];
    _time.text = time;
    [_time sizeToFit];
    
}

@end
