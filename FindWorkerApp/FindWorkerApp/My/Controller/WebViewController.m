//
//  WebViewController.m
//  手保
//
//  Created by my-mac on 15/12/10.
//  Copyright © 2015年 my-mac. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "CXZ.h"


@interface WebViewController ()<UIWebViewDelegate>
{
    
    UIActivityIndicatorView *_activityView;
}


@property(nonatomic,retain)UIWebView * webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitleWithString:self.titleString withColor:[UIColor whiteColor]];
    [self setupBackw];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"secondBack"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBackBtn)];
//    self.navigationItem.leftBarButtonItem = item;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //这个属性让上面的navigation的不挡着内容
//    self.edgesForExtendedLayout=UIRectEdgeBottom;
    
    //这个属性让下面的tabbar占据的那块区域露出来
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.webView sizeToFit];
    [self.view addSubview:self.webView];
    
//    NSLog(@"***%@",self.urlStr);
    NSString *encodedString=[self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [[NSURL alloc]initWithString:encodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-15, SCREEN_HEIGHT/2-15, 30, 30)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityView.hidesWhenStopped = YES;
    [self.view addSubview:_activityView];
    [self.view bringSubviewToFront:_activityView];
     [_activityView startAnimating];
    
    if (self.isAboutUs) {
        [self setupTitleWithString:self.titleString withColor:TOP_GREEN];
    }
  
    if (self.isShare) {
         [self setupNextWithString:@"分享" withColor:[UIColor whiteColor]];
    }
    if (self.is_Send) {
        [self setupNextWithImage:[UIImage imageNamed:@"send"]];
    }
}

-(void)onNext
{
    if (self.isShare) {
        [self share];
    }else{
        if (self.is_Send) {
            [self sendOtherApp];
            
        }
       
    }
    
}

-(void)sendOtherApp
{
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *filesName = [NSString stringWithFormat:@"%@.%@",self.filesModel.file_name, self.filesModel.attribute];
    UIActivityViewController *activeViewController = [[UIActivityViewController alloc]initWithActivityItems:@[self.urlStr] applicationActivities:nil]; //不显示哪些分享平台(具体支持那些平台，可以查看Xcode的api)
  
    UIActivityViewControllerCompletionHandler myblock = ^(NSString *type,BOOL completed){
        NSLog(@"%d %@",completed,type);
    };
    activeViewController.completionHandler = myblock;
    [self.navigationController presentViewController:activeViewController animated:YES completion:nil]; //分享结果回调方法

}

-(void)share
{

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.titleString
                                     images:[UIImage imageNamed:@"旭邦装饰名片 - 副本"]
                                        url:[NSURL URLWithString:self.urlStr]
                                      title:@"合同"
                                       type:SSDKContentTypeAuto];
    NSArray *shareList = @[@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeWechatSession)];
    //、分享（可以弹出我们的分享菜单和编辑界面）
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                                                     items:shareList
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           
                                                           switch (state) {
                                                               case SSDKResponseStateSuccess:
                                                               {
                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                                                       message:nil
                                                                                                                      delegate:nil
                                                                                                             cancelButtonTitle:@"确定"
                                                                                                             otherButtonTitles:nil];
                                                                   [alertView show];
                                                                   break;
                                                               }
                                                               case SSDKResponseStateFail:
                                                               {
                                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                                                  delegate:nil
                                                                                                         cancelButtonTitle:@"OK"
                                                                                                         otherButtonTitles:nil, nil];
                                                                   [alert show];
                                                                   break;
                                                               }
                                                               default:
                                                                   break;
                                                           }
                                                       }
                                             ];
    
    
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)clickedBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView{
//    NSString *userAgent = [_webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//    
//    userAgent = [userAgent stringByAppendingString:@" Version/7.0 Safari/9537.53"];
//    
//    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent": userAgent}];
    NSLog(@"开始加载webview");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载webview完成");
    [_activityView stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"加载webview失败%@",[error description]);
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [_activityView startAnimating];
    
    NSLog(@"+---%@",[request.URL absoluteString]);
    
    return YES;
}



@end
