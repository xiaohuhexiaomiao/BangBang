//
//  ShowPurchaseViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/7.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ShowPurchaseViewController.h"
#import "CXZ.h"
#import "PurchaseModel.h"
#import "ApprovalResultModel.h"

#import "PurchaseView.h"
#import "ApprovalContentView.h"
#import "DealWithApprovalView.h"
#import "ApprovalTableView.h"

#import "AdressBookViewController.h"

@interface ShowPurchaseViewController ()<ZLPhotoPickerBrowserViewControllerDelegate>

@property(nonatomic, strong)UIScrollView *bgScrollview;

@property(nonatomic, strong)UILabel *titleLabel;

@property(nonatomic ,strong)UILabel *contract_name_label;

@property(nonatomic, strong)UILabel *departmentLabel;

@property(nonatomic, strong)UILabel *manage_name_label;

@property(nonatomic, strong)UILabel *manage_phone_label;

@property(nonatomic, strong)UILabel *arrival_time_label;

@property(nonatomic, strong)UIView *buyView;

@property(nonatomic, strong)UILabel *buy_name_label;

@property(nonatomic, strong)UILabel *buy_phone_label;

@property(nonatomic, strong)UILabel *receive_name_label;

@property(nonatomic, strong)UILabel *receive_phone_label;

@property(nonatomic, strong)UILabel *receive_address_Title_label;

@property(nonatomic, strong)UILabel *receive_address_detail_label;

@property(nonatomic, strong)UILabel *project_name_label;

@property(nonatomic, strong)UILabel *approvalLabel;

@property(nonatomic, strong)UILabel *totalMoneyLabel;

@property(nonatomic ,strong)UILabel *sponsorLabel;//发起人

@property(nonatomic, strong)UIButton *checkButton;

@property(nonatomic, strong)UIView *line3;

@property(nonatomic, strong)UIView *line4;

@property(nonatomic, strong)UIView *line5;

@property(nonatomic, strong)UIView *lastView;

@property(nonatomic, strong)UIImageView *wasteImageview;//作废标识

@property(nonatomic, strong)DealWithApprovalView *dealView;

@property(nonatomic ,strong)ShowFilesView *showFielsView;//

@property(nonatomic ,strong)PurchaseModel *purchaseModel;

@property(nonatomic ,strong)NSString *enclosure_id;

@property (nonatomic ,assign) NSUInteger ennexType;

@property(nonatomic ,copy)NSString *participation_id;//

@property(nonatomic , assign) NSInteger isDownload;

@property(nonatomic ,copy)NSString *companyID;

@end

@implementation ShowPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"请购单" withColor:[UIColor whiteColor]];
    [self config];
    [self removeTapGestureRecognizer];
//    self.bgScrollview.hidden = YES;
    
    
    
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
        [self loadPersonalDetail];
    }

}

#pragma mark 数据相关

// approvalStr = YES 获取 内容
-(void)loadDetailData
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"approval_id":self.approvalID};
    [[NetworkSingletion sharedManager]getContractReviewDetail:paramDict onSucceed:^(NSDictionary *dict) {
//                NSLog(@"*detail**%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            
            PurchaseModel *detailModel = [PurchaseModel objectWithKeyValues:dict[@"data"]];
            self.purchaseModel = detailModel;
            self.companyID = detailModel.company_id;
           
            if (![NSString isBlankString:detailModel.department_name]) {
                self.departmentLabel.text = detailModel.department_name;
            }
            
            self.titleLabel.text = detailModel.request_contract_address;
            CGSize size = CGSizeMake(self.titleLabel.width,CGFLOAT_MAX);
            CGSize titleSize = [detailModel.request_contract_address sizeWithFont:self.titleLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat titleHeiht = fmax(30, titleSize.height+10);
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(titleHeiht);
            }];
            
            self.contract_name_label.text = detailModel.contract_name_new;
            CGSize contranct_name_label_size = CGSizeMake(self.contract_name_label.width,CGFLOAT_MAX);
            CGSize contranct_name_size = [detailModel.contract_name_new sizeWithFont:self.contract_name_label.font constrainedToSize:contranct_name_label_size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat contract_name_height = fmax(30, contranct_name_size.height+10);
            [self.contract_name_label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contract_name_height);
            }];
            
            self.manage_name_label.text = detailModel.contract_responsible;
            self.manage_phone_label.text = detailModel.responsible_tel;
            self.arrival_time_label.text = detailModel.arrival_time;
            self.receive_name_label.text = detailModel.consignee;
            self.receive_phone_label.text = detailModel.consignee_phone;
            if (detailModel.project_manager_name) {
                self.project_name_label.text = detailModel.project_manager_name[@"name"];
                
            }
            
            if ([NSString isBlankString:detailModel.buy_person]) {
                self.buyView.hidden = YES;
                self.line3.hidden = YES;
                [self.line4 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.arrival_time_label.mas_bottom);
                    make.left.mas_equalTo(8);
                    make.width.mas_equalTo(SCREEN_WIDTH-16);
                    make.height.mas_equalTo(1);
                }];
            }else{
                 self.buyView.hidden = NO;
                self.buy_phone_label.text = detailModel.buy_person_phone;
                self.buy_name_label.text = detailModel.buy_person;
            }
            if ([NSString isBlankString:detailModel.receive_address]) {
                self.receive_address_detail_label.hidden = YES;
                self.receive_address_Title_label.hidden = YES;
                [self.line5 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.receive_phone_label.mas_bottom);
                    make.left.mas_equalTo(8);
                    make.width.mas_equalTo(SCREEN_WIDTH-16);
                    make.height.mas_equalTo(1);
                }];
            }else{
                 self.receive_address_detail_label.text = detailModel.receive_address;
                CGSize addresssize = CGSizeMake(self.receive_address_detail_label.width,CGFLOAT_MAX);
                CGSize addressSize = [detailModel.receive_address sizeWithFont:self.receive_address_detail_label.font constrainedToSize:addresssize lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat addressHeiht = fmax(25, addressSize.height+10);
                
                [self.receive_address_detail_label mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(addressHeiht);
                }];
            }
            
            NSMutableArray *fileArray = [NSMutableArray array];
            if (detailModel.enclosure_id) {
                
                [fileArray addObject:detailModel.enclosure_id];
            }
            if (detailModel.many_enclosure.count > 0) {
                [fileArray addObjectsFromArray:detailModel.many_enclosure];
            }
            CGFloat fileHeight = [self.showFielsView setShowFilesViewWithArray:fileArray];
            
            [self.showFielsView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(fileHeight);
            }];
            
            [self setPurchaseList:detailModel];
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
    NSDictionary *paramDict = @{ @"company_id":self.companyID,
                                @"approval_id":self.approvalID,};
    [[NetworkSingletion sharedManager]getReviewResult:paramDict onSucceed:^(NSDictionary *dict) {
//                                NSLog(@"**result*%@",dict);
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

-(void)loadPersonalDetail
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"approval_personal_id":self.approvalID};
    [[NetworkSingletion sharedManager]getPersonalApprovalDetail:paramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"**detail*%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            
            PurchaseModel *detailModel = [PurchaseModel objectWithKeyValues:dict[@"data"]];
            self.purchaseModel = detailModel;
            self.companyID = detailModel.company_id;
            
            if (![NSString isBlankString:detailModel.department_name]) {
                self.departmentLabel.text = detailModel.department_name;
            }
            
            self.titleLabel.text = detailModel.request_contract_address;
            CGSize size = CGSizeMake(self.titleLabel.width,CGFLOAT_MAX);
            CGSize titleSize = [detailModel.request_contract_address sizeWithFont:self.titleLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat titleHeiht = fmax(30, titleSize.height+10);
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(titleHeiht);
            }];
            
            self.contract_name_label.text = detailModel.contract_name_new;
            CGSize contranct_name_label_size = CGSizeMake(self.contract_name_label.width,CGFLOAT_MAX);
            CGSize contranct_name_size = [detailModel.contract_name_new sizeWithFont:self.contract_name_label.font constrainedToSize:contranct_name_label_size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat contract_name_height = fmax(30, contranct_name_size.height+10);
            [self.contract_name_label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contract_name_height);
            }];
            
            self.manage_name_label.text = detailModel.contract_responsible;
            self.manage_phone_label.text = detailModel.responsible_tel;
            self.arrival_time_label.text = detailModel.arrival_time;
            self.receive_name_label.text = detailModel.consignee;
            self.receive_phone_label.text = detailModel.consignee_phone;
            if (detailModel.project_manager_name) {
                self.project_name_label.text = detailModel.project_manager_name[@"name"];
                
            }
            
            if ([NSString isBlankString:detailModel.buy_person]) {
                self.buyView.hidden = YES;
                self.line3.hidden = YES;
                [self.line4 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.arrival_time_label.mas_bottom);
                    make.left.mas_equalTo(8);
                    make.width.mas_equalTo(SCREEN_WIDTH-16);
                    make.height.mas_equalTo(1);
                }];
            }else{
                self.buyView.hidden = NO;
                self.buy_phone_label.text = detailModel.buy_person_phone;
                self.buy_name_label.text = detailModel.buy_person;
            }
            if ([NSString isBlankString:detailModel.receive_address]) {
                self.receive_address_detail_label.hidden = YES;
                self.receive_address_Title_label.hidden = YES;
                [self.line5 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.receive_phone_label.mas_bottom);
                    make.left.mas_equalTo(8);
                    make.width.mas_equalTo(SCREEN_WIDTH-16);
                    make.height.mas_equalTo(1);
                }];
            }else{
                self.receive_address_detail_label.text = detailModel.receive_address;
                CGSize addresssize = CGSizeMake(self.receive_address_detail_label.width,CGFLOAT_MAX);
                CGSize addressSize = [detailModel.receive_address sizeWithFont:self.receive_address_detail_label.font constrainedToSize:addresssize lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat addressHeiht = fmax(25, addressSize.height+10);
                
                [self.receive_address_detail_label mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(addressHeiht);
                }];
            }
            
            NSMutableArray *fileArray = [NSMutableArray array];
            if (detailModel.enclosure_id) {
                
                [fileArray addObject:detailModel.enclosure_id];
            }
            if (detailModel.many_enclosure.count > 0) {
                [fileArray addObjectsFromArray:detailModel.many_enclosure];
            }
            CGFloat fileHeight = [self.showFielsView setShowFilesViewWithArray:fileArray];
            
            [self.showFielsView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(fileHeight);
            }];
            
            [self setPurchaseList:detailModel];
            
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



#pragma mark System Method

-(void)onNext
{
    if (self.is_copy) {
        [self.delegate copyPurchaseFormAll:self.purchaseModel];
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


-(void)setPurchaseList:(PurchaseModel*)purchaseModel
{
    if (purchaseModel.content.count > 0) {
        UILabel *label = [CustomView customTitleUILableWithContentView:_bgScrollview  title:@"请购物清单："];
        label.font = [UIFont systemFontOfSize:FONT_SIZE weight:0.8];
        label.frame = CGRectMake(8, _lastView.bottom, SCREEN_WIDTH-16, 25);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_lastView.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH/2-8);
            make.height.mas_equalTo(25);
        }];
        _lastView = label;
        
        _totalMoneyLabel = [[UILabel alloc]init];
        _totalMoneyLabel.font = [UIFont systemFontOfSize:12 weight:0.8];
        _totalMoneyLabel.textColor = DARK_RED_COLOR;
        _totalMoneyLabel.textAlignment = NSTextAlignmentRight;
        _totalMoneyLabel.text = [NSString stringWithFormat:@"合计：%.2f元",purchaseModel.total];
        [_bgScrollview addSubview:_totalMoneyLabel];
        [_totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right);
            make.top.mas_equalTo(label.mas_top);
            make.width.mas_equalTo(SCREEN_WIDTH/2-8);
            make.height.mas_equalTo(25);
        }];
        
        for (int i = 0; i < purchaseModel.content.count; i++) {
            NSDictionary *dict = purchaseModel.content[i];
            PurchaseView *salaryView = [[PurchaseView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH,100)];
            CGFloat salaryHeight =  [salaryView showPurchaseViewWithDict:dict];
            [_bgScrollview addSubview:salaryView];
            [salaryView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(_lastView.mas_bottom);
                make.width.mas_equalTo(SCREEN_WIDTH);
                make.height.mas_equalTo(salaryHeight);
            }];
            _lastView = salaryView;
            
        }
       
    }
    
    _sponsorLabel = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    _sponsorLabel.frame = CGRectMake(8, _lastView.bottom+3, SCREEN_WIDTH-16, 20);
    [_sponsorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_lastView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(20);
    }];
    
    _approvalLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, _sponsorLabel.bottom, SCREEN_WIDTH-16, 30)];
    _approvalLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    _approvalLabel.numberOfLines = 2;
    _approvalLabel.textColor = TITLECOLOR;
    [_bgScrollview addSubview:_approvalLabel];
    [_approvalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_sponsorLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(35);
    }];
    
    _lastView = _approvalLabel;
    [_bgScrollview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_lastView.mas_bottom).mas_offset(120);
      ;
    }];
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
    
    _titleLabel = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_right);
        make.top.mas_equalTo(titleLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line1 = [CustomView customLineView:_bgScrollview];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
   
    // ---
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
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line99 = [CustomView customLineView:_bgScrollview];
    [line99 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_contract_name_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    _lastView = line99;
    
//------
    if (self.form_type == 0) {
        NSString *depart = @"请购部门：";
        CGSize departSize = [depart sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *departLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:depart];
        [departLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_lastView.mas_bottom);
            make.width.mas_equalTo(departSize.width+0.5);
            make.height.mas_equalTo(30);
        }];
        _departmentLabel = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
        [_departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(departLbl.mas_right);
            make.top.mas_equalTo(_lastView.mas_bottom);
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
            make.height.mas_equalTo(30);
        }];
        UIView *line2 = [CustomView customLineView:_bgScrollview];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_departmentLabel.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo(1);
        }];
         _lastView = line2;
    }
    
    
//------
    NSString *manage_name = @"工程负责人：";
    CGSize manage_name_Size = [manage_name sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *manage_name_Lbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:manage_name];
    [manage_name_Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_lastView.mas_bottom);
        make.width.mas_equalTo(manage_name_Size.width+0.5);
        make.height.mas_equalTo(25);
    }];
    _manage_name_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_manage_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(manage_name_Lbl.mas_right);
        make.top.mas_equalTo(manage_name_Lbl.mas_top);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(manage_name_Lbl.mas_height);
    }];
    
    NSString *manage_phone = @"联系方式：";
    CGSize manage_phone_Size = [manage_phone sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *manage_phone_Lbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:manage_phone];
    [manage_phone_Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_manage_name_label.mas_right);
        make.top.mas_equalTo(manage_name_Lbl.mas_top);
        make.width.mas_equalTo(manage_phone_Size.width+0.5);
        make.height.mas_equalTo(manage_name_Lbl.mas_height);
    }];
    _manage_phone_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_manage_phone_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(manage_phone_Lbl.mas_right);
        make.top.mas_equalTo(manage_name_Lbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(manage_name_Lbl.mas_height);
    }];
    
    NSString *arrival = @"要求到货时间：";
    CGSize arrival_Size = [arrival sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *arrivalLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:arrival];
    [arrivalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(manage_name_Lbl.mas_bottom);
        make.width.mas_equalTo(arrival_Size.width+0.5);
        make.height.mas_equalTo(manage_name_Lbl.mas_height);
    }];
    _arrival_time_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_arrival_time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(arrivalLbl.mas_right);
        make.top.mas_equalTo(arrivalLbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(manage_name_Lbl.mas_height);
    }];
    
    _line3 = [CustomView customLineView:_bgScrollview];
    [ _line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_arrival_time_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    _lastView =  _line3;
    
//--------
    
    _buyView = [[UIView alloc]init];
    [_bgScrollview addSubview:_buyView];
    [_buyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_lastView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(30);
    }];
    _lastView = _buyView;
    NSString *buyname = @"采购执行人：";
    CGSize buynameSize = [buyname sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *buyNameLbl = [CustomView customTitleUILableWithContentView:_buyView title:buyname];
    [buyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo( 0);
        make.width.mas_equalTo(buynameSize.width+0.5);
        make.height.mas_equalTo(30);
    }];
    _buy_name_label = [CustomView customContentUILableWithContentView:_buyView title:nil];
    [_buy_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(buyNameLbl.mas_right);
        make.top.mas_equalTo(buyNameLbl.mas_top);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(buyNameLbl.mas_height);
    }];
    NSString *buy_phone = @"联系方式：";
    CGSize buy_phone_Size = [buy_phone sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *buy_phone_Lbl = [CustomView customTitleUILableWithContentView:_buyView title:buy_phone];
    [buy_phone_Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(manage_phone_Lbl.mas_left);
        make.top.mas_equalTo(buyNameLbl.mas_top);
        make.width.mas_equalTo(buy_phone_Size.width+0.5);
        make.height.mas_equalTo(buyNameLbl.mas_height);
    }];
    _buy_phone_label = [CustomView customContentUILableWithContentView:_buyView title:nil];
    [_buy_phone_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(buy_phone_Lbl.mas_right);
        make.top.mas_equalTo(buy_phone_Lbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(buyNameLbl.mas_height);
    }];
    
    _line4 = [CustomView customLineView:_bgScrollview];
    [_line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_buy_phone_label.mas_bottom);
       make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
//---------
    
    NSString *receivename = @"收货人：";
    CGSize receivenameSize = [receivename sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *receiveNameLbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:receivename];
    [receiveNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_line4.mas_bottom);
        make.width.mas_equalTo(receivenameSize.width+1);
        make.height.mas_equalTo(30);
    }];
    _receive_name_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_receive_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(receiveNameLbl.mas_right);
        make.top.mas_equalTo(receiveNameLbl.mas_top);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(receiveNameLbl.mas_height);
    }];
    
    NSString *receive_phone = @"联系方式：";
    CGSize receive_phone_Size = [receive_phone sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *receive_phone_Lbl = [CustomView customTitleUILableWithContentView:_bgScrollview title:receive_phone];
    [receive_phone_Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(manage_phone_Lbl.mas_left);
        make.top.mas_equalTo(receiveNameLbl.mas_top);
        make.width.mas_equalTo(receive_phone_Size.width+0.5);
        make.height.mas_equalTo(receiveNameLbl.mas_height);
    }];
    _receive_phone_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_receive_phone_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(receive_phone_Lbl.mas_right);
        make.top.mas_equalTo(receive_phone_Lbl.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(receiveNameLbl.mas_height);
    }];
    
    _lastView = _receive_phone_label;
    NSString *receive_adress = @"收货地址：";
    CGSize receive_adress_Size = [receive_phone sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    _receive_address_Title_label = [CustomView customTitleUILableWithContentView:_bgScrollview title:receive_adress];
    [_receive_address_Title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_lastView.mas_bottom);
        make.width.mas_equalTo(receive_adress_Size.width+0.5);
        make.height.mas_equalTo(25);
    }];
    _receive_address_detail_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_receive_address_detail_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_receive_address_Title_label.mas_right);
        make.top.mas_equalTo(_receive_address_Title_label.mas_top);
        make.right.equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(25);
    }];
    _lastView = _receive_address_detail_label;
    
    _line5 = [CustomView customLineView:_bgScrollview];
    [_line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_receive_address_detail_label.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    _lastView = _line5;
 
//----------
    if (self.form_type == 0) {
        NSString *project = @"项目经理：";
        CGSize project_Size = [project sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *projectLable = [CustomView customTitleUILableWithContentView:_bgScrollview title:project];
        [projectLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_lastView.mas_bottom);
            make.width.mas_equalTo(project_Size.width+0.5);
            make.height.mas_equalTo(30);
        }];
        _project_name_label = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
        [_project_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(projectLable.mas_right);
            make.top.mas_equalTo(projectLable.mas_top);
            make.right.equalTo(self.view.mas_right).mas_offset(-8);
            make.height.mas_equalTo(projectLable.mas_height);
        }];
        
        UIView *line6 = [CustomView customLineView:_bgScrollview];
        [line6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_project_name_label.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo(1);
        }];
        _lastView = line6;
    }
   
//----------
    
    _showFielsView = [[ShowFilesView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH-16, 30)];
    [_bgScrollview addSubview:_showFielsView];
    [_showFielsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_lastView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line7 = [CustomView customLineView:_bgScrollview];
    [line7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_showFielsView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    _lastView = line7;
    
    
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
