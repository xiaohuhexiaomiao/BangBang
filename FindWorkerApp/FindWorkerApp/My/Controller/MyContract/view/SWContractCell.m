//
//  SWContractCell.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/19.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWContractCell.h"

#import "CXZ.h"

#import "SWAuditContractCmd.h"
#import "SWAuditInfo.h"

#define padding 10

@interface SWContractCell ()

@property (nonatomic, retain) UILabel *timeLbl;

@property (nonatomic, retain) UILabel *contentLbl;

@property (nonatomic, retain) UILabel *statusLbl;

@property (nonatomic, retain) UIButton *acceptBtn;

@property (nonatomic, retain) UIButton *rejectBtn;

@property (nonatomic, strong) UILabel *ownerNameLabel;

@end

@implementation SWContractCell

+ (instancetype)initWithTableViewCell:(UITableView *)tableView {
    
    static NSString *indentify = @"CELL";
        SWContractCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if(!cell) {
        
        cell = [[SWContractCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
        
    }
    
    return cell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.font = [UIFont systemFontOfSize:12];
        _timeLbl.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.16 alpha:1.00];
        [self.contentView addSubview:_timeLbl];
        
        _contentLbl = [[UILabel alloc] init];
        _contentLbl.font = [UIFont systemFontOfSize:12];
        _contentLbl.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.16 alpha:1.00];
        [self.contentView addSubview:_contentLbl];
        
        _statusLbl = [[UILabel alloc] init];
        _statusLbl.font = [UIFont systemFontOfSize:12];
        _statusLbl.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.16 alpha:1.00];
        [self.contentView addSubview:_statusLbl];
        
        _ownerNameLabel = [[UILabel alloc]init];
        _ownerNameLabel.font = [UIFont systemFontOfSize:12];
        _ownerNameLabel.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.16 alpha:1.00];
        [self.contentView addSubview:_ownerNameLabel];
        
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    return self;
    
}

- (void)showSendData:(SWListContractData *)data {
    
    _contractData = data;
    
    _timeLbl.text = data.add_time;
    [_timeLbl sizeToFit];
    _timeLbl.frame = CGRectMake(padding, 5, _timeLbl.bounds.size.width, _timeLbl.bounds.size.height);
    
    _contentLbl.text = data.title;
    [_contentLbl sizeToFit];
    _contentLbl.frame = CGRectMake(padding, _timeLbl.bottom+3, _contentLbl.bounds.size.width, _contentLbl.bounds.size.height);
    
    _ownerNameLabel.text = [NSString stringWithFormat:@"乙方：%@",data.worker_name];
    [_ownerNameLabel sizeToFit];
    _ownerNameLabel.frame = CGRectMake(padding, _contentLbl.bottom+3, _ownerNameLabel.bounds.size.width, _ownerNameLabel.bounds.size.height);
    
    if(data.status == 0) { //等待工人审核合同
    
        NSString *statusStr = @"等待工人审核";
        
        CGSize statusSize = [statusStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        
        _statusLbl.frame = CGRectMake(SCREEN_WIDTH - padding - statusSize.width, _contentLbl.bottom, statusSize.width, statusSize.height);
        _statusLbl.text = statusStr;
        
    }else if(data.status == 1) { //同意
        
        NSString *statusStr = @"工人同意,点击付预付款";
        
        CGSize statusSize = [statusStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        
        _statusLbl.frame = CGRectMake(SCREEN_WIDTH - padding - statusSize.width, _contentLbl.bottom, statusSize.width, statusSize.height);
        _statusLbl.text = statusStr;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBtn:)];
        _statusLbl.userInteractionEnabled = YES;
        [_statusLbl addGestureRecognizer:tap];
        
    }else if(data.status == 2) { //雇主重新编写合同
        
        NSString *statusStr = @"重新编写合同";
        
        CGSize statusSize = [statusStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        
        _statusLbl.frame = CGRectMake(SCREEN_WIDTH - padding - statusSize.width, _contentLbl.bottom, statusSize.width, statusSize.height);
        _statusLbl.text = statusStr;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickNoAgree:)];
        _statusLbl.userInteractionEnabled = YES;
        [_statusLbl addGestureRecognizer:tap];
        
    }else if(data.status == 4) { //雇主重新编写合同
        
        NSString *statusStr = @"预付款已付";
        
        CGSize statusSize = [statusStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        
        _statusLbl.frame = CGRectMake(SCREEN_WIDTH - padding - statusSize.width, _contentLbl.bottom, statusSize.width, statusSize.height);
        _statusLbl.text = statusStr;
        
    }else {
        
        NSString *statusStr = @"工人不同意";
        
        CGSize statusSize = [statusStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        
        _statusLbl.frame = CGRectMake(SCREEN_WIDTH - padding - statusSize.width, _contentLbl.bottom, statusSize.width, statusSize.height);
        _statusLbl.text = statusStr;
        
    }
    
}
-(void)clickNoAgree:(UITapGestureRecognizer*)tap
{
    if([self.contractDelegate respondsToSelector:@selector(noAgree:)]){
        
        [self.contractDelegate noAgree:self];
        
    }
}

/**
 显示数据
 @param data data
 */
- (void)showReceiveData:(SWListContractData *)data {
    
    _contractData = data;
    
    _timeLbl.text = data.add_time;
    [_timeLbl sizeToFit];
    _timeLbl.frame = CGRectMake(padding, 5, _timeLbl.bounds.size.width, _timeLbl.bounds.size.height);
    
    _contentLbl.text = data.title;
    [_contentLbl sizeToFit];
    _contentLbl.frame = CGRectMake(padding, _timeLbl.bottom+3, _contentLbl.bounds.size.width, _contentLbl.bounds.size.height);
    
    _ownerNameLabel.text = [NSString stringWithFormat:@"甲方：%@",data.employ_name];
    [_ownerNameLabel sizeToFit];
    _ownerNameLabel.frame = CGRectMake(padding, _contentLbl.bottom+3, _ownerNameLabel.bounds.size.width, _ownerNameLabel.bounds.size.height);
    
    [_rejectBtn removeFromSuperview];
    [_acceptBtn removeFromSuperview];
    
    _rejectBtn = [[UIButton alloc] init];
    [_rejectBtn setTitle:@"拒绝合同" forState:UIControlStateNormal];
    [_rejectBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    
    if(data.status == 1) {
        
        [_rejectBtn setTitle:@"已同意，等待雇主支付预付款" forState:UIControlStateNormal];
        [_rejectBtn setTitleColor:DARK_RED_COLOR forState:UIControlStateNormal];
        _rejectBtn.userInteractionEnabled = NO;
        
    }else if(data.status == 2) {
        
        [_rejectBtn setTitle:@"等待雇主重新编写合同" forState:UIControlStateNormal];
        [_rejectBtn setTitleColor:DARK_RED_COLOR forState:UIControlStateNormal];
        _rejectBtn.userInteractionEnabled = NO;
        
        
        
    }else if(data.status == 3) {
        
        [_rejectBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
        [_rejectBtn setTitleColor:DARK_RED_COLOR forState:UIControlStateNormal];
        _rejectBtn.userInteractionEnabled = NO;
    }else if(data.status == 4) {
        
        [_rejectBtn setTitle:@"已付预付款" forState:UIControlStateNormal];
        [_rejectBtn setTitleColor:DARK_RED_COLOR forState:UIControlStateNormal];
        _rejectBtn.userInteractionEnabled = NO;
    }
    else if(data.status == 5) {
        
        [_rejectBtn setTitle:@"工程已完结" forState:UIControlStateNormal];
        [_rejectBtn setTitleColor:DARK_RED_COLOR forState:UIControlStateNormal];
        _rejectBtn.userInteractionEnabled = NO;
    }
    
    
    _rejectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_rejectBtn addTarget:self action:@selector(rejectClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rejectBtn sizeToFit];
    
    CGFloat rejectW = _rejectBtn.bounds.size.width;
    CGFloat rejectH = _rejectBtn.bounds.size.height;
    CGFloat rejectX = SCREEN_WIDTH - padding - rejectW; 
    CGFloat rejectY = (49.0f - rejectH) / 2;
    _rejectBtn.frame = CGRectMake(rejectX, _contentLbl.bottom, rejectW, rejectH);
    [self.contentView addSubview:_rejectBtn];
    
    _acceptBtn = [[UIButton alloc] init];
    [_acceptBtn setTitle:@"接受合同" forState:UIControlStateNormal];
    [_acceptBtn setTitleColor:DARK_RED_COLOR forState:UIControlStateNormal];
    [_acceptBtn addTarget:self action:@selector(acceptClick:) forControlEvents:UIControlEventTouchUpInside];
    _acceptBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_acceptBtn sizeToFit];
    _acceptBtn.hidden = YES;
    
    if(data.status == 0) {
        
        _acceptBtn.hidden = NO;
        
    }
    
    CGFloat acceptW = _acceptBtn.bounds.size.width;
    CGFloat acceptH = _acceptBtn.bounds.size.height;
    CGFloat acceptX = SCREEN_WIDTH - padding - acceptW - (SCREEN_WIDTH - rejectX);
    CGFloat acceptY = (49.0f - rejectH) / 2;
    _acceptBtn.frame = CGRectMake(acceptX, _rejectBtn.top, acceptW, acceptH);
    [self.contentView addSubview:_acceptBtn];
    
}

- (void)acceptClick:(UIButton *)sender {
    
    if([self.contractDelegate respondsToSelector:@selector(agree:)]){
        
        [self.contractDelegate agree:self];
        
    }
        
}

- (void)rejectClick:(UIButton *)sender {

    if([self.contractDelegate respondsToSelector:@selector(rejectData:)]){
    
        [self.contractDelegate rejectData:self];
        
    }
    
}

-(void)clickBtn:(UITapGestureRecognizer*)tap
{
    if([self.contractDelegate respondsToSelector:@selector(applyAdvancePayment:)]){
        
        [self.contractDelegate applyAdvancePayment:self];
        
    }
}


@end
