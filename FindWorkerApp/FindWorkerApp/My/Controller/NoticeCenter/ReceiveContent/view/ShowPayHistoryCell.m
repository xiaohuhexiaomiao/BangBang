//
//  ShowPayHistoryCell.m
//  FindWorkerApp
//
//  Created by cxz on 2018/5/10.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "ShowPayHistoryCell.h"
#import "CXZ.h"
#import "ShowPayHistoryModel.h"

@interface ShowPayHistoryCell()

@property(nonatomic ,strong)UILabel *moneyLabel;

@property(nonatomic ,strong)UILabel *addTimeLabel;

@property(nonatomic ,strong)UIButton *operationButton;//

@property(nonatomic ,strong)UIButton *rejectButton;//拒绝

@property(nonatomic ,strong)ShowPayHistoryModel *model;//拒绝

@end;

@implementation ShowPayHistoryCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [CustomView customTitleUILableWithContentView:self.contentView title:@"申请金额："];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(8);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
        
        _moneyLabel = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right);
            make.top.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(titleLabel.mas_height);
        }];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        //        UIView *line0 = [CustomView customLineView:self.contentView];
        //        [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.mas_equalTo(8);
        //            make.top.mas_equalTo(_moneyLabel.mas_bottom);
        //            make.width.mas_equalTo(SCREEN_WIDTH-16);
        //            make.height.mas_equalTo(1);
        //        }];
        
        UILabel *timeLabel = [CustomView customTitleUILableWithContentView:self.contentView title:@"申请时间："];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_moneyLabel.mas_bottom);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(titleLabel.mas_height);
        }];
        
        _addTimeLabel = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        [_addTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(timeLabel.mas_right);
            make.top.mas_equalTo(timeLabel.mas_top);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(titleLabel.mas_height);
        }];
        _addTimeLabel.textAlignment = NSTextAlignmentRight;
        //        UIView *line1 = [CustomView customLineView:self.contentView];
        //        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.mas_equalTo(8);
        //            make.top.mas_equalTo(_addTimeLabel.mas_bottom);
        //            make.width.mas_equalTo(SCREEN_WIDTH-16);
        //            make.height.mas_equalTo(1);
        //        }];
        
        _operationButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"已付款"];
        [_operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(_addTimeLabel.mas_bottom);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(26);
        }];
        _operationButton.layer.cornerRadius = 13.0;
        _operationButton.layer.borderColor = GREEN_COLOR.CGColor;
        _operationButton.layer.borderWidth = 0.8;
        [_operationButton setBackgroundColor:GREEN_COLOR];
        [_operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _operationButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_operationButton addTarget:self action:@selector(clickOperationButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _rejectButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"拒绝"];
        [_rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_operationButton.mas_left).mas_offset(-5);
            make.top.mas_equalTo(_operationButton.mas_top);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(26);
        }];
        _rejectButton.layer.cornerRadius = 13.0;
        _rejectButton.hidden = YES;
        _rejectButton.layer.borderColor = ORANGE_COLOR.CGColor;
        _rejectButton.layer.borderWidth = 0.8;
        [_rejectButton setBackgroundColor:ORANGE_COLOR];
        [_rejectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rejectButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_rejectButton addTarget:self action:@selector(clickRejectButton) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)setShowPayHistoryCellWithModel:(ShowPayHistoryModel*)payModel
{
    self.model = payModel;
    self.addTimeLabel.text = payModel.add_time;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",payModel.money];
    NSString *buttonStr;
    if (payModel.status == 0) {
        _operationButton.layer.borderColor = ORANGE_COLOR.CGColor;
        _operationButton.layer.borderWidth = 0.8;
        [_operationButton setBackgroundColor:ORANGE_COLOR];
        if (self.cellType == 0) {
            buttonStr = @"等待处理..";
            self.operationButton.userInteractionEnabled = NO;
            self.rejectButton.hidden = YES;
        }else{
            buttonStr = @"去付款";
            self.operationButton.userInteractionEnabled = YES;
            self.rejectButton.hidden = NO;
        }
    }else if (payModel.status == 1){
        self.rejectButton.hidden = YES;
        self.operationButton.userInteractionEnabled = NO;
        _operationButton.layer.borderColor = GREEN_COLOR.CGColor;
        _operationButton.layer.borderWidth = 0.8;
        [_operationButton setBackgroundColor:GREEN_COLOR];
        buttonStr = @"已付款";
    }else{
        self.rejectButton.hidden = YES;
        self.operationButton.userInteractionEnabled = NO;
        _operationButton.layer.borderColor = [UIColor grayColor].CGColor;
        _operationButton.layer.borderWidth = 0.8;
        [_operationButton setBackgroundColor:[UIColor grayColor]];
        buttonStr = @"已拒绝";
    }
}

-(void)clickOperationButton:(UIButton*)button//去付款
{
    if (self.cellType == 0) {
        
    }else{
        [WFHudView showMsg:@"此功能正在升级中.." inView:self.viewController.view];
    }
}

-(void)clickRejectButton
{
    [[NetworkSingletion sharedManager]rejectApplyPay:@{@"apply_pay_id":self.model.apply_pay_id} onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            self.rejectButton.hidden = YES;
            [self.operationButton setTitle:@"已拒绝" forState:UIControlStateNormal];
            self.operationButton.layer.borderColor = LINE_GRAY.CGColor;
            [self.operationButton setBackgroundColor:LINE_GRAY];
            self.operationButton.userInteractionEnabled = NO;
        }
        
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.viewController.view];
    }];

}

@end
