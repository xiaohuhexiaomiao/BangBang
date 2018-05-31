//
//  SWContactController.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/13.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWContactController.h"
#import "CXZ.h"

#import "SWAddContactCmd.h"
#import "SWAddContactInfo.h"

#import "SWAuditContractCmd.h"
#import "SWAuditInfo.h"
#import "SignNameViewController.h"

@interface SWContactController ()

@property (nonatomic, retain) UIWebView *webView;

@end

@implementation SWContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupBackw];
    
    [self setupTitleWithString:@"合同" withColor:[UIColor whiteColor]];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = YES;
}
- (void)setUpView {
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame      = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    webView.scalesPageToFit = YES;
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.view addSubview:webView];
    _webView = webView;
    
    
//    NSLog(@"jehehh %ld",self.status);
    if(_status == 0) {
        
        
        
    }else if(_status == 1){
        
        CGFloat btnW = SCREEN_WIDTH / 3;
        CGFloat btnH = 49;
        CGFloat btnX = 0;
        CGFloat btnY = SCREEN_HEIGHT - btnH - 64;
        
        UIButton *acceptBtn = [[UIButton alloc] init];
        acceptBtn.frame     = CGRectMake(btnX, btnY, btnW, btnH);
        acceptBtn.backgroundColor = GREEN_COLOR;
        [acceptBtn setTitle:@"我接受" forState:UIControlStateNormal];
        [acceptBtn addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:acceptBtn];
        
        btnX = SCREEN_WIDTH / 3;
        
        UIButton *rewriteBtn = [[UIButton alloc] init];
        rewriteBtn.frame     = CGRectMake(btnX, btnY, btnW, btnH);
        rewriteBtn.backgroundColor = DARK_RED_COLOR;
        [rewriteBtn setTitle:@"退回修改" forState:UIControlStateNormal];
        [rewriteBtn addTarget:self action:@selector(rewiteClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rewriteBtn];
        
        btnX = SCREEN_WIDTH * 2 / 3;
        
        UIButton *rejectBtn = [[UIButton alloc] init];
        rejectBtn.frame     = CGRectMake(btnX, btnY, btnW, btnH);
        rejectBtn.backgroundColor = TOP_GREEN;
        [rejectBtn setTitle:@"拒绝用工" forState:UIControlStateNormal];
        [rejectBtn addTarget:self action:@selector(rejectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rejectBtn];
        
    }else if (_status == 2) { //工人同意，等待雇主付款
        
        CGFloat btnW = SCREEN_WIDTH;
        CGFloat btnH = 49;
        CGFloat btnX = 0;
        CGFloat btnY = SCREEN_HEIGHT - btnH - 64;
        
        UIButton *acceptBtn = [[UIButton alloc] init];
        acceptBtn.frame     = CGRectMake(btnX, btnY, btnW, btnH);
        acceptBtn.backgroundColor = GREEN_COLOR;
        [acceptBtn setTitle:@"已接受" forState:UIControlStateNormal];
//        [acceptBtn addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:acceptBtn];
        
    }else if(_status == 3) { //不同意
        
        CGFloat btnW = SCREEN_WIDTH;
        CGFloat btnH = 49;
        CGFloat btnX = 0;
        CGFloat btnY = SCREEN_HEIGHT - btnH - 64;
        
        UIButton *acceptBtn = [[UIButton alloc] init];
        acceptBtn.frame     = CGRectMake(btnX, btnY, btnW, btnH);
        acceptBtn.backgroundColor = GREEN_COLOR;
        [acceptBtn setTitle:@"需要雇主重新编写" forState:UIControlStateNormal];
        //        [acceptBtn addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:acceptBtn];
        
    }else if(_status == 4) {
        
        CGFloat btnW = SCREEN_WIDTH;
        CGFloat btnH = 49;
        CGFloat btnX = 0;
        CGFloat btnY = SCREEN_HEIGHT - btnH - 64;
        
        UIButton *acceptBtn = [[UIButton alloc] init];
        acceptBtn.frame     = CGRectMake(btnX, btnY, btnW, btnH);
        acceptBtn.backgroundColor = GREEN_COLOR;
        [acceptBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
        //        [acceptBtn addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:acceptBtn];
        
    }else if(_status == 5) {//雇主已付预付款，合同生效
        
        CGFloat btnW = SCREEN_WIDTH;
        CGFloat btnH = 49;
        CGFloat btnX = 0;
        CGFloat btnY = SCREEN_HEIGHT - btnH - 64;
        
        UIButton *acceptBtn = [[UIButton alloc] init];
        acceptBtn.frame     = CGRectMake(btnX, btnY, btnW, btnH);
        acceptBtn.backgroundColor = GREEN_COLOR;
        [acceptBtn setTitle:@"工程进行中" forState:UIControlStateNormal];
        //        [acceptBtn addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:acceptBtn];
        
    }else {
        
        CGFloat btnW = SCREEN_WIDTH;
        CGFloat btnH = 49;
        CGFloat btnX = 0;
        CGFloat btnY = SCREEN_HEIGHT - btnH - 64;
        
        UIButton *acceptBtn = [[UIButton alloc] init];
        acceptBtn.frame     = CGRectMake(btnX, btnY, btnW, btnH);
        acceptBtn.backgroundColor = GREEN_COLOR;
        [acceptBtn setTitle:@"工程已完结" forState:UIControlStateNormal];
        //        [acceptBtn addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:acceptBtn];
        
    }
    
}

- (void)rejectClick:(UIButton *)sender {
    
    SWAuditContractCmd *auditCmd = [[SWAuditContractCmd alloc] init];
    auditCmd.information_id = self.infomation_id;
    auditCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    auditCmd.status = 3;
    
    [[HttpNetwork getInstance] requestPOST:auditCmd success:^(BaseRespond *respond) {
        
        SWAuditInfo *auditInfo = [[SWAuditInfo alloc] initWithDictionary:respond.data];
        
        if(auditInfo.code == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_RECEIVE" object:nil];
            
        }else {
            
            [MBProgressHUD showError:auditInfo.message toView:self.view];
            
        }
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        [MBProgressHUD showError:@"加载数据失败" toView:self.view];
        
    }];

    
}

- (void)rewiteClick:(UIButton *)sender {

    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"确定要退回修改么？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SWAuditContractCmd *auditCmd = [[SWAuditContractCmd alloc] init];
        auditCmd.information_id = self.infomation_id;
        auditCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        auditCmd.status = 2;
        
        [[HttpNetwork getInstance] requestPOST:auditCmd success:^(BaseRespond *respond) {
            
            SWAuditInfo *auditInfo = [[SWAuditInfo alloc] initWithDictionary:respond.data];
            
            if(auditInfo.code == 0) {
                
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_RECEIVE" object:nil];
                
            }else {
                
                [MBProgressHUD showError:auditInfo.message toView:self.view];
                
            }
            
        } failed:^(BaseRespond *respond, NSString *error) {
            
            [MBProgressHUD showError:@"加载数据失败" toView:self.view];
            
        }];
        
    }]];
    [self presentViewController:alerVC animated:YES completion:nil];
     
    
    
}

/** 同意合同点击事件 */
- (void)agreeClick:(UIButton *)sender {

    
    
    sender.userInteractionEnabled = NO;
    
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"确定接受合同？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        SignNameViewController *signVC = [[SignNameViewController alloc]init];
//        signVC.isWorker = YES;
//        signVC.contranctID = self.contact_id;
//        [self.navigationController pushViewController:signVC animated:YES];
        
        
    }]];
    [self presentViewController:alerVC animated:YES completion:nil];
    
    
    
    
}

- (void)showWebView:(NSString *)infomation_id worker_id:(NSString *)worker_id {
    
    _infomation_id = infomation_id;
    _worker_id = worker_id;
    
    [self setUpView];
    NSURL *url = [NSURL URLWithString:self.urlString];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}


@end
