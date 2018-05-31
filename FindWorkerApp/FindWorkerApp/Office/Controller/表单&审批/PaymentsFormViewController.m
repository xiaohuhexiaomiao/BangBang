//
//  PaymentsFormViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/19.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "PaymentsFormViewController.h"
#import "CXZ.h"

#import "SelectedContractViewController.h"
#import "SalaryView.h"
#import "ApprovalContentView.h"
#import "EnclosureView.h"

#import "ReviewListModel.h"
#import "PaymentModel.h"

#import "AdressBookViewController.h"
#import "AddProjectViewController.h"
#import "ShowCompanyViewController.h"
#import "ShowPurchaseViewController.h"
#import "ShowFileViewController.h"
#import "CompanyReviewViewController.h"


@interface PaymentsFormViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,SalaryViewDelegate,ZLPhotoPickerBrowserViewControllerDelegate,SelectedContractDelegate,AdressBookDelegate,CopyDelegate,EnclosureViewDelegate,ProjectViewControllerDelegate>

{
    NSInteger salaryTag;
    NSInteger seleteSalaryTag;//标记选择 salary view Tag
}
@property(nonatomic ,strong)UIScrollView *bgScrollview;

@property(nonatomic ,strong)UITextView *productNameTxtfield;//工程名称

@property(nonatomic ,strong)UITextView *contractTitleTxtview;//合同名称

@property(nonatomic ,strong)EnclosureView *enclosureView;

@property(nonatomic ,strong)UIButton *addContractButton;//添加合同附件

@property(nonatomic ,strong)UITextField *nameTxtfield;//请款人姓名

@property(nonatomic ,strong)UITextField *workTypeTextfield;//工种

@property(nonatomic ,strong)UITextField *phoneTextfield;//联系方式

@property(nonatomic ,strong)UITextField *numTxtfield;//请款次数

@property(nonatomic ,strong)UITextField *accountTxtfield;//账户名

@property(nonatomic ,strong)UITextField *bankNameTxtfield;//开户行

@property(nonatomic ,strong)UITextField *bankAccountTxtfield;//账号

@property(nonatomic ,strong)UITextField *moneyTxtfield;//合同金额

@property(nonatomic ,strong)UITextField *lessTxtfield;//增减金额

@property(nonatomic ,strong)UITextField *alreadyGetMoneyTxf;//已领工程款

@property(nonatomic ,strong)UITextField *currentMoneyTxf;//本次请款

@property(nonatomic ,strong)UITextView *progressTxtview;//合同执行进度

@property(nonatomic ,strong)UILabel *contentLabel;//请款内容

@property(nonatomic ,strong)UITextView *contentTextview;//请款内容

@property(nonatomic ,strong)UIButton *addWorkListButton;//添加工人工资表

@property(nonatomic ,strong)UIView *line4;

@property(nonatomic ,strong)UIView *line5;

@property(nonatomic ,strong)UIView *line6;

@property(nonatomic ,strong) UIButton *projectManagerBtn;//项目负责人

//@property(nonatomic ,strong) UIButton *addBtn;

@property(nonatomic ,strong) UIButton *submitbButton;

@property(nonatomic ,copy) MoreFilesView *fileView;

@property(nonatomic ,strong)UIView *lastView;

//@property(nonatomic ,strong)UIView *listView;

//@property(nonatomic, strong)NSMutableArray *salaryViewArray;//存放工资表 SalaryView

@property(nonatomic , strong) NSMutableArray *assets;

@property(nonatomic , strong) NSMutableArray *photos;

@property(nonatomic ,copy)NSString *projectManagerStr;

@property(nonatomic ,copy)NSString *typeStr;

@property(nonatomic ,copy)NSString *ennexID;


@end

@implementation PaymentsFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self config];
    self.projectManagerStr = @"";
    [self setupTitleWithString:@"请款单" withColor:[UIColor whiteColor]];
    salaryTag = 99;
    
    [self setupNextWithString:@"去复制" withColor:[UIColor whiteColor]];
    
    [self getLastContent];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark 接口数据相关

-(void)getLastContent
{
    if (![NSString isBlankString:self.formID]) {
        self.enclosureView.hidden = NO;
        NSDictionary *paramDict = @{@"approval_id":self.formID};
        [[NetworkSingletion sharedManager]getLastApplyPaymentsList:paramDict onSucceed:^(NSDictionary *dict) {
//                    NSLog(@"*sdsd**%@",dict);
            if ([dict[@"code"] integerValue]==0) {
                PaymentModel *payModel = [PaymentModel objectWithKeyValues:dict[@"data"]];
                self.productNameTxtfield.text = payModel.contract_name,
                self.contractTitleTxtview.text = payModel.contract_name_new,
                self.nameTxtfield.text = payModel.request_name;
                if (![NSString isBlankString:self.contractName]) {
                    self.contractTitleTxtview.text = self.contractName;
                }
                self.workTypeTextfield.text = payModel.worker_type;
                self.phoneTextfield.text = payModel.phone;
                self.accountTxtfield.text = payModel.account_name;
                self.bankNameTxtfield.text = payModel.bank_address;
                self.bankAccountTxtfield.text = payModel.bank_card;
                self.moneyTxtfield.text = payModel.subtotal;
                self.alreadyGetMoneyTxf.text = payModel.money;
            }
        } OnError:^(NSString *error) {
            
        }];
    }
    
}

#pragma mark 提交

-(void)submitPaymentForms
{
    if (self.form_type == 0) {
        if ( [NSString isBlankString:self.productNameTxtfield.text]) {
            [WFHudView showMsg:@"请输入工程名称" inView:self.view];
            return;
        }
        if ( [NSString isBlankString:self.contractTitleTxtview.text]) {
            [WFHudView showMsg:@"请输入合同名称" inView:self.view];
            return;
        }
        if ( [NSString isBlankString:self.nameTxtfield.text]) {
            [WFHudView showMsg:@"请输入请款人姓名" inView:self.view];
            return;
        }
        if ( [NSString isBlankString:self.workTypeTextfield.text]) {
            [WFHudView showMsg:@"请输入工种" inView:self.view];
            return;
        }
        if ( [NSString isBlankString:self.accountTxtfield.text]) {
            [WFHudView showMsg:@"请输入账户名" inView:self.view];
            return;
        }
        if ( [NSString isBlankString:self.bankNameTxtfield.text]) {
            [WFHudView showMsg:@"请输入开户行" inView:self.view];
            return;
        }
        if ( [NSString isBlankString:self.numTxtfield.text]) {
            [WFHudView showMsg:@"请输入请款次数" inView:self.view];
            return;
        }
        if ( [NSString isBlankString:self.moneyTxtfield.text]) {
            [WFHudView showMsg:@"请输入合同金额" inView:self.view];
            return;
        }
        if ( [NSString isBlankString:self.currentMoneyTxf.text]) {
            [WFHudView showMsg:@"请输入本次请款金额" inView:self.view];
            return;
        }
        if ( [NSString isBlankString:self.lessTxtfield.text]) {
            [WFHudView showMsg:@"请输入增减金额" inView:self.view];
            return;
        }
        if ( [NSString isBlankString:self.alreadyGetMoneyTxf.text]) {
            [WFHudView showMsg:@"请输入已领金额" inView:self.view];
            return;
        }
        if ( [NSString isBlankString:self.progressTxtview.text]) {
            [WFHudView showMsg:@"请输入合同执行进度" inView:self.view];
            return;
        }
        if ( [NSString isBlankString:self.contentTextview.text]) {
            
        }
        if ([NSString isBlankString:self.projectManagerStr]) {
            [WFHudView showMsg:@"请选择项目经理" inView:self.view];
            return;
        }
    }
    NSMutableArray *hushArray = [NSMutableArray array];
    if (self.fileView.imgArray.count > 0) {
        for (int i = 0; i < self.fileView.imgArray.count; i++) {
            UploadImageModel *imgView = self.fileView.imgArray[i];
            if ([NSString isBlankString:imgView.hashString]) {
                [WFHudView showMsg:@"图片正在上传中，请稍后提交.." inView:self.view];
                return;
            }
            [hushArray addObject:imgView.hashString];
            
        }
        [self uploadPhotos:hushArray];
    }else{
        [WFHudView showMsg:@"请上传附件" inView:self.view];
        return;
//        [self uploadThisPage];
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
            [self uploadThisPage];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self.view];
        }
    } OnError:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
    
}

//提交数据
-(void)uploadThisPage
{
    self.submitbButton.userInteractionEnabled = NO;
    NSMutableArray *enclosureArray = [NSMutableArray array];
    if (self.fileView.file_id_array.count > 0) {
        [enclosureArray addObjectsFromArray:self.fileView.file_id_array];
    }
    if (![NSString isBlankString:self.ennexID]) {
        NSDictionary *dict = @{@"contract_id":self.ennexID,@"type":@(3),@"name":@"图片"};
        [enclosureArray addObject:dict];
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *dict = @{@"uid":uid,
                           @"contract_name":self.productNameTxtfield.text,
                           @"contract_name_new":self.contractTitleTxtview.text,
                           @"request_name":self.nameTxtfield.text,
                           @"worker_type":self.workTypeTextfield.text,
                           @"phone":self.phoneTextfield.text,
                           @"account_name":self.accountTxtfield.text,
                           @"bank_card":self.bankAccountTxtfield.text,
                           @"bank_address":self.bankNameTxtfield.text,
                           @"request_num":self.numTxtfield.text,
                           @"subtotal":self.moneyTxtfield.text,
                           @"gain_reduction_subtotal":self.lessTxtfield.text,
                           @"balance_subtotal":self.alreadyGetMoneyTxf.text,
                           @"request_subtotal":self.currentMoneyTxf.text,
                           @"request_content":self.contentTextview.text,
                           @"contract_state":self.progressTxtview.text};
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict addEntriesFromDictionary:dict];
    if (enclosureArray.count > 0) {
        NSString *many_enclosure = [NSString dictionaryToJson:enclosureArray];
        [paramDict setObject:many_enclosure forKey:@"many_enclosure"];
    }
    if (![NSString isBlankString:self.projectManagerStr]) {
        [paramDict setObject:self.projectManagerStr forKey:@"project_manager"];
    }
    if (![NSString isBlankString:self.formID]) {
        [paramDict setObject:self.formID forKey:@"form_approval_id"];
    }
    if (![NSString isBlankString:self.companyID]) {
        [paramDict setObject:self.companyID forKey:@"company_id"];
    }
    
    if (self.form_type == 1) {//添加个人
        [paramDict setObject:self.worker_user_id forKey:@"handler_uid"];
        [[NetworkSingletion sharedManager]sendPersonalPaymentsForm:paramDict onSucceed:^(NSDictionary *dict) {
//            NSLog(@"****%@",dict);
            if ([dict[@"code"] integerValue] == 0) {
                [self.fileView removeObserver:self forKeyPath:@"height"];
                for (CopyViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[CopyViewController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
                
                
            }else{
                self.submitbButton.userInteractionEnabled = YES;
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            self.submitbButton.userInteractionEnabled = YES;
            [MBProgressHUD showError:error toView:self.view];
        }];

    }else{
        [[NetworkSingletion sharedManager]addPaymentForm:paramDict onSucceed:^(NSDictionary *dict) {
//                            NSLog(@"****%@",dict);
            if ([dict[@"code"] integerValue] == 0) {
                [self.fileView removeObserver:self forKeyPath:@"height"];
                for (CopyViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[CopyViewController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }else{
                self.submitbButton.userInteractionEnabled = YES;
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            self.submitbButton.userInteractionEnabled = YES;
            [MBProgressHUD showError:error toView:self.view];
        }];

    }
}



#pragma mark 点击事件

-(void)onNext
{
    if (self.form_type == 0) {
        CopyViewController *copyVC = [[CopyViewController alloc]init];
        copyVC.companyID = self.companyID;
        copyVC.type = 1001;
        copyVC.delegate = self;
        [self.navigationController pushViewController:copyVC animated:YES];
    }else{
        CopyViewController *copyVC = [[CopyViewController alloc]init];
        copyVC.formType = 2;
        copyVC.type = 1;
        copyVC.delegate = self;
        [self.navigationController pushViewController:copyVC animated:YES];
    }
    
    
}

-(void)onBack
{
    [self.fileView removeObserver:self forKeyPath:@"height"];
    [self.navigationController popViewControllerAnimated:YES];
}

//添加附件
-(void)clickAddContractEnnex:(UIButton*)button
{
    seleteSalaryTag = button.tag;
    
    
}


-(void)clickProjectManager
{
    AdressBookViewController *bookVC = [[AdressBookViewController alloc]init];
    bookVC.isSelectedManager = YES;
    bookVC.companyid = self.companyID;
    bookVC.delegate = self;
    bookVC.loadDataType = 2;
    [self.navigationController pushViewController:bookVC animated:YES];
}


-(void)clickRightButton:(UIButton*)buton
{
    NSInteger tag = buton.tag;
    if (tag == 1000) {
        AddProjectViewController *addVC = [[AddProjectViewController alloc]init];
        addVC.company_id = self.companyID;
        addVC.delegate = self;
        addVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark ViewController Delegate

-(void)selectedProject:(NSDictionary *)projectDict
{
    self.productNameTxtfield.text = projectDict[@"project_name"];
}

-(void)selectedPorjectManager:(NSDictionary *)dict
{
    NSDictionary *dictionay = @{@"uid":dict[@"uid"]};
    self.projectManagerStr = [NSString dictionaryToJson:dictionay];
    [self.projectManagerBtn setTitle:dict[@"name"] forState:UIControlStateNormal];
}

-(void)copyAll:(id)model
{
    PaymentModel *detailModel = (PaymentModel*)model;
    
    self.productNameTxtfield.text = detailModel.contract_name;
    self.nameTxtfield.text = detailModel.request_name;
    self.workTypeTextfield.text = detailModel.worker_type;
    self.phoneTextfield.text = detailModel.phone;
    self.numTxtfield.text = detailModel.request_num;
    self.accountTxtfield.text = detailModel.account_name;
    self.bankNameTxtfield.text = detailModel.bank_address;
    self.bankAccountTxtfield.text = detailModel.bank_card;
    self.moneyTxtfield.text = detailModel.subtotal;
    self.lessTxtfield.text = detailModel.gain_reduction_subtotal;
    self.alreadyGetMoneyTxf.text = detailModel.balance_subtotal;
    self.currentMoneyTxf.text = detailModel.request_subtotal;
    self.progressTxtview.text = detailModel.contract_state;
    self.contentTextview.text = detailModel.request_content;
    self.contractTitleTxtview.text = detailModel.contract_name_new;
    
    if (![NSString isBlankString:detailModel.project_manager_id]) {
        NSDictionary *dictionay = @{@"uid":detailModel.project_manager_id};
        self.projectManagerStr = [NSString dictionaryToJson:dictionay];
        [self.projectManagerBtn setTitle:detailModel.project_manager_name[@"name"] forState:UIControlStateNormal];
    }
    
    NSMutableArray *fileArray = [NSMutableArray array];
    if (detailModel.contract_id.count>0) {
        
        [fileArray addObject:detailModel.contract_id];
    }
    if (detailModel.many_enclosure.count > 0) {
        [fileArray addObjectsFromArray:detailModel.many_enclosure];
    }
    [self.fileView setMoreFilesViewWithArray:fileArray];
    _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH,  self.line6.bottom+200);
    
    
}



#pragma mark view Delegate

-(void)clickDeleteEnclosure
{
    self.enclosureView.hidden = YES;
    self.formID = nil;
}

-(void)clickEnclosure
{
    if (self.payType ==1 ||self.payType ==2)  {
        CompanyReviewViewController *reviewVC = [[CompanyReviewViewController alloc]init];
        reviewVC.typeStr = [NSString stringWithFormat:@"%@",@(self.payType)];
        reviewVC.is_aready_approval = YES;
        reviewVC.company_id = self.companyID;
        reviewVC.approval_id = self.formID;
        reviewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:reviewVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (self.payType ==3 || self.payType ==7||self.payType ==10){
        ShowPurchaseViewController *companyVC = [[ShowPurchaseViewController alloc]init];
        companyVC.is_aready_approval = YES;
        companyVC.approvalID = self.formID;
        companyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:companyVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (self.payType==6){
        ShowFileViewController *fileVC = [[ShowFileViewController alloc]init];
        fileVC.is_aready_approval = YES;
        fileVC.approvalID = self.formID;
        fileVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fileVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (self.payType == 111) {
        ShowCompanyViewController *companyVC = [[ShowCompanyViewController alloc]init];
        companyVC.is_aready_approval = YES;
        companyVC.approval_id = self.formID;
        companyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:companyVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}









#pragma mark 界面相关

-(void)config
{
    
    _bgScrollview = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _bgScrollview.delegate = self;
    _bgScrollview.showsVerticalScrollIndicator = YES;
    _bgScrollview.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_bgScrollview];
    
    NSString *title = @"工程名称：";
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *titleLabel = [self customUILabelWithFrame:CGRectMake(8, 0, titleSize.width, 30) title:title];
    [_bgScrollview addSubview:titleLabel];
    
    _productNameTxtfield = [[UITextView alloc]initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, SCREEN_WIDTH-titleLabel.right-30, 30)];
    _productNameTxtfield.font = [UIFont systemFontOfSize:FONT_SIZE];
    _productNameTxtfield.textColor = FORMTITLECOLOR;
    [_bgScrollview addSubview:_productNameTxtfield];
    
    UIButton *rightBtn1 = [CustomView customButtonWithContentView:_bgScrollview image:@"right" title:nil];
    rightBtn1.tag = 1000;
    rightBtn1.frame = CGRectMake(_productNameTxtfield.right, _productNameTxtfield.top, 30, 30);
    rightBtn1.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [rightBtn1 addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line0 = [self customLineViewWithFrame:CGRectMake(8, _productNameTxtfield.bottom, SCREEN_WIDTH-16, 1)];
    [_bgScrollview addSubview:line0];
    
    
    NSString *contractTitleStr =@"合同名称：";
    CGSize contractTitleSize = [contractTitleStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *contract = [self customUILabelWithFrame:CGRectMake(8, line0.bottom, contractTitleSize.width, 30) title:contractTitleStr];
    [_bgScrollview addSubview:contract];
    
    _contractTitleTxtview = [[UITextView alloc]initWithFrame:CGRectMake(contract.right, contract.top, SCREEN_WIDTH-contract.right-50, titleLabel.height)];
    _contractTitleTxtview.font = titleLabel.font;
    if (![NSString isBlankString:self.contractName]) {
        _contractTitleTxtview.text = self.contractName;
    }
    [_bgScrollview addSubview:_contractTitleTxtview];
    
    _enclosureView = [[EnclosureView alloc]initWithFrame:CGRectMake(_contractTitleTxtview.right, _contractTitleTxtview.top, 50, 35)];
    _enclosureView.hidden = YES;
    _enclosureView.deleteButton.hidden = YES;
    _enclosureView.delegate = self;
    [_bgScrollview addSubview:_enclosureView];
  
    
    UIView *line99 = [self customLineViewWithFrame:CGRectMake(8, _contractTitleTxtview.bottom, SCREEN_WIDTH-16, 1)];
    [_bgScrollview addSubview:line99];
    
    
    NSString *worktype = @"工种：";
    CGSize worktypeSize = [worktype sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *worktypeLabel = [self customUILabelWithFrame:CGRectMake(titleLabel.left, line99.bottom, worktypeSize.width, 30) title:worktype];
    [_bgScrollview addSubview:worktypeLabel];
    
    _workTypeTextfield = [self customTextFieldWithFrame:CGRectMake(worktypeLabel.right, worktypeLabel.top, SCREEN_WIDTH-worktypeLabel.right-8, worktypeLabel.height)];
    [_bgScrollview addSubview:_workTypeTextfield];
    
    UIView *line1 = [self customLineViewWithFrame:CGRectMake(8, _workTypeTextfield.bottom, SCREEN_WIDTH-16, 1)];
    [_bgScrollview addSubview:line1];
    
    NSString *name = @"请款人姓名：";
    CGSize nameSize = [name sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *nameLabel = [self customUILabelWithFrame:CGRectMake(titleLabel.left, line1.bottom, nameSize.width, 30) title:name];
    _lastView = nameLabel;
    [_bgScrollview addSubview:nameLabel];
    
    AdressBookButton *nameBtn = [[AdressBookButton alloc]initWithFrame:CGRectMake(nameLabel.right, nameLabel.top+5, 20, 20)];
    nameBtn.companyID = self.companyID;
    __weak typeof(self) weakSelf = self;
    nameBtn.DidSelectObjectBlock = ^(NSDictionary *object) {
        //        NSLog(@"gaga  %@",object);
        if ([NSString isBlankString:object[@"name"]]) {
            weakSelf.nameTxtfield.text = @"";
        }else{
            weakSelf.nameTxtfield.text = object[@"name"];
        }
//        weakSelf.nameTxtfield.text = object[@"name"];
        weakSelf.phoneTextfield.text = object[@"phone"];
    };
    _lastView = nameBtn;
    [_bgScrollview addSubview:nameBtn];
    
    _nameTxtfield = [self customTextFieldWithFrame:CGRectMake(_lastView.right, nameLabel.top, 60, nameLabel.height)];
    [_bgScrollview addSubview:_nameTxtfield];
    
    NSString *phoneStr = @"联系方式：";
    CGSize phoneSize = [phoneStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *phoneLabel = [self customUILabelWithFrame:CGRectMake(_nameTxtfield.right, nameLabel.top, phoneSize.width, nameLabel.height) title:phoneStr];
    [_bgScrollview addSubview:phoneLabel];
    
    _phoneTextfield = [self customTextFieldWithFrame:CGRectMake(phoneLabel.right, phoneLabel.top, 100, phoneLabel.height)];
    _phoneTextfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_bgScrollview addSubview:_phoneTextfield];
    
    UIView *line2 = [self customLineViewWithFrame:CGRectMake(line1.left, _phoneTextfield.bottom, line1.width, 1)];
    [_bgScrollview addSubview:line2];
    
    
    NSString *accountStr = @"账户名：";
    CGSize accountSize = [accountStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *accountLabel = [self customUILabelWithFrame:CGRectMake(line2.left, line2.bottom, accountSize.width, 20) title:accountStr];
    [_bgScrollview addSubview:accountLabel];
    
    _accountTxtfield = [self customTextFieldWithFrame:CGRectMake(accountLabel.right, accountLabel.top, SCREEN_WIDTH-accountLabel.right-8, accountLabel.height)];
    [_bgScrollview addSubview:_accountTxtfield];
    
    NSString *bankNameStr = @"开户行：";
    CGSize bankNameSize = [bankNameStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *bankNameLabel = [self customUILabelWithFrame:CGRectMake(accountLabel.left, _accountTxtfield.bottom, bankNameSize.width, _accountTxtfield.height) title:bankNameStr];
    [_bgScrollview addSubview:bankNameLabel];
    
    _bankNameTxtfield = [self customTextFieldWithFrame:CGRectMake(bankNameLabel.right, bankNameLabel.top, SCREEN_WIDTH-accountLabel.right-8, bankNameLabel.height)];
    [_bgScrollview addSubview:_bankNameTxtfield];
    
    NSString *bankAccountStr = @"账号：";
    CGSize bankAccountSize = [bankAccountStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *bankAccountLabel = [self customUILabelWithFrame:CGRectMake(bankNameLabel.left, _bankNameTxtfield.bottom, bankAccountSize.width, _bankNameTxtfield.height) title:bankAccountStr];
    [_bgScrollview addSubview:bankAccountLabel];
    
    _bankAccountTxtfield = [self customTextFieldWithFrame:CGRectMake(bankAccountLabel.right, bankAccountLabel.top, SCREEN_WIDTH-bankAccountLabel.right-8, bankAccountLabel.height)];
    [_bgScrollview addSubview:_bankAccountTxtfield];
    
    UIView *line3 = [self customLineViewWithFrame:CGRectMake(line1.left, _bankAccountTxtfield.bottom, line1.width, 1)];
    [_bgScrollview addSubview:line3];
    
    NSString *countStr = @"请款次数：";
    CGSize countSize = [countStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *countLabel = [self customUILabelWithFrame:CGRectMake(line3.left, line3.bottom, countSize.width, bankAccountSize.height) title:countStr];
    [_bgScrollview addSubview:countLabel];
    
    _numTxtfield = [self customTextFieldWithFrame:CGRectMake(countLabel.right, countLabel.top, SCREEN_WIDTH-countLabel.right-8, countLabel.height)];
    _numTxtfield.keyboardType = UIKeyboardTypeDecimalPad;
    [_bgScrollview addSubview:_numTxtfield];
    
    NSString *money = @"合同金额：";
    CGSize moneySize =[money sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *moneyLabel = [self customUILabelWithFrame:CGRectMake(countLabel.left, _numTxtfield.bottom, moneySize.width, bankAccountLabel.height) title:money];
    [_bgScrollview addSubview:moneyLabel];
    
    _moneyTxtfield = [self customTextFieldWithFrame:CGRectMake(moneyLabel.right, moneyLabel.top, SCREEN_WIDTH/2-moneyLabel.right, moneyLabel.height)];
    _moneyTxtfield.keyboardType = UIKeyboardTypeDecimalPad;
    [_bgScrollview addSubview:_moneyTxtfield];
    
    NSString *less = @"增减金额：";
    CGSize lessSize =[less sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *lessLabel = [self customUILabelWithFrame:CGRectMake(_moneyTxtfield.right, _moneyTxtfield.top, lessSize.width, bankAccountLabel.height) title:less];
    [_bgScrollview addSubview:lessLabel];
    
    _lessTxtfield = [self customTextFieldWithFrame:CGRectMake(lessLabel.right, lessLabel.top, SCREEN_WIDTH-lessLabel.right-8, moneyLabel.height)];
//    _lessTxtfield.keyboardType = UIKeyboardTypeDecimalPad;
    [_bgScrollview addSubview:_lessTxtfield];
    
    NSString *already = @"已领金额：";
    CGSize alreadySize = [already sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *alreadyLabel = [self customUILabelWithFrame:CGRectMake(moneyLabel.left, moneyLabel.bottom, alreadySize.width, lessLabel.height) title:already];
    [_bgScrollview addSubview:alreadyLabel];
    
    _alreadyGetMoneyTxf = [self customTextFieldWithFrame:CGRectMake(alreadyLabel.right, alreadyLabel.top, SCREEN_WIDTH/2-alreadyLabel.right, alreadyLabel.height)];
    _alreadyGetMoneyTxf.keyboardType = UIKeyboardTypeDecimalPad;
    [_bgScrollview addSubview:_alreadyGetMoneyTxf];
    
    NSString *current = @"本次请款：";
    CGSize currentSize = [current sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *currentLable = [self customUILabelWithFrame:CGRectMake(_alreadyGetMoneyTxf.right, _alreadyGetMoneyTxf.top, currentSize.width, alreadyLabel.height) title:current];
    [_bgScrollview addSubview:currentLable];
    
    _currentMoneyTxf = [self customTextFieldWithFrame:CGRectMake(currentLable.right, currentLable.top, SCREEN_WIDTH-currentLable.right-8, currentLable.height)];
    _currentMoneyTxf.keyboardType = UIKeyboardTypeDecimalPad;
    [_bgScrollview addSubview:_currentMoneyTxf];
    
    UIView *line333 = [self customLineViewWithFrame:CGRectMake(line1.left, _currentMoneyTxf.bottom, line1.width, 1)];
    [_bgScrollview addSubview:line333];
    
    NSString *progress = @"合同执行进度：";
    CGSize progressSize = [progress sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *progressLabel = [self customUILabelWithFrame:CGRectMake(alreadyLabel.left, line333.bottom, progressSize.width, currentLable.height) title:progress];
    [_bgScrollview addSubview:progressLabel];
    
    _progressTxtview = [[UITextView alloc]initWithFrame:CGRectMake(progressLabel.right, progressLabel.top, SCREEN_WIDTH-progressLabel.right-8, 40)];
    _progressTxtview.delegate = self;
    _progressTxtview.font = [UIFont systemFontOfSize:FONT_SIZE];
    _progressTxtview.returnKeyType = UIReturnKeyDone;
    _progressTxtview.textColor = FORMTITLECOLOR;
    [_bgScrollview addSubview:_progressTxtview];
    
    _line4 = [self customLineViewWithFrame:CGRectMake(line1.left, _progressTxtview.bottom, line1.width, 1)];
    [_bgScrollview addSubview:_line4];
    
    NSString *content = @"请款内容：";
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    _contentLabel = [self customUILabelWithFrame:CGRectMake(progressLabel.left, _line4.bottom, contentSize.width, progressLabel.height) title:content];
    [_bgScrollview addSubview:_contentLabel];
    
    _contentTextview = [[UITextView alloc]initWithFrame:CGRectMake(_contentLabel.right, _contentLabel.top, SCREEN_WIDTH-_contentLabel.right-8, 40)];
    _contentTextview.delegate = self;
    _contentTextview.font = [UIFont systemFontOfSize:FONT_SIZE];
    _contentTextview.textColor = FORMTITLECOLOR;
    _contentTextview.returnKeyType = UIReturnKeyDone;
    [_bgScrollview addSubview:_contentTextview];
    
    _line5 = [self customLineViewWithFrame:CGRectMake(line1.left, _contentTextview.bottom, line1.width, 1)];
    [_bgScrollview addSubview:_line5];
    _lastView = _line5;
    
    if (self.form_type == 0) {
        NSString *project = @"项目（部门）经理：";
        CGSize projectSize = [project sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *managerLabel = [self customUILabelWithFrame:CGRectMake(_lastView.left, _lastView.bottom, projectSize.width, 30) title:project];
        [_bgScrollview addSubview:managerLabel];
        
        _projectManagerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _projectManagerBtn.frame = CGRectMake(managerLabel.right, managerLabel.top, SCREEN_WIDTH-managerLabel.right-8, managerLabel.height);
        [_projectManagerBtn setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
        _projectManagerBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [_projectManagerBtn addTarget:self action:@selector(clickProjectManager) forControlEvents:UIControlEventTouchUpInside];
        _projectManagerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_bgScrollview addSubview:_projectManagerBtn];
        
        UIView *line8 = [self customLineViewWithFrame:CGRectMake(line1.left, _projectManagerBtn.bottom, line1.width, 1)];
        [_bgScrollview addSubview:line8];
        _lastView = line8;
    }
    
    
    _fileView = [[MoreFilesView alloc]initWithFrame:CGRectMake(8, _lastView.bottom, SCREEN_WIDTH-16, 30)];
    [_bgScrollview addSubview:_fileView];
    [_fileView addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [_fileView.addButton setTitle:@"+添加附件（照片、结算单、工资表等）" forState:UIControlStateNormal];
    
    
    _line6 = [self customLineViewWithFrame:CGRectMake(line1.left, _fileView.bottom, line1.width, 1)];
    [_bgScrollview addSubview:_line6];
    
    
//    _listView = [[UIView alloc]initWithFrame:CGRectMake(0, _line6.bottom, SCREEN_WIDTH, 30)];
//     [_bgScrollview addSubview:_listView];
//    _addWorkListButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _addWorkListButton.frame = CGRectMake(managerLabel.left,0, SCREEN_WIDTH-16, 30);
//    [_addWorkListButton setTitle:@"＋添加工人工资表" forState:UIControlStateNormal];
//    _addWorkListButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [_addWorkListButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
//    _addWorkListButton.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE weight:0.8];
//    [_addWorkListButton addTarget:self action:@selector(clickAddWorkerList:) forControlEvents:UIControlEventTouchUpInside];
//    [_listView addSubview:_addWorkListButton];
//    
//    
//    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
//    _addBtn.frame = CGRectMake(SCREEN_WIDTH-35, SCREEN_HEIGHT-200, 30, 30);
//    [_addBtn addTarget:self action:@selector(clickAddWorkerList:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_addBtn];
    
    _lastView = _line6;
    
    _submitbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitbButton.frame = CGRectMake(8, _line6.bottom+40, SCREEN_WIDTH-16, 40);
    _submitbButton.backgroundColor = TOP_GREEN;
    _submitbButton.layer.cornerRadius = 5;
    [_submitbButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitbButton setTitle:@"提交" forState:UIControlStateNormal];
    _submitbButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:0.8];
    [_submitbButton addTarget:self action:@selector(submitPaymentForms) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollview addSubview:_submitbButton];
    
    _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, _line6.bottom+200);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"height"] ) {
        CGFloat newHeight = [change[@"new"] floatValue];
        //        CGFloat oldMoney = [change[@"old"] floatValue];
        //        NSLog(@"**height*%lf",newHeight);
        CGRect frame = self.fileView.frame;
        frame.size.height = newHeight;
        self.fileView.frame = frame;
        
        self.line6.top = self.fileView.bottom;
       
        self.submitbButton.top = self.line6.bottom+40;
        _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, self.line6.bottom+200);
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark 自定义类型

-(UITextField*)customTextFieldWithFrame:(CGRect)frame
{
    UITextField *textfield = [[UITextField alloc]initWithFrame:frame];
    textfield.delegate = self;
    textfield.font = [UIFont systemFontOfSize:FONT_SIZE];
    textfield.textColor = FORMTITLECOLOR;
    textfield.returnKeyType = UIReturnKeyDone;
    return textfield;
}

-(UILabel*)customUILabelWithFrame:(CGRect)frame title:(NSString*)title
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = FORMLABELTITLECOLOR;
    label.font = [UIFont systemFontOfSize:FONT_SIZE];
    label.text = title;
    return label;
}

-(UIView*)customLineViewWithFrame:(CGRect)frame
{
    UIView *line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = UIColorFromRGB(224, 223, 226);
    return line;
}

-(UIButton*)customButtonWithFrame:(CGRect)frame title:(NSString*)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [button setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

#pragma mark UITextfield Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    
    return YES;
}



#pragma mark get/set



@end
