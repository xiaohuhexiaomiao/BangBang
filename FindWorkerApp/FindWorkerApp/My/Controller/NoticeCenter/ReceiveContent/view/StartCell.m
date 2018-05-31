//
//  OnGoingContractCell.m
//  FindWorkerApp
//
//  Created by cxz on 2018/3/23.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "StartCell.h"
#import "CXZ.h"
#import "ContractStatusModel.h"
#import "ReceiveAcceptDetailController.h"
#import "ReceiveAcceptHistoryController.h"
#import "ApplyPayHistoryViewController.h"

@interface StartCell()

@property(nonatomic ,strong)UILabel *titleLabel;

@property(nonatomic ,strong)UILabel *addTimeLabel;

@property(nonatomic ,strong)UILabel *workerName;

@property(nonatomic ,strong)UIButton *historyButton;//查看申请验收记录

@property(nonatomic ,strong)UIButton *payHistoryButton;//查看申请付款记录

@property(nonatomic ,strong)UIButton *checkButton;//验收button

@property(nonatomic ,strong)UIButton *overButton;//完工button

@property(nonatomic ,strong)UIButton *applyPayButton;//申请付款button

@property(nonatomic ,strong)ContractStatusModel *statusModel;


@end

@implementation StartCell

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
        //        _addTimeLabel.font = [UIFont systemFontOfSize:12];
        //        _addTimeLabel.textAlignment = NSTextAlignmentRight;
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
            make.height.mas_equalTo(25);
        }];
//        [_historyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _historyButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_historyButton addTarget:self action:@selector(clickHistoryButton) forControlEvents:UIControlEventTouchUpInside];
        
        _payHistoryButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"查看申请付款记录"];
        _payHistoryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_payHistoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_historyButton.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo(25);
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
        
        NSString *buttonStr =@"申请验收";
        CGSize buttonSize = [buttonStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
         _checkButton = [CustomView customButtonWithContentView:self.contentView image:nil title:buttonStr];
        [_checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(line.mas_bottom).mas_offset(8);
            make.width.mas_equalTo(buttonSize.width+20);
            make.height.mas_equalTo(26);
        }];
        [_checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [_checkButton setBackgroundColor:ORANGE_COLOR];
        _checkButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _checkButton.layer.cornerRadius = 13.0;
        _checkButton.layer.borderColor = ORANGE_COLOR.CGColor;
        _checkButton.layer.borderWidth = 0.8;
        [_checkButton addTarget:self action:@selector(clickCheckButton) forControlEvents:UIControlEventTouchUpInside];
        
        _applyPayButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"申请付款"];
        [_applyPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_checkButton.mas_left).mas_offset(-5);
            make.top.mas_equalTo(_checkButton.mas_top);
            make.width.mas_equalTo(buttonSize.width+20);
            make.height.mas_equalTo(26);
        }];
        [_applyPayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applyPayButton setBackgroundColor:ORANGE_COLOR];
        _applyPayButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _applyPayButton.layer.cornerRadius = 13.0;
        _applyPayButton.layer.borderColor = ORANGE_COLOR.CGColor;
        _applyPayButton.layer.borderWidth = 0.8;
        [_applyPayButton addTarget:self action:@selector(clickApplyPayButton) forControlEvents:UIControlEventTouchUpInside];
        
        _overButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"完工"];
        [_overButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(_checkButton.mas_bottom).mas_offset(3);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(26);
        }];
        _overButton.layer.cornerRadius = 13.0;
        _overButton.layer.borderColor = ORANGE_COLOR.CGColor;
        _overButton.layer.borderWidth = 0.8;
        [_overButton setBackgroundColor:ORANGE_COLOR];
        [_overButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _overButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_overButton addTarget:self action:@selector(clickOverButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    return self;
}

#pragma mark 

-(void)setOnGoingContractCellWithModel:(ContractStatusModel *)goingModel
{
    self.addTimeLabel.text =[NSString stringWithFormat:@"创建时间：%@",goingModel.add_time] ;
    self.titleLabel.text =[NSString stringWithFormat:@"合同名称：%@",goingModel.contract_name];
    self.workerName.text = [NSString stringWithFormat:@"甲方姓名：%@",goingModel.employ_name];
    self.statusModel = goingModel;
    self.overButton.userInteractionEnabled = YES;
    self.overButton.layer.borderColor = ORANGE_COLOR.CGColor;
    [self.overButton setBackgroundColor:ORANGE_COLOR];
    self.checkButton.hidden = NO;
    if (goingModel.take_effect == 5) {
        self.checkButton.hidden = YES;
        [self.overButton setTitle:@"已完工" forState:UIControlStateNormal];
        self.overButton.layer.borderColor = LINE_GRAY.CGColor;
        [self.overButton setBackgroundColor:LINE_GRAY];
        self.overButton.userInteractionEnabled = NO;
    }
    if (goingModel.worker_apply == 2) {
        self.checkButton.hidden = YES;
        [self.overButton setTitle:@"处理中" forState:UIControlStateNormal];
        self.overButton.userInteractionEnabled = NO;
    }
    if (goingModel.apply_status == 1) {
         NSString *buttonStr;
        if (goingModel.apply_is_ok == 0) {
            [self.checkButton setTitle:buttonStr forState:UIControlStateNormal];
            buttonStr =@"等待甲方处理";
            self.checkButton.userInteractionEnabled = YES;
            self.overButton.userInteractionEnabled = NO;
            
        }else if (goingModel.apply_is_ok == 1){
            buttonStr =@"申请验收";
            self.checkButton.userInteractionEnabled = YES;
            self.overButton.userInteractionEnabled = NO;
            
        }else if (goingModel.apply_is_ok == 2){
            buttonStr =@"验收被拒，点击修改";
            self.checkButton.userInteractionEnabled = YES;
            self.overButton.userInteractionEnabled = NO;
            
        }else if (goingModel.apply_is_ok == 3){
            buttonStr =@"等待甲方处理";
            self.checkButton.userInteractionEnabled = NO;
            self.overButton.userInteractionEnabled = NO;
            
        }else if (goingModel.apply_is_ok == 4){
            buttonStr =@"验收被拒，点击修改";
            self.checkButton.userInteractionEnabled = YES;
            self.overButton.userInteractionEnabled = NO;
            
        }else if (goingModel.apply_is_ok == 5){
            buttonStr =@"验收成功";
            self.checkButton.userInteractionEnabled = NO;
            self.overButton.userInteractionEnabled = YES;
            
        }
        CGSize buttonSize = [buttonStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        [self.checkButton setTitle:buttonStr forState:UIControlStateNormal];
        [self.checkButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(buttonSize.width+20);
        }];
    }
    NSString *applyButtonStr ;
    if ([NSString isBlankString:self.statusModel.apply_pay]) {
        applyButtonStr =@"申请付款";
        self.applyPayButton.userInteractionEnabled = YES;
    }else{
        applyButtonStr =@"申请付款中..";
        
        self.applyPayButton.userInteractionEnabled = NO;
    }
    CGSize applyButtonSize = [applyButtonStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    [self.applyPayButton setTitle:applyButtonStr forState:UIControlStateNormal];
    [self.applyPayButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(applyButtonSize.width+20);
    }];
    
}

#pragma mark IBACTION

-(void)clickPayHistoryButton
{
    ApplyPayHistoryViewController *historyVC = [[ApplyPayHistoryViewController alloc]init];
    historyVC.contract_id = self.statusModel.contract_id;
    historyVC.type = 0;
    historyVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:historyVC animated:YES];
    self.viewController.hidesBottomBarWhenPushed = YES;
}

-(void)clickApplyPayButton//申请付款
{
    [WFHudView showMsg:@"此功能正在升级中..." inView:self.viewController.view];
}

-(void)clickHistoryButton
{
    ReceiveAcceptHistoryController *historyVC = [[ReceiveAcceptHistoryController alloc]init];
    historyVC.contract_id = self.statusModel.contract_id;
    historyVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:historyVC animated:YES];
    self.viewController.hidesBottomBarWhenPushed = YES;
}

-(void)clickCheckButton
{
    ReceiveAcceptDetailController *detailVC = [[ReceiveAcceptDetailController alloc]init];
    
    if (self.statusModel.apply_status == 0) {
        detailVC.operation_type = 0;
    }else{
        if (self.statusModel.apply_is_ok == 1) {
            detailVC.operation_type = 0;
        }else{
             detailVC.operation_type = 1;
        }
    }
    detailVC.apply_id = self.statusModel.apply_id;
    detailVC.contract_id = self.statusModel.contract_id;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
    self.viewController.hidesBottomBarWhenPushed = YES;
}


-(void)clickOverButton
{
    if (self.statusModel.apply_status == 1) {
        [MBProgressHUD showError:@"正在申请验收，不能进行此操作！" toView:self.viewController.view];
        return;
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否确认完工？" message:@"申请完工，经甲方同意后，则此合同结束，将不能进行任何操作" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NetworkSingletion sharedManager]applyEndContract:@{@"contract_id":@(self.statusModel.contract_id)} onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue]==0) {
                self.checkButton.hidden = YES;
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
}

@end
