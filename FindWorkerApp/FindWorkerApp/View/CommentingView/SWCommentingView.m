//
//  SWCommentingView.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/25.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWCommentingView.h"
#import "CXZ.h"

#import "SWEvaluateCmd.h"
#import "SWEvaluateInfo.h"


#import "SWPublishFinishedDetailController.h"

#define padding 10

#define IMAGE_WIDTH 30

@interface SWCommentingView ()<UITextViewDelegate>

@property (nonatomic, retain) UIImageView *iconImage;

@property (nonatomic, retain) UILabel *nameLbl;

@property (nonatomic, retain) UITextView *textView;


@end

@implementation SWCommentingView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
    
        [self initWithView];
        
    }
    
    return self;
    
}

//初始化界面
- (void)initWithView {
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.frame = CGRectMake(padding, padding, IMAGE_WIDTH, IMAGE_WIDTH);
    _iconImage.layer.cornerRadius = IMAGE_WIDTH / 2;
    _iconImage.layer.masksToBounds = YES;
    [self addSubview:_iconImage];
    
    _nameLbl = [[UILabel alloc] init];
    _nameLbl.font = [UIFont systemFontOfSize:12];
    _nameLbl.textColor = [UIColor colorWithRed:0.39 green:0.39 blue:0.40 alpha:1.00];
    [self addSubview:_nameLbl];
    
    NSString *evaluateStr = @"您对他的评价是：";
    
    CGSize evaluateSize = [evaluateStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    CGFloat evaluateX = padding;
    CGFloat evaluateY = CGRectGetMaxY(_iconImage.frame) + padding;
    CGFloat evaluateW = evaluateSize.width;
    CGFloat evaluateH = evaluateSize.height;
    
    UILabel *evaluateLbl = [[UILabel alloc] init];
    evaluateLbl.frame = CGRectMake(evaluateX, evaluateY, evaluateW, evaluateH);
    evaluateLbl.font = [UIFont systemFontOfSize:12];
    evaluateLbl.text = evaluateStr;
    evaluateLbl.textColor = [UIColor colorWithRed:0.39 green:0.39 blue:0.40 alpha:1.00];
    [self addSubview:evaluateLbl];
    
    UIButton *perfectBtn = [[UIButton alloc] init];
    [perfectBtn setImage:[UIImage imageNamed:@"dow_unselect"] forState:UIControlStateNormal];
    [perfectBtn setImage:[UIImage imageNamed:@"great_select"] forState:UIControlStateSelected];
    perfectBtn.tag = 1;
    [perfectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    [perfectBtn setTitle:@"满意" forState:UIControlStateNormal];
    perfectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    perfectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [perfectBtn setTitleColor:[UIColor colorWithRed:0.58 green:0.58 blue:0.59 alpha:1.00] forState:UIControlStateNormal];
    [perfectBtn setTitleColor:[UIColor colorWithRed:0.87 green:0.44 blue:0.46 alpha:1.00] forState:UIControlStateSelected];
    [perfectBtn sizeToFit];
    
    CGFloat perfectX = 2 * padding;
    CGFloat perfectY = CGRectGetMaxY(evaluateLbl.frame) + padding;
    CGFloat perfectW = perfectBtn.bounds.size.width;
    CGFloat perfectH = perfectBtn.bounds.size.height;
    perfectBtn.frame = CGRectMake(perfectX, perfectY, perfectW, perfectH);
    [self addSubview:perfectBtn];
    
    UIButton *goodBtn = [[UIButton alloc] init];
    [goodBtn setImage:[UIImage imageNamed:@"dow_unselect"] forState:UIControlStateNormal];
    [goodBtn setImage:[UIImage imageNamed:@"normal_select"] forState:UIControlStateSelected];
    goodBtn.tag = 2;
    [goodBtn setTitle:@"一般" forState:UIControlStateNormal];
    [goodBtn setTitleColor:[UIColor colorWithRed:0.58 green:0.58 blue:0.59 alpha:1.00] forState:UIControlStateNormal];
    [goodBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    [goodBtn setTitleColor:[UIColor colorWithRed:0.90 green:0.62 blue:0.41 alpha:1.00] forState:UIControlStateSelected];
    goodBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    goodBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [goodBtn sizeToFit];
    
    CGFloat goodW = goodBtn.bounds.size.width;
    CGFloat goodH = goodBtn.bounds.size.height;
    CGFloat goodX = (self.frame.size.width - goodW) / 2;
    CGFloat goodY = perfectY;
    
    goodBtn.frame = CGRectMake(goodX, goodY, goodW, goodH);
    [self addSubview:goodBtn];
    
    UIButton *badBtn = [[UIButton alloc] init];
    [badBtn setImage:[UIImage imageNamed:@"dow_unselect"] forState:UIControlStateNormal];
    [badBtn setImage:[UIImage imageNamed:@"bad_select"] forState:UIControlStateSelected];
    [badBtn setTitle:@"不满意" forState:UIControlStateNormal];
    badBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    badBtn.tag = 3;
    [badBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    badBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [badBtn setTitleColor:[UIColor colorWithRed:0.58 green:0.58 blue:0.59 alpha:1.00] forState:UIControlStateNormal];
    [badBtn setTitleColor:[UIColor colorWithRed:0.56 green:0.76 blue:1.00 alpha:1.00] forState:UIControlStateSelected];
    [badBtn sizeToFit];
    
    CGFloat badW = badBtn.bounds.size.width;
    CGFloat badH = badBtn.bounds.size.height;
    CGFloat badX = self.frame.size.width - badW - 2 * padding;
    CGFloat badY = perfectY;
    
    badBtn.frame = CGRectMake(badX, badY, badW, badH);
    [self addSubview:badBtn];
    

    
    CGFloat maxHeight = CGRectGetMaxY(badBtn.frame) + padding;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"备注";
    label.textColor = [UIColor colorWithRed:0.39 green:0.39 blue:0.40 alpha:1.00];
    [label sizeToFit];
    
    CGFloat lblW = label.frame.size.width;
    CGFloat lblH = label.frame.size.height;
    CGFloat lblX = padding;
    CGFloat lblY = maxHeight;
    label.frame = CGRectMake(lblX, lblY, lblW, lblH);
    [self addSubview:label];
    
    maxHeight = CGRectGetMaxY(label.frame) + padding;
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame       = CGRectMake(padding, maxHeight, self.frame.size.width - 2 * padding, 100);
    textView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    textView.layer.cornerRadius = 6;
    textView.delegate = self;
    textView.layer.masksToBounds = YES;
    [self addSubview:textView];
    _textView = textView;
    
    UIButton *sendBtn = [[UIButton alloc] init];
    sendBtn.frame     = CGRectMake(0, CGRectGetMaxY(textView.frame) + padding * 2, self.frame.size.width, 49);
    [sendBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.backgroundColor = GREEN_COLOR;
    [sendBtn setTitle:@"立即评价" forState:UIControlStateNormal];
    [self addSubview:sendBtn];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(sendBtn.frame));
    
    
}

- (void)selectClick:(UIButton *)sender {
    
    sender.selected = YES;
    
    if(sender.tag == 1) {
    
        UIButton *btn1 = [self viewWithTag:2];
        UIButton *btn2 = [self viewWithTag:3];
        btn1.selected = NO;
        btn2.selected = NO;
        
    }else if(sender.tag == 2) {
    
        UIButton *btn1 = [self viewWithTag:1];
        UIButton *btn2 = [self viewWithTag:3];
        btn1.selected = NO;
        btn2.selected = NO;
        
    }else {
        
        UIButton *btn1 = [self viewWithTag:1];
        UIButton *btn2 = [self viewWithTag:2];
        btn1.selected = NO;
        btn2.selected = NO;
        
    }
    
}

- (void)commentClick:(UIButton *)sender {

    sender.userInteractionEnabled = NO;
    
    [self endEditing:YES];
    
    SWEvaluateCmd *evaluateCmd = [[SWEvaluateCmd alloc] init];
    evaluateCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    evaluateCmd.worker_id = _data.uid;
    evaluateCmd.information_id = _infomation_id;
    evaluateCmd.details = _textView.text;
    
    UIButton *btn = [self viewWithTag:1];
    UIButton *btn1 = [self viewWithTag:2];
    UIButton *btn2 = [self viewWithTag:3];
    
    
    if(btn.isSelected) {
        
        evaluateCmd.rated_type = @"0";

    }else if(btn1.isSelected) {
        
        evaluateCmd.rated_type = @"1";
        
    }else if(btn2.isSelected) {
        
        evaluateCmd.rated_type = @"2";
        
    }
    
    [[HttpNetwork getInstance] requestPOST:evaluateCmd success:^(BaseRespond *respond) {
        
        SWEvaluateInfo *evaluateInfo = [[SWEvaluateInfo alloc] initWithDictionary:respond.data];
        
        if(evaluateInfo.code == 0) {
            
            [MBProgressHUD showError:@"评论成功" toView:self];
            
        }else {
            
            [MBProgressHUD showError:evaluateInfo.message toView:self];
            
        }
        
        SWPublishFinishedDetailController *detailController = (SWPublishFinishedDetailController *)self.viewController;
        [detailController hideView];
        
        sender.userInteractionEnabled = YES;
        
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        sender.userInteractionEnabled = YES;
        
        SWPublishFinishedDetailController *detailController = (SWPublishFinishedDetailController *)self.viewController;
        [detailController hideView];
        
        [MBProgressHUD showError:error toView:self];
        
    }];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if([self.SWCommentingViewDelegate respondsToSelector:@selector(showKeyBoard:)]) {
        
        [self.SWCommentingViewDelegate showKeyBoard:textView];
        
    }
    
}

- (void)showData:(NSString *)imageName name:(NSString *)name jobArr:(NSArray *)jobs {
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,imageName]] placeholderImage:[UIImage imageNamed:@"temp"]];
    
    CGSize nameSize = [name sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    _nameLbl.frame = CGRectMake(CGRectGetMaxX(_iconImage.frame) + padding, padding, nameSize.width, nameSize.height);
    _nameLbl.text = name;
    
    
}

@end
