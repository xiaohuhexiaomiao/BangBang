//
//  CreatCompanyViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/13.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CreatCompanyViewController.h"

#import "CXZ.h"

#import "AddPositionViewController.h"

@interface CreatCompanyViewController ()

@property(nonatomic ,strong)UITextField *company_name_textfield;

@property(nonatomic ,strong)UITextField *company_phone_textfield;

@property(nonatomic ,strong)UITextField *company_address_textfield;

@property(nonatomic ,strong)UIButton *nextButton;

@end

@implementation CreatCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    if (self.is_creat_subCompany) {
        [self setupTitleWithString:@"创建群组/分公司" withColor:[UIColor whiteColor]];
    }else{
        [self setupTitleWithString:@"创建公司" withColor:[UIColor whiteColor]];
    }
    
    [self config];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark 

-(void)config
{
    NSString *title = @"公司名称：";
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *titleLabel = [CustomView customTitleUILableWithContentView:self.view title:title];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(titleSize.width+0.5);
        make.height.mas_equalTo(35);
    }];
    
    _company_name_textfield = [CustomView customUITextFieldWithContetnView:self.view placeHolder:@"请输入公司名称"];
    [_company_name_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(titleLabel.mas_height);
        make.top.mas_equalTo(titleLabel.mas_top);
    }];
    
    UIView *line1 = [CustomView customLineView:self.view];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_company_name_textfield.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *phoneLabel = [CustomView customTitleUILableWithContentView:self.view title:@"公司电话："];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom);
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(titleLabel.mas_width);
        make.height.mas_equalTo(titleLabel.mas_height);
    }];
    
    _company_phone_textfield = [CustomView customUITextFieldWithContetnView:self.view placeHolder:@"请输入公司电话号码"];
    [_company_phone_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLabel.mas_right);
        make.top.mas_equalTo(phoneLabel.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(phoneLabel.mas_height);
    }];
    
    UIView *line2 = [CustomView customLineView:self.view];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line1.mas_left);
        make.top.mas_equalTo(_company_phone_textfield.mas_bottom);
        make.width.mas_equalTo(line1.mas_width);
        make.height.mas_equalTo(line1.mas_height);
    }];
    
    UILabel *addressLabel = [CustomView customTitleUILableWithContentView:self.view title:@"公司地址："];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line2.mas_left);
        make.top.mas_equalTo(line2.mas_bottom);
        make.width.mas_equalTo(titleLabel.mas_width);
        make.height.mas_equalTo(titleLabel.mas_height);
    }];
   
    _company_address_textfield = [CustomView customUITextFieldWithContetnView:self.view placeHolder:@"请输入公司地址"];
    [_company_address_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressLabel.mas_right);
        make.top.mas_equalTo(addressLabel.mas_top);
        make.right.mas_equalTo(_company_name_textfield.mas_right);
        make.height.mas_equalTo(addressLabel.mas_height);
    }];
    
    UIView *line3 = [CustomView customLineView:self.view];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line2.mas_left);
        make.top.mas_equalTo(_company_address_textfield.mas_bottom);
        make.width.mas_equalTo(line2.mas_width);
        make.height.mas_equalTo(line2.mas_height);
    }];
    
    
    _nextButton = [CustomView customButtonWithContentView:self.view image:nil title:@"下一步"];
    [_nextButton setTitleColor:TOP_GREEN forState:UIControlStateNormal];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line2.mas_left);
        make.top.mas_equalTo(line3.mas_bottom).mas_offset(30);
        make.width.mas_equalTo(line3.mas_width);
        make.height.mas_equalTo(30);
    }];
    _nextButton.layer.cornerRadius = 5;
    [_nextButton addTarget:self action:@selector(clickNextButon) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clickNextButon
{
    if ([NSString isBlankString:self.company_name_textfield.text]) {
        [WFHudView showMsg:@"请输入公司名称" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.company_address_textfield.text]) {
        [WFHudView showMsg:@"请输入公司详细地址" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.company_phone_textfield.text]) {
        [WFHudView showMsg:@"请输入公司电话号码" inView:self.view];
        return;
    }
    
    if (self.is_creat_subCompany) {
        NSDictionary *paramDict = @{@"company_id":self.compony_id,@"name":self.company_name_textfield.text,@"company_address":self.company_address_textfield.text,@"company_tel":self.company_phone_textfield.text};
        [[NetworkSingletion sharedManager]creatSubCompany:paramDict onSucceed:^(NSDictionary *dict) {
                                                NSLog(@"**creat**%@",dict);
            if ([dict[@"code"] integerValue] == 0) {
                self.company_name_textfield.text = @"";
                self.company_phone_textfield.text = @"";
                self.company_address_textfield.text = @"";
                [MBProgressHUD showSuccess:@"创建成功" toView:self.view];
                AddPositionViewController *addvc = [[AddPositionViewController alloc]init];
                addvc.compony_id = [dict[@"data"] objectForKey:@"company_id"];

                addvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:addvc animated:YES];
                self.hidesBottomBarWhenPushed = YES;
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
        }];
    }else{
        NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
        NSDictionary *paramDict = @{@"uid":uid,@"name":self.company_name_textfield.text,@"company_address":self.company_address_textfield.text,@"company_tel":self.company_phone_textfield.text};
        [[NetworkSingletion sharedManager]createCompany:paramDict onSucceed:^(NSDictionary *dict) {
            //                                    NSLog(@"**creat**%@",dict);
            if ([dict[@"code"] integerValue] == 0) {
                AddPositionViewController *addvc = [[AddPositionViewController alloc]init];
                addvc.compony_id = [dict[@"data"] objectForKey:@"company_id"];
                
                addvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:addvc animated:YES];
                self.hidesBottomBarWhenPushed = YES;
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
        }];
    }
    
    
}


@end
