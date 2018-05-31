//
//  IdeaBackViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/4/18.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "IdeaBackViewController.h"

@interface IdeaBackViewController ()<UITextViewDelegate>

@property(nonatomic ,strong) UITextView *contentView;

@end

@implementation IdeaBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"意见反馈" withColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self config];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark Private Method
-(void)config
{
    _contentView = [[UITextView alloc]initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH-16, 100)];
    _contentView.layer.borderColor = [UIColor grayColor].CGColor;
    _contentView.layer.borderWidth = 0.5;
    _contentView.layer.cornerRadius = 5;
    _contentView.text = @"请输入内容...";
    _contentView.delegate  = self;
    [self.view addSubview:_contentView];
    
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(8, _contentView.bottom+30, SCREEN_WIDTH-16, 40);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.backgroundColor = TOP_GREEN;
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    sendBtn.layer.cornerRadius = 5;
    [sendBtn addTarget:self action:@selector(clickSendButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
}

-(void)clickSendButton
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSDictionary *paramDict = @{@"uid":uid,@"content":self.contentView.text};
    [[NetworkSingletion sharedManager]feedbackIdea:paramDict onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            [MBProgressHUD showSuccess:@"发送成功!" toView:self.view];
            self.contentView.text = @"";
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];

    }];
}

#pragma mark Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _contentView.text = @"";
    return YES;
}


@end
