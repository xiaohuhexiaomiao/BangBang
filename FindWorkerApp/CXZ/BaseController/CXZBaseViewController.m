//
//  CXZBaseViewController.m
//  DiaoDiao
//
//  Created by wangzeng on 14-10-20.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import "CXZBaseViewController.h"
#import "CXZ.h"
#import "MJRefresh.h"
#import "NSString+Category.h"
#import "MONActivityIndicatorView.h"

@interface CXZBaseViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate, MONActivityIndicatorViewDelegate> {
    NSInteger prewTag; //UITextField的tag
    float prewMoveY; //编辑到时候移动到高度
    UIImageView*navBarHairlineImageView;
}
@property (nonatomic, strong) MONActivityIndicatorView* loadingView;

@end

@implementation CXZBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self registerHideKeyWindow];
    navBarHairlineImageView= [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.alpha=0.4;
    if (@available(iOS 11.0, *)) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL)shouldAutorotate{
    return _isAutorotate;
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

#pragma mark 初始化标题栏
// 返回
- (void) setupBack{
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 20, 20);
    // [back setTitle:@"返回" forState:UIControlStateNormal];
    // back.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    // [back setImage:[UIImage imageNamed:@"back_highlight"] forState:UIControlStateHighlighted];
    //  [back setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    //  [back setTitleEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [back addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = rightItem;
}
// 返回(图标为白色)
- (void) setupBackw{
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 20, 20);
    [back setImage:[UIImage imageNamed:@"secondBack"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = rightItem;
}
- (void) setupBackWithImage:(UIImage *)image withString:(NSString *)text{
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    //    CGSize sz = [text sizeWithFont:[UIFont boldSystemFontOfSize:14] width:100];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    
    back.frame = CGRectMake(-10, -1, 44, 44);
    [back setTitle:text forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [back setImage:image forState:UIControlStateNormal];
    [back setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [back addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:back];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void) setupNextWithImage:(UIImage *)image {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 46)];
    //    view.backgroundColor = [UIColor whiteColor];
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(45, 0, 44, 44);
    [back setImage:image forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:back];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void) setupNextWithArray:(NSArray*) array{
    self.navigationItem.rightBarButtonItems = array;
}

- (void) setupNextWithString:(NSString *)text {
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16] width:100];
    back.frame = CGRectMake(0, 0, size.width, 44);
    [back setTitle:text forState:UIControlStateNormal];
    [back setTitleColor:HexRGB(0x616161) forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void) setupBackWithString:(NSString *)text withColor:(UIColor *)color {
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16] width:100];
    back.frame = CGRectMake(0, 0, size.width, 44);
    [back setTitle:text forState:UIControlStateNormal];
    [back setTitleColor:color forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = rightItem;
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
    titleView.textColor = color;
    self.navigationItem.titleView = titleView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTitle)];
    titleView.userInteractionEnabled = YES;
    [titleView addGestureRecognizer:tap];
    
}

-(void)setUpNextWithFirstTitle:(NSString*)firstTitle Second:(NSString*)secondTitle
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    
    if (![NSString isBlankString:firstTitle]) {
        UIButton* firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        firstButton.frame = CGRectMake(0, 7, 40, 30);
        firstButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [firstButton setTitle:firstTitle forState:UIControlStateNormal];
        [firstButton addTarget:self action:@selector(clickRrightFirstItem) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:firstButton];
    }
    
    UIButton* secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton.frame = CGRectMake(40, 7, 40, 30);
    [secondButton setTitle:secondTitle forState:UIControlStateNormal];
    secondButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [secondButton addTarget:self action:@selector(clickRrightSecondItem) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:secondButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}

-(void)setUpNextWithFirstImages:(NSString*)firstImage Second:(NSString*)secondImage
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    
    if (![NSString isBlankString:firstImage]) {
        UIButton* firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        firstButton.frame = CGRectMake(0, 7, 30, 30);
        [firstButton setImage:[UIImage imageNamed:firstImage] forState:UIControlStateNormal];
        firstButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 0, 0);
        [firstButton addTarget:self action:@selector(clickRrightFirstItem) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:firstButton];
    }
    
    UIButton* secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton.frame = CGRectMake(36, 10, 24, 24);
    [secondButton setImage:[UIImage imageNamed:secondImage] forState:UIControlStateNormal];
    secondButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 0, 0);
    [secondButton addTarget:self action:@selector(clickRrightSecondItem) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:secondButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}


-(void)setupTitle{
    
}

#pragma mark 界面点击 关闭键盘用
-(void)removeTapGestureRecognizer
{
    NSMutableArray *newges = [NSMutableArray arrayWithArray:self.view.gestureRecognizers];
    for (int i =0; i<[newges count]; i++) {
        [self.view removeGestureRecognizer:[newges objectAtIndex:i]];
    }
    }

- (void)registerHideKeyWindow {
    if([self needRegisterHideKeyboard]) {
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyWindow)];
        tap.delegate = self;
        [self.view addGestureRecognizer:tap];
    }
}

- (void)hideKeyWindow {
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UICollectionViewCellContentView"]) {
        return NO;
    }
    if ( [NSStringFromClass([touch.view.superview class]) isEqualToString:@"UICollectionViewCell"]) {
        return NO;
    }
    //    NSLog(@"%@", NSStringFromClass([touch.view class]));
    return YES;
}

#pragma mark - 重载onback
- (void)onBack {
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
    
}

-(void)clickRrightFirstItem
{
    
}
-(void)clickRrightSecondItem
{
    
}

#pragma mark - 点击标题
- (void)clickTitle
{
    
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

//设置状态栏的颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}



@end
