//
//  SWEvaluateWorkerController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/25.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWEvaluateWorkerController.h"

#import "CXZ.h"

#import "SWLookUserData.h"
#import "SWCommentingView.h"

#define padding 10

@interface SWEvaluateWorkerController ()<SWCommentViewDelegate>

@property (nonatomic, retain) UIScrollView *contentView;

@property (nonatomic, assign) CGFloat replyViewDraw;

@property (nonatomic, assign) CGPoint origpoint;

@property (nonatomic, assign) BOOL isShow; //判断键盘是不是显示

@end

@implementation SWEvaluateWorkerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupBackw];
    
    [self setupTitleWithString:@"评价工人" withColor:[UIColor whiteColor]];
    
    [self initWithView];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBegin:) name:UITextViewTextDidBeginEditingNotification object:nil];
    //添加键盘出现的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyHidden) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyShow) name:UIKeyboardWillShowNotification object:nil];
    
    
}

- (void)keyShow {
    
    _isShow = YES;
    
}

- (void)keyHidden {
    
    _isShow = NO;
    
}

- (void)showKeyboard:(NSNotification *)notif {
    
    if(_isShow) {
        
        NSDictionary *dic = notif.userInfo;
        CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
        
        if(keyboardRect.size.height > 250) {
            
            [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
                
                [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
                
                CGPoint offsetPoint = _origpoint;
                offsetPoint.y -= (keyboardRect.origin.y - self.replyViewDraw);
                self.contentView.contentOffset = offsetPoint;
                
                
            }];
            
        }
        
    }
    
    
    
}

- (void)initWithView {
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame         = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    [self.view addSubview:contentView];
    _contentView = contentView;
    
    [self addWorkerEvaluate:_workerArr];
    
}

- (void)addWorkerEvaluate:(NSArray *)workers {
    
    CGFloat workerX = padding;
    CGFloat workerY = padding;
    CGFloat workerW = SCREEN_WIDTH - 2 * workerX;
    CGFloat workerH = padding;
    
    CGFloat maxHeight = 0;
    
    for (int i = 0; i < workers.count; i++) {
        
        SWLookUserData *userData = workers[i];
        
        SWCommentingView *commentingView = [[SWCommentingView alloc] initWithFrame:CGRectMake(workerX, workerY, workerW, workerH)];
        commentingView.backgroundColor = [UIColor whiteColor];
        [commentingView showData:userData.avatar name:userData.name jobArr:userData.type];
        commentingView.SWCommentingViewDelegate = self;
        [_contentView addSubview:commentingView];
        
        workerY = CGRectGetMaxY(commentingView.frame) + padding;
        
        maxHeight = CGRectGetMaxY(commentingView.frame) + padding;
        
    }
    
    _contentView.contentSize = CGSizeMake(0, maxHeight);
    
}

- (void)showKeyBoard:(UITextView *)textView {
    
    NSLog(@"text ======= %@",textView.superview);
    
    SWCommentingView *commentingView = (SWCommentingView *)textView.superview;
    
    _origpoint = _contentView.contentOffset;
    
    self.replyViewDraw = [commentingView convertRect:commentingView.bounds toView:self.view.window].origin.y + commentingView.frame.size.height;
    
    NSLog(@"content ====== %f",self.replyViewDraw);
    
    
}

@end
