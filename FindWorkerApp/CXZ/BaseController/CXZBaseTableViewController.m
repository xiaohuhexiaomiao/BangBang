//
//  CXZBaseTableViewController.m
//  DiaoDiao
//
//  Created by wangzeng on 14-10-20.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import "CXZBaseTableViewController.h"
#import "CXZ.h"
#import "AppDelegate.h"
#import "NSString+Category.h"
#import "MONActivityIndicatorView.h"


@interface CXZBaseTableViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate, UITableViewDelegate, MONActivityIndicatorViewDelegate> {
    NSInteger prewTag; //UITextField的tag
    float prewMoveY; //编辑到时候移动到高度
    UIImageView*navBarHairlineImageView;
}
@property (strong ,nonatomic)UILabel * labelText;
@property (nonatomic ,strong)UIView * UpView;
@property (nonatomic, strong) MONActivityIndicatorView* loadingView;

@end

@implementation CXZBaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self registerHideKeyWindow];
    
    _preScrollEnable = self.tableView.scrollEnabled;
    _preInterEnable = self.tableView.userInteractionEnabled;
    navBarHairlineImageView= [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.alpha=0.4;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIImageView*)findHairlineImageViewUnder:(UIView*)view {
    
    if([view isKindOfClass:UIImageView.class] && view.bounds.size.height<=1.0) {
        return(UIImageView*)view;
    }
    for(UIView*subview in view.subviews) {
        UIImageView*imageView = [self findHairlineImageViewUnder:subview];
        if(imageView) {
            return imageView;
        }
    }
    return nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark 初始化标题栏
// 返回
- (void) setupBack {
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 20, 20);
   // [back setTitle:@"" forState:UIControlStateNormal];
   // back.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
   // [back setImage:[UIImage imageNamed:@"back_highlight"] forState:UIControlStateHighlighted];
   // [back setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
   // [back setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [back addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = rightItem;
}

- (void) setupNextWithImage:(UIImage *)image {
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 44, 44);
    [back setImage:image forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (UIButton*) setupNextWithString:(NSString *)text {
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16] width:100];
    back.frame = CGRectMake(0, 0, size.width, 44);
    [back setTitle:text forState:UIControlStateNormal];
    [back setTitleColor:HexRGB(0x616161) forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.rightBarButtonItem = rightItem;
    return back;
}

- (void) setupNextWithString:(NSString *)text withColor:(UIColor *)color {
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16] width:100];
    back.frame = CGRectMake(0, 0, size.width, 44);
    [back setTitle:text forState:UIControlStateNormal];
    [back setTitleColor:color forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)setupTitleWithString:(NSString *)text withColor:(UIColor *)color{
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-30, 0, 60, TITLE_BAR_HEIGHT)];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = text;
    titleView.font = [UIFont boldSystemFontOfSize:17];
    titleView.textColor = color;
    self.navigationItem.titleView = titleView;
}


#pragma mark 界面点击 关闭键盘用
- (void)registerHideKeyWindow {
    if([self needRegisterHideKeyboard]) {
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyWindow)];
        tap.delegate = self;
        [self.tableView addGestureRecognizer:tap];
    }
}

- (void)hideKeyWindow {
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UICollectionViewCellContentView"]) {
        return NO;
    }
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideKeyWindow];
}

#pragma mark - 重载needWaiting
- (BOOL)needWaiting {
    return NO;
}

#pragma mark - 重载onback
- (void)onBack {
    [self hideKeyWindow];
    UIViewController * controller=[self.navigationController.viewControllers objectAtIndex:0];
    if(controller == self) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 重载onnext
- (void)onNext {
    [self hideKeyWindow];
}

#pragma mark - 重载popByDrag
- (void)popByDrag {
}

#pragma mark - 是否需要侧拉返回
- (BOOL)needDragBack {
    return YES;
}

#pragma mark - 是否需要注册隐藏键盘手势
- (BOOL)needRegisterHideKeyboard {
    return YES;
}

// 界面效果
- (void)showLoading {
    if (self.loadingView == nil) {
        self.loadingView = [[MONActivityIndicatorView alloc] init];
        self.loadingView.delegate = self;
        self.loadingView.numberOfCircles = 5;
        self.loadingView.radius = 10;
        self.loadingView.internalSpacing = 3;
        self.loadingView.duration = 0.75;
        [self.view addSubview:self.loadingView];
        self.loadingView.center = self.view.center;
        
    }
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
}

- (void)hideLoading {
    if (self.loadingView) {
        [self.loadingView stopAnimating];
        [self.loadingView setHidden:YES];
    }
}

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end
