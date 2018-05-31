//
//  SWRegisterController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWRegisterController.h"

#import "SWTwoRegisterController.h"
#import "WebViewController.h"
#import "CXZ.h"
#import "CXZStringUtil.h"

#define padding 10
@interface SWRegisterController ()

@property (nonatomic, retain) UITextField *phoneField;

@end

@implementation SWRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];

    [self setupBackWithString:@"取消" withColor:[UIColor colorWithRed:0.52 green:0.71 blue:0.92 alpha:1.00]];
    
    [self setupTitleWithString:@"注册" withColor:[UIColor whiteColor]];
    if (self.type == 1) {
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
    
    UIView *phoneView = [self setUpInputView:@"login_phone" placeHolder:@"请输入手机号" btnTitle:nil frame:CGRectMake(phoneviewX, phoneviewY, phoneviewW, phoneviewH)];
    [self.view addSubview:phoneView];
    
    CGFloat nextX = phoneviewX;
    CGFloat nextY = CGRectGetMaxY(phoneView.frame) + 3 * padding;
    CGFloat nextW = SCREEN_WIDTH - 2 * nextX;
    CGFloat nextH = 40;
    
    UIButton *nextBtn = [[UIButton alloc] init];
    nextBtn.frame     = CGRectMake(nextX, nextY, nextW, nextH);
    nextBtn.layer.cornerRadius = 5;
    nextBtn.layer.masksToBounds = YES;
    nextBtn.backgroundColor = [UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1.00];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:nextBtn];
    
    NSString *tintStr = @"注册表示接受《邦邦师傅》用户协议";
    
    CGSize tintSize = [tintStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    CGFloat tintX = (SCREEN_WIDTH - tintSize.width) / 2;
    CGFloat tintY = CGRectGetMaxY(nextBtn.frame) + padding;
    CGFloat tintW = tintSize.width;
    CGFloat tintH = tintSize.height;
    
    UIButton *tintBtn = [[UIButton alloc] init];
    tintBtn.frame     = CGRectMake(tintX, tintY, tintW, tintH);
    [tintBtn setTitle:tintStr forState:UIControlStateNormal];
    [tintBtn setTitleColor:[UIColor colorWithRed:0.89 green:0.52 blue:0.41 alpha:1.00] forState:UIControlStateNormal];
    tintBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [tintBtn addTarget:self action:@selector(clickTintButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tintBtn];
    if (self.type == 1) {
        tintBtn.hidden = YES;
    }
   
}

-(void)clickTintButton
{
    WebViewController  *webVC = [[WebViewController alloc]init];
    webVC.urlStr = [NSString stringWithFormat:@"%@/index.php/Mobile/aboutme/treaty",API_HOST];
    webVC.isAboutUs = YES;
    webVC.titleString = @"用户协议";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)nextClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    if(_phoneField.text) {
        
        SWTwoRegisterController *registerController = [[SWTwoRegisterController alloc] init];
        registerController.phoneNum = _phoneField.text;
        if (self.type == 1) {
            registerController.forget = YES;
        }
        [self.navigationController pushViewController:registerController animated:YES];
        
    }else {
        
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
        
    }
    
    
    
    sender.userInteractionEnabled = YES;
    
}

- (UIView *)setUpInputView:(NSString *)imageName placeHolder:(NSString *)placeHolder btnTitle:(NSString *)btnTitle frame:(CGRect)frame{
    
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
    textField.keyboardType = UIKeyboardTypePhonePad;
    textField.font         = [UIFont systemFontOfSize:15];
    [inputView addSubview:textField];
    _phoneField = textField;
    
    return inputView;
    
}


@end
