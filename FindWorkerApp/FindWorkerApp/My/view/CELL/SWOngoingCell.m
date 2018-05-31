//
//  SWOngoingCell.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWOngoingCell.h"

#import "CXZ.h"

#import "SWComfirmCompletionCmd.h"
#import "SWComfirmCompletionInfo.h"

#define padding 10

@interface SWOngoingCell ()

@property (nonatomic, retain) UILabel *timeLbl;

@property (nonatomic, retain) UILabel *contentLbl;

@property (nonatomic, retain) UIButton *rejectBtn;

@end

@implementation SWOngoingCell

+ (instancetype)initWithTableViewCell:(UITableView *)tableView {
    
    static NSString *indentify = @"ONGOING_CELL";
    
    SWOngoingCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if(!cell) {
        
        cell = [[SWOngoingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
        
    }
    
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.frame = CGRectMake(padding, padding, padding, padding);
        _timeLbl.font = [UIFont systemFontOfSize:12];
        _timeLbl.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.16 alpha:1.00];
        [self.contentView addSubview:_timeLbl];
        
        _contentLbl = [[UILabel alloc] init];
        _contentLbl.frame = CGRectMake(padding, CGRectGetMaxY(_timeLbl.frame) + padding, 10, 10);
        _contentLbl.font = [UIFont systemFontOfSize:12];
        _contentLbl.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.16 alpha:1.00];
        [self.contentView addSubview:_contentLbl];
        
        _rejectBtn = [[UIButton alloc] init];
        [_rejectBtn setTitle:@"确认完工" forState:UIControlStateNormal];
        [_rejectBtn setTitleColor:LIGHT_RED_COLOR forState:UIControlStateNormal];
        _rejectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_rejectBtn sizeToFit];
        [_rejectBtn addTarget:self action:@selector(finishJob:) forControlEvents:UIControlEventTouchUpInside];
        _rejectBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - _rejectBtn.bounds.size.width, (49.0f - _rejectBtn.bounds.size.height) / 2, _rejectBtn.bounds.size.width, _rejectBtn.bounds.size.height);
        [self.contentView addSubview:_rejectBtn];
        
    }
    
    return self;
    
}

- (void)finishJob:(UIButton *)sender {
    
    SWComfirmCompletionCmd *completionCmd = [[SWComfirmCompletionCmd alloc] init];
    completionCmd.information_id = _taskData.information_id;
    completionCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    [[HttpNetwork getInstance] requestPOST:completionCmd success:^(BaseRespond *respond) {
        
        SWComfirmCompletionInfo *completionInfo = [[SWComfirmCompletionInfo alloc] initWithDictionary:respond.data];
        
        if(completionInfo.code == 0) {
//            [MBProgressHUD showError:@"确认成功" toView:self.viewController.view];
            [_rejectBtn setTitle:@"已确认，等待雇主确认" forState:UIControlStateNormal];
             _rejectBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - _rejectBtn.bounds.size.width, (49.0f - _rejectBtn.bounds.size.height) / 2, _rejectBtn.bounds.size.width, _rejectBtn.bounds.size.height);
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_ONGOINGCELL" object:nil];
            
        }else {
        
            [MBProgressHUD showError:@"确认失败" toView:self.viewController.view];
            
        }
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        [MBProgressHUD showError:@"确认失败" toView:self.viewController.view];
        
    }];
    
}

/**
 显示数据
 
 @param date 发布时间
 @param content 标题
 @param status 待完成：等待确认完成状态位2 已确认完成状态位3
 */
- (void)showData:(NSString *)date content:(NSString *)content status:(NSInteger)status {
    
    _timeLbl.text = date;
    [_timeLbl sizeToFit];
    
    _contentLbl.text = content;
    [_contentLbl sizeToFit];
    
    if(status == 2) {
    
        
        
    }else {
        
        _rejectBtn.userInteractionEnabled = NO;
        [_rejectBtn setTitle:@"已确认，等待雇主确认" forState:UIControlStateNormal];
        [_rejectBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        [_rejectBtn sizeToFit];
        
        _rejectBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - _rejectBtn.bounds.size.width, (49.0f - _rejectBtn.bounds.size.height) / 2, _rejectBtn.bounds.size.width, _rejectBtn.bounds.size.height);
        
    }
    
}

@end
