//
//  SeeWorkerCell.m
//  FindWorkerApp
//
//  Created by cxz on 2018/3/30.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "SeeWorkerCell.h"
#import "CXZ.h"

#define padding 10

#define cellHeight 55.0f

@interface SeeWorkerCell()

@property (nonatomic, retain) UIImageView *icon;

@property (nonatomic, retain) UILabel *name; //姓名

@property (nonatomic, retain) UILabel *moneyLbl; //付款金额

@property (nonatomic, retain) UIButton *hireBtn; // 雇佣按钮

@property (nonatomic, retain) UIButton *cancelhireBtn; // 取消雇佣按钮

@property (nonatomic, retain) UIButton *remarkBtn; //评论按钮

@property (nonatomic, retain) UILabel *job; //工作


@property (nonatomic, strong) UIButton *collectonBtn;

@end

@implementation SeeWorkerCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _icon = [[UIImageView alloc] init];
        _icon.frame = CGRectMake(5, 12.5, 30, 30);
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = _icon.frame.size.height / 2;
        [self addSubview:_icon];
        
        _name = [[UILabel alloc] init];
        _name.frame = CGRectMake(_icon.right + 5, _icon.frame.origin.y, 10, 10);
        _name.font = [UIFont systemFontOfSize:12];
        _name.textColor = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00];
        [self addSubview:_name];
        
        _hireBtn = [[UIButton alloc] init];
        [_hireBtn setTitle:@"发送合同" forState:UIControlStateNormal];
        _hireBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_hireBtn setTitleColor:[UIColor colorWithRed:0.49 green:0.76 blue:0.75 alpha:1.00] forState:UIControlStateNormal];
        [_hireBtn sizeToFit];
        [_hireBtn addTarget:self action:@selector(hireClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat btnW = _hireBtn.bounds.size.width;
        CGFloat btnH = _hireBtn.bounds.size.height;
        _hireBtn.frame = CGRectMake(SCREEN_WIDTH - padding - btnW, (cellHeight - btnH) / 2, btnW, btnH);
        _btnStr = _hireBtn.currentTitle;
        [self addSubview:_hireBtn];
        
    }
    return self;
}

-(void)clickCollectionBtn:(UIButton*)sender
{
    //    NSLog(@"***%@",self.data);
    //0 取消收藏 1收藏
    UIImage *tempImage = [UIImage imageNamed:@"favorite_click"];
    NSData *tempData = UIImagePNGRepresentation(tempImage);
    UIImage *btnImage = [sender imageForState:UIControlStateNormal];
    NSData *data = UIImagePNGRepresentation(btnImage);
    if ([data isEqualToData:tempData]) {
        //        NSLog(@"qu xiao shou cang");
        [self colletedWorkersWithStatus:0];
        
    }else{
        [self colletedWorkersWithStatus:1];
        
    }
}

-(void)colletedWorkersWithStatus:(NSInteger)status
{
    //    NSLog(@"***%@",self.data.collect);
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSDictionary *paramDict = @{@"uid":uid,
                                @"worker_id":self.data.uid,
                                @"status":@(status)};
    [[NetworkSingletion sharedManager]colletedWorker:paramDict onSucceed:^(NSDictionary *dict) {
        NSLog(@"***%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            if (status == 0) {
                [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_unclick"] forState:UIControlStateNormal];
                [WFHudView showMsg:@"取消收藏成功" inView:self];
            }else{
                [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_click"] forState:UIControlStateNormal];
                [WFHudView showMsg:@"收藏成功" inView:self];
            }
        }else{
            //             [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_click"] forState:UIControlStateNormal];
            [WFHudView showMsg:dict[@"message"] inView:self];
        }
    } OnError:^(NSString *error) {
        [WFHudView showMsg:error inView:self];
    }];
}
-(void)showUnWorkerData:(NSString *)imageName name:(NSString *)name jobs:(NSArray *)jobs status:(NSInteger)status is_send:(BOOL)is_send
{
    //    NSLog(@"**zhjuangt*%@，%@",imageName,name);
    
    if (self.data.collect == 0) {
        [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_unclick"] forState:UIControlStateNormal];
    }else{
        [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_click"] forState:UIControlStateNormal];
    }
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,imageName]] placeholderImage:[UIImage imageNamed:@"temp"]];
    
    _name.text = name;
    [_name sizeToFit];
    
    
    CGFloat x = CGRectGetMaxX(_icon.frame) + 5;
    CGFloat y = CGRectGetMaxY(_name.frame) + 5;
    
    for (NSString *jobName in jobs) {
        
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
        [self addSubview:jobLbl];
        
        x = CGRectGetMaxX(jobLbl.frame) + 5;
        
    }
    if (self.type == 0) {
        
        self.hireBtn.hidden = NO;
        if (is_send) {
            [self.hireBtn setTitle:@"已发送" forState:UIControlStateNormal];
            self.hireBtn.userInteractionEnabled = NO;
        }else{
             [self.hireBtn setTitle:@"发送合同" forState:UIControlStateNormal];
            self.hireBtn.userInteractionEnabled = YES;
        }
        
    }else{
        self.hireBtn.hidden = YES;
    }
    
    
}

- (void)hireClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    if([self.seeDelegate respondsToSelector:@selector(applyWorker: data:)]) {
        
        [self.seeDelegate applyWorker:self data:self.data];
        
    }
    
    sender.userInteractionEnabled = YES;
    
}


@end
