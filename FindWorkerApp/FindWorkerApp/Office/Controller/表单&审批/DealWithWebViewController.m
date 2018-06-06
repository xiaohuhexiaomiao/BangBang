//
//  DealWithWebViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/6/4.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "DealWithWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "CXZ.h"

#import "SignNameViewController.h"
#import "AdressBookViewController.h"

@protocol JSObjcDelegate <JSExport>

-(void)onGeted:(BOOL)isSuccess WithError:(NSString*)error WithResult:(NSString*)result;

@end

@interface DealWithWebViewController ()<UIWebViewDelegate,JSObjcDelegate>
{
    
    UIActivityIndicatorView *_activityView;
}
@property(nonatomic,retain)UIWebView * webView;

@property(nonatomic, strong)DealWithApprovalView *dealView;

@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation DealWithWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"报销单" withColor:[UIColor whiteColor]];
    [self config];
    [self removeTapGestureRecognizer];
    if (self.is_aready_approval) {
        if (self.is_cancel) {
            [self setUpNextWithFirstImages:nil Second:@"feedback"];
        }else{
            [self setUpNextWithFirstImages:nil Second:@"download"];
        }
    }
}

-(void)config{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //这个属性让上面的navigation的不挡着内容
    //    self.edgesForExtendedLayout=UIRectEdgeBottom;
    
    //这个属性让下面的tabbar占据的那块区域露出来
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.webView sizeToFit];
    [self.view addSubview:self.webView];
    
    NSString *encodedString= [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_inspection_company?approval_id=%@",API_HOST,self.approvalID];
    NSURL *url = [[NSURL alloc]initWithString:encodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-15, SCREEN_HEIGHT/2-15, 30, 30)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityView.hidesWhenStopped = YES;
    [self.view addSubview:_activityView];
    
    [_activityView startAnimating];
    
    if (!self.is_aready_approval) {
//         self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-40);
        _dealView = [[DealWithApprovalView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-113, SCREEN_WIDTH, 40)];
        _dealView.photoBtn.hidden = YES;
        _dealView.is_sign = YES;
        _dealView.approvalID = self.approvalID;
        _dealView.participation_id = self.participation_id;
        _dealView.canApproval = YES;
         [self.view addSubview:_dealView];
        [_dealView setApprovalMenueView];
       
    }
    
    
    
    
    
    
}

#pragma mark public Method


-(void)clickRrightSecondItem
{
    if (self.is_cancel == 0) {
        NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                    @"approval_id":self.approvalID,
                                    @"company_id":self.company_id,
                                    @"participation_id":self.participation_id};
        [[NetworkSingletion sharedManager]getLoadToken:paramDict onSucceed:^(NSDictionary *dict) {
            //            NSLog(@"load %@",dict);
            if ([dict[@"code"] integerValue] == 0) {
                NSString *token = dict[@"data"];
                NSString *urlStr = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/aaampd_picture?token=%@",API_HOST,token];
                NSURL *url = [NSURL URLWithString:urlStr];
                [[UIApplication sharedApplication] openURL:url];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
            
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
        
    }else{//重新编辑
        EditWebViewController *web = [[EditWebViewController alloc]init];
        
        web.editType = 12;
        web.company_id = self.company_id;
        web.formid = [self.approvalID integerValue];
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}
#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    self.jsContext[@"FindworkersHtmlCustomform"] = self;
    //    NSLog(@"加载webview完成");
    [_activityView stopAnimating];
    
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"加载webview失败%@",[error description]);
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [_activityView startAnimating];
    
    
    return YES;
}

#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
