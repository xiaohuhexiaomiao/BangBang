//
//  InputReasonViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/2/7.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "InputReasonViewController.h"
#import "CXZ.h"
@interface InputReasonViewController ()

@property(nonatomic ,strong)UILabel *titleLabel;

@property(nonatomic ,strong)UITextView *contentTextView;//内容

@property(nonatomic ,strong)UIButton *cancelButton;//quxiao

@property(nonatomic ,strong)UIButton *confirmButton;//确定

@end

@implementation InputReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    
    if (self.inputType == 1 || self.inputType == 2) {
        [self setupTitleWithString:@"输入拒绝原因" withColor:[UIColor whiteColor]];
    }else{
        [self setupTitleWithString:@"输入撤销原因" withColor:[UIColor whiteColor]];
    }
    [self config];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Private Method

-(void)clickConfirmButton:(UIButton*)button
{
    if (self.inputType == 1 || self.inputType == 2) {
        if ([NSString isBlankString:self.contentTextView.text]) {
            [WFHudView showMsg:@"请输入拒绝原因" inView:self.view];
            return;
        }
        NSDictionary *paramDict = @{@"contract_id":self.contract_id,@"state":@(2),@"apply_id":self.apply_id,@"type":@(self.inputType),@"reason":self.contentTextView.text};
        [[NetworkSingletion sharedManager]dealWithAcceptance:paramDict onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue]==0) {
                
                [MBProgressHUD showSuccess:@"处理成功" toView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [WFHudView showMsg:dict[@"message"] inView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }else{
        if ([NSString isBlankString:self.contentTextView.text]) {
            [WFHudView showMsg:@"请输入撤销原因" inView:self.view];
            return;
        }
        NSDictionary *paramDict = @{@"withdrawal_reason":self.contentTextView.text,
                                    @"approval_id":self.approval_id,
                                    @"company_id":self.company_id
                                    };
        [[NetworkSingletion sharedManager]cancelApproval:paramDict onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue] == 0) {
                [MBProgressHUD showSuccess:@"已撤回" toView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }
    
}



-(void)config{

//    _titleLabel = [CustomView customContentUILableWithContentView:self.view title:@"请输入撤销原因"];
////    _titleLabel.textAlignment = NSTextAlignmentCenter;
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(5);
//        make.left.mas_equalTo(8);
//        make.width.mas_equalTo(SCREEN_WIDTH-16);
//        make.height.mas_equalTo(30);
//    }];
    
    _contentTextView = [CustomView customUITextViewWithContetnView:self.view placeHolder:nil];
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(SCREEN_WIDTH-32);
        make.height.mas_equalTo(120);
    }];
    _contentTextView.backgroundColor = UIColorFromRGB(241, 241, 241);
    _contentTextView.layer.cornerRadius = 3;
    
    
    _confirmButton = [CustomView customButtonWithContentView:self.view image:nil title:@"确定"];
    [_confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentTextView.mas_bottom).mas_offset(40);
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(40);
    }];
    _confirmButton.layer.cornerRadius = 3;
    _confirmButton.backgroundColor = ORANGE_COLOR;
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}



@end
