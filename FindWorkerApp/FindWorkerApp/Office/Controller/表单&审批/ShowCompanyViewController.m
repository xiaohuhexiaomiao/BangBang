//
//  ShowCompanyViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/7.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ShowCompanyViewController.h"
#import "CXZ.h"
#import "CompanyContractReviewModel.h"
#import "ApprovalResultModel.h"

#import "CompanyFitView.h"
#import "ApprovalContentView.h"
#import "DealWithApprovalView.h"
#import "EnclosureView.h"
#import "ApprovalTableView.h"


@interface ShowCompanyViewController ()<EnclosureViewDelegate>

@property(nonatomic ,strong)UIScrollView *bgScrollView;

@property(nonatomic ,strong)UILabel *title_label;

@property(nonatomic ,strong)UILabel *contract_name_label;

@property(nonatomic ,strong)EnclosureView *enclosureView;

@property(nonatomic ,strong)UILabel *code_label;

@property(nonatomic ,strong)UILabel *manage_name_label;//项目经理

@property(nonatomic ,strong)UILabel *company_content_label;

//2017-9-6 新加字段

@property(nonatomic ,strong)UILabel *jia_label;

@property(nonatomic ,strong)UILabel *yi_label;

@property(nonatomic ,strong)UILabel *execution_Label;//执行人

@property(nonatomic ,strong)UILabel *price_label;

@property(nonatomic ,strong)UILabel *total_money_label;

@property(nonatomic ,strong)UILabel *price_differences_label;

@property(nonatomic ,strong)UILabel *payment_method_label;

@property(nonatomic ,strong)UILabel *arrival_time_label;

@property(nonatomic ,strong)UILabel *complete_time_label;

@property(nonatomic, strong)UILabel *approvalLabel;

@property(nonatomic, strong)UIImageView *wasteImageview;//作废标识

@property(nonatomic ,strong)ShowFilesView *showFielsView;//

@property(nonatomic ,strong)UILabel *sponsorLabel;//发起人

@property(nonatomic ,strong)UIView *lastView;

@property(nonatomic ,strong)CompanyContractReviewModel *reviewModel;

@property(nonatomic, strong)DealWithApprovalView *dealView;

@property(nonatomic , assign) NSInteger isDownload;

@property(nonatomic ,copy)NSString *participation_id;//

@property(nonatomic, copy)NSString *company_id;//公司id

@end

@implementation ShowCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"合同评审表" withColor:[UIColor whiteColor]];
    [self removeTapGestureRecognizer];
    [self config];
    
    [self loadDetailData];
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
//    dispatch_group_async(group, queue, ^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            dispatch_semaphore_signal(sem);
//                            [self loadResultData];
//        });
//        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//    });
//    dispatch_group_async(group, queue, ^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            dispatch_semaphore_signal(sem);
//                            [self loadDetailData];
//        });
//        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//    });
   
    
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
    
   
    
}

#pragma mark Public Method
//提交
-(void)onNext
{
    [self.delegate copyNewCompanyReviewAll:self.reviewModel];
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)clickRrightFirstItem
{
    if (self.isDownload == 0 || self.isDownload == 1 ) {

        InputReasonViewController *inputVC = [[InputReasonViewController alloc]init];
        inputVC.inputType = 0;
        inputVC.company_id = self.company_id;
        inputVC.approval_id = self.approval_id;
        inputVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:inputVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        
    }
//    else if (self.isDownload == 1){
//        [WFHudView showMsg:@"审批已通过，不能撤回.." inView:self.view];
//    }
    else if (self.isDownload == 2){
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
                                    @"approval_id":self.approval_id,
                                    @"company_id":self.company_id,
                                    @"participation_id":self.participation_id};
        
        [[NetworkSingletion sharedManager]getLoadToken:paramDict onSucceed:^(NSDictionary *dict) {
            //                NSLog(@"load %@",dict);
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



#pragma mark 数据相关

-(void)loadDetailData
{
   
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"approval_id":self.approval_id};
    [[NetworkSingletion sharedManager]getContractReviewDetail:paramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"*detail**%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            CompanyContractReviewModel *detailModel = [CompanyContractReviewModel objectWithKeyValues:dict[@"data"]];
            self.reviewModel = detailModel;
            self.company_id = detailModel.company_id;
            if (![NSString isBlankString:detailModel.contract_id]) {
                self.enclosureView.hidden = NO;
            }
            self.title_label.text = detailModel.contract_name;
            CGSize size = CGSizeMake(self.title_label.width,CGFLOAT_MAX);
            CGSize titleSize = [detailModel.contract_name sizeWithFont:self.title_label.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat titleHeiht = fmax(30, titleSize.height+10);
            [self.title_label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(titleHeiht);
            }];
            
            self.contract_name_label.text = detailModel.contract_name_new;
            CGSize contranct_name_label_size = CGSizeMake(self.contract_name_label.width,CGFLOAT_MAX);
            CGSize contranct_name_size = [detailModel.contract_name_new sizeWithFont:self.contract_name_label.font constrainedToSize:contranct_name_label_size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat contract_name_height = fmax(30, contranct_name_size.height+10);
            [self.contract_name_label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contract_name_height);
            }];
            
            self.code_label.text = detailModel.contract_num;
            self.jia_label.text = detailModel.a_name;
            self.yi_label.text = detailModel.b_name;
            self.execution_Label.text = detailModel.executor;
            if (detailModel.project_manager_name) {
                self.manage_name_label.text = detailModel.project_manager_name[@"name"];
                
            }
            self.price_label.text = detailModel.prive;
             self.total_money_label.text = detailModel.total_prive;
            
            self.price_differences_label.text = detailModel.difference;
            CGSize diffrence = CGSizeMake(self.price_differences_label.width,CGFLOAT_MAX);
            CGSize diffrencesize = [detailModel.difference sizeWithFont:self.price_differences_label.font constrainedToSize:diffrence lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat diffrenceHeiht = fmax(25, diffrencesize.height+10);
            [self.price_differences_label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(diffrenceHeiht);
            }];
            
            self.payment_method_label.text = detailModel.pay_method;
            CGSize payment = CGSizeMake(self.payment_method_label.width,CGFLOAT_MAX);
            CGSize paymentsize = [detailModel.pay_method sizeWithFont:self.payment_method_label.font constrainedToSize:payment lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat paymentHeiht = fmax(25, paymentsize.height+10);
            [self.payment_method_label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(paymentHeiht);
            }];
            
            self.arrival_time_label.text = detailModel.arrive_time;
            self.complete_time_label.text = detailModel.end_time;
            
            self.company_content_label.text = detailModel.remarks;
            CGSize content = CGSizeMake(self.company_content_label.width,CGFLOAT_MAX);
            CGSize contentsize = [detailModel.remarks sizeWithFont:self.company_content_label.font constrainedToSize:content lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat contentHeiht = fmax(25, contentsize.height+10);
            [self.company_content_label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeiht);
            }];
            
            NSMutableArray *fileArray = [NSMutableArray array];
            if (detailModel.enclosure_id) {
                NSString *enclosure_id = [NSString stringWithFormat:@"%li",[detailModel.enclosure_id integerValue]];
                NSDictionary *dict = @{@"contract_id":enclosure_id,@"type":@(3)};
                [fileArray addObject:dict];
            }
            if (detailModel.attachments_id) {
                NSString *contractid = [NSString stringWithFormat:@"%li",[[detailModel.attachments_id objectForKey:@"contract_id"] integerValue]];
                NSInteger type = [[detailModel.attachments_id objectForKey:@"type"] integerValue];
                NSDictionary *dict = @{@"contract_id":contractid,@"type":@(type)};
                [fileArray addObject:dict];
            }
            if (detailModel.many_enclosure.count > 0) {
                [fileArray addObjectsFromArray:detailModel.many_enclosure];
            }
           CGFloat fileHeight = [self.showFielsView setShowFilesViewWithArray:fileArray];
            [self.showFielsView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(fileHeight);
            }];
            
            
            self.bgScrollView.hidden = NO;
            [self loadResultData];
            
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}
//获取审批处理结果
-(void)loadResultData
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                @"company_id":self.company_id,
                                @"approval_id":self.approval_id,
                                @"type":@(111)};
    [[NetworkSingletion sharedManager]getReviewResult:paramDict onSucceed:^(NSDictionary *dict) {
//                        NSLog(@"**result*%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            ApprovalResultModel *resultModel = [ApprovalResultModel objectWithKeyValues:dict[@"data"]];
            self.participation_id = resultModel.participation_id;
            
            if (!self.is_aready_approval) {
                self.dealView.approvalID = self.approval_id;
                self.dealView.participation_id = self.participation_id;
                self.dealView.personal_id = self.personal_id;
                self.dealView.company_ID = self.company_id;
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
                approvalView.approvalID = self.approval_id;
                approvalView.companyID = self.company_id;
                [self.bgScrollView addSubview:approvalView];
                [approvalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(_lastView.mas_bottom);
                    make.left.mas_equalTo(0);
                    make.width.mas_equalTo(SCREEN_WIDTH);
                    make.height.mas_equalTo(SCREEN_HEIGHT-64);
                }];
                [approvalView setApprovalTableViewWithModel:resultModel];
                _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+SCREEN_HEIGHT-64);
                
            }

            self.isDownload = resultModel.is_ok;
            if (resultModel.is_ok == 4) {
                self.wasteImageview.hidden = NO;
                [self.bgScrollView bringSubviewToFront:self.wasteImageview];
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


#pragma mark Delegate

-(void)clickEnclosure
{
    WebViewController *web = [[WebViewController alloc]init];
    web.urlStr = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_draft?view=1&id=%li",API_HOST,[self.reviewModel.contract_id integerValue]];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}


#pragma mark 界面相关
//添加回执内容
-(void)addCashierReplyContentView:(NSDictionary*)dict
{
    CashierReplyContentView *cashierView = [[CashierReplyContentView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 40)];
    CGFloat height = [cashierView setCashierReplyContentWith:dict];
    CGRect frame = cashierView.frame;
    frame.size.height = height;
    cashierView.frame = frame;
    cashierView.replyContentDict = dict;
    [_bgScrollView addSubview:cashierView];
    [cashierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_lastView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(height);
    }];
    _lastView = cashierView;
    _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+100);
}




-(void)config
{
    
    _bgScrollView.hidden = YES;
    
    _bgScrollView = [[UIScrollView alloc]init];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_bgScrollView];
    _bgScrollView.bounces = NO;
    [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    
    _wasteImageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"feiqi"]];
    _wasteImageview.transform = CGAffineTransformMakeRotation(-M_PI/12);
    _wasteImageview.alpha = 0.6;
    [_bgScrollView addSubview:_wasteImageview];
    _wasteImageview.hidden = YES;
    [_wasteImageview mas_makeConstraints:^(MASConstraintMaker *make) { 
        make.left.mas_equalTo(SCREEN_WIDTH/2-105);
        make.top.mas_equalTo(SCREEN_HEIGHT/2-50);
        make.width.mas_equalTo(210);
        make.height.mas_equalTo(140);
    }];
    
    NSString *title = @"工程名称：";
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *titleLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:title];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(titleSize.width+0.1);
        make.height.mas_equalTo(30);
    }];
    
    _title_label = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    [_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_right);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line1 = [CustomView customLineView:_bgScrollView];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_title_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
 // ---
    NSString *contract = @"合同名称：";
    CGSize contractSize = [contract sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *contractLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:contract];
    [contractLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line1.mas_bottom);
        make.width.mas_equalTo(contractSize.width+0.1);
        make.height.mas_equalTo(30);
    }];
    
    _contract_name_label = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    [_contract_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contractLbl.mas_right);
        make.top.mas_equalTo(contractLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-35);
        make.height.mas_equalTo(30);
    }];
    
    _enclosureView = [[EnclosureView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-35, line1.bottom, 35, 35)];
    [_bgScrollView addSubview:_enclosureView];
    [_enclosureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contract_name_label.mas_right);
        make.top.mas_equalTo(_contract_name_label.mas_top);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(30);
    }];
    _enclosureView.hidden = YES;
    _enclosureView.deleteButton.hidden = YES;
    _enclosureView.delegate = self;

    
    UIView *line99 = [CustomView customLineView:_bgScrollView];
    [line99 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_contract_name_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
//-----------
    NSString *code = @"合同编号：";
    CGSize codeSize = [code sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *codeLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:code];
    [codeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_left);
        make.top.mas_equalTo(line99.mas_bottom);
        make.width.mas_equalTo(codeSize.width+0.1);
        make.height.mas_equalTo(30);
    }];
    
    _code_label = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    [_code_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(codeLbl.mas_right);
        make.top.mas_equalTo(codeLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line2 = [CustomView customLineView:_bgScrollView];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_code_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
//-------------
    NSString *jiaF = @"甲方：";
    CGSize jiaSize = [jiaF sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *jiaLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:jiaF];
    [jiaLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_left);
        make.top.mas_equalTo(line2.mas_bottom);
        make.width.mas_equalTo(jiaSize.width+0.1);
        make.height.mas_equalTo(30);
    }];
    
    _jia_label = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    [_jia_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(jiaLbl.mas_right);
        make.top.mas_equalTo(jiaLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line3 = [CustomView customLineView:_bgScrollView];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_jia_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
 
//-----------------
    NSString *yiF = @"乙方：";
    CGSize yiSize = [yiF sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *yiLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:yiF];
    [yiLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_left);
        make.top.mas_equalTo(line3.mas_bottom);
        make.width.mas_equalTo(yiSize.width+0.1);
        make.height.mas_equalTo(30);
    }];
    
    _yi_label = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    [_yi_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(yiLbl.mas_right);
        make.top.mas_equalTo(yiLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line4 = [CustomView customLineView:_bgScrollView];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_yi_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];

//-----------------------
    NSString *execution = @"执行人：";
    CGSize executionSize = [execution sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *executionLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:execution];
    [executionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_left);
        make.top.mas_equalTo(line4.mas_bottom);
        make.width.mas_equalTo(executionSize.width+0.5);
        make.height.mas_equalTo(30);
    }];
    
    _execution_Label = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    [_execution_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(executionLbl.mas_right);
        make.top.mas_equalTo(executionLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line5 = [CustomView customLineView:_bgScrollView];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_execution_Label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
 
//-----------------------
    NSString *manage = @"项目经理：";
    CGSize manageSize = [manage sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *manageLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:manage];
    [manageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_left);
        make.top.mas_equalTo(line5.mas_bottom);
        make.width.mas_equalTo(manageSize.width+0.1);
        make.height.mas_equalTo(30);
    }];
    
    _manage_name_label = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    [_manage_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(manageLbl.mas_right);
        make.top.mas_equalTo(manageLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line6 = [CustomView customLineView:_bgScrollView];
    [line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_manage_name_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
  
//-------------------
    
    NSString *price = @"单价（元）：";
    CGSize priceSize = [price sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *priceLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:price];
    [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_left);
        make.top.mas_equalTo(line6.mas_bottom);
        make.width.mas_equalTo(priceSize.width+0.5);
        make.height.mas_equalTo(25);
    }];
    
    _price_label = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    [_price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(priceLbl.mas_right);
        make.top.mas_equalTo(priceLbl.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH/2-manageSize.width-1);
        make.height.mas_equalTo(priceLbl.mas_height);
    }];
    
    NSString *total = @"总价（元）：";
    CGSize totalSize = [total sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *totalLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:total];
    [totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_price_label.mas_right);
        make.top.mas_equalTo(priceLbl.mas_top);
        make.width.mas_equalTo(totalSize.width+0.5);
        make.height.mas_equalTo(priceLbl.mas_height);
    }];
    
    _total_money_label = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    [_total_money_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(totalLbl.mas_right);
        make.top.mas_equalTo(totalLbl.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH/2-totalSize.width-1);
        make.height.mas_equalTo(totalLbl.mas_height);
    }];

    NSString *diffrence = @"与投标价格差异：";
    CGSize diffrenceSize = [diffrence sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *diffrenceLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:diffrence];
    [diffrenceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_left);
        make.top.mas_equalTo(priceLbl.mas_bottom);
        make.width.mas_equalTo(diffrenceSize.width+0.5);
        make.height.mas_equalTo(priceLbl.mas_height);
    }];
    
    _price_differences_label = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    [_price_differences_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(diffrenceLbl.mas_right);
        make.top.mas_equalTo(diffrenceLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(25);
    }];
    
    NSString *payment = @"付款方式：";
    CGSize paymentSize = [payment sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *paymentLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:payment];
    [paymentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_left);
        make.top.mas_equalTo(_price_differences_label.mas_bottom);
        make.width.mas_equalTo(paymentSize.width+0.1);
        make.height.mas_equalTo(priceLbl.mas_height);
    }];
    
    _payment_method_label = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    [_payment_method_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(paymentLbl.mas_right);
        make.top.mas_equalTo(paymentLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(25);
    }];
    
    NSString *arrive = @"到货时间：";
    CGSize arriveSize = [arrive sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *arriveLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:arrive];
    [arriveLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_left);
        make.top.mas_equalTo(_payment_method_label.mas_bottom);
        make.width.mas_equalTo(arriveSize.width+0.1);
        make.height.mas_equalTo(priceLbl.mas_height);
    }];
    
    _arrival_time_label = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    [_arrival_time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(arriveLbl.mas_right);
        make.top.mas_equalTo(arriveLbl.mas_top);
       make.width.mas_equalTo(SCREEN_WIDTH/2-arriveSize.width-1);
        make.height.mas_equalTo(priceLbl.mas_height);
    }];
    
    NSString *complete = @"完工时间：";
    CGSize completeSize = [complete sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *completeLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:complete];
    [completeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_arrival_time_label.mas_right);
        make.top.mas_equalTo(arriveLbl.mas_top);
        make.width.mas_equalTo(completeSize.width+0.1);
        make.height.mas_equalTo(priceLbl.mas_height);
    }];
    
    _complete_time_label = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    [_complete_time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(completeLbl.mas_right);
        make.top.mas_equalTo(completeLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(priceLbl.mas_height);
    }];
    
    NSString *content = @"合同主要内容：";
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *contentLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:content];
    [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_left);
        make.top.mas_equalTo(_arrival_time_label.mas_bottom);
        make.width.mas_equalTo(contentSize.width+0.1);
        make.height.mas_equalTo(priceLbl.mas_height);
    }];
    
    _company_content_label = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    [_company_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentLbl.mas_right);
        make.top.mas_equalTo(contentLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(25);
    }];
  
    
    UIView *line7 = [CustomView customLineView:_bgScrollView];
    [line7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_company_content_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
    
    _showFielsView = [[ShowFilesView alloc]initWithFrame:CGRectMake(0, line7.bottom, SCREEN_WIDTH-16, 30)];
    [_bgScrollView addSubview:_showFielsView];
    [_showFielsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line7.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(30);
    }];

    
    UIView *line8 = [CustomView customLineView:_bgScrollView];
    [line8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_showFielsView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
    _sponsorLabel = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    [_sponsorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line8.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(20);
    }];
    
    _approvalLabel = [[UILabel alloc]init];
    _approvalLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    _approvalLabel.numberOfLines = 2;
    _approvalLabel.textColor = TITLECOLOR;
    [_bgScrollView addSubview:_approvalLabel];
    [_approvalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_sponsorLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(35);
    }];
    
    _lastView = _approvalLabel;
    [_bgScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(_lastView.mas_bottom).mas_offset(100);
    }];

    
    
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
