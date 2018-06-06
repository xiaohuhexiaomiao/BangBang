//
//  EditContractViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/3/22.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "EditWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "CXZ.h"

#import "SignNameViewController.h"
#import "AdressBookViewController.h"

@protocol JSObjcDelegate <JSExport>

-(void)onGeted:(BOOL)isSuccess WithError:(NSString*)error WithResult:(NSString*)result;

@end

@interface EditWebViewController ()<UIWebViewDelegate,JSObjcDelegate>
{
    
    UIActivityIndicatorView *_activityView;
}
@property(nonatomic,retain)UIWebView * webView;

@property (nonatomic, strong) JSContext *jsContext;


@end

@implementation EditWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitleWithString:self.titleString withColor:[UIColor whiteColor]];
    [self setupBackw];
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
    
    NSString *encodedString;
     // 0 编辑公司合同  1 编辑个人合同 2 编辑报验单  3 编辑结算单 4修改个人合同 5 修改报验单 6 修改结算单  7 查看个人合同 8 查看公司合同 9 查看报验单 10 查看结算单
    if (self.editType == 0) {
        encodedString = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_draft?operation=1&view=2&id=%li",API_HOST,self.form_Type_ID];
    }else if (self.editType == 1){
        encodedString = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_draft?operation=1&view=1&id=%li",API_HOST,self.form_Type_ID];
    }else if (self.editType == 2){
        encodedString = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_inspection?type=1&operation=1&form_type_id=%li",API_HOST,self.form_Type_ID];
    }else if (self.editType == 3){
        encodedString = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_inspection?type=2&operation=1&form_type_id=%li",API_HOST,self.form_Type_ID];
    }else if(self.editType == 4){
        encodedString=[NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_draft?operation=3&view=1&id=%li",API_HOST,self.contractID];
    }else if (self.editType == 5){
        encodedString = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_inspection?type=1&operation=3&form_id=%li",API_HOST,self.formid];
    }else if (self.editType == 6){
        encodedString = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_inspection?type=2&operation=3&form_id=%li",API_HOST,self.formid];
    }else if (self.editType == 7){
        encodedString =[NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_draft?operation=2&view=1&id=%li",API_HOST,self.contractID];
    }else if (self.editType == 8){
        encodedString =[NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_draft?operation=2&view=2&id=%li",API_HOST,self.contractID];
    }else if (self.editType == 9){
        encodedString = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_inspection?type=1&operation=2&form_id=%li",API_HOST,self.formid];
    }else if (self.editType == 10){
        encodedString = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_inspection?type=2&operation=2&form_id=%li",API_HOST,self.formid];
    }else if (self.editType == 11){
        encodedString = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_inspection_company?type_id=%li",API_HOST,self.form_Type_ID];
    }else if (self.editType == 12){
        encodedString = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_inspection_company?type_id=%li&form_id=%li",API_HOST,self.self.form_Type_ID,self.formid];
    }else if (self.editType == 13){
        encodedString = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_inspection_company?approval_id=%li",API_HOST,self.formid];
    }
    NSURL *url = [[NSURL alloc]initWithString:encodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-15, SCREEN_HEIGHT/2-15, 30, 30)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityView.hidesWhenStopped = YES;
    [self.view addSubview:_activityView];
    [self.view bringSubviewToFront:_activityView];
    [_activityView startAnimating];
    
    if (self.editType == 0) {
        [self setupNextWithString:@"保存" withColor:[UIColor whiteColor]];
    }else if(self.editType == 7 || self.editType == 8||self.editType == 9||self.editType == 10){
//        [self setupNextWithString:@"下一步" withColor:[UIColor whiteColor]];
    }else if(self.editType == 1){
        [self setupNextWithString:@"下一步" withColor:[UIColor whiteColor]];
    }else if(self.editType == 11){
        [self setupNextWithString:@"发送" withColor:[UIColor whiteColor]];
    }else{
        [self setupNextWithString:@"提交" withColor:[UIColor whiteColor]];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onNext
{
    NSString *jsStr = @"getCustomFormResult()";
     [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
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


#pragma mark - JSObjcDelegate

-(void)onGeted:(BOOL)isSuccess WithError:(NSString*)error WithResult:(NSString*)result
{
//    NSLog(@"***%i***%@**%@",isSuccess,error,result);
    if (isSuccess) {
        if (self.editType == 0) {
            [[NetworkSingletion sharedManager]addCompanyContractNew:@{@"contract_type_id":@(self.form_Type_ID),@"content_json":result} onSucceed:^(NSDictionary *dict) {
                if ([dict[@"code"] integerValue]==0) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [MBProgressHUD showError:dict[@"message"] toView:self.view];
                }
            } OnError:^(NSString *error) {
                [MBProgressHUD showError:error toView:self.view];

            }];
        }
        
        if (self.editType == 1) {
            SignNameViewController *signVC = [[SignNameViewController alloc]init];
            signVC.signType = 1;
            signVC.contentJson = result;
            signVC.projectID = self.projectID;
            signVC.contranctTypeID = self.form_Type_ID;
            signVC.workID = self.workID;
            signVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:signVC animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }
        
        if (self.editType == 4) {
            SignNameViewController *signVC = [[SignNameViewController alloc]init];
            signVC.signType = 4;
            signVC.contentJson = result;
            signVC.contranctTypeID = self.form_Type_ID;
            signVC.contranctID = self.contractID;
            signVC.workID = self.workID;
            signVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:signVC animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }
        if (self.editType == 2) {
            NSDictionary *dict = @{@"contract_id":@(self.contractID),@"inspection_type":@(self.form_Type_ID),@"result_ids":result,@"type":@(1)};
            
            [[NetworkSingletion sharedManager]addAccpectForm:dict onSucceed:^(NSDictionary *dict) {
                //                NSLog(@"*wewrew**%@***%@",dict,dict[@"message"]);
                if ([dict[@"code"] integerValue]==0) {
                    NSString *inspection_id = [NSString stringWithFormat:@"%li",[dict[@"data"] integerValue]];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"SENDACCEPTSUCCESS" object:nil];
                    [[NSUserDefaults standardUserDefaults] setObject:inspection_id forKey:@"inspection_id"];
                    //                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1 ] animated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } OnError:^(NSString *error) {
                [MBProgressHUD showError:error toView:self.view];
            }];
        }else if (self.editType == 3){
            NSDictionary *dict = @{@"contract_id":@(self.contractID),@"settlement_type":@(self.form_Type_ID),@"result_ids":result,@"type":@(1)};
            [[NetworkSingletion sharedManager]addSettlementForm:dict onSucceed:^(NSDictionary *dict) {
                if ([dict[@"code"] integerValue]==0) {
                    NSString *settlement_id = [NSString stringWithFormat:@"%li",[dict[@"data"] integerValue]];
                    [[NSUserDefaults standardUserDefaults] setObject:settlement_id forKey:@"settlement_id"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"SENDACCEPTSUCCESS" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } OnError:^(NSString *error) {
                [MBProgressHUD showError:error toView:self.view];
            }];
        }else if (self.editType == 5){
            NSDictionary *dict = @{@"contract_id":@(self.contractID),@"result_ids":result,@"type":@(2),@"apply_id":@(self.apply_id)};
            [[NetworkSingletion sharedManager]addAccpectForm:dict onSucceed:^(NSDictionary *dict) {
                if ([dict[@"code"] integerValue]==0) {
                    NSString *inspection_id = [NSString stringWithFormat:@"%li",[dict[@"data"] integerValue]];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"SENDACCEPTSUCCESS" object:nil];
                    [[NSUserDefaults standardUserDefaults] setObject:inspection_id forKey:@"inspection_id"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } OnError:^(NSString *error) {
                [MBProgressHUD showError:error toView:self.view];
            }];
        }else if (self.editType == 6){
            NSDictionary *dict = @{@"contract_id":@(self.contractID),@"result_ids":result,@"type":@(2),@"apply_id":@(self.apply_id)};
            [[NetworkSingletion sharedManager]addSettlementForm:dict onSucceed:^(NSDictionary *dict) {
                if ([dict[@"code"] integerValue]==0) {
                    NSString *settlement_id = [NSString stringWithFormat:@"%li",[dict[@"data"] integerValue]];
                    [[NSUserDefaults standardUserDefaults] setObject:settlement_id forKey:@"settlement_id"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"SENDACCEPTSUCCESS" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } OnError:^(NSString *error) {
                [MBProgressHUD showError:error toView:self.view];
            }];
        }else if (self.editType == 11||self.editType ==  12){
            AdressBookViewController *bookVC = [[AdressBookViewController alloc]init];
            bookVC.companyid = self.company_id;
            bookVC.isSelect = YES;
            bookVC.operation_type = 3;
            bookVC.loadDataType = 2;
            bookVC.form_type = self.form_Type_ID;
            bookVC.result_json_string = result;
            bookVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bookVC animated:YES];
            self.hidesBottomBarWhenPushed = YES;
            
        }

    }else{
        [MBProgressHUD showError:error toView:self.view];
    }
    
    
}


@end
