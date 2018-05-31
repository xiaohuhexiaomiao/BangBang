//
//  SWNearbyWorkerView.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/20.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWNearbyWorkerView.h"
#import "PermissionUpdateViewController.h"
#import "CXZ.h"

@interface SWNearbyWorkerView ()

@property (nonatomic, retain) UIImageView *icon;

@property (nonatomic, retain) UILabel *name; //姓名

@property (nonatomic, retain) UILabel *money; //预算

@property (nonatomic, retain) UILabel *job; //工作

@property (nonatomic, strong) UILabel *yearLabel; 

@property (nonatomic, retain) UILabel *time; //时间

@property (nonatomic, retain) UILabel *distance; //距离

@property (nonatomic, retain) UIButton *phoneBtn;


@property (nonatomic, retain) NSMutableArray *viewArr;

@end

@implementation SWNearbyWorkerView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        _viewArr = [NSMutableArray array];
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
    [self addSubview:_icon];
    
    _name = [[UILabel alloc] init];
    _name.frame = CGRectMake(CGRectGetMaxX(_icon.frame) + 5, _icon.frame.origin.y, 10, 10);
    _name.font = [UIFont systemFontOfSize:12];
    _name.textColor = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00];
    [self addSubview:_name];
    
    _distance = [[UILabel alloc] init];
    _distance.font = [UIFont systemFontOfSize:13];
    _distance.textColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00];
    [self addSubview:_distance];
    
    _yearLabel = [[UILabel alloc]init];
    _yearLabel.textAlignment = NSTextAlignmentCenter;
    _yearLabel.font = [UIFont systemFontOfSize:12];
    _yearLabel.textColor = TITLECOLOR;
    [self addSubview:_yearLabel];
}

//展示数据
//image:头像
//name:姓名
//phone:手机
//jobs:工种
//distance:距离
- (void)showData:(NSString *)imageName name:(NSString *)name distance:(NSString *)distance jobs:(NSArray *)Jobarr phone:(NSString *)phone year:(NSString *)year{
    
    _phone = phone;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"temp"]];
    
    _name.text = name;
    [_name sizeToFit];
    CGFloat dis = [distance floatValue]/1000;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距离您%.2fkm",dis]];
    NSString *str = [NSString stringWithFormat:@"距离您%.2fkm",dis];
    NSRange range = [str rangeOfString:[NSString stringWithFormat:@"%.2f",dis]];
    [att addAttributes:@{NSForegroundColorAttributeName:LIGHT_RED_COLOR} range:range];
    
    CGSize distanceSize = [[NSString stringWithFormat:@"距离您%.2fkm",dis] sizeWithFont:[UIFont systemFontOfSize:13] width:SCREEN_WIDTH];
    
    _distance.frame = CGRectMake(SCREEN_WIDTH - distanceSize.width - 10, (55 - distanceSize.height) / 2, 10, 10);
    _distance.textColor = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1.00];
    _distance.attributedText = att;
    [_distance sizeToFit];
    
    [self removeAllView:self.viewArr];
    
    CGFloat x = CGRectGetMaxX(_icon.frame) + 5;
    CGFloat y = CGRectGetMaxY(_name.frame) + 5;
    
    for (NSString *jobName in Jobarr) {
        
        CGSize nameSize = [jobName sizeWithFont:[UIFont systemFontOfSize:10] width:SCREEN_WIDTH];
        
        UILabel *jobLbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, nameSize.width + 10, nameSize.height + 5)];
        jobLbl.textColor = TITLECOLOR;
        jobLbl.font      = [UIFont systemFontOfSize:10];
        jobLbl.text      = jobName;
        [self addSubview:jobLbl];

        x += nameSize.width+5;
        
    }
    _yearLabel.frame = CGRectMake(x, y, 50, 18);
    _yearLabel.text = year;
    
    //vip
    _phoneBtn = [[UIButton alloc] init];
//    if (self.is_Vip == 0) {
//        NSString *title = [_phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//        [_phoneBtn setTitle:title forState:UIControlStateNormal];
//    }else{
//        [_phoneBtn setTitle:_phone forState:UIControlStateNormal];
//    }
    [_phoneBtn setTitle:_phone forState:UIControlStateNormal];
    [_phoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_phoneBtn addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
    [_phoneBtn sizeToFit];
    
    CGFloat btnW = _phoneBtn.bounds.size.width;
    CGFloat btnH = _phoneBtn.bounds.size.height;
    CGFloat btnX = (SCREEN_WIDTH - btnW) / 2;
    CGFloat btnY = (55.0f - btnH) / 2;
    _phoneBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    [self addSubview:_phoneBtn];
    
}

- (void)callClick {

    [self.delegate clickPhoneWithData:self.workData];
    
}

- (void)removeAllView:(NSMutableArray *)arr {
    
    for (UILabel *view in arr) {
        
        [view removeFromSuperview];
        
    }
    
    [arr removeAllObjects];
    
}

@end
