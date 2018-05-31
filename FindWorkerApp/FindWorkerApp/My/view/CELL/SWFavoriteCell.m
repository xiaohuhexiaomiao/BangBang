//
//  SWFavoriteCell.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWFavoriteCell.h"

#import "CXZ.h"

#import "SWCollectCmd.h"
#import "SWCollectInfo.h"

#import "SWMyFavoriteController.h"

@interface SWFavoriteCell ()

@property (nonatomic, retain) UIImageView *icon;

@property (nonatomic, retain) UILabel *name; //姓名

@property (nonatomic, retain) UIButton *cancelBtn;

@property (nonatomic, retain) NSMutableArray *viewArr;

@end

@implementation SWFavoriteCell

+ (instancetype)initWithTableViewCell:(UITableView *)tableView {
    
    static NSString *indentify = @"CELL";
    
    SWFavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if(!cell) {
        
        cell = [[SWFavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
        
    }
    
    return cell;
    
}

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
    _icon.frame = CGRectMake(5, 12.5, 30, 30);
    _icon.layer.masksToBounds = YES;
    _icon.layer.cornerRadius = _icon.frame.size.height / 2;
    [self.contentView addSubview:_icon];
    
    _name = [[UILabel alloc] init];
    _name.frame = CGRectMake(CGRectGetMaxX(_icon.frame) + 5, _icon.frame.origin.y, 10, 10);
    _name.font = [UIFont systemFontOfSize:12];
    _name.textColor = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00];
    [self.contentView addSubview:_name];
    
    _cancelBtn = [[UIButton alloc] init];
    [_cancelBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorWithRed:0.87 green:0.36 blue:0.00 alpha:1.00] forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_cancelBtn sizeToFit];
    [_cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - _cancelBtn.bounds.size.width, (55 - _cancelBtn.bounds.size.height) / 2, _cancelBtn.bounds.size.width, _cancelBtn.bounds.size.height);
    [self.contentView addSubview:_cancelBtn];
    
    
}

- (void)cancelClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    SWCollectCmd *collectCmd = [[SWCollectCmd alloc] init];
    collectCmd.worker_id = _favoriteWorker.uid;
    collectCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    collectCmd.status = 0;
    
    [[HttpNetwork getInstance] requestPOST:collectCmd success:^(BaseRespond *respond) {
        
        SWMyFavoriteController *favoriteController = (SWMyFavoriteController *)self.viewController;
        
        UITableView *tableView = favoriteController.tableView;
        [tableView.mj_header beginRefreshing];
        sender.userInteractionEnabled = YES;
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        sender.userInteractionEnabled = YES;
        
    }];
    
}


//展示数据
//image:头像
//name:姓名
//distance:距离
//jobs:工种
- (void)showData:(NSString *)imageName name:(NSString *)name jobs:(NSArray *)Jobarr {

    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,imageName]] placeholderImage:[UIImage imageNamed:@"temp"]];
    
    _name.text = name;
    [_name sizeToFit];
    
    
    [self removeAllView:self.viewArr];
    
    CGFloat x = CGRectGetMaxX(_icon.frame) + 5;
    CGFloat y = CGRectGetMaxY(_name.frame) + 5;
    
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
        
        x = CGRectGetMaxX(jobLbl.frame) + 5;
        
    }

}

- (void)removeAllView:(NSMutableArray *)arr {
    
    for (UILabel *view in arr) {
        
        [view removeFromSuperview];
        
    }
    
    [arr removeAllObjects];
    
}

@end
