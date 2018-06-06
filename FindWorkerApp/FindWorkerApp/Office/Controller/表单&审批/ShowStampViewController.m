//
//  ShowStampViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/3/30.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "ShowStampViewController.h"
#import "CXZ.h"
#import "StampModel.h"
#import "ApprovalResultModel.h"

#import "ShowStampView.h"
#import "ApprovalContentView.h"
#import "ApprovalTableView.h"


@interface ShowStampViewController ()
@property(nonatomic ,strong) UIScrollView *bgScrollview;

@property(nonatomic ,strong) UILabel *departmentLabel;

@property(nonatomic ,strong) UILabel *applyNameLabel;

@property(nonatomic ,strong) UILabel *projectLabel;//部门经理

@property(nonatomic ,strong)UILabel *approvalLabel;//审批人员展示

@property(nonatomic, strong)UIImageView *wasteImageview;//作废标识

@property(nonatomic , strong) DealWithApprovalView *dealView;

@property(nonatomic ,strong)UILabel *sponsorLabel;//发起人

@property(nonatomic ,strong)ShowFilesView *showFielsView;//

@property(nonatomic ,strong)UIView *listView;

@property(nonatomic ,strong) UIView *lastView;

@property(nonatomic , strong)StampModel *stampModel;

@property(nonatomic ,copy)NSString *departmentStr;

@property(nonatomic , assign) NSInteger isDownload;

@property(nonatomic ,copy)NSString *projectManagerStr;//部门经理

@property(nonatomic ,copy)NSString *participation_id;//

@property(nonatomic ,copy)NSString *companyID;

@end

@implementation ShowStampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setupBackw];
    [self setupTitleWithString:@"印章申请" withColor:[UIColor whiteColor]];
    [self config];
    [self loadDetailData];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Systom Method
-(void)onNext
{
    if (self.is_copy) {
        [self.delegate copyStampAll:self.stampModel];
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
// approvalStr = YES 获取 内容
-(void)loadDetailData
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"approval_id":self.approvalID};
    [[NetworkSingletion sharedManager]getContractReviewDetail:paramDict onSucceed:^(NSDictionary *dict) {
//                        NSLog(@"*detail**%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            StampModel *detailModel = [StampModel objectWithKeyValues:dict[@"data"]];
            self.stampModel = detailModel;
            self.companyID = detailModel.company_id;
            self.departmentLabel.text = detailModel.department_name;
            self.applyNameLabel.text = detailModel.user_name;
            if (detailModel.project_manager_name) {
                self.projectLabel.text = detailModel.project_manager_name[@"name"];
                
            }
            NSMutableArray *fileArray = [NSMutableArray array];
            if (detailModel.contract_id) {
                [fileArray addObject:detailModel.contract_id];
            }
            if (detailModel.many_enclosure.count > 0) {
                [fileArray addObjectsFromArray:detailModel.many_enclosure];
            }
            [self setApplyStampListView:detailModel fileArray:fileArray];
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
                                @"approval_id":self.approvalID};
    [[NetworkSingletion sharedManager]getReviewResult:paramDict onSucceed:^(NSDictionary *dict) {
//                NSLog(@"**result*%@",dict);
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




#pragma mark 界面相关

-(void)config
{
    _bgScrollview = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _bgScrollview.showsVerticalScrollIndicator = YES;
    _bgScrollview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bgScrollview];
    
    _wasteImageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"feiqi"]];
    _wasteImageview.transform = CGAffineTransformMakeRotation(-M_PI/12);
    _wasteImageview.alpha = 0.6;
    [_bgScrollview addSubview:_wasteImageview];
    _wasteImageview.hidden = YES;
    _wasteImageview.frame = CGRectMake(SCREEN_WIDTH/2-105, SCREEN_HEIGHT/2-50, 210, 140);

    NSString *depart = @"部门：";
    CGSize departSize = [depart sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *departLabel = [CustomView customTitleUILableWithContentView:_bgScrollview title:depart];
    departLabel.frame = CGRectMake(8, 0, departSize.width+1, 30);
   
    _departmentLabel = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    _departmentLabel.frame = CGRectMake(departLabel.right, departLabel.top, SCREEN_WIDTH-departLabel.right-8, 30);
    
    UIView *line1 = [CustomView customLineView:_bgScrollview];
    line1.frame = CGRectMake(8, _departmentLabel.bottom, SCREEN_WIDTH-16, 1);

    
    NSString *apply = @"申请人：";
    CGSize applySize = [apply sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *applyLabel = [CustomView customTitleUILableWithContentView:_bgScrollview title:apply];
    applyLabel.frame = CGRectMake(8, line1.bottom, applySize.width,30);
    
    _applyNameLabel = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    _applyNameLabel.frame = CGRectMake(applyLabel.right, applyLabel.top, SCREEN_WIDTH-applyLabel.right-8, applyLabel.height);
    
    UIView *line2 = [CustomView customLineView:_bgScrollview];
    line2.frame = CGRectMake(line1.left, _applyNameLabel.bottom, line1.width, line1.height);
    
    NSString *partStr = @"部门经理：";
    CGSize partSize = [partStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *partLabel = [CustomView customTitleUILableWithContentView:_bgScrollview title:partStr];
    partLabel.frame = CGRectMake(applyLabel.left, line2.bottom, partSize.width, departLabel.height);
  
    
    _projectLabel = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    _projectLabel.frame = CGRectMake(partLabel.right, partLabel.top, SCREEN_WIDTH-partLabel.right-8, partLabel.height);
    
    UIView *line3 = [CustomView customLineView:_bgScrollview];
    line3.frame = CGRectMake(line1.left, _projectLabel.bottom, line1.width, line1.height);
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


-(void)setApplyStampListView:(StampModel*)detailModel fileArray:(NSArray*)filesArray
{
    
    if (filesArray.count > 0) {
        _showFielsView = [[ShowFilesView alloc]initWithFrame:CGRectMake(8, _lastView.bottom, SCREEN_WIDTH-16, 30)];
        [_bgScrollview addSubview:_showFielsView];
        CGFloat fileHeight = [self.showFielsView setShowFilesViewWithArray:filesArray];
        CGRect frame = _showFielsView.frame;
        frame.size.height = fileHeight;
        _showFielsView.frame = frame;
        
        UIView *line = [CustomView customLineView:_bgScrollview];
        line.frame = CGRectMake(8, _showFielsView.bottom, SCREEN_WIDTH-16, 1);
        _lastView = line;
    }
    
    if (detailModel.info.count > 0) {
        UILabel *label = [CustomView customTitleUILableWithContentView:_bgScrollview title:@"申请清单："];
        label.frame = CGRectMake(8, _lastView.bottom, SCREEN_WIDTH-30, 30);
        _lastView = label;
        
        for (int i = 0; i < detailModel.info.count; i ++) {
            ShowStampView *stampView = [[ShowStampView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 125)];
             CGFloat height = [stampView showStampViewData:detailModel.info[i]];
            CGRect frame = stampView.frame;
            frame.size.height = height;
            stampView.frame = frame;
            _lastView = stampView;
            [_bgScrollview addSubview:stampView];
        }
    }
    
    _sponsorLabel = [CustomView customContentUILableWithContentView:_bgScrollview title:nil];
    _sponsorLabel.frame = CGRectMake(8, _lastView.bottom+2, SCREEN_WIDTH-16, 20);
//    _sponsorLabel.backgroundColor = [UIColor greenColor];
    
    _approvalLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, _sponsorLabel.bottom, SCREEN_WIDTH-16, 35)];
    _approvalLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [_bgScrollview addSubview:_approvalLabel];
    _lastView = _approvalLabel;
    _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+100);
    
    
    
}


@end
