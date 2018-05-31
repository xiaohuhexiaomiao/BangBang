//
//  SWWaitingCell.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWWaitingCell.h"

#import "CXZ.h"

#import "SWPaySuccessCmd.h"
#import "SWPaySuccessInfo.h"

#import "SWAcceptCmd.h"
#import "SWAcceptInfo.h"

#define padding 10

@interface SWWaitingCell ()

@property (nonatomic, retain) UILabel *timeLbl;

@property (nonatomic, retain) UILabel *contentLbl;

@property (nonatomic, retain) UIButton *acceptBtn;

@property (nonatomic, retain) UIButton *rejectBtn;

@end

@implementation SWWaitingCell

+ (instancetype)initWithTableViewCell:(UITableView *)tableView {
    
    static NSString *indentify = @"Waiting_CELL";
    
    SWWaitingCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if(!cell) {
        
        cell = [[SWWaitingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
        
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
        
    }
    
    return self;
    
}

/**
 待开始的cell
 
 @param date 发布时间
 @param content 标题
 @param status 待开始：等待确认付款状态位0 已确认付款状态位1
 
 */
- (void)showWaitingData:(NSString *)date content:(NSString *)content status:(NSInteger)status data:(SWMyTaskData *)data {

    _data = data;
    
    [_rejectBtn removeFromSuperview];
    
    _timeLbl.text = date;
    [_timeLbl sizeToFit];
    
    _contentLbl.text = content;
    [_contentLbl sizeToFit];
    
    _rejectBtn = [[UIButton alloc] init];
    if(status == 0) {
        _rejectBtn.userInteractionEnabled = NO;
        [_rejectBtn setTitleColor:[UIColor colorWithRed:0.86 green:0.28 blue:0.00 alpha:1.00] forState:UIControlStateNormal];
        [_rejectBtn setTitle:@"等待雇主付款成功" forState:UIControlStateNormal];
        
    }else {
        
        _rejectBtn.userInteractionEnabled = NO;
        [_rejectBtn setTitleColor:[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00] forState:UIControlStateNormal];
        [_rejectBtn setTitle:@"付款成功,等待雇主开始施工" forState:UIControlStateNormal];
        
    }
    
    _rejectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_rejectBtn sizeToFit];
//    [_rejectBtn addTarget:self action:@selector(paySuccess:) forControlEvents:UIControlEventTouchUpInside];
    _rejectBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - _rejectBtn.bounds.size.width, (49.0f - _rejectBtn.bounds.size.height) / 2, _rejectBtn.bounds.size.width, _rejectBtn.bounds.size.height);
    [self.contentView addSubview:_rejectBtn];
    
}

- (void)paySuccess:(UIButton *)sender {
    
    SWPaySuccessCmd *paySuccess = [[SWPaySuccessCmd alloc] init];
    paySuccess.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    paySuccess.information_id = _data.information_id;
    
    [[HttpNetwork getInstance] requestPOST:paySuccess success:^(BaseRespond *respond) {
        
        SWPaySuccessInfo *paySuccessInfo = [[SWPaySuccessInfo alloc] initWithDictionary:respond.data];
        
        if(paySuccessInfo.code == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_WAITINGCELL" object:nil];
            
        }else {
            
            [MBProgressHUD showError:paySuccessInfo.message toView:self.viewController.view];
            
        }
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
    }];
    
}

- (void)showData:(NSString *)date content:(NSString *)content data:(SWMyTaskData *)data{
    
    _data = data;
    
    _timeLbl.text = date;
    [_timeLbl sizeToFit];
    
    _contentLbl.text = content;
    [_contentLbl sizeToFit];
    
    [_rejectBtn removeFromSuperview];
    [_acceptBtn removeFromSuperview];
    
    _rejectBtn = [[UIButton alloc] init];
    [_rejectBtn setTitle:@"拒绝雇佣" forState:UIControlStateNormal];
    [_rejectBtn setTitleColor:[UIColor colorWithRed:0.86 green:0.28 blue:0.00 alpha:1.00] forState:UIControlStateNormal];
    _rejectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    if(data.status == 1) {
        
        _rejectBtn.userInteractionEnabled = NO;
        [_rejectBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        [_rejectBtn setTitle:@"已接受雇佣，请等待雇主发送合同" forState:UIControlStateNormal];
        
    }else if(data.status == 2) {
        
        _rejectBtn.userInteractionEnabled = NO;
        [_rejectBtn setTitleColor:[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00] forState:UIControlStateNormal];
        [_rejectBtn setTitle:@"已拒绝雇佣" forState:UIControlStateNormal];
        
    }
    
    [_rejectBtn sizeToFit];
    _rejectBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - _rejectBtn.bounds.size.width, (49.0f - _rejectBtn.bounds.size.height) / 2, _rejectBtn.bounds.size.width, _rejectBtn.bounds.size.height);
    [_rejectBtn addTarget:self action:@selector(rejectClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_rejectBtn];
    
    _acceptBtn = [[UIButton alloc] init];
    [_acceptBtn setTitle:@"接受雇佣" forState:UIControlStateNormal];
    [_acceptBtn setTitleColor:[UIColor colorWithRed:0.47 green:0.75 blue:0.76 alpha:1.00] forState:UIControlStateNormal];
    _acceptBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_acceptBtn sizeToFit];
    _acceptBtn.frame = CGRectMake(CGRectGetMinX(_rejectBtn.frame) - 10 - _acceptBtn.bounds.size.width, (49.0f - _acceptBtn.bounds.size.height) / 2, _acceptBtn.bounds.size.width, _acceptBtn.bounds.size.height);
    [_acceptBtn addTarget:self action:@selector(acceptClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_acceptBtn];
    
    if(data.status == 0) {
        
        _acceptBtn.hidden = NO;
        
    }else {
        
        _acceptBtn.hidden = YES;
        
    }
    
    
}

- (void)rejectClick:(UIButton *)sender {
    
    SWAcceptCmd *acceptCmd = [[SWAcceptCmd alloc] init];
    acceptCmd.eid = _data.eid;
    acceptCmd.invite_status = @"2";
    
    [[HttpNetwork getInstance] requestPOST:acceptCmd success:^(BaseRespond *respond) {
        
        SWAcceptInfo *acceptInfo = [[SWAcceptInfo alloc] initWithDictionary:respond.data];
        
        if(acceptInfo.code == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_REPEAT" object:nil];
            
        }
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        
        
    }];
    
}

- (void)acceptClick:(UIButton *)sender {

    SWAcceptCmd *acceptCmd = [[SWAcceptCmd alloc] init];
    acceptCmd.eid = _data.eid;
    acceptCmd.invite_status = @"1";
    
    [[HttpNetwork getInstance] requestPOST:acceptCmd success:^(BaseRespond *respond) {
        
        SWAcceptInfo *acceptInfo = [[SWAcceptInfo alloc] initWithDictionary:respond.data];
        
        if(acceptInfo.code == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_REPEAT" object:nil];
            
        }
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        
        
    }];
    
}



@end
