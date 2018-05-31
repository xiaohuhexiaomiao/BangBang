//
//  SWNearbyWorkerCell.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/18.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWNearbyWorkerCell.h"
#import "CXZ.h"

@interface SWNearbyWorkerCell ()

@property (nonatomic, retain) UIImageView *icon;

@property (nonatomic, retain) UILabel *name; //姓名

@property (nonatomic, retain) UILabel *money; //预算

@property (nonatomic, retain) UILabel *job; //工作

@property (nonatomic, strong) UILabel *yearLabel; 

@property (nonatomic, retain) UILabel *time; //时间

@property (nonatomic, retain) UILabel *distance; //距离

@property (nonatomic, retain) UIButton *phoneBtn;

@property (nonatomic ,retain) UILabel *recommendLabel;

@property (nonatomic, retain) NSMutableArray *viewArr;

@end

@implementation SWNearbyWorkerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifie {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifie]) {
        
        _viewArr = [NSMutableArray array];
        [self initView];
        
    }
    
    return self;
    
}



//初始化视图
- (void)initView {
    
    _icon = [[UIImageView alloc] init];
    _icon.frame = CGRectMake(5, 10, 32, 32);
    _icon.layer.masksToBounds = YES;
    _icon.layer.cornerRadius = _icon.frame.size.height / 2;
    [self.contentView addSubview:_icon];
    
    _name = [[UILabel alloc] init];
    _name.frame = CGRectMake(CGRectGetMaxX(_icon.frame)+5 , 8, 10, 10);
    _name.font = [UIFont systemFontOfSize:12];
    _name.textColor = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00];
    [self.contentView addSubview:_name];
    
    _recommendLabel = [[UILabel alloc]init];
    _recommendLabel.frame = CGRectMake(_name.right+3, _name.top+2, 100, _name.height);
    _recommendLabel.font = [UIFont systemFontOfSize:10];
    _recommendLabel.textColor = [UIColor grayColor];
//    _recommendLabel.hidden = YES;
    [self.contentView addSubview:_recommendLabel];
    
    _phoneBtn = [[UIButton alloc] init];
    [_phoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [_phoneBtn addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
//    _phoneBtn.hidden = YES;
    [self.contentView addSubview:_phoneBtn];
    
    _distance = [[UILabel alloc] init];
    _distance.font = [UIFont systemFontOfSize:13];
    _distance.textColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00];
    [self.contentView addSubview:_distance];
    
    _job = [[UILabel alloc]init];
//    _job.textAlignment = NSTextAlignmentCenter;
    _job.font = [UIFont systemFontOfSize:10];
    _job.textColor = TITLECOLOR;
    [self.contentView addSubview:_job];
    
    _yearLabel = [[UILabel alloc]init];
    _yearLabel.textAlignment = NSTextAlignmentCenter;
    _yearLabel.font = [UIFont systemFontOfSize:12];
    _yearLabel.textColor = TITLECOLOR;
    [self.contentView addSubview:_yearLabel];
    
}

//展示数据
//image:头像
//name:姓名
//distance:距离
//jobs:工种
- (void)showData:(NSString *)imageName name:(NSString *)name distance:(NSString *)distance jobs:(NSArray *)Jobarr {
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"temp"]];
    
    _name.text = name;
    [_name sizeToFit];
    
    CGFloat dis = [distance integerValue]/1000.00;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距离您%.2fkm",dis]];
    NSString *str = [NSString stringWithFormat:@"距离您%.2fkm",dis];
    NSRange range = [str rangeOfString:[NSString stringWithFormat:@"%.2f",dis]];
    [att addAttributes:@{NSForegroundColorAttributeName:LIGHT_RED_COLOR} range:range];
    
    CGSize distanceSize = [[NSString stringWithFormat:@"距离您%.2fkm",dis] sizeWithFont:[UIFont systemFontOfSize:13] width:SCREEN_WIDTH];
    
    _distance.frame = CGRectMake(SCREEN_WIDTH - distanceSize.width - 10, (55 - distanceSize.height) / 2, 10, 10);
    _distance.textColor = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1.00];
    _distance.attributedText = att;
    [_distance sizeToFit];
    
    [self.viewArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat x = CGRectGetMaxX(_icon.frame) + 5;
    CGFloat y = CGRectGetMaxY(_name.frame) + 8;
    
    for (NSString *jobName in Jobarr) {
        
        CGSize nameSize = [jobName sizeWithFont:[UIFont systemFontOfSize:10] width:SCREEN_WIDTH];
        
        UILabel *jobLbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, nameSize.width + 10, nameSize.height + 5)];
        jobLbl.textColor = [UIColor colorWithRed:0.52 green:0.53 blue:0.53 alpha:1.00];
        jobLbl.font      = [UIFont systemFontOfSize:10];
        jobLbl.text      = jobName;
        jobLbl.textAlignment = NSTextAlignmentCenter;
        jobLbl.layer.cornerRadius = nameSize.height / 2;
        jobLbl.layer.masksToBounds = YES;
        jobLbl.layer.borderWidth = 0.5;
        jobLbl.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00].CGColor;
        [self.contentView addSubview:jobLbl];
        [self.viewArr addObject:jobLbl];
        x += nameSize.width+15;

        
    }
    
}

//展示数据
//image:头像
//name:姓名
//phone:手机
//jobs:工种
//distance:距离
- (void)showData:(NSString *)imageName name:(NSString *)name distance:(NSString *)distance jobs:(NSArray *)Jobarr phone:(NSString *)phone year:(NSString*)year {

    _phone = phone;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"temp"]];
    
    _name.text = name;
    [_name sizeToFit];
    
    CGFloat dis = [distance floatValue]/1000;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距离%.2fkm",dis]];
    NSString *str = [NSString stringWithFormat:@"距离%.2fkm",dis];
    NSRange range = [str rangeOfString:[NSString stringWithFormat:@"%.2f",dis]];
    [att addAttributes:@{NSForegroundColorAttributeName:LIGHT_RED_COLOR} range:range];
    
    CGSize distanceSize = [[NSString stringWithFormat:@"距离%.2fkm",dis] sizeWithFont:[UIFont systemFontOfSize:13] width:SCREEN_WIDTH];
    
    _distance.frame = CGRectMake(SCREEN_WIDTH - distanceSize.width - 10, (55 - distanceSize.height) / 2, 10, 10);
    _distance.textColor = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1.00];
    _distance.attributedText = att;
    [_distance sizeToFit];
    
//    [self.viewArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat x = CGRectGetMaxX(_icon.frame) + 5;
    CGFloat y = CGRectGetMaxY(_name.frame) + 8;
    

    if (Jobarr.count > 0) {
        NSString *jobName = [Jobarr componentsJoinedByString:@" "];
        CGSize nameSize = [jobName sizeWithFont:[UIFont systemFontOfSize:10] width:SCREEN_WIDTH];
        _job.frame = CGRectMake(x, y, nameSize.width + 5, nameSize.height + 5);
        _job.text = jobName;
    }
    
    _yearLabel.frame = CGRectMake(_job.right, _job.top, 50, _job.height);
    _yearLabel.text = year;
    
//    _phoneBtn.hidden = NO;
//    if (self.is_Vip == 0) {
//        NSString *title = [_phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//        [_phoneBtn setTitle:title forState:UIControlStateNormal];
//    }else{
//        [_phoneBtn setTitle:_phone forState:UIControlStateNormal];
//    }
     [_phoneBtn setTitle:_phone forState:UIControlStateNormal];
    [_phoneBtn sizeToFit];
    CGFloat btnW = _phoneBtn.bounds.size.width;
    CGFloat btnH = _phoneBtn.bounds.size.height;
    CGFloat btnX = (SCREEN_WIDTH - btnW) / 2;
//    CGFloat btnY = (55.0f - btnH) / 2;
    _phoneBtn.frame = CGRectMake(btnX, 8, btnW, btnH);
    
    
    
}
- (void)setWokerData:(SWWorkerData *)workData
{
    if (workData.registe == 0 ) {
        _recommendLabel.left = _name.right+3;
        _recommendLabel.text = [NSString stringWithFormat:@"推荐人：%@",workData.tjr_name];
        _recommendLabel.hidden = NO;
        CGRect frame = _phoneBtn.frame;
        frame.origin.y += 5;
        _phoneBtn.frame = frame;
//        _distance.hidden = YES;
        _distance.text = @"";
    }else{
        _recommendLabel.text = @"";
    }
}


- (void)callClick {

    [self.delegate clickPhoneWithPhone:self.workData];
    
}


@end
