//
//  ShowPayViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/22.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ShowPaymentsViewController.h"
#import "CXZ.h"
#import "EnclosureView.h"
#import "DealWithApprovalView.h"
#import "ApprovalContentView.h"
#import "SalaryView.h"
#import "ApprovalTableView.h"

#import "PaymentModel.h"
#import "ApprovalResultModel.h"

#import "ShowFileViewController.h"
#import "ShowCompanyViewController.h"
#import "ShowPurchaseViewController.h"
#import "CompanyReviewViewController.h"

@interface ShowPaymentsViewController ()<EnclosureViewDelegate,SalaryViewDelegate>

@property(nonatomic ,strong)UIScrollView *bgScrollview;

//@property(nonatomic ,strong)UIButton *isHomeButton;//合同
//
//@property(nonatomic ,strong)UIButton *nohomeButton;//请购单

@property(nonatomic, strong)UILabel *projectLabel;//工程名称

@property(nonatomic ,strong)UILabel *contract_name_label;//合同

@property(nonatomic ,strong)EnclosureView *enclosureView;

@property(nonatomic ,strong)UILabel *woker_type_label;//工种

@property(nonatomic ,strong)UILabel *pay_name_label;//请款姓名

@property(nonatomic ,strong)UILabel *pay_phone_label;//请款人电话

@property(nonatomic ,strong)UILabel *account_name_label;//账户名

@property(nonatomic ,strong)UILabel *bank_name_label;//开户行

@property(nonatomic ,strong)UILabel *account_num_label;//账号

@property(nonatomic ,strong)UILabel *pay_number_label;//请款次数

@property(nonatomic ,strong)UILabel *total_money_label;//合同金额

@property(nonatomic ,strong)UILabel *less_money_label;//增减金额

@property(nonatomic ,strong)UILabel *already_get_label;//已领金额

@property(nonatomic ,strong)UILabel *current_apply_label;//本次请款

@property(nonatomic ,strong)UILabel *progress_label;//合同执行进度

@property(nonatomic ,strong)UILabel *apply_content_label;//请款内容

@property(nonatomic ,strong)UILabel *project_manager_label;//项目经理

@property(nonatomic, strong)UIImageView *wasteImageview;//作废标识

@property(nonatomic ,strong)ShowFilesView *showFielsView;//

@property(nonatomic ,strong)UIView *lastView;

@property(nonatomic ,strong)UILabel *approvalLabel;//审批人员展示

@property(nonatomic ,strong)UILabel *sponsorLabel;//发起人

@property(nonatomic , strong) DealWithApprovalView *dealView;

@property(nonatomic , assign) NSInteger isDownload;

@property(nonatomic , strong) PaymentModel *paymentModel;

@property(nonatomic ,copy)NSString *participation_id;//

@property(nonatomic ,copy)NSString *companyID;
@end

@implementation ShowPaymentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"请款单" withColor:[UIColor whiteColor]];
    [self config];
    [self removeTapGestureRecognizer];

    
    if (self.is_aready_approval) {
        if (self.is_copy) {
            [self setupNextWithString:@"复制全部" withColor:[UIColor whiteColor]];
        }else{
            if (self.is_cancel) {
                [self setUpNextWithFirstImages:@"cancel" Second:@"download"];
            }else{
                [self setUpNextWithFirstImages:nil Second:@"download"];
            }
            
        }
    }
    if (self.form_type == 0) {
        [self loadDetailData];
    }else{
        [self loadPersonDetailData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark View Delegate

//查看工人工资表附件
-(void)checkContract:(NSInteger)tag
{
    NSDictionary *dict = self.paymentModel.worker_contract_id[tag];
    [self checkContractWithType:[dict[@"type"] integerValue] contractID:dict[@"contract_id"]];
}

-(void)clickEnclosure
{
    if (self.paymentModel.approval_type ==1 ||self.paymentModel.approval_type ==2)  {
        CompanyReviewViewController *reviewVC = [[CompanyReviewViewController alloc]init];
        reviewVC.typeStr = [NSString stringWithFormat:@"%@",@(self.paymentModel.approval_type)];
        reviewVC.is_aready_approval = YES;
        reviewVC.is_approval = YES;
        reviewVC.company_id = self.companyID;
        reviewVC.approval_id = self.paymentModel.form_approval_id;
        reviewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:reviewVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (self.paymentModel.approval_type ==3 || self.paymentModel.approval_type ==7||self.paymentModel.approval_type ==10){
        ShowPurchaseViewController *companyVC = [[ShowPurchaseViewController alloc]init];
        companyVC.is_aready_approval = YES;
        companyVC.approvalID = self.paymentModel.form_approval_id;;
        companyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:companyVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (self.paymentModel.approval_type==6){
        ShowFileViewController *fileVC = [[ShowFileViewController alloc]init];
        fileVC.is_aready_approval = YES;
        fileVC.approvalID = self.paymentModel.form_approval_id;
        
        fileVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fileVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (self.paymentModel.approval_type == 111) {
        ShowCompanyViewController *companyVC = [[ShowCompanyViewController alloc]init];
        companyVC.is_aready_approval = YES;
        companyVC.approval_id = self.paymentModel.form_approval_id;
        companyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:companyVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark 点击事件

-(void)checkContractWithType:(NSInteger)type contractID:(NSString*)contractID
{
    if (type == 3) {
        [[NetworkSingletion sharedManager]getReviewAnnexDetail:@{@"enclosure_id":contractID} onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue]==0) {
                NSArray *imgArray = [dict[@"data"] objectForKey:@"picture"];
                NSMutableArray *photoArray = [NSMutableArray array];
                for (int i = 0 ; i < imgArray.count ; i++) {
                    NSString *pic = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,imgArray[i]];
                    ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                    photo.photoURL = [NSURL URLWithString:pic];
                    [photoArray addObject:photo];
                }
                ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
                // 淡入淡出效果
                // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
                // 数据源/delegate
                pickerBrowser.editing = NO;
                pickerBrowser.photos = photoArray;
                // 当前选中的值
                pickerBrowser.currentIndex = 0;
                // 展示控制器
                [pickerBrowser showPickerVc:self];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }else if(type == 1){
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"app_token"];
        NSString *uid =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
        NSString *urlStr = [NSString stringWithFormat:@"%@/index.php/Mobile/find/contract_company_detail?skey=%@&skey_uid=%@&id=%@",API_HOST,token,uid,contractID];
        WebViewController *web = [WebViewController new];
        web.urlStr = urlStr;
        web.title = @"合同详情";
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if(type == 4 ){
        [[NetworkSingletion sharedManager]lookFilesDetail:@{@"attachments_id":contractID} onSucceed:^(NSDictionary *dict) {
            
            if ([dict[@"code"] integerValue]==0) {
                FilesModel *files = [FilesModel objectWithKeyValues:dict[@"data"]];
                NSString *urlString = [NSString stringWithFormat:@"%@%@",IMAGE_HOST, files.attachments];
                WebViewController *docVC = [[WebViewController alloc]init];
                docVC.urlStr = urlString;
                docVC.filesModel = files;
                docVC.titleString = files.file_name;
                docVC.is_Send = YES;
                [self.navigationController pushViewController:docVC animated:YES];
                //                NSURL *url = [NSURL URLWithString:urlString];
                //                [[UIApplication sharedApplication] openURL:url];
                
            }
            
        } OnError:^(NSString *error) {
            
        }];
    }else{
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"app_token"];
        NSString *uid =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
        NSString *urlStr = [NSString stringWithFormat:@"%@/index.php/Mobile/find/contract_company_detail?skey=%@&skey_uid=%@&id=%@",API_HOST,token,uid,contractID];
        WebViewController *web = [WebViewController new];
        web.urlStr = urlStr;
        web.title = @"合同详情";
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}


#pragma mark Systom Method
-(void)onNext
{
    if (self.is_copy) {
        [self.delegate copyPaymentFormsAll:self.paymentModel];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


-(void)clickRrightFirstItem
{
    if (self.isDownload == 0 || self.isDownload == 1 ) {
        
        InputReasonViewController *inputVC = [[InputReasonViewController alloc]init];
        inputVC.inputType = 0;
        inputVC.company_id = self.companyID;
        inputVC.approval_id = self.approvalID;
        inputVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:inputVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        
    }else if (self.isDownload == 2){
        [WFHudView showMsg:@"审批被拒绝，不能撤回.." inView:self.view];
    }else if (self.isDownload == 3){
        [WFHudView showMsg:@"审批已撤回" inView:self.view];
    }else if (self.isDownload == 4){
        [WFHudView showMsg:@"已作废无法撤回" inView:self.view];
    }
}

-(void)clickRrightSecondItem
{
    if (self.isDownload == 0) {
        [WFHudView showMsg:@"审批未结束，暂不能下载" inView:self.view];
    }else{
        NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                    @"approval_id":self.approvalID,
                                    @"company_id":self.companyID,
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
    }
}

#pragma mark 数据
-(void)loadDetailData
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"approval_id":self.approvalID};
    [[NetworkSingletion sharedManager]getContractReviewDetail:paramDict onSucceed:^(NSDictionary *dict) {
//                        NSLog(@"**detail*%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            PaymentModel *detailModel = [PaymentModel objectWithKeyValues:dict[@"data"]];
            self.paymentModel = detailModel;
            self.companyID = detailModel.company_id;
            if (![NSString isBlankString:detailModel.contract_name]) {
                self.projectLabel.text = detailModel.contract_name;
                CGSize size = CGSizeMake(self.projectLabel.width,CGFLOAT_MAX);
                CGSize titleSize = [detailModel.contract_name sizeWithFont:self.projectLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat titleHeiht = fmax(30, titleSize.height+10);
                [self.projectLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(titleHeiht);
                }];
            }
            if (![NSString isBlankString:detailModel.form_approval_id]) {
                self.enclosureView.hidden = NO;
            }
            if (![NSString isBlankString:detailModel.contract_name_new]) {
                self.contract_name_label.text = detailModel.contract_name_new;
                CGSize contranct_name_label_size = CGSizeMake(self.contract_name_label.width,CGFLOAT_MAX);
                CGSize contranct_name_size = [detailModel.contract_name_new sizeWithFont:self.contract_name_label.font constrainedToSize:contranct_name_label_size lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat contract_name_height = fmax(30, contranct_name_size.height+10);
                [self.contract_name_label mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(contract_name_height);
                }];
            }
            
            self.woker_type_label.text = detailModel.worker_type;
            self.pay_name_label.text = detailModel.request_name;
            self.pay_phone_label.text = detailModel.phone;
            self.account_name_label.text = detailModel.account_name;
            self.bank_name_label.text = detailModel.bank_address;
            self.account_num_label.text = detailModel.bank_card;
            self.pay_number_label.text =detailModel.request_num;
            self.total_money_label.text = detailModel.subtotal;
            self.less_money_label.text = detailModel.gain_reduction_subtotal;
            self.already_get_label.text = detailModel.balance_subtotal;
            self.current_apply_label.text = detailModel.request_subtotal;
            
            self.progress_label.text = detailModel.contract_state;
            CGSize progresssize = CGSizeMake(self.progress_label.width,CGFLOAT_MAX);
            CGSize progresstitleSize = [detailModel.contract_state sizeWithFont:self.progress_label.font constrainedToSize:progresssize lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat progresstitleHeiht = fmax(30, progresstitleSize.height+10);
            [self.progress_label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(progresstitleHeiht);
            }];
            
            self.apply_content_label.text = detailModel.request_content;
            CGSize applysize = CGSizeMake(self.apply_content_label.width,CGFLOAT_MAX);
            CGSize applytitleSize = [detailModel.request_content sizeWithFont:self.apply_content_label.font constrainedToSize:applysize lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat applytitleHeiht = fmax(30, applytitleSize.height+10);
            [self.apply_content_label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(applytitleHeiht);
            }];
            
            
            if (detailModel.project_manager_name) {
                self.project_manager_label.text = detailModel.project_manager_name[@"name"];
            }
            
            NSMutableArray *fileArray = [NSMutableArray array];
            if (detailModel.contract_id.count > 0) {
                
                [fileArray addObjectsFromArray:detailModel.contract_id];
            }
            if (detailModel.many_enclosure.count > 0) {
                [fileArray addObjectsFromArray:detailModel.many_enclosure];
            }
            CGFloat fileHeight = [self.showFielsView setShowFilesViewWithArray:fileArray];
            [self.showFielsView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(fileHeight);
            }];
            
            [self setWorkMoneyListWithArray:detailModel];
            
            self.bgScrollview.hidden = NO;
            [self loadResultData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}
//获取审批处理结果
-(void)loadResultData
{
    NSDictionary *paramDict = @{@"company_id":self.companyID,
                                @"approval_id":self.approvalID,
                                @"type":@"0",
                                @"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]};
    [[NetworkSingletion sharedManager]getReviewResult:paramDict onSucceed:^(NSDictionary *dict) {
//                        NSLog(@"**result*%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            ApprovalResultModel *resultModel = [ApprovalResultModel objectWithKeyValues:dict[@"data"]];
            self.participation_id = resultModel.participation_id;
            if (!self.is_aready_approval) {
                self.dealView.approvalID = self.approvalID;
                self.dealView.participation_id = self.participation_id;
                self.dealView.personal_id = self.personal_id;
                self.dealView.company_ID = self.companyID;
            }

            
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in resultModel.list) {
                [array addObject:dict[@"name"]];
            }
            NSString *approvalStr = [array componentsJoinedByString:@"、"];
            self.approvalLabel.text = [NSString stringWithFormat:@"审批人员：%@",approvalStr];
            self.sponsorLabel.text = [NSString stringWithFormat:@"发起人：%@",resultModel.found_name];
            if (resultModel.content.count > 0) {
                ApprovalTableView *approvalView = [[ApprovalTableView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
                approvalView.is_reply = self.is_reply;
                approvalView.approvalID = self.approvalID;
                approvalView.companyID = self.companyID;
                [self.bgScrollview addSubview:approvalView];
                [approvalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(_lastView.mas_bottom);
                    make.left.mas_equalTo(0);
                    make.width.mas_equalTo(SCREEN_WIDTH);
                    make.height.mas_equalTo(SCREEN_HEIGHT-64);
                }];
                [approvalView setApprovalTableViewWithModel:resultModel];
                _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+SCREEN_HEIGHT-64);
                
            }

//            for (int i = 0; i < resultModel.content.count; i++ ) {
//                [self addApprovalviewWithDict:resultModel.content[i]];
//            }
//            if (resultModel.finance) {
//                [self addCashierReplyContentView:resultModel.finance];
//            }
            
            
            self.isDownload = resultModel.is_ok;
            if (resultModel.is_ok == 4) {
                self.wasteImageview.hidden = NO;
                [self.bgScrollview bringSubviewToFront:self.wasteImageview];
            }
            self.participation_id = resultModel.participation_id;
            
            
            if (!self.is_cashier) {
                self.dealView.is_sepcial = self.is_sepcial;
                self.dealView.canApproval = resultModel.can_approval;
                [self.dealView setApprovalMenueView];;
            }
           
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        
        [MBProgressHUD showError:error toView:self.view];
    }];
}

-(void)loadPersonDetailData
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"approval_personal_id":self.approvalID};
    [[NetworkSingletion sharedManager]getPersonalApprovalDetail:paramDict onSucceed:^(NSDictionary *dict) {
//                                NSLog(@"**detail*%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            PaymentModel *detailModel = [PaymentModel objectWithKeyValues:dict[@"data"]];
            self.paymentModel = detailModel;
            self.companyID = detailModel.company_id;
            if (![NSString isBlankString:detailModel.contract_name]) {
                self.projectLabel.text = detailModel.contract_name;
                CGSize size = CGSizeMake(self.projectLabel.width,CGFLOAT_MAX);
                CGSize titleSize = [detailModel.contract_name sizeWithFont:self.projectLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat titleHeiht = fmax(30, titleSize.height+10);
                [self.projectLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(titleHeiht);
                }];
            }
            if (![NSString isBlankString:detailModel.form_approval_id]) {
                self.enclosureView.hidden = NO;
            }
            if (![NSString isBlankString:detailModel.contract_name_new]) {
                self.contract_name_label.text = detailModel.contract_name_new;
                CGSize contranct_name_label_size = CGSizeMake(self.contract_name_label.width,CGFLOAT_MAX);
                CGSize contranct_name_size = [detailModel.contract_name_new sizeWithFont:self.contract_name_label.font constrainedToSize:contranct_name_label_size lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat contract_name_height = fmax(30, contranct_name_size.height+10);
                [self.contract_name_label mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(contract_name_height);
                }];
            }
            
            self.woker_type_label.text = detailModel.worker_type;
            self.pay_name_label.text = detailModel.request_name;
            self.pay_phone_label.text = detailModel.phone;
            self.account_name_label.text = detailModel.account_name;
            self.bank_name_label.text = detailModel.bank_address;
            self.account_num_label.text = detailModel.bank_card;
            self.pay_number_label.text =detailModel.request_num;
            self.total_money_label.text = detailModel.subtotal;
            self.less_money_label.text = detailModel.gain_reduction_subtotal;
            self.already_get_label.text = detailModel.balance_subtotal;
            self.current_apply_label.text = detailModel.request_subtotal;
            
            self.progress_label.text = detailModel.contract_state;
            CGSize progresssize = CGSizeMake(self.progress_label.width,CGFLOAT_MAX);
            CGSize progresstitleSize = [detailModel.contract_state sizeWithFont:self.progress_label.font constrainedToSize:progresssize lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat progresstitleHeiht = fmax(30, progresstitleSize.height+10);
            [self.progress_label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(progresstitleHeiht);
            }];
            
            self.apply_content_label.text = detailModel.request_content;
            CGSize applysize = CGSizeMake(self.apply_content_label.width,CGFLOAT_MAX);
            CGSize applytitleSize = [detailModel.request_content sizeWithFont:self.apply_content_label.font constrainedToSize:applysize lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat applytitleHeiht = fmax(30, applytitleSize.height+10);
            [self.apply_content_label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(applytitleHeiht);
            }];
            
//            
//            if (detailModel.project_manager_name) {
//                self.project_manager_label.text = detailModel.project_manager_name[@"name"];
//            }
            
            NSMutableArray *fileArray = [NSMutableArray array];
            if (detailModel.contract_id.count > 0) {
                
                [fileArray addObjectsFromArray:detailModel.contract_id];
            }
            if (detailModel.many_enclosure.count > 0) {
                [fileArray addObjectsFromArray:detailModel.many_enclosure];
            }
            CGFloat fileHeight = [self.showFielsView setShowFilesViewWithArray:fileArray];
            [self.showFielsView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(fileHeight);
            }];
            
            [self setWorkMoneyListWithArray:detailModel];
            
            if (!self.is_aready_approval) {
                self.dealView.approval_personal_id = self.approvalID;
                self.dealView.company_ID = self.companyID;
                self.dealView.formType = 1;
            }
            
            self.approvalLabel.text = [NSString stringWithFormat:@"审批人员：%@",detailModel.approval_content.handler_name];
            self.sponsorLabel.text = [NSString stringWithFormat:@"发起人：%@",detailModel.approval_content.found_name];
            if (detailModel.approval_content.approval_state != 0) {
                ApprovalContentView *approvalView = [[ApprovalContentView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 40)];
                CGFloat contentHeight = [approvalView setApprovalContentWith:detailModel.approval_content];
                CGRect frame = approvalView.frame;
                frame.size.height = contentHeight;
                approvalView.frame = frame;
                [self.bgScrollview addSubview:approvalView];
                [approvalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(_lastView.mas_bottom);
                    make.left.mas_equalTo(0);
                    make.width.mas_equalTo(SCREEN_WIDTH);
                    make.height.mas_equalTo(contentHeight);
                }];
                
                _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+contentHeight+100);
                
            }
            self.bgScrollview.hidden = NO;
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];

}




#pragma mark 界面


-(void)setWorkMoneyListWithArray:(PaymentModel*)model
{

    if (model.worker_contract_id.count > 0) {
        UILabel *label = [CustomView customTitleUILableWithContentView:_bgScrollview title:@"工人工资表"];
        label.frame = CGRectMake(8, _lastView.bottom, SCREEN_WIDTH-16, 30);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_lastView.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo( 30);
        }];
        _lastView = label;
        for (int i = 0; i < model.worker_contract_id.count; i++) {
            NSDictionary *dict = model.worker_contract_id[i];
            SalaryView *salaryView = [[SalaryView alloc]initWithFrame:CGRectMake(8, _lastView.bottom, SCREEN_WIDTH-16, 100)];
            [_bgScrollview addSubview:salaryView];
            salaryView.tag = i;
            salaryView.delegate = self;
            [salaryView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(_lastView.mas_bottom);
                make.width.mas_equalTo(SCREEN_WIDTH-16);
                make.height.mas_equalTo(100);
            }];
            [salaryView showSalaryViewWithDict:dict];
            _lastView = salaryView;
            _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+100);
        }
    }
    
    _sponsorLabel = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    _sponsorLabel.frame = CGRectMake(8, _lastView.bottom, SCREEN_WIDTH-16, 20);
    [_sponsorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_lastView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(20);
    }];
    
    _approvalLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, _sponsorLabel.bottom, SCREEN_WIDTH-16, 30)];
    _approvalLabel.numberOfLines  = 2;
    _approvalLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    _approvalLabel.textColor = TITLECOLOR;
    [_bgScrollview addSubview:_approvalLabel];
    [_approvalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_sponsorLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(35);
    }];
    
    _lastView = _approvalLabel;
    _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, _approvalLabel.bottom+100);
//    NSLog(@"content %@",NSStringFromCGSize(_bgScrollview.contentSize));
//    NSLog(@"**%@",NSStringFromCGRect(_approvalLabel.frame));
}



//添加回执内容
-(void)addCashierReplyContentView:(NSDictionary*)dict
{
    CashierReplyContentView *cashierView = [[CashierReplyContentView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 40)];
    CGFloat height = [cashierView setCashierReplyContentWith:dict];
    CGRect frame = cashierView.frame;
    frame.size.height = height;
    cashierView.frame = frame;
    cashierView.replyContentDict = dict;
    [_bgScrollview addSubview:cashierView];
    [cashierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_lastView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(height);
    }];
    _lastView = cashierView;
    _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+100);
}

-(void)config
{
    _bgScrollview = [[UIScrollView alloc]init];
    _bgScrollview.showsVerticalScrollIndicator = NO;
    _bgScrollview.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_bgScrollview];
    _bgScrollview.bounces = NO;
    [_bgScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //------
    _wasteImageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"feiqi"]];
    _wasteImageview.transform = CGAffineTransformMakeRotation(-M_PI/12);
    _wasteImageview.alpha = 0.6;
    [_bgScrollview addSubview:_wasteImageview];
    _wasteImageview.hidden = YES;
    [_wasteImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCREEN_WIDTH/2-105);
        make.top.mas_equalTo(SCREEN_HEIGHT/2-50);
        make.width.mas_equalTo(210);
        make.height.mas_equalTo(140);
    }];

    //------
    NSString *title = @"工程名称：";
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *titleLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:title];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(titleSize.width+0.5);
        make.height.mas_equalTo(30);
    }];
    
    
    _projectLabel = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_right);
        make.top.mas_equalTo(titleLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line1 = [CustomView customLineView:_bgScrollview];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_projectLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
    //------
    NSString *contract = @"合同名称：";
    CGSize contractSize = [contract sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *contractLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:contract];
    [contractLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line1.mas_bottom);
        make.width.mas_equalTo(contractSize.width+0.1);
        make.height.mas_equalTo(30);
    }];
    
    _contract_name_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_contract_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contractLbl.mas_right);
        make.top.mas_equalTo(contractLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-35);
        make.height.mas_equalTo(30);
    }];
    
    _enclosureView = [[EnclosureView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-35, line1.bottom, 35, 35)];
    [_bgScrollview addSubview:_enclosureView];
    [_enclosureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contract_name_label.mas_right);
        make.top.mas_equalTo(_contract_name_label.mas_top);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(30);
    }];
    _enclosureView.hidden = YES;
    _enclosureView.deleteButton.hidden = YES;
    _enclosureView.delegate = self;
    
    
    UIView *line2 = [CustomView customLineView:_bgScrollview];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_contract_name_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
    //--------
    NSString *woker = @"工种：";
    CGSize wokerSize = [woker sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *wokerLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:woker];
    [wokerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line2.mas_bottom);
        make.width.mas_equalTo(wokerSize.width+0.5);
        make.height.mas_equalTo(30);
    }];
    
    
    _woker_type_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_woker_type_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wokerLbl.mas_right);
        make.top.mas_equalTo(wokerLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line3 = [CustomView customLineView:_bgScrollview];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_woker_type_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
    //----
    NSString *payname = @"请款人：";
    CGSize paynameSize = [payname sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *paynameLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:payname];
    [paynameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line3.mas_bottom);
        make.width.mas_equalTo(paynameSize.width+0.5);
        make.height.mas_equalTo(30);
    }];
    
    
    _pay_name_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_pay_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(paynameLbl.mas_right);
        make.top.mas_equalTo(paynameLbl.mas_top);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    NSString *payphone = @"联系方式：";
    CGSize payphoneSize = [payphone sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *payphoneLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:payphone];
    [payphoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_pay_name_label.mas_right);
        make.top.mas_equalTo(paynameLbl.mas_top);
        make.width.mas_equalTo(payphoneSize.width+0.5);
        make.height.mas_equalTo(30);
    }];
    
    
    _pay_phone_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_pay_phone_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(payphoneLbl.mas_right);
        make.top.mas_equalTo(payphoneLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line4 = [CustomView customLineView:_bgScrollview];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_pay_phone_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
    //------
    NSString *account = @"账户名：";
    CGSize accountSize = [account sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *accountLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:account];
    [accountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line4.mas_bottom);
        make.width.mas_equalTo(accountSize.width+0.5);
        make.height.mas_equalTo(25);
    }];
    
    
    _account_name_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_account_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(accountLbl.mas_right);
        make.top.mas_equalTo(accountLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).offset(-8);
        make.height.mas_equalTo(accountLbl.mas_height);
    }];
    
    NSString *bank = @"开户行：";
    CGSize bankSize = [bank sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *bankLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:bank];
    [bankLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_account_name_label.mas_bottom);
        make.width.mas_equalTo(bankSize.width+0.5);
        make.height.mas_equalTo(accountLbl.mas_height);
    }];
    
    
    _bank_name_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_bank_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bankLbl.mas_right);
        make.top.mas_equalTo(bankLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).offset(-8);
        make.height.mas_equalTo(accountLbl.mas_height);
    }];
    
    NSString *acountNum = @"账号：";
    CGSize acountNumSize = [acountNum sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *acountNumLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:acountNum];
    [acountNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_bank_name_label.mas_bottom);
        make.width.mas_equalTo(acountNumSize.width+0.5);
        make.height.mas_equalTo(accountLbl.mas_height);
    }];
    
    
    _account_num_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_account_num_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(acountNumLbl.mas_right);
        make.top.mas_equalTo(acountNumLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).offset(-8);
        make.height.mas_equalTo(accountLbl.mas_height);
    }];
    
    
    UIView *line5 = [CustomView customLineView:_bgScrollview];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_account_num_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
    //------
    
    NSString *payNum = @"请款次数：";
    CGSize payNumSize = [payNum sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *payNumLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:payNum];
    [payNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line5.mas_bottom);
        make.width.mas_equalTo(payNumSize.width+0.5);
        make.height.mas_equalTo(accountLbl.mas_height);
    }];
    
    
    _pay_number_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_pay_number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(payNumLbl.mas_right);
        make.top.mas_equalTo(payNumLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).offset(-8);
        make.height.mas_equalTo(accountLbl.mas_height);
    }];
    
    NSString *total = @"合同金额：";
    CGSize totalSize = [total sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *totalLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:total];
    [totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_pay_number_label.mas_bottom);
        make.width.mas_equalTo(totalSize.width+0.5);
        make.height.mas_equalTo(accountLbl.mas_height);
    }];
    
    
    _total_money_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_total_money_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(totalLbl.mas_right);
        make.top.mas_equalTo(totalLbl.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH/2-totalSize.width);
        make.height.mas_equalTo(accountLbl.mas_height);
    }];
    
    NSString *less = @"增减金额：";
    CGSize lessSize = [less sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *lessLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:less];
    [lessLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_total_money_label.mas_right);
        make.top.mas_equalTo(_total_money_label.mas_top);
        make.width.mas_equalTo(lessSize.width+0.5);
        make.height.mas_equalTo(accountLbl.mas_height);
    }];
    
    
    _less_money_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_less_money_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lessLbl.mas_right);
        make.top.mas_equalTo(lessLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).offset(-8);
        make.height.mas_equalTo(accountLbl.mas_height);
    }];
    
    NSString *already = @"已领金额：";
    CGSize alreadySize = [already sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *alreadyLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:already];
    [alreadyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_total_money_label.mas_bottom);
        make.width.mas_equalTo(alreadySize.width+0.5);
        make.height.mas_equalTo(accountLbl.mas_height);
    }];
    
    
    _already_get_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_already_get_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(alreadyLbl.mas_right);
        make.top.mas_equalTo(alreadyLbl.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH/2-totalSize.width);
        make.height.mas_equalTo(accountLbl.mas_height);
    }];
    
    NSString *current = @"本次请款：";
    CGSize currentSize = [current sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *currentLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:current];
    [currentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_already_get_label.mas_right);
        make.top.mas_equalTo(_already_get_label.mas_top);
        make.width.mas_equalTo(currentSize.width+0.5);
        make.height.mas_equalTo(accountLbl.mas_height);
    }];
    
    
    _current_apply_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_current_apply_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(currentLbl.mas_right);
        make.top.mas_equalTo(currentLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).offset(-8);
        make.height.mas_equalTo(accountLbl.mas_height);
    }];
    
    
    UIView *line6 = [CustomView customLineView:_bgScrollview];
    [line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_current_apply_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
    
    //--------
    NSString *progress = @"合同执行进度：";
    CGSize progressSize = [progress sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *progressLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:progress];
    [progressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line6.mas_bottom);
        make.width.mas_equalTo(progressSize.width+0.5);
        make.height.mas_equalTo(30);
    }];
    
    
    _progress_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_progress_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(progressLbl.mas_right);
        make.top.mas_equalTo(progressLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    
    UIView *line7 = [CustomView customLineView:_bgScrollview];
    [line7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_progress_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
    //-------
    
    //--------
    NSString *content = @"请款内容：";
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *contentLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:content];
    [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line7.mas_bottom);
        make.width.mas_equalTo(contentSize.width+0.5);
        make.height.mas_equalTo(30);
    }];
    
    
    _apply_content_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_apply_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentLbl.mas_right);
        make.top.mas_equalTo(contentLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    
    UIView *line8 = [CustomView customLineView:_bgScrollview];
    [line8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_apply_content_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    _lastView = line8;
    
    //--------
    if (self.form_type == 0) {
        NSString *manager = @"项目（部门）经理：";
        CGSize managerSize = [manager sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *managerLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:manager];
        [managerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_lastView.mas_bottom);
            make.width.mas_equalTo(managerSize.width+0.5);
            make.height.mas_equalTo(30);
        }];
        
        
        _project_manager_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
        [_project_manager_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(managerLbl.mas_right);
            make.top.mas_equalTo(managerLbl.mas_top);
            make.right.mas_equalTo(self.view.mas_right).offset(-8);
            make.height.mas_equalTo(30);
        }];
        
        
        UIView *line9 = [CustomView customLineView:_bgScrollview];
        [line9 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_project_manager_label.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo(1);
        }];
         _lastView = line9;
    }
    
    
    _showFielsView = [[ShowFilesView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH-16, 30)];
    [_bgScrollview addSubview:_showFielsView];
    [_showFielsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_lastView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(30);
    }];
    
    
    UIView *line10 = [CustomView customLineView:_bgScrollview];
    [line10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_showFielsView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];

    _lastView = line10;
    _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+100);
    
    if (!self.is_aready_approval) {
        _dealView = [[DealWithApprovalView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-113, SCREEN_WIDTH, 40)];
        _dealView.is_cashier = self.is_cashier;
        [self.view addSubview:_dealView];
        if (self.is_cashier) {
            _dealView.canApproval = YES;
            [_dealView setApprovalMenueView];
        }
    }
    
}


@end
