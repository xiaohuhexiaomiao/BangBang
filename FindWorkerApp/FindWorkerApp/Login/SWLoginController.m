//
//  SWLoginController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWLoginController.h"

#import "CXZ.h"

#import "SWRegisterController.h"
#import "SWRegisterCompanyViewController.h"

#import "SWFindWorkerUtils.h"

#import "SWLoginCmd.h"
#import "SWUserInfo.h"
#import "SWUserData.h"

#import "CXZStringUtil.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"

#define padding 10

@interface SWLoginController ()

@end

@implementation SWLoginController

static NSInteger seq = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    if (self.type == 0) {
//        [self setupBackWithString:@"取消" withColor:[UIColor colorWithRed:0.52 green:0.71 blue:0.92 alpha:1.00]];
      [self setupNextWithString:@"注册" withColor:[UIColor colorWithRed:0.52 green:0.71 blue:0.92 alpha:1.00]];
        [self setupTitleWithString:@"登录" withColor:[UIColor whiteColor]];
        
    }else{
        self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
        [self setupNextWithString:@"注册" withColor:[UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1.00]];
        [self setupTitleWithString:@"登录" withColor:[UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1.00]];
    }
    
      [self initWithView];
}

//初始化界面
- (void)initWithView {
    
    CGFloat phoneviewX = 40;
    CGFloat phoneviewY = 120;
    CGFloat phoneviewW = SCREEN_WIDTH - 2 * phoneviewX;
    CGFloat phoneviewH = 40;
    
    UIView *phoneView = [self setUpInputView:@"login_phone" placeHolder:@"请输入手机号" btnTitle:@"" frame:CGRectMake(phoneviewX, phoneviewY, phoneviewW, phoneviewH) tag:1];
    [self.view addSubview:phoneView];
    
    CGFloat checkviewX = phoneviewX;
    CGFloat checkviewY = CGRectGetMaxY(phoneView.frame) + 3 * padding;
    CGFloat checkviewW = SCREEN_WIDTH - 2 * checkviewX;
    CGFloat checkviewH = 40;
    
    UIView *checkView = [self setUpInputView:@"password" placeHolder:@"请输入密码" btnTitle:@"" frame:CGRectMake(checkviewX, checkviewY, checkviewW, checkviewH) tag:2];
    [self.view addSubview:checkView];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(checkView.right-120, checkView.bottom+10, 120, 30);
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetBtn setTitle:@"忘记密码/更改密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:TOP_GREEN forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgetBtn addTarget:self action:@selector(clickForgetBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    CGFloat loginX = phoneviewX;
    CGFloat loginY = CGRectGetMaxY(checkView.frame) + 5 * padding;
    CGFloat loginW = SCREEN_WIDTH - 2 * loginX;
    CGFloat loginH = 40;
    
    
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.frame     = CGRectMake(loginX, loginY, loginW, loginH);
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = [UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1.00];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:loginBtn];
    
    
}

- (void)clickForgetBtn
{
    SWRegisterController *registeController = [[SWRegisterController alloc] init];
    registeController.type = 1;
    [self.navigationController pushViewController:registeController animated:YES];
}

- (void)loginClick:(UIButton *)sender {
    
//    sender.userInteractionEnabled = NO;
    
    UITextField *username = [self.view viewWithTag:1];
    
    if(IS_EMPTY(username.text)) {
    
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
        [username becomeFirstResponder];
        return;
        
    }
    
    UITextField *password = [self.view viewWithTag:2];
    
    if(IS_EMPTY(password.text)) {
        
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        [password becomeFirstResponder];
        return;
        
    }
    [username resignFirstResponder];
    [password resignFirstResponder];
    
    SWLoginCmd *loginCmd = [[SWLoginCmd alloc] init];
    loginCmd.phone       = username.text;
    loginCmd.password    = [CXZStringUtil md5:password.text];
    
    [[NSUserDefaults standardUserDefaults] setObject:username.text forKey:@"phone"];
    
    [SVProgressHUD show];
    
    [[HttpNetwork getInstance] requestPOST:loginCmd success:^(BaseRespond *respond) {
        
        [SVProgressHUD dismiss];
        
//        NSLog(@"***add123:%@", respond.data);
        SWUserInfo *userInfo = [[SWUserInfo alloc] initWithDictionary:respond.data];
        
        if(userInfo.code == 0){
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IS_LOGIN"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"LOG"];
            SWUserData *userData = userInfo.data;

            [[NSUserDefaults standardUserDefaults] setObject:userData.skey forKey:@"app_token"];
            [[NSUserDefaults standardUserDefaults] setObject:userData.uid forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] setObject:userData.roles forKey:@"roles"];
            [[NSUserDefaults standardUserDefaults] setObject:userData.phone forKey:@"phone"];
            [[NSUserDefaults standardUserDefaults] setObject:userData.rong_token forKey:@"RongYunToken"];
            [[NSUserDefaults standardUserDefaults] setObject:userData.avatar forKey:@"avatar"];
            [[NSUserDefaults standardUserDefaults] setObject:userData.name forKey:@"realname"];
            if(IS_EMPTY(userData.avatar)) {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"IS_FINISH"];
            }else {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"IS_FINISH"];
            }
            
            
            [SWFindWorkerUtils jumpMain];
            
//            [JPUSHService registrationID];
            NSString *alias = [NSString stringWithFormat:@"%li",[username.text integerValue]];
            
            [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
            } seq:[self seq]];
            
        }else {
            
            [MBProgressHUD showError:userInfo.message toView:self.view];
            
        }
        
//        sender.userInteractionEnabled = YES;
        
    } failed:^(BaseRespond *respond, NSString *error) {
        [SVProgressHUD dismiss];
        [MBProgressHUD showError:error toView:self.view];
//        sender.userInteractionEnabled = YES;
        
    }];
    
}

- (NSInteger)seq {
    return ++ seq;
}


//- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
//    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
//}




- (UIView *)setUpInputView:(NSString *)imageName placeHolder:(NSString *)placeHolder btnTitle:(NSString *)btnTitle frame:(CGRect)frame tag:(NSInteger)tag {
    
    UIView *inputView = [[UIView alloc] init];
    inputView.frame   = frame;
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.layer.cornerRadius = 5;
    inputView.layer.masksToBounds = YES;
    inputView.layer.borderWidth = 0.5;
    inputView.layer.borderColor = [UIColor colorWithRed:0.52 green:0.71 blue:0.92 alpha:1.00].CGColor;
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    CGFloat iconW = image.size.width;
    CGFloat iconH = image.size.height;
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
        
        textW = CGRectGetMinX(send.frame) - CGRectGetMaxX(icon.frame) - padding;
        
    }
    
    UITextField *textField = [[UITextField alloc] init];
    textField.frame        = CGRectMake(textX, textY, textW, textH);
    textField.placeholder  = placeHolder;
    textField.tag = tag;
    textField.font         = [UIFont systemFontOfSize:15];
    [inputView addSubview:textField];
    if(tag == 1) {
    
        textField.keyboardType = UIKeyboardTypePhonePad;
        
    }else {
        UIButton *seeButon = [CustomView customButtonWithContentView:inputView image:@"see" title:nil];
        seeButon.frame = CGRectMake(textField.right-textH, textField.top, textH, textH);
        [seeButon addTarget:self action:@selector(clickEyeButton) forControlEvents:UIControlEventTouchUpInside];
        textField.secureTextEntry = YES;
    
    }
    
    return inputView;
    
}

-(void)clickEyeButton
{
    UITextField *username = [self.view viewWithTag:2];
    username.secureTextEntry = NO;
}

- (void)onBack {
    
    [SWFindWorkerUtils jumpMain];
    
}
//注册
- (void)onNext {
    
    SWRegisterController *registeController = [[SWRegisterController alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"type"];
    [self.navigationController pushViewController:registeController animated:YES];}


@end
