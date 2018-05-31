//
//  CompanyReviewViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CompanyReviewViewController.h"

#import "CXZ.h"
#import "ApprovalContentView.h"
#import "HomeFitView.h"
#import "CompanyFitView.h"
#import "EnclosureView.h"

#import "ReviewDetailModel.h"
#import "CompanyContractReviewModel.h"
#import "CompanyContractModel.h"
#import "ApprovalResultModel.h"

#import "AdressBookViewController.h"
#import "AddProjectViewController.h"
#import "Company_SendViewController.h"
#import "GuideViewController.h"
#import "FileListViewController.h"

@interface CompanyReviewViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,ZLPhotoPickerBrowserViewControllerDelegate,CompanyFitViewDelegate,HomeFitViewDelegate,AdressBookDelegate,CopyDelegate,ProjectViewControllerDelegate,EnclosureViewDelegate,CompanySendViewControllerDelegate>
{
    NSInteger viewTag;
}
@property(nonatomic ,strong)UIScrollView *mainScrollView;

@property(nonatomic ,strong)UITextView *titleTextField;

@property(nonatomic ,strong)UITextView *contractTitleTxtview;

@property(nonatomic ,strong)UITextField *contractIdTxt;

@property(nonatomic ,strong)UITextField *jiafangTxf;

@property(nonatomic ,strong)UITextField *yifangTxf;

@property(nonatomic ,strong)UITextField *executeTxf;

@property(nonatomic ,strong)UITextField *priceTxtfield;

@property(nonatomic ,strong)UITextField *totalTxtfield;

@property(nonatomic ,strong)UITextView *diffrenceTxtview;

@property(nonatomic ,strong)UITextView *paymentTxtview;

@property(nonatomic ,strong)UILabel *arrivalTimeLabel;

@property(nonatomic ,strong)UILabel *compeleteLabel;

@property(nonatomic ,strong) UIButton *projectManagerBtn;//项目经理

@property(nonatomic ,strong)UITextView *contentTextview;//内容

@property(nonatomic ,strong)HomeFitView *homeView;

@property(nonatomic ,strong)CompanyFitView *companyView;

@property(nonatomic ,strong)EnclosureView *enclosureView;

@property(nonatomic ,strong)UIButton *addListBtn;

@property(nonatomic ,strong)UIView *line1;

@property(nonatomic ,strong)UIView *line2;

@property(nonatomic ,strong)UIButton *addContractButton;//添加合同附件

@property(nonatomic ,strong)UIButton *checkBtn;

@property(nonatomic ,strong)UIScrollView *photoScrollview;

@property(nonatomic ,strong)UILabel *approvalLabel;

@property(nonatomic , strong) DealWithApprovalView *dealView;

@property(nonatomic , strong) MoreFilesView *filesView;

@property(nonatomic ,strong) UIButton *submitbButton;

@property(nonatomic ,strong)UIView *lastView;

@property(nonatomic ,strong)ReviewDetailModel *reviewModel;

@property(nonatomic ,strong)CompanyContractModel *contractModel;

@property(nonatomic ,copy) NSString *contractID;//公司合同id

@property(nonatomic ,copy) NSString *ennexID;//附件id

@property(nonatomic, strong)NSMutableArray *imgArray;

@property (nonatomic , strong) NSMutableArray *assets;

@property (nonatomic , strong) NSMutableArray *photos;

@property (nonatomic , strong) NSMutableArray *tempAssets;

@property (nonatomic ,strong) NSMutableArray *viewArray;

@property (nonatomic, assign) NSInteger annex;//YES 自己上传的附件 NO 公司合同

@property(nonatomic , assign) NSInteger isDownload;

@property (nonatomic, copy) NSString *annexID;

@property(nonatomic ,copy)NSString *projectManagerStr;

@property(nonatomic ,strong)NSMutableArray *fileArray;

@end

@implementation CompanyReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    if ([self.typeStr isEqualToString:@"1"]) {
        [self setupTitleWithString:@"合同评审表" withColor:[UIColor whiteColor]];
    }else{
        [self setupTitleWithString:@"家装合同评审表" withColor:[UIColor whiteColor]];
    }
    [self config];
    self.projectManagerStr = @"";
    self.ennexID= @"";
    viewTag = 100;
    if (self.is_approval == YES) {
        self.mainScrollView.hidden = YES;
        [self setApprolView];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        dispatch_group_async(group, queue, ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_semaphore_signal(sem);
                [self loadResultData];
            });
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        });
        dispatch_group_async(group, queue, ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_semaphore_signal(sem);
                [self loadDetailData];
            });
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        });
    }else{
        [self setupNextWithString:@"去复制" withColor:[UIColor whiteColor]];
    }
    
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


#pragma mark Publick Method

-(void)onBack
{
    [self.filesView removeObserver:self forKeyPath:@"height"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNext
{
    if (self.is_copy) {
        [self.delegate copyCompanyReviewAll:self.reviewModel];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        CopyViewController *copyVC = [[CopyViewController alloc]init];
        copyVC.companyID = self.company_id;
        
        if ([self.typeStr isEqualToString:@"1"]) {
            copyVC.type = 111;
        }else{
            copyVC.type = 2;
        }
        copyVC.delegate = self;
        [self.navigationController pushViewController:copyVC animated:YES];
    }
}
#pragma mark Private Method
// approvalStr = YES 获取 内容
-(void)loadDetailData
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"approval_id":self.approval_id};
    [[NetworkSingletion sharedManager]getContractReviewDetail:paramDict onSucceed:^(NSDictionary *dict) {
        //                        NSLog(@"*detail**%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            ReviewDetailModel *detailModel = [ReviewDetailModel objectWithKeyValues:dict[@"data"]];
            self.reviewModel = detailModel;
            self.titleTextField.text = detailModel.contract_name;
            self.contractIdTxt.text = detailModel.contract_num;
            self.contentTextview.text = detailModel.remarks;
            CGSize size = CGSizeMake(self.contentTextview.width, MAXFLOAT);
            CGSize labelSize = [self.contentTextview sizeThatFits:size];
            CGRect newFrame = self.contentTextview.frame;
            newFrame.size = CGSizeMake(self.contentTextview.width,labelSize.height);
            self.contentTextview.frame = newFrame;
            _line1.top = self.contentTextview.bottom;
            if (detailModel.project_manager_name) {
                [self.projectManagerBtn setTitle:[detailModel.project_manager_name objectForKey:@"name"] forState:UIControlStateNormal];
            }
            
            _checkBtn = [UIButton buttonWithType: UIButtonTypeCustom];
            _checkBtn.frame = CGRectMake(8, _lastView.bottom, 100, 30);
            [_checkBtn setTitle:@"查看附件" forState:UIControlStateNormal];
            [_checkBtn setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
            _checkBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE weight:0.8];
            _checkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_checkBtn addTarget:self action:@selector(checkEnnex) forControlEvents:UIControlEventTouchUpInside];
            [_mainScrollView addSubview:_checkBtn];
            _lastView = _checkBtn;
            if ([self.typeStr isEqualToString:@"1"]) {//公装
                for (int i = 0; i < detailModel.content.count; i++) {
                    CompanyFitView *view = [[CompanyFitView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 100)];
                    [view showCompanyFitViewWithDict:detailModel.content[i]];
                    [_mainScrollView addSubview:view];
                    _lastView = view;
                }
                _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+100);
            }else{
                for (int i = 0; i < detailModel.content.count; i++) {
                    HomeFitView *view = [[HomeFitView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 75)];
                    [view showHomeFitViewWithDict:detailModel.content[i]];
                    [_mainScrollView addSubview:view];
                    _lastView = view;
                }
                _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+100);
            }
            
            
            self.mainScrollView.hidden = NO;
            
            if (detailModel.is_enclosure == 1) {
                self.annex = 1;
                self.annexID = detailModel.enclosure_id;
            }else{
                self.annex = 0;
            }
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
                                @"type":self.typeStr};
    [[NetworkSingletion sharedManager]getReviewResult:paramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"**result*%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            
            ApprovalResultModel *resultModel = [ApprovalResultModel objectWithKeyValues:dict[@"data"]];
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in resultModel.list) {
                [array addObject:dict[@"name"]];
            }
            
            NSString *approvalStr = [array componentsJoinedByString:@"、"];
            _approvalLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, _lastView.bottom, SCREEN_WIDTH-16, 35)];
            _approvalLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
            _approvalLabel.numberOfLines = 2;
            _approvalLabel.textColor = TITLECOLOR;
            [_mainScrollView addSubview:_approvalLabel];
            _lastView = _approvalLabel;
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, _lastView.bottom, SCREEN_WIDTH-16, 1)];
            line.backgroundColor = UIColorFromRGB(224, 223, 226);
            [_mainScrollView addSubview:line];
            _lastView = line;
            self.approvalLabel.text = [NSString stringWithFormat:@"审批人员：%@",approvalStr];
            if (resultModel.content.count > 0) {
                for (int i = 0; i < resultModel.content.count; i++ ) {
                    [self addApprovalviewWithDict:resultModel.content[i]];
                }
                
            }
            if (resultModel.finance) {
                [self addCashierReplyContentView:resultModel.finance];
            }

            self.isDownload = resultModel.is_ok;
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


-(void)submitForm
{
    if ([NSString isBlankString:self.titleTextField.text]) {
        [WFHudView showMsg:@"请输入工程名称" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.titleTextField.text]) {
        [WFHudView showMsg:@"请输入工程名称" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.contractTitleTxtview.text]) {
        [WFHudView showMsg:@"请输入合同名称" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.contractIdTxt.text]) {
        [WFHudView showMsg:@"请输入合同编号" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.jiafangTxf.text]) {
        [WFHudView showMsg:@"请输入甲方名称" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.yifangTxf.text]) {
        [WFHudView showMsg:@"请输入乙方名称" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.priceTxtfield.text]) {
        [WFHudView showMsg:@"请输入单价" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.totalTxtfield.text]) {
        [WFHudView showMsg:@"请输入总价" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.diffrenceTxtview.text]) {
        [WFHudView showMsg:@"请输入与投标价格差异" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.paymentTxtview.text]) {
        [WFHudView showMsg:@"请输入付款方式" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.arrivalTimeLabel.text]) {
        [WFHudView showMsg:@"请选择到货时间" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.compeleteLabel.text]) {
        [WFHudView showMsg:@"请选择完工时间" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.contentTextview.text]) {
        [WFHudView showMsg:@"请输入合同主要内容" inView:self.view];
        return;
    }
    NSMutableArray *hushArray = [NSMutableArray array];
    if (self.filesView.imgArray.count > 0) {
        for (int i = 0; i < self.filesView.imgArray.count; i++) {
            UploadImageModel *imgView = self.filesView.imgArray[i];
            if ([NSString isBlankString:imgView.hashString]) {
                [WFHudView showMsg:@"图片正在上传中，请稍后提交.." inView:self.view];
                return;
            }
            [hushArray addObject:imgView.hashString];
            
        }
        [self uploadPhotos:hushArray];
    }else{
        if(self.filesView.file_id_array.count > 0){
            
            [self uploadCompanyData];
        }else{
            [WFHudView showMsg:@"请上传附件" inView:self.view];
            return;
        }
    }
    
}

-(void)clickRrightFirstItem
{
    if (self.isDownload == 0 ) {
        NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                    @"approval_id":self.approval_id,
                                    @"company_id":self.company_id};
        [[NetworkSingletion sharedManager]cancelApproval:paramDict onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue] == 0) {
                [MBProgressHUD showSuccess:@"已撤回" toView:self.view];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }else if (self.isDownload == 1){
        [WFHudView showMsg:@"审批已通过，不能撤回.." inView:self.view];
    }else if (self.isDownload == 2){
        [WFHudView showMsg:@"审批被拒绝，不能撤回.." inView:self.view];
    }else if (self.isDownload == 3){
        [WFHudView showMsg:@"审批已撤回" inView:self.view];
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
//上传附件
-(void)uploadPhotos:(NSMutableArray*)hashArray
{
    NSString *hashStr = [NSString dictionaryToJson:hashArray];
    [[NetworkSingletion sharedManager]updateReviewAnnexNew:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"picture":hashStr} onSucceed:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        if ([dict[@"code"] integerValue]==0) {
            self.ennexID = [dict[@"data"] objectForKey:@"enclosure_id"];
            [self uploadCompanyData];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self.view];
        }
    } OnError:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
    
}

-(void)uploadCompanyData
{
    self.submitbButton.userInteractionEnabled = NO;
    NSMutableArray *enclosureArray = [NSMutableArray array];
    if (self.filesView.file_id_array.count > 0) {
        [enclosureArray addObjectsFromArray:self.filesView.file_id_array];
    }
    if (![NSString isBlankString:self.ennexID]) {
       NSDictionary *dict = @{@"contract_id":self.ennexID,@"type":@(3),@"name":@"图片"};
        [enclosureArray addObject:dict];
    }
    //    NSLog(@"****%@",self.ennexID);
    NSDictionary *dict = @{@"type":self.typeStr,
                           @"company_id":self.company_id,
                           @"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"contract_name":self.titleTextField.text,
                           @"contract_num":self.contractIdTxt.text,
                           @"remarks":self.contentTextview.text,
                           @"a_name":self.jiafangTxf.text,
                           @"b_name":self.yifangTxf.text,
                           @"prive":self.priceTxtfield.text,
                           @"total_prive":self.totalTxtfield.text,
                           @"difference":self.diffrenceTxtview.text,
                           @"pay_method":self.paymentTxtview.text,
                           @"arrive_time":self.arrivalTimeLabel.text,
                           @"end_time":self.compeleteLabel.text,
                           @"executor":self.executeTxf.text,
                           @"contract_name_new":self.contractTitleTxtview.text,
                           };
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict addEntriesFromDictionary:dict];
    if (![NSString isBlankString:self.projectManagerStr]) {
        [paramDict setObject:self.projectManagerStr forKey:@"project_manager"];
        
    }
    if (![NSString isBlankString:self.contractID]) {
        [paramDict setObject:self.contractID forKey:@"contract_id"];
    }
    if (enclosureArray.count > 0) {
        NSString *many_enclosure = [NSString dictionaryToJson:enclosureArray];
        [paramDict setObject:many_enclosure forKey:@"many_enclosure"];
    }
  
    [[NetworkSingletion sharedManager]creatCompanyReview:paramDict onSucceed:^(NSDictionary *dict) {
        //                        NSLog(@"**sefds*%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            [self.filesView removeObserver:self forKeyPath:@"height"];
           
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            self.submitbButton.userInteractionEnabled = YES;
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        self.submitbButton.userInteractionEnabled = YES;
        [MBProgressHUD showError:error toView:self.view];
    }];
}


#pragma mark 点击事件

//添加清单
-(void)addListView
{
    if ([self.typeStr isEqualToString:@"1"]) {//公装
        CompanyFitView *companyView = [[CompanyFitView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 100)];
        companyView.tag = viewTag;
        companyView.delegate = self;
        [_mainScrollView addSubview:companyView];
        _lastView = companyView;
        [self.viewArray addObject:companyView];
    }else{
        HomeFitView *homeView = [[HomeFitView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 75)];
        homeView.tag = viewTag;
        [_mainScrollView addSubview:homeView];
        _lastView = homeView;
        homeView.delegate = self;
        [self.viewArray addObject:homeView];
    }
    viewTag ++;
    self.submitbButton.top = _lastView.bottom+40;
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+200);
}



//添加 审批 view
-(void)addApprovalviewWithDict:(NSDictionary*)dict
{
    ApprovalContentView *approvalView = [[ApprovalContentView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 40)];
    CGFloat height = [approvalView setApprovalContentWithDictinary:dict];
    CGRect frame = approvalView.frame;
    frame.size.height = height;
    approvalView.frame = frame;
   
    [_mainScrollView addSubview:approvalView];
    _lastView = approvalView;
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+100);
}

//查看附件
-(void)checkEnnex
{
    if (self.annex == 1) {
        //            NSLog(@"*sdad**%@ ***%@",self.annexID,self.approval_id);
        if (![NSString isBlankString:self.annexID]) {
            [[NetworkSingletion sharedManager]getReviewAnnexDetail:@{@"enclosure_id":self.annexID} onSucceed:^(NSDictionary *dict) {
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
        }
        
    }else{
//        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"app_token"];
//        NSString *uid =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
//        NSString *urlStr = [NSString stringWithFormat:@"%@/index.php/Mobile/find/contract_company_detail?skey=%@&skey_uid=%@&id=%@",API_HOST,token,uid,self.contractID];
//        WebViewController *web = [WebViewController new];
//        web.urlStr = urlStr;
//        web.title = @"合同详情";
//        web.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:web animated:YES];
//        self.hidesBottomBarWhenPushed = YES;
        EditWebViewController *web = [[EditWebViewController alloc]init];
        web.titleString = @"合同详情";
        web.editType = 8;
        web.contractID = [self.contractID integerValue];
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}
//选择部门经理
-(void)clickProjectManager
{
    AdressBookViewController *bookVC = [[AdressBookViewController alloc]init];
    bookVC.isSelectedManager = YES;
    bookVC.companyid = self.company_id;
    bookVC.delegate = self;
    bookVC.loadDataType = 2;
    [self.navigationController pushViewController:bookVC animated:YES];
}

-(void)clickSelectedDate:(UITapGestureRecognizer*)tap
{
    NSInteger tag = ((UILabel*)tap.view).tag;
    
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
//    picker.minimumDate = [NSDate date];
    picker.frame = CGRectMake(0, 40, 320, 200);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择时间\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSDate *date = picker.date;
        if (tag == 10) {
            self.arrivalTimeLabel.text = [date stringWithFormat:@"yyyy-MM-dd"];
        }else{
            self.compeleteLabel.text = [date stringWithFormat:@"yyyy-MM-dd"];
        }
        
    }];
    [alertController.view addSubview:picker];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)clickRightButton:(UIButton*)buton
{
    NSInteger tag = buton.tag;
    if (tag == 1000) {
        AddProjectViewController *addVC = [[AddProjectViewController alloc]init];
        addVC.company_id = self.company_id;
        addVC.delegate = self;
        addVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else{
        Company_SendViewController *sendVC = [[Company_SendViewController alloc]init];
        sendVC.isSelected = YES;
        sendVC.delegate = self;
        sendVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sendVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark ViewController Delegate

-(void)selectedProject:(NSDictionary *)projectDict
{
    self.titleTextField.text = projectDict[@"project_name"];
}

-(void)selectedPorjectManager:(NSDictionary *)dict
{
    NSDictionary *dictionay = @{@"uid":dict[@"uid"]};
    self.projectManagerStr = [NSString dictionaryToJson:dictionay];
    [self.projectManagerBtn setTitle:dict[@"name"] forState:UIControlStateNormal];
}

-(void)copyAll:(id)model
{
    CompanyContractReviewModel *detailModel = (CompanyContractReviewModel*)model;
    self.titleTextField.text = detailModel.contract_name;
    self.contractTitleTxtview.text = detailModel.contract_name_new;
    self.contractIdTxt.text = detailModel.contract_num;
    self.contentTextview.text = detailModel.remarks;
    self.jiafangTxf.text = detailModel.a_name;
    self.yifangTxf.text = detailModel.b_name;
    self.executeTxf.text = detailModel.executor;
    if (![NSString isBlankString:detailModel.project_manager_id]) {
        NSDictionary *dictionay = @{@"uid":detailModel.project_manager_id};
        self.projectManagerStr = [NSString dictionaryToJson:dictionay];
        [self.projectManagerBtn setTitle:detailModel.project_manager_name[@"name"] forState:UIControlStateNormal];
    }
    if (![NSString isBlankString:detailModel.contract_id]) {
        self.enclosureView.hidden = NO;
        self.contractID = detailModel.contract_id;
    }
    self.priceTxtfield.text = detailModel.prive;
    self.totalTxtfield.text = detailModel.total_prive;
    self.diffrenceTxtview.text = detailModel.difference;
    self.paymentTxtview.text = detailModel.pay_method;
    self.arrivalTimeLabel.text = detailModel.arrive_time;
    self.compeleteLabel.text = detailModel.end_time;
    NSMutableArray *fileArray = [NSMutableArray array];
    if (detailModel.enclosure_id) {
        NSString *enclosure_id = [NSString stringWithFormat:@"%li",[detailModel.enclosure_id integerValue]];
        NSDictionary *dict = @{@"contract_id":enclosure_id,@"type":@(3),@"name":@"图片附件"};
        [fileArray addObject:dict];
    }
    if (detailModel.attachments_id) {
        NSString *contractid = [NSString stringWithFormat:@"%li",[[detailModel.attachments_id objectForKey:@"contract_id"] integerValue]];
        NSInteger type = [[detailModel.attachments_id objectForKey:@"type"] integerValue];
        NSDictionary *dict = @{@"contract_id":contractid,@"type":@(type),@"name":@"图片附件"};
        [fileArray addObject:dict];
    }
    if (detailModel.many_enclosure.count > 0) {
        [fileArray addObjectsFromArray:detailModel.many_enclosure];
    }
    [self.filesView setMoreFilesViewWithArray:fileArray];
}

-(void)copyReviewAll:(id)model
{
    ReviewDetailModel *detailModel = (ReviewDetailModel*)model;
    self.titleTextField.text = detailModel.contract_name;
    self.contractIdTxt.text = detailModel.contract_num;
    self.contentTextview.text = detailModel.remarks;
    
    if (![NSString isBlankString:detailModel.project_manager_id]) {
        NSDictionary *dictionay = @{@"uid":detailModel.project_manager_id};
        self.projectManagerStr = [NSString dictionaryToJson:dictionay];
        [self.projectManagerBtn setTitle:detailModel.project_manager_name[@"name"] forState:UIControlStateNormal];
    }
    
    if (![NSString isBlankString:detailModel.enclosure_id]) {
        self.ennexID = detailModel.enclosure_id;
        [[NetworkSingletion sharedManager]getReviewAnnexDetail:@{@"enclosure_id":detailModel.enclosure_id} onSucceed:^(NSDictionary *dict) {
            
            if ([dict[@"code"] integerValue]==0) {
                NSArray *imageArray = [dict[@"data"] objectForKey:@"picture"];
                [self.imgArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self.imgArray removeAllObjects];
                NSInteger count = imageArray.count;
                for (int i = 0 ; i < imageArray.count ; i++) {
                    NSString *pic = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,imageArray[i]];
                    UIImageView *imgview = [[UIImageView alloc]init];
                    [imgview sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:nil];
                    imgview.tag = i;
                    imgview.contentMode = UIViewContentModeScaleAspectFill;
                    imgview.layer.masksToBounds = YES;
                    [_photoScrollview addSubview:imgview];
                    imgview.frame = CGRectMake(40*i, 0, 40, 40);
                    //                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotos:)];
                    //                    imgview.userInteractionEnabled = YES;
                    //                    [imgview addGestureRecognizer:tap];
                    [self.imgArray addObject:imgview];
                    
                }
                
                _photoScrollview.contentSize = CGSizeMake(40*count, 40);
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }
    if (detailModel.content.count>0) {
        if ([self.typeStr isEqualToString:@"1"]) {//公装
            [self.companyView showCompanyFitViewWithDict:detailModel.content[0]];
            
            for (int i = 1; i < detailModel.content.count; i++) {
                CompanyFitView *companyView = [[CompanyFitView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 100)];
                [companyView showCopyCompanyFitViewWithDict:detailModel.content[i]];
                companyView.tag = viewTag;
                companyView.delegate = self;
                [_mainScrollView addSubview:companyView];
                _lastView = companyView;
                [self.viewArray addObject:companyView];
            }
        }else{
            [self.homeView showHomeFitViewWithDict:detailModel.content[0]];
            for (int i = 1; i < detailModel.content.count; i++) {
                HomeFitView *homeView = [[HomeFitView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 75)];
                [homeView showCopyHomeFitViewWithDict:detailModel.content[i]];
                homeView.tag = viewTag;
                [_mainScrollView addSubview:homeView];
                _lastView = homeView;
                homeView.delegate = self;
                [self.viewArray addObject:homeView];
            }
        }
        
        viewTag ++;
    }
    
    
    self.submitbButton.top = _lastView.bottom+40;
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+200);
    
}


#pragma mark View Delegate

-(void)selectedContract:(CompanyContractModel *)contractModel
{
    self.contractModel = contractModel;
    self.contractID = contractModel.contract_draft_id;
    self.contractTitleTxtview.text = contractModel.contract_name;
    self.yifangTxf.text = contractModel.b_name;
    self.enclosureView.hidden = NO;
}
-(void)deleteCompanyFitView:(NSInteger)tag
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        CompanyFitView *view =(CompanyFitView*) [_mainScrollView viewWithTag:tag];
        [view removeFromSuperview];
        [self.viewArray removeObject:view];
        [self refreshWorkerListUI];
    }) ;
}

-(void)deleteHomeFitView:(NSInteger)tag
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        HomeFitView *view =(HomeFitView*) [_mainScrollView viewWithTag:tag];
        [view removeFromSuperview];
        [self.viewArray removeObject:view];
        [self refreshWorkerListUI];
    }) ;
}

//刷新UI
-(void)refreshWorkerListUI
{
    _lastView = _addListBtn;
    [self.viewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if ([self.typeStr isEqualToString:@"1"]) {//公装
        
        for (int i = 0; i < self.viewArray.count; i++) {
            CompanyFitView *view =(CompanyFitView*) self.viewArray[i];
            view.frame = CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 100);
            [self.mainScrollView addSubview:view];
            _lastView = view;
        }
    }else{
        for (int i = 0; i < self.viewArray.count; i++) {
            HomeFitView *view =(HomeFitView*) self.viewArray[i];
            view.frame = CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 75);
            [self.mainScrollView addSubview:view];
            _lastView = view;
        }
    }
}

-(void)clickDeleteEnclosure
{
    
    self.contractID = nil;
    self.enclosureView.hidden = YES;
}
-(void)clickEnclosure
{
    WebViewController *web = [[WebViewController alloc]init];
    web.urlStr = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_draft?view=2&id=%li",API_HOST,[self.contractModel.contract_draft_id integerValue]];
    web.titleString = self.contractModel.contract_name;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
#pragma mark 界面

-(void)config
{
    _mainScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _mainScrollView.showsVerticalScrollIndicator = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_mainScrollView];
    
    NSString *titleStr =@"工程名称：";
    CGSize titleSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *title = [self customUILabelWithFrame:CGRectMake(8, 0, titleSize.width, 35) title:titleStr];
    [_mainScrollView addSubview:title];
    
    _titleTextField = [[UITextView alloc]initWithFrame:CGRectMake(title.right, title.top, SCREEN_WIDTH-title.right-32, title.height)];
    _titleTextField.font = title.font;
    [_mainScrollView addSubview:_titleTextField];
    
    UIButton *rightBtn1 = [CustomView customButtonWithContentView:_mainScrollView image:@"right" title:nil];
    rightBtn1.tag = 1000;
    rightBtn1.frame = CGRectMake(_titleTextField.right, title.top, 32, 32);
    rightBtn1.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [rightBtn1 addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [self customLineViewWithFrame:CGRectMake(8, _titleTextField.bottom, SCREEN_WIDTH-16, 1)];
    [_mainScrollView addSubview:line];
    _lastView = line;
    
    NSString *contractTitleStr =@"合同名称：";
    CGSize contractTitleSize = [contractTitleStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *contract = [self customUILabelWithFrame:CGRectMake(8, line.bottom, contractTitleSize.width, 35) title:contractTitleStr];
    [_mainScrollView addSubview:contract];
    
    _contractTitleTxtview = [[UITextView alloc]initWithFrame:CGRectMake(contract.right, contract.top, SCREEN_WIDTH-contract.right-32-55, title.height)];
    _contractTitleTxtview.font = title.font;
    [_mainScrollView addSubview:_contractTitleTxtview];
    
    _enclosureView = [[EnclosureView alloc]initWithFrame:CGRectMake(_contractTitleTxtview.right, _contractTitleTxtview.top, 55, 35)];
    _enclosureView.hidden = YES;
    _enclosureView.delegate = self;
    [_mainScrollView addSubview:_enclosureView];
    
    UIButton *rightBtn2 = [CustomView customButtonWithContentView:_mainScrollView image:@"right" title:nil];
    rightBtn2.tag = 1001;
    rightBtn2.frame = CGRectMake(SCREEN_WIDTH-32, contract.top, 32, 32);
    rightBtn2.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [rightBtn2 addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIView *line99 = [self customLineViewWithFrame:CGRectMake(8, _contractTitleTxtview.bottom, SCREEN_WIDTH-16, 1)];
    [_mainScrollView addSubview:line99];
    _lastView = line99;
    
    NSString *contractStr =@"合同编号：";
    CGSize contractSize = [contractStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *contractLabel = [self customUILabelWithFrame:CGRectMake(title.left, line99.bottom, contractSize.width, title.height) title:@"合同编号："];
    [_mainScrollView addSubview:contractLabel];
    
    _contractIdTxt = [self customTextFieldWithFrame:CGRectMake(contractLabel.right, contractLabel.top, SCREEN_WIDTH-contractLabel.right-8, contractLabel.height)];
    [_mainScrollView addSubview:_contractIdTxt];
    
    UIView *line2 = [self customLineViewWithFrame:CGRectMake(line.left, _contractIdTxt.bottom, line.width, line.height)];
    [_mainScrollView addSubview:line2];
    _lastView = line2;
    
    if (!self.is_approval && [self.typeStr isEqualToString:@"1"])
    {
        NSString *jiafangStr =@"甲方：";
        CGSize jiafangSize = [jiafangStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *jiafangLabel = [self customUILabelWithFrame:CGRectMake(title.left, _lastView.bottom, jiafangSize.width, title.height) title:jiafangStr];
        [_mainScrollView addSubview:jiafangLabel];
        
        _jiafangTxf = [self customTextFieldWithFrame:CGRectMake(jiafangLabel.right, jiafangLabel.top, SCREEN_WIDTH-jiafangLabel.right-8, jiafangLabel.height)];
        [_mainScrollView addSubview:_jiafangTxf];
        
        UIView *line3 = [self customLineViewWithFrame:CGRectMake(line.left, _jiafangTxf.bottom, line.width, line.height)];
        [_mainScrollView addSubview:line3];
        
        NSString *yifangStr =@"乙方：";
        CGSize yifangSize = [yifangStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *yifangLabel = [self customUILabelWithFrame:CGRectMake(title.left, line3.bottom, yifangSize.width, title.height) title:yifangStr];
        [_mainScrollView addSubview:yifangLabel];
        
        _yifangTxf = [self customTextFieldWithFrame:CGRectMake(yifangLabel.right, yifangLabel.top, SCREEN_WIDTH-yifangLabel.right-8, yifangLabel.height)];
        [_mainScrollView addSubview:_yifangTxf];
        
        UIView *line4 = [self customLineViewWithFrame:CGRectMake(line.left, _yifangTxf.bottom, line.width, line.height)];
        [_mainScrollView addSubview:line4];
        
        
        NSString *executeStr =@"执行人：";
        CGSize executeSize = [executeStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *executeLabel = [self customUILabelWithFrame:CGRectMake(title.left, line4.bottom, executeSize.width, title.height) title:executeStr];
        [_mainScrollView addSubview:executeLabel];
        
        
        AdressBookButton *nameBtn = [[AdressBookButton alloc]initWithFrame:CGRectMake(executeLabel.right, executeLabel.top+7, 20, 20)];
        nameBtn.companyID = self.company_id;
        __weak typeof(self) weakSelf = self;
        nameBtn.DidSelectObjectBlock = ^(NSDictionary *object) {
            //        NSLog(@"gaga  %@",object);
            if ([NSString isBlankString:object[@"name"]]) {
                weakSelf.executeTxf.text = @"";
            }else{
                weakSelf.executeTxf.text = object[@"name"];
            }
//            weakSelf.executeTxf.text = object[@"name"];
        };
        [_mainScrollView addSubview:nameBtn];
        
        _executeTxf = [self customTextFieldWithFrame:CGRectMake(nameBtn.right, executeLabel.top, SCREEN_WIDTH-nameBtn.right-8, executeLabel.height)];
        [_mainScrollView addSubview:_executeTxf];
        
        
        UIView *line5 = [self customLineViewWithFrame:CGRectMake(line.left, _executeTxf.bottom, line.width, line.height)];
        [_mainScrollView addSubview:line5];
        
        
        _lastView = line5;
        
    }
    
    NSString *content = @"项目经理：";
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *managerLabel = [self customUILabelWithFrame:CGRectMake(_lastView.left, _lastView.bottom, contentSize.width, title.height) title:content];
    [_mainScrollView addSubview:managerLabel];
    
    _projectManagerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _projectManagerBtn.frame = CGRectMake(managerLabel.right, managerLabel.top, SCREEN_WIDTH-managerLabel.right-8, managerLabel.height);
    [_projectManagerBtn setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
    _projectManagerBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [_projectManagerBtn addTarget:self action:@selector(clickProjectManager) forControlEvents:UIControlEventTouchUpInside];
    _projectManagerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_mainScrollView addSubview:_projectManagerBtn];
    
    UIView *line6 = [self customLineViewWithFrame:CGRectMake(line2.left, _projectManagerBtn.bottom, line2.width, line2.height)];
    [_mainScrollView addSubview:line6];
    _lastView = line6;
    
    if (!self.is_approval && [self.typeStr isEqualToString:@"1"])
    {
        NSString *price =@"单价（元）：";
        CGSize priceSize = [price sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *priceLabel = [self customUILabelWithFrame:CGRectMake(title.left, _lastView.bottom, priceSize.width, 30) title:price];
        [_mainScrollView addSubview:priceLabel];
        
        _priceTxtfield = [self customTextFieldWithFrame:CGRectMake(priceLabel.right, priceLabel.top, SCREEN_WIDTH/2-priceLabel.right, priceLabel.height)];
        _priceTxtfield.keyboardType = UIKeyboardTypeDecimalPad;
        [_mainScrollView addSubview:_priceTxtfield];
        
        NSString *total =@"总价（元）：";
        CGSize totalSize = [total sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *totalLabel = [self customUILabelWithFrame:CGRectMake(_priceTxtfield.right, priceLabel.top, totalSize.width, priceLabel.height) title:total];
        [_mainScrollView addSubview:totalLabel];
        
        _totalTxtfield = [self customTextFieldWithFrame:CGRectMake(totalLabel.right, totalLabel.top, SCREEN_WIDTH-totalLabel.right-8, priceLabel.height)];
        _totalTxtfield.keyboardType = UIKeyboardTypeDecimalPad;
        [_mainScrollView addSubview:_totalTxtfield];
        
        UIView *line7 = [self customLineViewWithFrame:CGRectMake(line2.left, _totalTxtfield.bottom, line2.width, line2.height)];
        [_mainScrollView addSubview:line7];
        
        NSString *diffrence =@"与投标价格差异：";
        CGSize diffrenceSize = [diffrence sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *diffrenceLabel = [self customUILabelWithFrame:CGRectMake(priceLabel.left, line7.bottom, diffrenceSize.width, 25) title:diffrence];
        [_mainScrollView addSubview:diffrenceLabel];
        
        _diffrenceTxtview = [[UITextView alloc]initWithFrame:CGRectMake(diffrenceLabel.right, diffrenceLabel.top, SCREEN_WIDTH-diffrenceLabel.right-8, 40)];
        [_mainScrollView addSubview:_diffrenceTxtview];
        
        UIView *line8 = [self customLineViewWithFrame:CGRectMake(line2.left, _diffrenceTxtview.bottom, line2.width, line2.height)];
        [_mainScrollView addSubview:line8];
        
        NSString *payment =@"付款方式：";
        CGSize paymentSize = [payment sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *paymentLabel = [self customUILabelWithFrame:CGRectMake(priceLabel.left, line8.bottom, paymentSize.width, 25) title:payment];
        [_mainScrollView addSubview:paymentLabel];
        
        _paymentTxtview = [[UITextView alloc]initWithFrame:CGRectMake(paymentLabel.right, paymentLabel.top, SCREEN_WIDTH-paymentLabel.right-8, 40)];
        [_mainScrollView addSubview:_paymentTxtview];
        
        UIView *line9 = [self customLineViewWithFrame:CGRectMake(line2.left, _paymentTxtview.bottom, line2.width, line2.height)];
        [_mainScrollView addSubview:line9];
        
        NSString *arrival = @"到货时间：";
        CGSize arrivalSize = [arrival sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *arrivalLabel = [self customUILabelWithFrame:CGRectMake(priceLabel.left, line9.bottom, arrivalSize.width, 30) title:arrival];
        [_mainScrollView addSubview:arrivalLabel];
        
        _arrivalTimeLabel = [self customUILabelWithFrame:CGRectMake(arrivalLabel.right, arrivalLabel.top, SCREEN_WIDTH/2-arrivalLabel.width, arrivalLabel.height) title:nil];
        _arrivalTimeLabel.textColor = FORMTITLECOLOR;
        _arrivalTimeLabel.tag = 10;
        [_mainScrollView addSubview:_arrivalTimeLabel];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSelectedDate:)];
        _arrivalTimeLabel.userInteractionEnabled = YES;
        [_arrivalTimeLabel addGestureRecognizer:tap1];
        
        NSString *complete =@"完工时间：";
        CGSize completeSize = [complete sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *completeLabel = [self customUILabelWithFrame:CGRectMake(_arrivalTimeLabel.right, arrivalLabel.top, completeSize.width, arrivalLabel.height) title:complete];
        [_mainScrollView addSubview:completeLabel];
        
        _compeleteLabel = [self customUILabelWithFrame:CGRectMake(completeLabel.right, arrivalLabel.top, SCREEN_WIDTH-completeLabel.width-8, arrivalLabel.height) title:nil];
        _compeleteLabel.textColor = FORMTITLECOLOR;
        _compeleteLabel.tag = 11;
        [_mainScrollView addSubview:_compeleteLabel];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSelectedDate:)];
        _compeleteLabel.userInteractionEnabled = YES;
        [_compeleteLabel addGestureRecognizer:tap2];
        
        UIView *line10 = [self customLineViewWithFrame:CGRectMake(line.left, _compeleteLabel.bottom, line.width, line.height)];
        [_mainScrollView addSubview:line10];
        _lastView = line10;
        
    }
    
    
    NSString *mark = @"合同主要内容： ";
    CGSize markSize = [mark sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *markLabel = [self customUILabelWithFrame:CGRectMake(_lastView.left, _lastView.bottom, markSize.width, markSize.height+2) title:mark];
    [_mainScrollView addSubview:markLabel];
    
    _contentTextview = [[UITextView alloc]initWithFrame:CGRectMake(markLabel.right, markLabel.top, SCREEN_WIDTH-markLabel.right-8, 80)];
    _contentTextview.delegate = self;
    [_mainScrollView addSubview:_contentTextview];
    
    _line1 = [self customLineViewWithFrame:CGRectMake(line.left, _contentTextview.bottom, line.width, line.height)];
    [_mainScrollView addSubview:_line1];
    _lastView = _line1;
    
    if (!self.is_approval) {
        
        _filesView = [[MoreFilesView alloc]initWithFrame:CGRectMake(8, _lastView.bottom, SCREEN_WIDTH-16, 30)];
        [_mainScrollView addSubview:_filesView];
        [_filesView addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        _line2 = [self customLineViewWithFrame:CGRectMake(line.left, _filesView.bottom, line.width, line.height)];
        [_mainScrollView addSubview:_line2];
        _lastView = _line2;
        
        if ([self.typeStr isEqualToString:@"2"]){//家装
            _addListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _addListBtn.frame = CGRectMake(line.left, _lastView.bottom, _lastView.width, title.height);
            [_addListBtn setTitle:@"＋添加清单" forState:UIControlStateNormal];
            _addListBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _addListBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE weight:0.8];
            [_addListBtn setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
            [_addListBtn addTarget:self action:@selector(addListView) forControlEvents:UIControlEventTouchUpInside];
            [_mainScrollView addSubview:_addListBtn];
            _lastView= _addListBtn;
            
            _homeView = [[HomeFitView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 75)];
            _homeView.deleteButton.hidden = YES;
            [_mainScrollView addSubview:_homeView];
            _lastView = _homeView;
            [self.viewArray addObject:_homeView];
        }
        
        _submitbButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitbButton.frame = CGRectMake(8, _lastView.bottom+40, SCREEN_WIDTH-16, 40);
        _submitbButton.backgroundColor = TOP_GREEN;
        _submitbButton.layer.cornerRadius = 5;
        [_submitbButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitbButton setTitle:@"提交" forState:UIControlStateNormal];
        _submitbButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:0.8];
        [_submitbButton addTarget:self action:@selector(submitForm) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:_submitbButton];
        
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+200);
    }
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
    [_mainScrollView addSubview:cashierView];
    [cashierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_lastView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(height);
    }];
    _lastView = cashierView;
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+100);
}

-(void)setApprolView
{
    self.titleTextField.userInteractionEnabled = NO;
    self.contentTextview.userInteractionEnabled = NO;
    self.contractIdTxt.userInteractionEnabled = NO;
    
    
    if (!self.is_aready_approval) {
        _dealView = [[DealWithApprovalView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-100, SCREEN_WIDTH, 40)];
        _dealView.is_cashier = self.is_cashier;
        _dealView.approvalID = self.approval_id;
        _dealView.participation_id = self.participation_id;
        [self.view addSubview:_dealView];
        if (self.is_cashier) {
            _dealView.canApproval = YES;
            _dealView.personal_id = self.personal_id;
            _dealView.company_ID = self.company_id;
            [_dealView setApprovalMenueView];
        }
    }
    
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+100);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"height"] ) {
        CGFloat newHeight = [change[@"new"] floatValue];
        //        CGFloat oldMoney = [change[@"old"] floatValue];
//        NSLog(@"**height*%lf",newHeight);
        CGRect frame = self.filesView.frame;
        frame.size.height = newHeight;
        self.filesView.frame = frame;
     
        self.line2.top = self.filesView.bottom;
        self.submitbButton.top = self.line2.bottom+40;
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.submitbButton.bottom+100);
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark    自定义view

-(UITextField*)customTextFieldWithFrame:(CGRect)frame
{
    UITextField *textfield = [[UITextField alloc]initWithFrame:frame];
    textfield.delegate = self;
    textfield.font = [UIFont systemFontOfSize:FONT_SIZE];
    textfield.returnKeyType = UIReturnKeyDone;
    textfield.textColor = FORMTITLECOLOR;
    return textfield;
}

-(UILabel*)customUILabelWithFrame:(CGRect)frame title:(NSString*)title
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = FORMLABELTITLECOLOR;
    label.font = [UIFont systemFontOfSize:FONT_SIZE];
    if (title) {
        label.text = title;
    }
    
    return label;
}


-(UIView*)customLineViewWithFrame:(CGRect)frame
{
    UIView *line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = UIColorFromRGB(224, 223, 226);
    return line;
}

#pragma mark UITextfield Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




#pragma mark SET/GET

-(NSMutableArray*)imgArray
{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
        
    }
    return _imgArray;
}

-(NSMutableArray*)photos
{
    if (!_photos) {
        _photos = [NSMutableArray array];
        UIImage *img = [UIImage imageNamed:@"上传照片.jpg"];
        [_photos addObject:img];
    }
    return _photos;
}
-(NSMutableArray*)assets
{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

-(NSMutableArray*)viewArray
{
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
}

-(NSMutableArray*)tempAssets
{
    if (!_tempAssets) {
        _tempAssets = [NSMutableArray array];
    }
    return _tempAssets;
}

-(NSMutableArray*)fileArray
{
    if (!_fileArray) {
        _fileArray = [NSMutableArray array];
    }
    return _fileArray;
}

@end
