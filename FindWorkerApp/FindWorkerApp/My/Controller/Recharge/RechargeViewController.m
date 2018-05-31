//
//  RechargeViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/5/28.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "RechargeViewController.h"
#import "CXZ.h"
#import "SWAlipay.h"

@interface RechargeViewController ()<UITextFieldDelegate>

@property(nonatomic ,strong) UIView *lastView;

@property(nonatomic ,strong) UITextField *inputTextfield;

@property(nonatomic ,strong) NSString *money;

@property(nonatomic ,strong) NSArray *titleArray;

@property(nonatomic ,strong) NSMutableArray *buttonArray;

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    
    [self setupTitleWithString:@"充值" withColor:[UIColor whiteColor]];
    
    self.buttonArray = [NSMutableArray array];
    self.titleArray = @[@"50",@"100",@"200",@"500",@"1000",@"其他"];
    CGFloat Width = SCREEN_WIDTH/3;
    CGFloat buttonWidth = 100;
    for (int i  = 0; i < (self.titleArray.count-1); i++) {
        if (i < 3) {
            UIButton *button = [CustomView customButtonWithContentView:self.view image:nil title:self.titleArray[i]];
            button.frame = CGRectMake(Width*i+(Width-buttonWidth)/2, 30, buttonWidth, 40);
            button.tag = i;
            button.layer.cornerRadius = 20;
            button.layer.borderWidth = 1;
            button.layer.borderColor = UIColorFromRGB(224, 223, 226).CGColor;
            [button addTarget:self action:@selector(clickMoneyButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonArray addObject:button];
            _lastView = button;
        }else{
            UIButton *button = [CustomView customButtonWithContentView:self.view image:nil title:self.titleArray[i]];
            button.frame = CGRectMake(Width*(i-3)+(Width-buttonWidth)/2, 90, buttonWidth, 40);
            button.tag = i;
            button.layer.cornerRadius = 20;
            button.layer.borderWidth = 1;
            button.layer.borderColor = UIColorFromRGB(224, 223, 226).CGColor;
            [button addTarget:self action:@selector(clickMoneyButton:) forControlEvents:UIControlEventTouchUpInside];
             [self.buttonArray addObject:button];
            _lastView = button;
        }
    }
    
    _inputTextfield = [CustomView customUITextFieldWithContetnView:self.view placeHolder:@"其他"];
//    _inputTextfield.text = @"其他";
    _inputTextfield.delegate = self;
    _inputTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    _inputTextfield.textAlignment = NSTextAlignmentCenter;
    _inputTextfield.frame = CGRectMake(Width*2+(Width-buttonWidth)/2, 90, buttonWidth, 40);
    _inputTextfield.layer.cornerRadius = 20;
    _inputTextfield.layer.borderWidth = 1;
    _inputTextfield.layer.borderColor =  UIColorFromRGB(224, 223, 226).CGColor;
    
    
    UIButton *recharButton = [CustomView customButtonWithContentView:self.view image:nil title:@"充值"];
    recharButton.frame = CGRectMake(10, _lastView.bottom+60, SCREEN_WIDTH-20, 40);
    recharButton.layer.cornerRadius = 3;
    recharButton.layer.borderWidth = 1;
    recharButton.backgroundColor = ORANGE_COLOR;
    recharButton.layer.borderColor = ORANGE_COLOR.CGColor;
    [recharButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recharButton addTarget:self action:@selector(clickRechargeButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setLayerColor
{
    for (UIButton *button in self.buttonArray) {
        button.layer.borderColor = UIColorFromRGB(224, 223, 226).CGColor;
        [button setTitleColor:[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1.00] forState:UIControlStateNormal];
    }
    self.inputView.layer.borderColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1.00].CGColor;
}

#pragma mark  IBAction

-(void)clickMoneyButton:(UIButton*)button
{
    NSInteger tag = button.tag;
    [self setLayerColor];
    button.layer.borderColor = GREEN_COLOR.CGColor;
    [button setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    self.money = self.titleArray[tag];
    
}
-(void)clickRechargeButton:(UIButton*)button
{
    NSLog(@"***%@",self.money);
    if ([self.money integerValue] < 10) {
        [WFHudView showMsg:@"金额不能小于10元" inView:self.view];
        return;
    }
    [[NetworkSingletion sharedManager]rechargeWithAlipay:@{@"money":self.money} onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            SWAlipay *pay = [SWAlipay new];
            NSString *payStr = dict[@"data"];
            [pay payToStr:payStr];
        }
    } OnError:^(NSString *error) {
        
    }];
}

#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    [self setLayerColor];

    self.inputTextfield.layer.borderColor = GREEN_COLOR.CGColor;
    self.inputTextfield.placeholder = nil;
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.money = textField.text;
}
#pragma arguments
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
