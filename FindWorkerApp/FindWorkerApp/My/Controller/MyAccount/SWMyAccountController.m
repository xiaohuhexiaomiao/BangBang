//
//  SWMyAccountController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMyAccountController.h"

#import "SWDepositHistoryController.h"
#import "TransactionLogViewController.h"

#import "CXZ.h"

#import "SWMoneyCmd.h"
#import "SWMoneyInfo.h"

#import "SWWithdraw.h"
#import "SWWithDrawInfo.h"

@interface SWMyAccountController ()

@property (nonatomic, retain) UILabel *moneyLbl;

@property (nonatomic, strong) UILabel *tipsLbl;

@end

@implementation SWMyAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithView];
    
    [self setupBackw];
    
    [self setupTitleWithString:@"我的账户" withColor:[UIColor whiteColor]];
    
    [self setupNextWithString:@"记录" withColor:[UIColor colorWithRed:0.57 green:0.78 blue:1.00 alpha:1.00]];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    [self loadData];
}

- (void)loadData {
    
//    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
//    NSDictionary *pramDict = @{@"uid":uid};
//    [[NetworkSingletion sharedManager]getAmountBalance:pramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"***%@",dict);
//        
//    } OnError:^(NSString *error) {
//        
//    }];
    
    SWMoneyCmd *moneyInfo = [[SWMoneyCmd alloc] init];
    moneyInfo.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    [[HttpNetwork getInstance] requestPOST:moneyInfo success:^(BaseRespond *respond) {
        
        SWMoneyInfo *moneyInfo = [[SWMoneyInfo alloc] initWithDictionary:respond.data];
        
        if(moneyInfo.code == 0) {
        
            CGFloat total = [moneyInfo.data[@"withdraw"] floatValue];
            CGFloat no_withdraw = [moneyInfo.data[@"no_withdraw"] floatValue];
            CGSize YuanSize = [[NSString stringWithFormat:@"¥ %.2f",total] sizeWithFont:[UIFont systemFontOfSize:25] width:SCREEN_WIDTH];
            _moneyLbl.frame    = CGRectMake(SCREEN_WIDTH / 2 - YuanSize.width / 2, _moneyLbl.frame.origin.y, YuanSize.width, YuanSize.height);
            _moneyLbl.text = [NSString stringWithFormat:@"¥ %.2f",total];
            self.tipsLbl.text = [NSString stringWithFormat:@"提示：未完结的工程 预付款是不能提现的哦，工程完结后才可以提现，所以您现在可提现金额为：¥%.2f",(total-no_withdraw)];
            
        }else {
        
            NSString *num = @"¥ 0.00";
            
            CGSize YuanSize = [num sizeWithFont:[UIFont systemFontOfSize:25] width:SCREEN_WIDTH];
            _moneyLbl.frame    = CGRectMake(SCREEN_WIDTH / 2 - YuanSize.width / 2, _moneyLbl.frame.origin.y, YuanSize.width, YuanSize.height);
            _moneyLbl.text = num;
            
        }
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        NSString *num = @"¥ 0.00";
        
        CGSize YuanSize = [num sizeWithFont:[UIFont systemFontOfSize:25] width:SCREEN_WIDTH];
        _moneyLbl.frame    = CGRectMake(SCREEN_WIDTH / 2 - YuanSize.width / 2, _moneyLbl.frame.origin.y, YuanSize.width, YuanSize.height);
        _moneyLbl.text = num;
        
    }];
    
}

//初始化界面
- (void)initWithView {
    
    UIImage *coin = [UIImage imageNamed:@"coin"];
    
    UIImageView *coinImg = [[UIImageView alloc] initWithImage:coin];
    coinImg.frame        = CGRectMake(SCREEN_WIDTH / 2 - coin.size.width / 2, 100, coin.size.width, coin.size.height);
    [self.view addSubview:coinImg];
    
    NSString *balanceStr = @"账户余额";
    CGSize balanceSize = [balanceStr sizeWithFont:[UIFont systemFontOfSize:25] width:SCREEN_WIDTH];
    
    UILabel *balanceLbl = [[UILabel alloc] init];
    balanceLbl.frame    = CGRectMake(SCREEN_WIDTH / 2 - balanceSize.width / 2, CGRectGetMaxY(coinImg.frame) + 10, balanceSize.width, balanceSize.height);
    balanceLbl.text     = balanceStr;
    balanceLbl.textColor = [UIColor blackColor];
    balanceLbl.font     = [UIFont systemFontOfSize:25];
    [self.view addSubview:balanceLbl];
    
    NSString *YuanStr = @"¥ 0.00";
    CGSize YuanSize = [YuanStr sizeWithFont:[UIFont systemFontOfSize:25] width:SCREEN_WIDTH];
    
    UILabel *YuanLbl = [[UILabel alloc] init];
    YuanLbl.frame    = CGRectMake(SCREEN_WIDTH / 2 - YuanSize.width / 2, CGRectGetMaxY(balanceLbl.frame) + 10, YuanSize.width, YuanSize.height);
    YuanLbl.text     = YuanStr;
    YuanLbl.textColor = [UIColor blackColor];
    YuanLbl.font     = [UIFont systemFontOfSize:25];
    [self.view addSubview:YuanLbl];
    _moneyLbl = YuanLbl;
    
    _tipsLbl = [[UILabel alloc]initWithFrame:CGRectMake(16, YuanLbl.bottom+20, SCREEN_WIDTH-16, 30)];
    _tipsLbl.textColor = [UIColor grayColor];
    _tipsLbl.numberOfLines = 2;
    _tipsLbl.font = [UIFont systemFontOfSize:12];
    _tipsLbl.text = @"提示：请确保您的个人资料填写的支付宝账号正确";
    [self.view addSubview:_tipsLbl];
    
    UIButton *applyBtn = [[UIButton alloc] init];
    applyBtn.frame     = CGRectMake(0, SCREEN_HEIGHT - 49 - 64, SCREEN_WIDTH, 49);
    [applyBtn setTitle:@"申请提现" forState:UIControlStateNormal];
    applyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    applyBtn.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
    [applyBtn addTarget:self action:@selector(applyPayClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyBtn];
    
}

- (void)applyPayClick:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"输入您要提现的金额" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"需要提现的金额";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        UITextField *textField = [alert.textFields lastObject];
        
        SWWithdraw *withDraw = [[SWWithdraw alloc] init];
        withDraw.user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        withDraw.money = textField.text;
        
        [[HttpNetwork getInstance] requestPOST:withDraw success:^(BaseRespond *respond) {
            
            SWWithDrawInfo *withDrawInfo = [[SWWithDrawInfo alloc] initWithDictionary:respond.data];
            
            if(withDrawInfo.code == 0) {
                
                [self loadData];
                [MBProgressHUD showError:withDrawInfo.message toView:self.view];
                
            }else {
            
                 [MBProgressHUD showError:withDrawInfo.message toView:self.view];
                
            }
            
        } failed:^(BaseRespond *respond, NSString *error) {
            
             [MBProgressHUD showError:error toView:self.view];
            
        }];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)onNext {
    
    TransactionLogViewController *dispositController = [[TransactionLogViewController alloc] init];
    dispositController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dispositController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}


@end
