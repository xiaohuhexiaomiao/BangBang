//
//  SWThreeRegisterController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWThreeRegisterController.h"

#import "SWTwoRegisterController.h"

#import "SWMyController.h"
#import "SWCompleteInfoController.h"
#import "SWLoginController.h"
#import "SWFindWorkerUtils.h"

#import "CXZ.h"

#import "SWRegisterCmd.h"
#import "SWRegister.h"
#import "SWUserData.h"

#import "JPUSHService.h"


#define padding 10

@interface SWThreeRegisterController ()

@end

@implementation SWThreeRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    [self setupBackWithString:@"取消" withColor:[UIColor colorWithRed:0.52 green:0.71 blue:0.92 alpha:1.00]];
    
    [self setupTitleWithString:@"注册" withColor:[UIColor whiteColor]];
    if (self.forgetPSW) {
        [self setupTitleWithString:@"忘记密码" withColor:[UIColor whiteColor]];
    }
    [self initWithView];
}

//初始化界面
- (void)initWithView {
    
    CGFloat phoneviewX = 40;
    CGFloat phoneviewY = 120;
    CGFloat phoneviewW = SCREEN_WIDTH - 2 * phoneviewX;
    CGFloat phoneviewH = 40;
    
    UIView *phoneView = [self setUpInputView:@"password" placeHolder:@"请输入密码" btnTitle:@"" frame:CGRectMake(phoneviewX, phoneviewY, phoneviewW, phoneviewH) tag:1];
    [self.view addSubview:phoneView];
    
    CGFloat checkviewX = phoneviewX;
    CGFloat checkviewY = CGRectGetMaxY(phoneView.frame) + 3 * padding;
    CGFloat checkviewW = SCREEN_WIDTH - 2 * checkviewX;
    CGFloat checkviewH = 40;
    
    UIView *checkView = [self setUpInputView:@"password_comfirm" placeHolder:@"请再次输入密码" btnTitle:@"" frame:CGRectMake(checkviewX, checkviewY, checkviewW, checkviewH) tag:2];
    [self.view addSubview:checkView];
    
    CGFloat loginX = phoneviewX;
    CGFloat loginY = CGRectGetMaxY(checkView.frame) + 3 * padding;
    CGFloat loginW = SCREEN_WIDTH - 2 * loginX;
    CGFloat loginH = 40;
    
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.frame     = CGRectMake(loginX, loginY, loginW, loginH);
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = [UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1.00];
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginBtn addTarget:self action:@selector(successReg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
}

- (void)successReg:(UIButton *)sender {
    
    UITextField *password = [self.view viewWithTag:1];
    
    if(IS_EMPTY(password.text)){
        
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        [password becomeFirstResponder];
        return;
        
    }
    
    UITextField *repeat_password = [self.view viewWithTag:2];
    
    if(IS_EMPTY(repeat_password.text)){
        
        [MBProgressHUD showError:@"请再输入密码" toView:self.view];
        [repeat_password becomeFirstResponder];
        return;
        
    }
    
    if(![password.text isEqualToString:repeat_password.text]){
        
        [MBProgressHUD showError:@"两次密码不一致" toView:self.view];
        return;
        
    }
    SWRegisterCmd *registerCmd = [[SWRegisterCmd alloc] init];
    registerCmd.sender          = self.phoneNum;
    registerCmd.password       = [CXZStringUtil md5:password.text];
    registerCmd.check_password = [CXZStringUtil md5:repeat_password.text];
    registerCmd.type           = [[NSUserDefaults standardUserDefaults] objectForKey:@"type"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.phoneNum forKey:@"phone"];
    if (self.forgetPSW) {
        [[NetworkSingletion sharedManager]forgetPassWords:@{@"phone":self.phoneNum,@"password":registerCmd.password,@"check_password":registerCmd.check_password} onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue] == 0) {
                [SWFindWorkerUtils jumpLogin];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
            
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
        
    }else{
        [JPUSHService setAlias:self.phoneNum callbackSelector:@selector(tagsInRange:scheme:options:tokenRanges:) object:self];
        
        [[HttpNetwork getInstance] requestPOST:registerCmd success:^(BaseRespond *respond) {
            
            SWRegister *registerModel = [[SWRegister alloc] initWithDictionary:respond.data];
            
            if(registerModel.code == 0){
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"type"];
                
                SWUserData *userData = registerModel.data;
                [[NSUserDefaults standardUserDefaults] setObject:userData.skey forKey:@"app_token"];               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IS_LOGIN"];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"LOG"];
                [[NSUserDefaults standardUserDefaults] setObject:userData.uid forKey:@"user_id"];
                [[NSUserDefaults standardUserDefaults] setObject:userData.roles forKey:@"roles"];
                [[NSUserDefaults standardUserDefaults]setObject:userData.phone forKey:@"phone"];
                [[NSUserDefaults standardUserDefaults] setObject:userData.rong_token forKey:@"RongYunToken"];
              
                
                //            [SWFindWorkerUtils jumpMain];
                SWCompleteInfoController *infoVC = [SWCompleteInfoController new];
             
                
                [self.navigationController pushViewController:infoVC animated:YES];
                
            }else {
                
                [MBProgressHUD showError:registerModel.message toView:self.view];
                
            }
        } failed:^(BaseRespond *respond, NSString *error) {
            
            [MBProgressHUD showError:error toView:self.view];
            
        }];
    }
    
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
    textField.secureTextEntry = YES;
    textField.font         = [UIFont systemFontOfSize:15];
    [inputView addSubview:textField];
    
    return inputView;
    
}

@end
