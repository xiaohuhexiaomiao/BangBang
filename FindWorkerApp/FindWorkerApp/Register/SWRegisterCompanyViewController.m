//
//  SWRegisterCompanyViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/30.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SWRegisterCompanyViewController.h"
#import "CXZ.h"
#import "SWSendCmd.h"
#import "SWCompleteInfoController.h"

#define padding 10

@interface SWRegisterCompanyViewController ()

@property (nonatomic, strong) UILabel *codeLabel;

@property (nonatomic, retain) NSTimer *timer;

@property (nonatomic, retain) UIButton *sendBtn;

@property (nonatomic, assign) NSInteger count; //计数值

@property (nonatomic, retain) NSString *code;//验证码

@end

@implementation SWRegisterCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
     _count = 60;
    [self setupBackWithString:@"取消" withColor:[UIColor colorWithRed:0.52 green:0.71 blue:0.92 alpha:1.00]];
    [self setupTitleWithString:@"公司注册" withColor:[UIColor whiteColor]];
    [self initWithView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark  Private Method
//初始化界面
- (void)initWithView {
    
    CGFloat phoneviewX = 40;
    CGFloat phoneviewY = 40;
    CGFloat phoneviewW = SCREEN_WIDTH - 2 * phoneviewX;
    CGFloat phoneviewH = 30;
    
    UIView *accountView = [self setUpInputView:@"login_phone" placeHolder:@"请输入手机号码" btnTitle:@"" frame:CGRectMake(phoneviewX, phoneviewY, phoneviewW, phoneviewH) tag:1];
    [self.view addSubview:accountView];
    
    UIView *nameView = [self setUpInputView:@"findworker_select" placeHolder:@"请输入公司名称" btnTitle:@"" frame:CGRectMake(phoneviewX, accountView.bottom+10, phoneviewW, phoneviewH) tag:2];
    [self.view addSubview:nameView];
    
    UIView *addressView = [self setUpInputView:@"neibWorker" placeHolder:@"请输入公司地址" btnTitle:@"" frame:CGRectMake(phoneviewX, nameView.bottom+10, phoneviewW, phoneviewH) tag:3];
    [self.view addSubview:addressView];
    
    UIView *phoneView = [self setUpInputView:@"phone" placeHolder:@"请输入公司电话" btnTitle:@"" frame:CGRectMake(phoneviewX, addressView.bottom+10, phoneviewW, phoneviewH) tag:4];
    [self.view addSubview:phoneView];
    
    UIView *codeView = [self setUpInputView:@"checkNum" placeHolder:@"请输入验证码" btnTitle:@"发送验证码" frame:CGRectMake(phoneviewX, phoneView.bottom+10, phoneviewW, phoneviewH) tag:5];
    [self.view addSubview:codeView];
    
    UIView *passwordsView = [self setUpInputView:@"password" placeHolder:@"请输入密码" btnTitle:@"" frame:CGRectMake(phoneviewX, codeView.bottom+10, phoneviewW, phoneviewH) tag:6];
    [self.view addSubview:passwordsView];
    
    UIView *confirmView = [self setUpInputView:@"password_comfirm" placeHolder:@"请再输入密码" btnTitle:@"" frame:CGRectMake(phoneviewX, passwordsView.bottom+10, phoneviewW, phoneviewH) tag:7];
    [self.view addSubview:confirmView];
    
    
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.frame     = CGRectMake(phoneviewX, confirmView.bottom+10, phoneviewW, phoneviewH);
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = [UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1.00];
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginBtn addTarget:self action:@selector(successReg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
}


- (UIView *)setUpInputView:(NSString *)imageName placeHolder:(NSString *)placeHolder btnTitle:(NSString *)btnTitle frame:(CGRect)frame tag:(NSInteger)tag {
    
    UIView *inputView = [[UIView alloc] init];
    inputView.frame   = frame;
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.layer.cornerRadius = 5;
    inputView.layer.masksToBounds = YES;
    inputView.layer.borderWidth = 0.5;
    inputView.layer.borderColor = [UIColor colorWithRed:0.52 green:0.71 blue:0.92 alpha:1.00].CGColor;
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    CGFloat iconW = 14;
    CGFloat iconH = 15;
    CGFloat iconX = padding;
    CGFloat iconY = (inputView.frame.size.height - iconH) / 2;
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.frame        = CGRectMake(iconX, iconY, iconW, iconH);
    icon.image        = image;
    [inputView addSubview:icon];
    
    CGFloat textX = CGRectGetMaxX(icon.frame) + padding;
    CGFloat textY = iconY;
    CGFloat textW = inputView.frame.size.width - textX - padding;
    CGFloat textH = inputView.frame.size.height - 2 * textY;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.frame        = CGRectMake(textX, textY, textW, textH);
    textField.placeholder  = placeHolder;
    textField.tag = tag;
    textField.secureTextEntry = YES;
    textField.font         = [UIFont systemFontOfSize:13];
    [inputView addSubview:textField];
    
    if(!IS_EMPTY(btnTitle)) {
        
        UIButton *send = [[UIButton alloc] init];
        [send setTitle:btnTitle forState:UIControlStateNormal];
        [send setTitleColor:[UIColor colorWithRed:0.53 green:0.77 blue:0.78 alpha:1.00] forState:UIControlStateNormal];
        send.titleLabel.font = [UIFont systemFontOfSize:12];
        [send sizeToFit];
        
        CGFloat sendW = send.bounds.size.width;
        CGFloat sendH = send.bounds.size.height;
        CGFloat sendX = inputView.frame.size.width - padding - sendW;
        CGFloat sendY = (inputView.frame.size.height - sendH) / 2;
        send.frame = CGRectMake(sendX, sendY, sendW, sendH);
        [inputView addSubview:send];
        [send addTarget:self action:@selector(sendNote:) forControlEvents:UIControlEventTouchUpInside];
        textW = CGRectGetMinX(send.frame) - CGRectGetMaxX(icon.frame) - padding;
        _sendBtn = send;
        
        _codeLabel = [[UILabel alloc]initWithFrame:_sendBtn.frame];
        _codeLabel.textAlignment = NSTextAlignmentCenter;
        _codeLabel.font = [UIFont systemFontOfSize:12];
        _codeLabel.backgroundColor = [UIColor whiteColor];
        _codeLabel.text = @"还剩60秒";
        _codeLabel.hidden = YES;
        _codeLabel.textColor = [UIColor colorWithRed:0.53 green:0.77 blue:0.78 alpha:1.00];
        [inputView addSubview:_codeLabel];
    }
    
    return inputView;
}

//发送验证码
- (void)sendNote:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    [self startTimer];
    UITextField *textfiel = (UITextField*)[self.view viewWithTag:1];
    NSString *phoneStr = textfiel.text;
    SWSendCmd *cmd = [[SWSendCmd alloc] init];
    if (!IS_EMPTY(phoneStr)) {
        cmd.sender = [phoneStr integerValue];
    }
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameter = @{@"sender":phoneStr};
    
    [sessionManager POST:[NSString stringWithFormat:@"%@/index.php/Mobile/User/send_validate_code",API_HOST] parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *msg = dict[@"message"];
//        NSLog(@"**code**%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            self.code = [dict[@"data"] objectForKey:@"code"];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD showError:[error description] toView:self.view];
        sender.userInteractionEnabled = YES;
    }];
}

-(void)successReg:(UIButton*)button
{
     NSString *phone =((UITextField*)[self.view viewWithTag:1]).text;
    NSString *companyName = ((UITextField*)[self.view viewWithTag:2]).text;
   NSString *companyAddress = ((UITextField*)[self.view viewWithTag:3]).text;
    NSString *companyTelephone = ((UITextField*)[self.view viewWithTag:4]).text;
    NSString *codeStr = ((UITextField*)[self.view viewWithTag:5]).text;
    NSString *passwords = ((UITextField*)[self.view viewWithTag:6]).text;
    NSString *confirm = ((UITextField*)[self.view viewWithTag:7]).text;
    if ([NSString isBlankString:phone]) {
        [WFHudView showMsg:@"验证码输入错误" inView:self.view];
        return;
    }
    if ([NSString isBlankString:companyName]) {
        [WFHudView showMsg:@"请输入公司名称" inView:self.view];
        return;
    }
    if ([NSString isBlankString:companyAddress]) {
        [WFHudView showMsg:@"请输入公司地址" inView:self.view];
        return;
    }
    if ([NSString isBlankString:companyTelephone]) {
        [WFHudView showMsg:@"请输入公司电话" inView:self.view];
        return;
    }
    if ([NSString isBlankString:codeStr]) {
        [WFHudView showMsg:@"请输入验证码" inView:self.view];
        return;
    }
    if ([NSString isBlankString:passwords]) {
        [WFHudView showMsg:@"请输入密码" inView:self.view];
        return;
    }
    if (![codeStr isEqualToString:self.code]) {
        [WFHudView showMsg:@"验证码输入错误" inView:self.view];
        return;
    }
    if (![passwords isEqualToString:confirm]) {
        [WFHudView showMsg:@"两次密码输入不一致" inView:self.view];
        return;
    }
    button.userInteractionEnabled = NO;
    NSDictionary *paramDict = @{@"password":passwords,@"check_password":confirm,@"phone":phone,@"type":@"3",@"company_name":companyName,@"company_address":companyAddress,@"company_tel":companyTelephone};
    [[NetworkSingletion sharedManager]registerCompany:paramDict onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]== 0) {
            SWCompleteInfoController *infoVC = [SWCompleteInfoController new];
            [self.navigationController pushViewController:infoVC animated:YES];
        }else{
            button.userInteractionEnabled = YES;
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
        
    } OnError:^(NSString *error) {
        button.userInteractionEnabled = YES;
        [MBProgressHUD showError:error toView:self.view];
    }];
    
}

- (void)startTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTimer) userInfo:nil repeats:YES];
    
}

- (void)countTimer {
    self.sendBtn.hidden = YES;
    if(self.count != 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.inputView bringSubviewToFront:self.codeLabel];
            self.codeLabel.hidden = NO;
            self.count--;
            self.codeLabel.text = [NSString stringWithFormat:@"还剩%li秒",(long)self.count];
            
        });
        
        
    }else{
        [_sendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        self.sendBtn.userInteractionEnabled = YES;
        self.sendBtn.hidden = NO;
        self.codeLabel.hidden = YES;
        [self stopTimer];
        return;
        
    }
}

- (void)stopTimer {
    
    _count = 60;
    [_timer invalidate];
    _timer = nil;
    
}


@end
