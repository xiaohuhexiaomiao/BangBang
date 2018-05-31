//
//  NotBeginCell.m
//  FindWorkerApp
//
//  Created by cxz on 2018/3/26.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "NotStarCell.h"
#import "CXZ.h"
#import "ContractStatusModel.h"
#import "SWAlipay.h"
#import "SignNameViewController.h"

@interface NotStarCell()

@property(nonatomic ,strong)UILabel *titleLabel;

@property(nonatomic ,strong)UILabel *addTimeLabel;

@property(nonatomic ,strong)UILabel *workerName;

@property(nonatomic ,strong)UIButton *backButton;

@property(nonatomic ,strong)UIButton *overButton;//查看申请验收记录

@property(nonatomic ,strong)UIButton *checkButton;//验收button

@property(nonatomic ,strong)ContractStatusModel *statusModel;

@end
@implementation NotStarCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _titleLabel = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        _titleLabel.numberOfLines = 2;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(25);
            
        }];
        _addTimeLabel = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        //        _addTimeLabel.font = [UIFont systemFontOfSize:12];
        //        _addTimeLabel.textAlignment = NSTextAlignmentRight;
        [_addTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(_titleLabel.mas_bottom);
            make.height.mas_equalTo(25);
        }];
        
        
        _workerName = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        [_workerName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(_addTimeLabel.mas_bottom);
            make.height.mas_equalTo(25);
        }];
        
        
        NSString *buttonStr =@"确认";
        CGSize buttonSize = [buttonStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        _checkButton = [CustomView customButtonWithContentView:self.contentView image:nil title:buttonStr];
        [_checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(_workerName.mas_bottom).mas_offset(2);
            make.width.mas_equalTo(buttonSize.width+20);
            make.height.mas_equalTo(26);
        }];
        [_checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _checkButton.layer.cornerRadius = 13.0;
        _checkButton.layer.borderColor = ORANGE_COLOR.CGColor;
        _checkButton.layer.borderWidth = 0.8;
        [_checkButton setBackgroundColor:ORANGE_COLOR];
        [_checkButton addTarget:self action:@selector(clickCheckButton) forControlEvents:UIControlEventTouchUpInside];
        _backButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"退回修改"];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_checkButton.mas_left).mas_offset(-5);
            make.top.mas_equalTo(_checkButton.mas_top);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(26);
        }];
        _backButton.layer.cornerRadius = 13.0;
        _backButton.layer.borderColor = ORANGE_COLOR.CGColor;
        _backButton.layer.borderWidth = 0.8;
        [_backButton setBackgroundColor:ORANGE_COLOR];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
        
        _overButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"拒绝"];
        [_overButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_backButton.mas_left).mas_offset(-5);
            make.top.mas_equalTo(_checkButton.mas_top);
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

-(void)setNotStarCellWithModel:(ContractStatusModel *)statusModle
{
    self.addTimeLabel.text = [NSString stringWithFormat:@"创建时间：%@",statusModle.add_time];
    self.titleLabel.text =[NSString stringWithFormat:@"合同名称：%@",statusModle.contract_name];
    self.workerName.text = [NSString stringWithFormat:@"甲方姓名：%@",statusModle.employ_name];
    self.statusModel = statusModle;
    NSString *buttonStr;
    if (statusModle.take_effect == 0) {
        [self.checkButton setTitle:buttonStr forState:UIControlStateNormal];
        buttonStr =@"确认";
        self.checkButton.userInteractionEnabled = YES;
        self.overButton.hidden = NO;
        self.backButton.hidden = NO;
    }else if (statusModle.take_effect == 1){
        buttonStr =@"等待甲方付预付款";
        self.checkButton.userInteractionEnabled = NO;
        self.overButton.hidden = YES;
        self.backButton.hidden = YES;
    }else if (statusModle.take_effect == 2){
        buttonStr =@"等待甲方修改合同";
        self.checkButton.userInteractionEnabled = NO;
        self.overButton.hidden = YES;
        self.backButton.hidden = YES;
    }else if (statusModle.take_effect == 3){
        buttonStr =@"已拒绝";
        self.checkButton.userInteractionEnabled = NO;
        self.overButton.hidden = YES;
        self.backButton.hidden = YES;
    }else if (statusModle.take_effect == 4){
        buttonStr =@"合同签订成功";
        self.checkButton.userInteractionEnabled = NO;
        self.overButton.hidden = YES;
        self.backButton.hidden = YES;
    }
    CGSize buttonSize = [buttonStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    [self.checkButton setTitle:buttonStr forState:UIControlStateNormal];
    [self.checkButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonSize.width+20);
    }];
    
}

#pragma mark IBACTION
-(void)clickCheckButton
{
    if (self.statusModel.take_effect== 0) {//确认
        SignNameViewController *signVC = [[SignNameViewController alloc]init];
        signVC.signType = 1;
        signVC.contranctID = self.statusModel.contract_id;
        signVC.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:signVC animated:YES];
        self.viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
}
//拒绝
-(void)clickOverButton
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:@(3) forKey:@"status"];
    [paramDict setObject:@(self.statusModel.contract_id) forKey:@"contract_id"];
    [[NetworkSingletion sharedManager]sendContractNew:paramDict onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            [MBProgressHUD showSuccess:@"处理成功" toView:self.viewController.view];
            NSString *buttonStr =@"已拒绝";
            self.checkButton.userInteractionEnabled = NO;
            self.overButton.hidden = YES;
            self.backButton.hidden = YES;

            CGSize buttonSize = [buttonStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
            [self.checkButton setTitle:buttonStr forState:UIControlStateNormal];
            [self.checkButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(buttonSize.width);
            }];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self.viewController.view];
        }
    } OnError:^(NSString *error) {
        [WFHudView showMsg:error inView:self.viewController.view];
    }];
    
}


-(void)clickBackButton
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:@(2) forKey:@"status"];
    [paramDict setObject:@(self.statusModel.contract_id) forKey:@"contract_id"];
    [[NetworkSingletion sharedManager]sendContractNew:paramDict onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            [MBProgressHUD showSuccess:@"已退回" toView:self.viewController.view];
            NSString *buttonStr =@"等待甲方修改合同";
            self.checkButton.userInteractionEnabled = NO;
            self.overButton.hidden = YES;
            self.backButton.hidden = YES;
            CGSize buttonSize = [buttonStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
            [self.checkButton setTitle:buttonStr forState:UIControlStateNormal];
            [self.checkButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(buttonSize.width);
            }];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self.viewController.view];
        }
    } OnError:^(NSString *error) {
        [WFHudView showMsg:error inView:self.viewController.view];
    }];
}






@end
