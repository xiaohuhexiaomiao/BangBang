//
//  ShowFileViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/4/11.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "ShowFileViewController.h"
#import "CXZ.h"
#import "ApprovalContentView.h"
#import "ApprovalFileModel.h"
#import "FilesModel.h"
#import "ApprovalResultModel.h"
#import "ApprovalTableView.h"

@interface ShowFileViewController ()
@property(nonatomic ,strong) UIScrollView *bgScrollview;

@property(nonatomic ,strong) UILabel *departmentLabel;

@property(nonatomic ,strong) UILabel *codeLabel;

@property(nonatomic ,strong) RTLabel *formTitleLabel;//

@property(nonatomic ,strong) UILabel *projectLabel;//部门经理

@property(nonatomic, strong)RTLabel *contentLabel;

@property(nonatomic ,strong) UILabel *filesLabel;

@property(nonatomic, strong)UIImageView *wasteImageview;//作废标识

@property(nonatomic , strong) DealWithApprovalView *dealView;

@property(nonatomic ,strong)UILabel *approvalLabel;

@property(nonatomic ,strong)UILabel *sponsorLabel;//发起人


@property(nonatomic ,strong)ShowFilesView *showFielsView;

@property(nonatomic ,strong)UIView *listView;

@property(nonatomic, strong)UIView *lastView;


@property(nonatomic , strong) ApprovalFileModel *approvalModel;


@property(nonatomic ,copy) NSString *departmentStr;

@property(nonatomic ,copy)NSString *projectManagerStr;//部门经理

@property(nonatomic ,strong)NSDictionary *chatDict;

@property(nonatomic ,copy)NSString *participation_id;//

@property(nonatomic ,copy)NSString *companyID;

@property(nonatomic , assign) NSInteger isDownload;

@end

@implementation ShowFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setupBackw];
    [self setupTitleWithString:@"呈批件" withColor:[UIColor whiteColor]];
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
#pragma mark load data

-(void)loadDetailData
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"approval_id":self.approvalID};
    [[NetworkSingletion sharedManager]getContractReviewDetail:paramDict onSucceed:^(NSDictionary *dict) {
        //                                        NSLog(@"*detail**%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            ApprovalFileModel *fileModel = [ApprovalFileModel  objectWithKeyValues:dict[@"data"]];
            self.approvalModel = fileModel;
            self.companyID = fileModel.company_id;
            if (![NSString isBlankString:fileModel.department_name]) {
                self.departmentLabel.text = fileModel.department_name;
            }
            self.codeLabel.text = fileModel.chengpi_num;
            self.formTitleLabel.text = fileModel.title;
            CGSize titleSize = [self.formTitleLabel optimumSize];
            CGFloat titleHeight = titleSize.height > 28.0 ? titleSize.height :28.0;
            [self.formTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(titleHeight);
            }];
            if (fileModel.project_manager_name) {
                self.projectLabel.text =fileModel.project_manager_name[@"name"]  ;
            }
            
            NSMutableArray *fileArray = [NSMutableArray array];
            if (fileModel.contract_id) {
                [fileArray addObject:fileModel.contract_id];
            }
            if (fileModel.many_enclosure.count > 0) {
                [fileArray addObjectsFromArray:fileModel.many_enclosure];
            }
            
            if (fileArray.count > 0) {
                CGFloat fileHeight = [self.showFielsView setShowFilesViewWithArray:fileArray];
                
                [self.showFielsView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(fileHeight);
                }];
            }else{
                self.showFielsView.hidden = YES;
                self.filesLabel.hidden = NO;
            }
            self.contentLabel.text = fileModel.content;
            CGSize optimumSize = [self.contentLabel optimumSize];
            CGFloat contentHeight = optimumSize.height > 30.0 ? optimumSize.height :30.0;
            [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight);
            }];
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
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"company_id":self.companyID,
                                @"approval_id":self.approvalID};
    [[NetworkSingletion sharedManager]getReviewResult:paramDict onSucceed:^(NSDictionary *dict) {
                                NSLog(@"**result*%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            ApprovalResultModel *resultModel = [ApprovalResultModel objectWithKeyValues:dict[@"data"]];
            self.participation_id = resultModel.participation_id;
            if (!self.is_aready_approval) {
                self.dealView.approvalID = self.approvalID;
                self.dealView.participation_id = self.participation_id;
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
                [self.dealView setApprovalMenueView];
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
//                                        NSLog(@"**detail*%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            ApprovalFileModel *fileModel = [ApprovalFileModel  objectWithKeyValues:dict[@"data"]];
            self.approvalModel = fileModel;
            self.companyID = fileModel.company_id;
            if (![NSString isBlankString:fileModel.department_name]) {
                self.departmentLabel.text = fileModel.department_name;
            }
            self.codeLabel.text = fileModel.chengpi_num;
            self.formTitleLabel.text = fileModel.title;
            CGSize titleSize = [self.formTitleLabel optimumSize];
            CGFloat titleHeight = titleSize.height > 28.0 ? titleSize.height :28.0;
            [self.formTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(titleHeight);
            }];
            if (fileModel.project_manager_name) {
                self.projectLabel.text =fileModel.project_manager_name[@"name"]  ;
            }
            
            NSMutableArray *fileArray = [NSMutableArray array];
            if (fileModel.contract_id) {
                [fileArray addObject:fileModel.contract_id];
            }
            if (fileModel.many_enclosure.count > 0) {
                [fileArray addObjectsFromArray:fileModel.many_enclosure];
            }
            
            if (fileArray.count > 0) {
                CGFloat fileHeight = [self.showFielsView setShowFilesViewWithArray:fileArray];
                
                [self.showFielsView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(fileHeight);
                }];
            }else{
                self.showFielsView.hidden = YES;
                self.filesLabel.hidden = NO;
            }
            self.contentLabel.text = fileModel.content;
            CGSize optimumSize = [self.contentLabel optimumSize];
            CGFloat contentHeight = optimumSize.height > 30.0 ? optimumSize.height :30.0;
            [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight);
            }];
         
            
            if (!self.is_aready_approval) {
                self.dealView.approval_personal_id = self.approvalID;
                self.dealView.company_ID = self.companyID;
                self.dealView.formType = 1;
            }
            
            self.approvalLabel.text = [NSString stringWithFormat:@"审批人员：%@",fileModel.approval_content.handler_name];
            self.sponsorLabel.text = [NSString stringWithFormat:@"发起人：%@",fileModel.approval_content.found_name];
            if (fileModel.approval_content.approval_state != 0) {
                ApprovalContentView *approvalView = [[ApprovalContentView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 40)];
                CGFloat contentHeight = [approvalView setApprovalContentWith:fileModel.approval_content];
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


#pragma mark Systom Method
-(void)onNext
{
    if (self.is_copy) {
        [self.delegate copyApprovalFileAll:self.approvalModel];
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

#pragma mark 界面

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
    if (self.form_type == 0) {
        NSString *department = @"部门：";
        CGSize departSize = [department sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *departLabel = [CustomView customTitleUILableWithContentView:_bgScrollview title:department];
        [departLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(departSize.width+0.5);
            make.height.mas_equalTo(30);
        }];
        
        _departmentLabel = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
        [_departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(departLabel.mas_right);
            make.top.mas_equalTo(departLabel.mas_top);
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
            make.height.mas_equalTo(30);
        }];
        
        UIView *line1 = [CustomView customLineView:_bgScrollview];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_departmentLabel.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo(1);
        }];
        _lastView = line1;
    }
   
    
    NSString *codeStr = @"编号：";
    CGSize codeSize = [codeStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *numberLabel = [CustomView customTitleUILableWithContentView:_bgScrollview title:codeStr];
    if (self.form_type == 0) {
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_lastView.mas_bottom);
            make.width.mas_equalTo(codeSize.width+0.5);
            make.height.mas_equalTo(30);
        }];
    }else{
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(codeSize.width+0.5);
            make.height.mas_equalTo(30);
        }];
    }
    
    
    _codeLabel = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(numberLabel.mas_right);
        make.top.mas_equalTo(numberLabel.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];

    UIView *line2 = [CustomView customLineView:_bgScrollview];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_codeLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
    NSString *titleStr = @"标题：";
    CGSize titleSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *titleStrLabel = [CustomView customTitleUILableWithContentView:_bgScrollview title:titleStr];
    [titleStrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line2.mas_bottom);
        make.width.mas_equalTo(titleSize.width+0.5);
        make.height.mas_equalTo(30);
    }];
    
    _formTitleLabel = [CustomView customRTLableWithContentView:_bgScrollview title:nil];
//    _formTitleLabel.backgroundColor = [UIColor blueColor];
    _formTitleLabel.frame = CGRectMake(titleStrLabel.right, titleStrLabel.top, SCREEN_WIDTH-titleSize.width-17, 30);
    [_formTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleStrLabel.mas_right);
        make.top.mas_equalTo(titleStrLabel.mas_top).mas_offset(2);
        make.width.mas_equalTo(SCREEN_WIDTH-titleSize.width-17);
        make.height.mas_equalTo(28);
    }];
    
    UIView *line3 = [CustomView customLineView:_bgScrollview];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_formTitleLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    _lastView = line3;
    
    if (self.form_type == 0) {
        NSString *managerStr = @"部门（项目）经理：";
        CGSize managerSize = [managerStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *managerLabel = [CustomView customTitleUILableWithContentView:_bgScrollview title:managerStr];
        [managerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_lastView.mas_bottom);
            make.width.mas_equalTo(managerSize.width+0.5);
            make.height.mas_equalTo(30);
        }];
        
        _projectLabel = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
        [_projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(managerLabel.mas_right);
            make.top.mas_equalTo(managerLabel.mas_top);
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
            make.height.mas_equalTo(30);
        }];
        
        UIView *line4 = [CustomView customLineView:_bgScrollview];
        [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_projectLabel.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo(1);
        }];
        _lastView = line4;
    }
    

    
    _filesLabel =[CustomView customTitleUILableWithContentView:_bgScrollview title:@"无附件"];
    _filesLabel.hidden = YES;
    [_filesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_lastView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(30);    }];

    
    _showFielsView = [[ShowFilesView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH-16, 30)];
    [_bgScrollview addSubview:_showFielsView];
    [_showFielsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_lastView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line5 = [CustomView customLineView:_bgScrollview];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_showFielsView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
    NSString *contentStr = @"内容：";
    CGSize contentSize = [contentStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *cotentLabel = [CustomView customTitleUILableWithContentView:_bgScrollview title:contentStr];
    [cotentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line5.mas_bottom);
        make.width.mas_equalTo(contentSize.width+0.5);
        make.height.mas_equalTo(30);
    }];
    
    _contentLabel = [CustomView customRTLableWithContentView:_bgScrollview title:nil];
    _contentLabel.frame = CGRectMake(cotentLabel.right, cotentLabel.top, SCREEN_WIDTH-contentSize.width-17, 30);
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cotentLabel.mas_right);
        make.top.mas_equalTo(cotentLabel.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line6 = [CustomView customLineView:_bgScrollview];
    [line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_contentLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
    _sponsorLabel = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    _sponsorLabel.frame = CGRectMake(8, _lastView.bottom+2, SCREEN_WIDTH-16, 20);
    [_sponsorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line6.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    _approvalLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, _sponsorLabel.bottom, SCREEN_WIDTH-16, 35)];
    _approvalLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [_bgScrollview addSubview:_approvalLabel];
    [_approvalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_sponsorLabel.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    _lastView = _approvalLabel;
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
//    NSLog(@"****%lf",STATUS_BAR_HEIGHT);
 
}




@end
