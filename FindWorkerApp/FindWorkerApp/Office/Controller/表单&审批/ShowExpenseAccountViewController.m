//
//  ShowExpenseAccountViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/1/5.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "ShowExpenseAccountViewController.h"
#import "CXZ.h"
#import "ExpenseAccountModel.h"
#import "ApprovalResultModel.h"

#import "ShowExpenseAccountView.h"
#import "ApprovalContentView.h"
#import "ApprovalTableView.h"

@interface ShowExpenseAccountViewController ()

@property(nonatomic, strong)UIScrollView *bgScrollview;

@property(nonatomic, strong)RTLabel *titleLabel;

@property(nonatomic ,strong)UILabel *projectName;

@property(nonatomic, strong)UILabel *totalMoneyLabel;

@property(nonatomic , strong)UILabel *totalMoneyWordsLabel;//大写总金额

@property(nonatomic, strong)UILabel *approvalLabel;

@property(nonatomic ,strong)UILabel *sponsorLabel;//发起人

@property(nonatomic, strong)UIView *lastView;

@property(nonatomic, strong)UIView *line0;

@property(nonatomic, strong)UIImageView *wasteImageview;//作废标识

@property(nonatomic, strong)DealWithApprovalView *dealView;

@property(nonatomic ,strong)ShowFilesView *showFielsView;//

@property(nonatomic ,strong)ExpenseAccountModel *expenseModel;//

@property(nonatomic , assign) NSInteger isDownload;

@property(nonatomic ,copy)NSString *participation_id;//

@property(nonatomic ,copy)NSString *companyID;

@end

@implementation ShowExpenseAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"报销单" withColor:[UIColor whiteColor]];
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
    // Dispose of any resources that can be recreated.
}
#pragma mark System Method

-(void)onNext
{
    if (self.is_copy) {
        [self.delegate copyExpenseAccountFormAll:self.expenseModel];
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


#pragma mark 数据相关

-(void)loadDetailData
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"approval_id":self.approvalID};
    [[NetworkSingletion sharedManager]getContractReviewDetail:paramDict onSucceed:^(NSDictionary *dict) {
//                        NSLog(@"*detail**%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            
            ExpenseAccountModel *detailModel = [ExpenseAccountModel objectWithKeyValues:dict[@"data"]];
            self.expenseModel = detailModel;
            self.companyID = detailModel.company_id;
           
            self.titleLabel.text = detailModel.title;
            CGSize size = CGSizeMake(self.titleLabel.width,CGFLOAT_MAX);
            CGSize titleSize = [detailModel.title sizeWithFont:self.titleLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat titleHeiht = fmax(30, titleSize.height+10);
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(titleHeiht);
            }];

            if (detailModel.project_manager_name) {
                self.projectName.text = detailModel.project_manager_name[@"name"];
                
            }
//

            CGFloat fileHeight = [self.showFielsView setShowFilesViewWithArray:detailModel.many_enclosure];
            
            [self.showFielsView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(fileHeight);
            }];
            
            [self setExpenseList:detailModel];
            self.bgScrollview.hidden = NO;
//
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
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"company_id":self.companyID,
                                @"approval_id":self.approvalID,
                                };
    [[NetworkSingletion sharedManager]getReviewResult:paramDict onSucceed:^(NSDictionary *dict) {
//          NSLog(@"**result*%@",dict);
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
            
//            if (resultModel.content.count > 0) {
//                for (int i = 0; i < resultModel.content.count; i++ ) {
//                    [self addApprovalviewWithDict:resultModel.content[i]];
//                }
//                
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
            ExpenseAccountModel *detailModel = [ExpenseAccountModel objectWithKeyValues:dict[@"data"]];
            self.expenseModel = detailModel;
            self.companyID = detailModel.company_id;
            
            self.titleLabel.text = detailModel.title;
            CGSize size = CGSizeMake(self.titleLabel.width,CGFLOAT_MAX);
            CGSize titleSize = [detailModel.title sizeWithFont:self.titleLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat titleHeiht = fmax(30, titleSize.height+10);
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(titleHeiht);
            }];
            
            if (detailModel.project_manager_name) {
                self.projectName.text = detailModel.project_manager_name[@"name"];
                
            }
            //
            
            CGFloat fileHeight = [self.showFielsView setShowFilesViewWithArray:detailModel.many_enclosure];
            
            [self.showFielsView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(fileHeight);
            }];
            
            [self setExpenseList:detailModel];
            
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



-(void)setExpenseList:(ExpenseAccountModel*)expenseModel
{
    if (expenseModel.content.count > 0) {
        UILabel *label = [CustomView customTitleUILableWithContentView:_bgScrollview  title:@"报销清单："];
        label.font = [UIFont systemFontOfSize:FONT_SIZE weight:0.8];
        label.frame = CGRectMake(8, _lastView.bottom, SCREEN_WIDTH-16, 25);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_lastView.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH/2-8);
            make.height.mas_equalTo(25);
        }];
       
        
        _totalMoneyLabel = [[UILabel alloc]init];
        _totalMoneyLabel.font = [UIFont systemFontOfSize:12 weight:0.8];
        _totalMoneyLabel.textColor = DARK_RED_COLOR;
        _totalMoneyLabel.textAlignment = NSTextAlignmentRight;
        _totalMoneyLabel.text = [NSString stringWithFormat:@"合计：%.2f元",expenseModel.money];
        [_bgScrollview addSubview:_totalMoneyLabel];
        [_totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right);
            make.top.mas_equalTo(label.mas_top);
            make.width.mas_equalTo(SCREEN_WIDTH/2-8);
            make.height.mas_equalTo(25);
        }];
        
        _totalMoneyWordsLabel = [CustomView customContentUILableWithContentView:_bgScrollview title:@"总金额（大写）："];
        _totalMoneyWordsLabel.text = [NSString stringWithFormat:@"总金额（大写）：%@",expenseModel.big_money];
        [_totalMoneyWordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(_totalMoneyLabel.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo(20);
        }];
        _totalMoneyWordsLabel.font = [UIFont systemFontOfSize:12 weight:0.8];
        _totalMoneyWordsLabel.textColor = DARK_RED_COLOR;
         _lastView = _totalMoneyWordsLabel;
        
        for (int i = 0; i < expenseModel.content.count; i++) {
            NSDictionary *dict = expenseModel.content[i];
            ShowExpenseAccountView *expenseView = [[ShowExpenseAccountView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH,130)];
            CGFloat expenseHeight =  [expenseView showExpenseViewWithDict:dict];
            [_bgScrollview addSubview:expenseView];
            [expenseView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(_lastView.mas_bottom);
                make.width.mas_equalTo(SCREEN_WIDTH);
                make.height.mas_equalTo(expenseHeight);
            }];
            _lastView = expenseView;
            
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



-(void)config{
    _bgScrollview = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _bgScrollview.showsVerticalScrollIndicator = YES;
    _bgScrollview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bgScrollview];
    [_bgScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(0);
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
    
    NSString *titleStr = @"标题：";
    CGSize titleSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *titleLabel = [CustomView customTitleUILableWithContentView:_bgScrollview title:titleStr];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(titleSize.width+1);
        make.height.mas_equalTo(30);
    }];
    
    _titleLabel = [CustomView customRTLableWithContentView:_bgScrollview title:nil];
    _titleLabel.frame = CGRectMake(titleLabel.right, 5, SCREEN_WIDTH-titleLabel.right-8, 25);
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right);
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(25);
    }];
    
    UIView *line1 = [CustomView customLineView:_bgScrollview];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(1);
    }];
    _lastView = line1;
    
    if (self.form_type == 0) {
        NSString *managerStr = @"项目（部门）经理：";
        CGSize projectManagerSize = [managerStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *projectManagerLabel = [CustomView customTitleUILableWithContentView:_bgScrollview title:managerStr];
        [projectManagerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(line1.mas_bottom);
            make.width.mas_equalTo(projectManagerSize.width+1);
            make.height.mas_equalTo(30);
        }];
        
        _projectName = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
        [_projectName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(projectManagerLabel.mas_right);
            make.top.mas_equalTo(projectManagerLabel.mas_top);
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
            make.height.mas_equalTo(30);
        }];
        
        UIView *line2 = [CustomView customLineView:_bgScrollview];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_projectName.mas_bottom);
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
            make.height.mas_equalTo(1);
        }];
        _lastView = line2;
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
    
    UIView *line3 = [CustomView customLineView:_bgScrollview];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_showFielsView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    _lastView = line3;
    
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
