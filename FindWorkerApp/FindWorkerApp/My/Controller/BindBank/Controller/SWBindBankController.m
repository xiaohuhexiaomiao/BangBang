//
//  SWBindBankController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWBindBankController.h"

#import "CXZ.h"

#define padding 10

@interface SWBindBankController ()

@end

@implementation SWBindBankController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBackw];
    
    [self setupTitleWithString:@"绑定银行卡" withColor:[UIColor whiteColor]];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    [self initWithView];
    
    
    
}

//初始化界面
- (void)initWithView {
    
    NSArray *titleArr = @[@"真实姓名",@"身份证",@"银行卡号",@"开卡行"];
    NSArray *placeArr = @[@"请输入真实姓名",@"请输入身份证号",@"请输入银行卡号",@"请选择开户行"];
    
    for (int i = 0; i < 4; i++) {
        
        CGFloat viewH = 50;
        CGFloat viewX = 0;
        CGFloat viewY = i * 50;
        CGFloat viewW = SCREEN_WIDTH;
        [self setUpInputView:CGRectMake(viewX, viewY, viewW, viewH) title:titleArr[i] placeholder:placeArr[i] tag:i+1];
        
    }
    
    UIButton *finish = [[UIButton alloc] init];
    finish.frame     = CGRectMake(0, SCREEN_HEIGHT - 64 - 49, SCREEN_WIDTH, 49);
    finish.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
    [finish setTitle:@"提交绑定" forState:UIControlStateNormal];
    finish.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:finish];
    
}

//设置输入界面
- (void)setUpInputView:(CGRect)frame title:(NSString *)title placeholder:(NSString *)placeholder tag:(NSInteger)tag {
    
    UIView *inputView = [[UIView alloc] initWithFrame:frame];
    inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputView];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont systemFontOfSize:12];
    titleLbl.textColor = [UIColor colorWithRed:0.31 green:0.32 blue:0.32 alpha:1.00];
    titleLbl.text = title;
    [titleLbl sizeToFit];
    titleLbl.frame = CGRectMake(padding, (49 - titleLbl.bounds.size.height) / 2, titleLbl.bounds.size.width, titleLbl.bounds.size.height);
    [inputView addSubview:titleLbl];
    
    UITextField *inputField = [[UITextField alloc] init];
    inputField.placeholder = placeholder;
    inputField.frame = CGRectMake(CGRectGetMaxX(titleLbl.frame) + padding, titleLbl.frame.origin.y + 2, SCREEN_WIDTH - CGRectGetMaxX(titleLbl.frame) - 2 * padding, 14);
    inputField.textAlignment = NSTextAlignmentRight;
    inputField.tag = tag;
    inputField.font = [UIFont systemFontOfSize:13];
    [inputView addSubview:inputField];
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, CGRectGetMaxY(titleLbl.frame) + (49 - titleLbl.bounds.size.height) / 2, SCREEN_WIDTH, 1);
    line.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [inputView addSubview:line];
    
//    inputView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, CGRectGetMaxY(line.frame));
    
}



@end
