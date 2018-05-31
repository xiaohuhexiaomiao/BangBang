//
//  OnGoingContractCell.m
//  FindWorkerApp
//
//  Created by cxz on 2018/3/23.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "OnGoingContractCell.h"
#import "CXZ.h"
#import "ContractStatusModel.h"
#import "AcceptDetailController.h"
#import "AcceptHistoryViewController.h"
#import "ApplyPayHistoryViewController.h"

@interface OnGoingContractCell()

@property(nonatomic ,strong)UILabel *titleLabel;

@property(nonatomic ,strong)UILabel *addTimeLabel;

@property(nonatomic ,strong)UILabel *workerName;

@property(nonatomic ,strong)UIButton *historyButton;//查看申请验收记录

@property(nonatomic ,strong)UIButton *payHistoryButton;//查看申请付款记录

@property(nonatomic ,strong)UIButton *applyPayButton;//申请付款button

@property(nonatomic ,strong)UIButton *overButton;//完工button

@property(nonatomic ,strong)ContractStatusModel *statusModel;


@end

@implementation OnGoingContractCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
                
        _titleLabel = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        _titleLabel.numberOfLines = 2;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        
        _addTimeLabel = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        [_addTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_titleLabel.mas_bottom);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(25);
        }];
        
        _workerName = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        [_workerName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(_addTimeLabel.mas_bottom);
            make.height.mas_equalTo(25);
        }];
        
        _historyButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"查看历史验收记录"];
        _historyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_historyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_workerName.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo(26);
        }];
//        [_historyButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _historyButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_historyButton addTarget:self action:@selector(clickHistoryButton) forControlEvents:UIControlEventTouchUpInside];
        
        _payHistoryButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"查看申请付款记录"];
        _payHistoryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_payHistoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_historyButton.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo(26);
        }];
        //        [_payHistoryButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _payHistoryButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_payHistoryButton addTarget:self action:@selector(clickPayHistoryButton) forControlEvents:UIControlEventTouchUpInside];
        

        
        UIView *line = [CustomView customLineView:self.contentView];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_payHistoryButton.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo(1);
        }];
        line.backgroundColor = UIColorFromRGB(230, 230, 230);
        
        NSString *buttonStr =@"乙方申请验收， 请确认";
        CGSize buttonSize = [buttonStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        _overButton = [CustomView customButtonWithContentView:self.contentView image:nil title:buttonStr];
        [_overButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(line.mas_bottom).mas_offset(7);
            make.width.mas_equalTo(buttonSize.width+20);
            make.height.mas_equalTo(26);
        }];
        _overButton.layer.cornerRadius = 13.0;
        _overButton.layer.borderColor = ORANGE_COLOR.CGColor;
        _overButton.layer.borderWidth = 0.8;
        [_overButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _overButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_overButton addTarget:self action:@selector(clickOverButton) forControlEvents:UIControlEventTouchUpInside];

        _applyPayButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"去付款"];
        [_applyPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_overButton.mas_left).mas_offset(-5);
            make.top.mas_equalTo(_overButton.mas_top);
            make.width.mas_equalTo(buttonSize.width+20);
            make.height.mas_equalTo(26);
        }];
        _applyPayButton.hidden = YES;
        [_applyPayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applyPayButton setBackgroundColor:ORANGE_COLOR];
        _applyPayButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _applyPayButton.layer.cornerRadius = 13.0;
        _applyPayButton.layer.borderColor = ORANGE_COLOR.CGColor;
        _applyPayButton.layer.borderWidth = 0.8;
        [_applyPayButton addTarget:self action:@selector(clickApplyPayButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark

-(void)setOnGoingContractCellWithModel:(ContractStatusModel *)goingModel
{
    self.addTimeLabel.text = [NSString stringWithFormat:@"创建时间：%@",goingModel.add_time];
    self.titleLabel.text =[NSString stringWithFormat:@"合同名称：%@",goingModel.contract_name];
    self.workerName.text = [NSString stringWithFormat:@"乙方姓名：%@",goingModel.worker_name];
    self.statusModel = goingModel;
    self.overButton.userInteractionEnabled = YES;
    self.overButton.layer.borderColor = ORANGE_COLOR.CGColor;
    [self.overButton setBackgroundColor:ORANGE_COLOR];
    NSString *buttonStr;
    if (goingModel.worker_apply == 0) {
        if (goingModel.apply_status == 0) {
            buttonStr =@"工程进行中...";
            self.overButton.userInteractionEnabled = NO;
        }else{
            if (goingModel.apply_is_ok == 0) {
                buttonStr =@"乙方申请验收，点击处理";
                self.overButton.userInteractionEnabled = YES;
            }else if (goingModel.apply_is_ok == 1){
                buttonStr =@"工程进行中...";
                self.overButton.userInteractionEnabled = NO;
            }else if (goingModel.apply_is_ok == 2){
                buttonStr =@"等待乙方修改验收单";
                self.overButton.userInteractionEnabled = YES;
            }else if (goingModel.apply_is_ok == 3){
                buttonStr =@"继续处理";
                self.overButton.userInteractionEnabled = YES;
            }else if (goingModel.apply_is_ok == 4){
                buttonStr =@"等待乙方修改验收单";
                self.overButton.userInteractionEnabled = YES;
            }
        }
        
    }else if (goingModel.worker_apply == 1){
        buttonStr =@"乙方申请完工，点击处理";
        self.overButton.userInteractionEnabled = YES;
    }else{
        if (goingModel.take_effect == 5) {
            buttonStr =@"已完工";
            self.overButton.userInteractionEnabled = NO;
            self.overButton.layer.borderColor = LINE_GRAY.CGColor;
            [self.overButton setBackgroundColor:LINE_GRAY];
        }
    }
    CGSize buttonSize = [buttonStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    [self.overButton setTitle:buttonStr forState:UIControlStateNormal];
    [self.overButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonSize.width+20);
    }];
    
    NSString *applyButtonStr ;
    if ([NSString isBlankString:self.statusModel.apply_pay]) {
        self.applyPayButton.hidden = YES;
    }else{
        self.applyPayButton.hidden = NO;
        self.applyPayButton.userInteractionEnabled = NO;
    }

}

#pragma mark IBACTION


-(void)clickPayHistoryButton
{
    ApplyPayHistoryViewController *historyVC = [[ApplyPayHistoryViewController alloc]init];
    historyVC.contract_id = self.statusModel.contract_id;
    historyVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:historyVC animated:YES];
    self.viewController.hidesBottomBarWhenPushed = YES;
}

-(void)clickApplyPayButton
{
    ApplyPayHistoryViewController *historyVC = [[ApplyPayHistoryViewController alloc]init];
    historyVC.contract_id = self.statusModel.contract_id;
    historyVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:historyVC animated:YES];
    self.viewController.hidesBottomBarWhenPushed = YES;

}

-(void)clickHistoryButton
{
    AcceptHistoryViewController *historyVC = [[AcceptHistoryViewController alloc]init];
    historyVC.contract_id = self.statusModel.contract_id;
    historyVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:historyVC animated:YES];
    self.viewController.hidesBottomBarWhenPushed = YES;
    
}


-(void)clickOverButton
{
    if (self.statusModel.worker_apply == 0) {
        if (self.statusModel.apply_status == 1) {
            if (self.statusModel.apply_is_ok == 1){//@"去付款"
                AcceptDetailController *historyVC = [[AcceptDetailController alloc]init];
                historyVC.contract_id = self.statusModel.contract_id;
                historyVC.is_to_pay = YES;
                historyVC.hidesBottomBarWhenPushed = YES;
                [self.viewController.navigationController pushViewController:historyVC animated:YES];
                self.viewController.hidesBottomBarWhenPushed = YES;
            }else {//调整验收申请界面
                AcceptDetailController *historyVC = [[AcceptDetailController alloc]init];
                historyVC.contract_id = self.statusModel.contract_id;
                historyVC.hidesBottomBarWhenPushed = YES;
                [self.viewController.navigationController pushViewController:historyVC animated:YES];
                self.viewController.hidesBottomBarWhenPushed = YES;
            }
        }
        
    }else if (self.statusModel.worker_apply == 1){//乙方申请完工，点击处理
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确认完工？" message:@"甲方同意后，则此合同结束，将不能进行任何操作" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *paramDict = @{@"contract_id":@(self.statusModel.contract_id),@"acceptance_id":self.statusModel.acceptance_id,@"state":@(2)};
            [[NetworkSingletion sharedManager]dealWithEndContract:paramDict onSucceed:^(NSDictionary *dict) {
                if ([dict[@"code"] integerValue]==0) {
                   
                    [self.overButton setTitle:@"已拒绝完工" forState:UIControlStateNormal];
                    self.overButton.layer.borderColor = LINE_GRAY.CGColor;
                    [self.overButton setBackgroundColor:LINE_GRAY];
                    self.overButton.userInteractionEnabled = NO;
                }
                
            } OnError:^(NSString *error) {
                [MBProgressHUD showError:error toView:self.viewController.view];
            }];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *paramDict = @{@"contract_id":@(self.statusModel.contract_id),@"acceptance_id":self.statusModel.acceptance_id,@"state":@(1)};
            [[NetworkSingletion sharedManager]dealWithEndContract:paramDict onSucceed:^(NSDictionary *dict) {
                if ([dict[@"code"] integerValue]==0) {
                    
                    [self.overButton setTitle:@"已完工" forState:UIControlStateNormal];
                    self.overButton.layer.borderColor = LINE_GRAY.CGColor;
                    [self.overButton setBackgroundColor:LINE_GRAY];
                    self.overButton.userInteractionEnabled = NO;
                }
                
            } OnError:^(NSString *error) {
                [MBProgressHUD showError:error toView:self.viewController.view];
            }];
        }]];
        [self.viewController presentViewController:alertVC animated:YES completion:nil];
        
    }else{//无操作
        
    }
}

@end
