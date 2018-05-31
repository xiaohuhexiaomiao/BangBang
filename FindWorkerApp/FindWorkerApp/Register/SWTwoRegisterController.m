//
//  SWTwoRegisterController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWTwoRegisterController.h"

#import "SWThreeRegisterController.h"

#import "CXZ.h"

#import "SWSendCmd.h"
#import "SWNode.h"
#import "SWNodeData.h"

#import "SWValidateCmd.h"
#import "SWValidate.h"

#import "NSDictionary+SWDictionary.h"

#define padding 10

@interface SWTwoRegisterController ()

@property (nonatomic, retain) UITextField *noteField;

@property (nonatomic, retain) UIView *inputView;

@property (nonatomic, retain) NSTimer *timer;

@property (nonatomic, retain) UIButton *sendBtn;

@property (nonatomic, assign) NSInteger count; //计数值

@property (nonatomic, retain) NSString *data;

@property (nonatomic, strong) UILabel *codeLabel;

@end

@implementation SWTwoRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _count = 60;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    [self setupBackWithString:@"取消" withColor:[UIColor colorWithRed:0.52 green:0.71 blue:0.92 alpha:1.00]];
    
    [self setupTitleWithString:@"注册" withColor:[UIColor whiteColor]];
    if (self.forget) {
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
    
    UIView *phoneView = [self setUpInputView:@"checkNum" placeHolder:@"请输入短信验证码" btnTitle:@"发送验证码" frame:CGRectMake(phoneviewX, phoneviewY, phoneviewW, phoneviewH)];
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
    
}

- (void)nextClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    if(!IS_EMPTY(_noteField.text)){
        
        SWValidateCmd *validateCmd = [[SWValidateCmd alloc] init];
        validateCmd.sender = self.phoneNum;
        validateCmd.code   = _noteField.text;
        if(_data){

            validateCmd.validate_code = _data;
            
        }
        
        
        
        [[HttpNetwork getInstance] requestPOST:validateCmd success:^(BaseRespond *respond) {
            
            SWValidate *validate = [[SWValidate alloc] initWithDictionary:respond.data];
            
            if(validate.code == 0){
                
                SWThreeRegisterController *registerController = [[SWThreeRegisterController alloc] init];
                registerController.phoneNum = self.phoneNum;
                if (self.forget) {
                    registerController.forgetPSW = YES;
                }
                [self.navigationController pushViewController:registerController animated:YES];
                
            }else {
                
                [MBProgressHUD showError:validate.message toView:self.view];
                
            }
           
            
            sender.userInteractionEnabled = YES;
            
        } failed:^(BaseRespond *respond, NSString *error) {
            
            sender.userInteractionEnabled = YES;
            
        }];
        
        
    }else {
        
        [MBProgressHUD showError:@"请填写验证码" toView:self.view];
        
    }
    
    
}

- (UIView *)setUpInputView:(NSString *)imageName placeHolder:(NSString *)placeHolder btnTitle:(NSString *)btnTitle frame:(CGRect)frame{
    
    UIView *inputView = [[UIView alloc] init];
    inputView.frame   = frame;
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.layer.cornerRadius = 5;
    inputView.layer.masksToBounds = YES;
    inputView.layer.borderWidth = 0.5;
    inputView.layer.borderColor = [UIColor colorWithRed:0.52 green:0.71 blue:0.92 alpha:1.00].CGColor;
    _inputView = inputView;
    
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
        [send addTarget:self action:@selector(sendNote:) forControlEvents:UIControlEventTouchUpInside];
        [inputView addSubview:send];
        
        textW = CGRectGetMinX(send.frame) - CGRectGetMaxX(icon.frame) - padding;
        _sendBtn = send;
        
    }
    
    UITextField *textField = [[UITextField alloc] init];
    textField.frame        = CGRectMake(textX, textY, textW, textH);
    textField.placeholder  = placeHolder;
    textField.keyboardType = UIKeyboardTypePhonePad;
    textField.font         = [UIFont systemFontOfSize:15];
    [inputView addSubview:textField];
    _noteField = textField;
    
    _codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(textField.right, textField.top, _sendBtn.width, textField.height)];
    _codeLabel.textAlignment = NSTextAlignmentCenter;
    _codeLabel.font = [UIFont systemFontOfSize:12];
    _codeLabel.backgroundColor = [UIColor whiteColor];
    _codeLabel.text = @"还剩60秒";
    _codeLabel.hidden = YES;
    _codeLabel.textColor = [UIColor colorWithRed:0.53 green:0.77 blue:0.78 alpha:1.00];
    [inputView addSubview:_codeLabel];
    
    return inputView;
    
}

- (void)sendNote:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    [self startTimer];
    SWSendCmd *cmd = [[SWSendCmd alloc] init];
    if (!IS_EMPTY(self.phoneNum)) {
        cmd.sender = [self.phoneNum integerValue];
    }
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameter = @{@"sender":self.phoneNum};
    
    if (self.forget) {
        [sessionManager POST:[NSString stringWithFormat:@"%@/index.php/Mobile/skey/sendValidate",API_HOST] parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
           
            NSString *msg = dict[@"message"];
//            NSLog(@"**cuowu*%@",dict);
//            NSString *str = [NSDictionary dictionaryToJson:model];
            if ([dict[@"code"] integerValue]==0) {
                NSError *error;
                NSData *gsData = [NSJSONSerialization
                                  dataWithJSONObject:dict[@"data"] options:NSJSONWritingPrettyPrinted error:&error];
                _data = [[NSString alloc] initWithData:gsData encoding:NSUTF8StringEncoding];
            }else{
                 [MBProgressHUD showError:msg toView:self.view];
            }
            
           
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [MBProgressHUD showError:[error description] toView:self.view];
            sender.userInteractionEnabled = YES;
            
        }];
    }else{
        [sessionManager POST:[NSString stringWithFormat:@"%@/index.php/Mobile/skey/send_validate_code",API_HOST] parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSString *msg = dict[@"message"];
            if ([dict[@"code"] integerValue]==0) {
                NSError *error;
                NSData *gsData = [NSJSONSerialization
                                  dataWithJSONObject:dict[@"data"] options:NSJSONWritingPrettyPrinted error:&error];
                _data = [[NSString alloc] initWithData:gsData encoding:NSUTF8StringEncoding];
            }else{
                [MBProgressHUD showError:msg toView:self.view];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [MBProgressHUD showError:[error description] toView:self.view];
            sender.userInteractionEnabled = YES;
            
        }];
    }
    
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
//    NSLog(@"***%li",_count);
}

- (void)stopTimer {
    
    _count = 60;
    [_timer invalidate];
    _timer = nil;
    
}
@end
