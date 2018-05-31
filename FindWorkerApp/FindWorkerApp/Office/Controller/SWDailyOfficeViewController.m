//
//  SWDailyOfficeViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/8.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SWDailyOfficeViewController.h"
#import "CXZ.h"

#import "DepartmentManageViewController.h"
#import "ApprovalViewController.h"
#import "CompanyContractViewController.h"
#import "AdressBookViewController.h"
#import "CompanyReviewViewController.h"
#import "PaymentsFormViewController.h"
#import "PurchaseViewController.h"
#import "StampViewController.h"
#import "ApprovalFileViewController.h"
#import "ApplyJoinCompanyViewController.h"
#import "CreatCompanyViewController.h"
#import "ManagerViewController.h"
#import "CashierReplyViewController.h"
#import "DiaryListViewController.h"
#import "AddColleagueViewController.h"
#import "WorkRemindViewController.h"
#import "ExpenseAccountViewController.h"

#import "JXPopoverView.h"

@interface SWDailyOfficeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *officeTableView;

@property (nonatomic , strong) UILabel *titleLabel;

@property (nonatomic , strong) UIButton *changeButton;

@property (nonatomic , strong) NSArray *listArray;

@property (nonatomic , strong) NSMutableArray *companyArray;

@property (nonatomic , assign) BOOL isEmployee;//是否为公司员工

@property (nonatomic , assign) BOOL isManager;//是否为管理员

@property (nonatomic , assign) BOOL isSpecial;//是否为管理员

@property (nonatomic , assign) BOOL isCashier;//是否为出纳

@property (nonatomic , copy) NSString *companyID;//公司ID

@property (nonatomic , copy) NSString *personal_id;//在公司的个人ID
@end

@implementation SWDailyOfficeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
    barView.backgroundColor = [UIColor blackColor];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 0, 200, 40)];
    _titleLabel.font  = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [ UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"日常办公";
    [barView addSubview:_titleLabel];
    
    _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeButton.frame = CGRectMake(SCREEN_WIDTH-50, 10, 50, 20);
    [_changeButton setTitle:@"切换" forState:UIControlStateNormal];
    _changeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_changeButton addTarget:self action:@selector(changeCompany) forControlEvents:UIControlEventTouchUpInside];
    _changeButton.hidden = NO;
    [barView addSubview:_changeButton];
    
    [self.view addSubview:barView];
    
    _officeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,barView.bottom, SCREEN_WIDTH, self.view.frame.size.height-64-46) style:UITableViewStyleGrouped];
    _officeTableView.delegate = self;
    _officeTableView.dataSource = self;
    [self.view addSubview:_officeTableView];
    __weak typeof(self) weakself = self;
    _officeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself getCompanyInfo];
    }];
    [_officeTableView.mj_header beginRefreshing];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)])
    {
        statusBar.backgroundColor = [UIColor blackColor];
    }
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}


#pragma mark Private Method

-(void)changeCompany
{
    if (self.companyArray.count > 0) {
        JXPopoverView *popoverView = [JXPopoverView popoverView];
        popoverView.style = PopoverViewStyleDark;
        NSMutableArray *actionArray = [NSMutableArray array];
        for (int i = 0 ; i < self.companyArray.count; i++) {
            NSDictionary *company = self.companyArray[i];
            __weak typeof(self) weakself = self;
            JXPopoverAction *action1 = [JXPopoverAction actionWithTitle:company[@"company_name"] handler:^(JXPopoverAction *action) {
                weakself.companyID = company[@"company_id"];
                weakself.personal_id = company[@"personnel_id"];
                weakself.titleLabel.text = company[@"company_name"];
                NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString dictionaryToJson:company] forKey:phone];
                [weakself getPersonalManagerRightInfoWith:company[@"company_id"]];
            }];
            
            [actionArray addObject:action1];
        }
        [popoverView showToView:self.changeButton withActions:actionArray];
    }
    
}



#pragma mark Data

-(void)getCompanyInfo
{
    [self.companyArray removeAllObjects];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[NetworkSingletion sharedManager]getCompanyList:@{@"uid":uid} onSucceed:^(NSDictionary *dict) {
//       NSLog(@"***haha*%@",dict);
        [self.officeTableView.mj_header endRefreshing];
        if ([dict[@"code"] integerValue] == 0) {
            [self.companyArray addObjectsFromArray:dict[@"data"]];
            if (self.companyArray.count > 0) {
                self.isEmployee = YES;
                NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
                NSString *comanyJson = [[NSUserDefaults standardUserDefaults]objectForKey:phone];
                NSString *title;
                if (![NSString isBlankString:comanyJson]) {
                    self.isEmployee = YES;
                    NSDictionary *comDict = [NSString dictionaryWithJsonString:comanyJson];
                    [self getPersonalManagerRightInfoWith:comDict[@"company_id"]];
                    title = [comDict objectForKey:@"company_name"];
                }else{
                    self.companyID = [self.companyArray[0] objectForKey:@"company_id"];
                    title = [self.companyArray[0] objectForKey:@"company_name"];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString dictionaryToJson:self.companyArray[0]] forKey:phone];
                    [self getPersonalManagerRightInfoWith:self.companyID];
                }
                self.titleLabel.text = title;

            }else{
                self.isEmployee = NO;
                [self reloadOfficeTableViewData];
            }
        }else if([dict[@"code"] integerValue] == 250){
             self.titleLabel.text = @"日常办公";
            self.isEmployee = NO;
            [self reloadOfficeTableViewData];
            
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [self.officeTableView.mj_header endRefreshing];
        [MBProgressHUD showError:error toView:self.view];
    }];
}

-(void)getPersonalManagerRightInfoWith:(NSString*)companyID
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[NetworkSingletion sharedManager]getMangerRightInfoOfCompany:@{@"uid":uid,@"company_id":companyID} onSucceed:^(NSDictionary *dict) {
//        NSLog(@"***haha*%@",dict);
        [self.officeTableView.mj_header endRefreshing];
        if ([dict[@"code"] integerValue] == 0) {
            NSDictionary *dataDict = [dict objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:[dict[@"data"] objectForKey:@"department_name"] forKey:@"DepartmentName"];
            if ([[dataDict objectForKey:@"is_manage"] integerValue]==1) {
                self.isManager = YES;
            }else{
                self.isManager = NO;
            }
            NSInteger sepcial = [[dataDict objectForKey:@"company_boss"] integerValue];
            if (sepcial == 1) {
                self.isSpecial = YES;
            }else{
                self.isSpecial = NO;
            }
            self.isCashier = [[dataDict objectForKey:@"is_finance"] integerValue];
            self.companyID = [dataDict objectForKey:@"company_id"];
            self.personal_id = [dataDict objectForKey:@"personnel_id"];
            [self reloadOfficeTableViewData];
        }else{
             self.titleLabel.text = @"日常办公";
             self.isEmployee = NO;
            [self reloadOfficeTableViewData];
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [self.officeTableView.mj_header endRefreshing];
        [MBProgressHUD showError:error toView:self.view];
    }];
}



-(void)reloadOfficeTableViewData
{
    if (self.isEmployee == YES) {
        if (self.isManager) {
            if (self.isCashier) {
                self.listArray = @[@[@"创建公司",@"申请加入公司",@"邀请同事"],@[@"设置"],@[@"审批处理",@"表单回执",@"工作记录",@"消息提醒",@"公司合同",@"通讯录"],@[@"合同评审单",@"请款单",@"请购单",@"印章申请",@"呈批件",@"报销单"]];
            }else{
                self.listArray = @[@[@"创建公司",@"申请加入公司",@"邀请同事"],@[@"设置"],@[@"审批处理",@"工作记录",@"消息提醒",@"公司合同",@"通讯录"],@[@"合同评审单",@"请款单",@"请购单",@"印章申请",@"呈批件",@"报销单"]];
            }
        }else{
            if (self.isCashier) {
                self.listArray = @[@[@"创建公司",@"申请加入公司",@"邀请同事"],@[@"审批处理",@"表单回执",@"工作记录",@"消息提醒",@"公司合同",@"通讯录"],@[@"合同评审单",@"请款单",@"请购单",@"印章申请",@"呈批件",@"报销单"]];
            }else{
                self.listArray = @[@[@"创建公司",@"申请加入公司",@"邀请同事"],@[@"审批处理",@"工作记录",@"消息提醒",@"公司合同",@"通讯录"],@[@"合同评审单",@"请款单",@"请购单",@"印章申请",@"呈批件",@"报销单"]];
            }
            
        }
    }else{
        self.listArray = @[@[@"创建公司",@"申请加入公司",@"邀请同事"],@[@"审批处理",@"工作记录",@"消息提醒",@"公司合同",@"公司合同",@"通讯录"],@[@"合同评审单",@"请款单",@"请购单",@"印章申请",@"呈批件",@"报销单"]];
        
    }
    [self.officeTableView reloadData];
    
}

-(void)creatDepartment
{
    CreatCompanyViewController *creatVC = [[CreatCompanyViewController alloc]init];
    creatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:creatVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark TableView delegate & datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.listArray[section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.listArray[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = TITLECOLOR;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEmployee == NO ) {// 无公司
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                [self creatDepartment];
            }else{
                ApplyJoinCompanyViewController *joinVC = [[ApplyJoinCompanyViewController alloc]init];
                joinVC.hidesBottomBarWhenPushed = YES;
                joinVC.companyID = self.companyID;
                [self.navigationController pushViewController:joinVC animated:YES];
            }
        }else{
            [WFHudView showMsg:@"亲，您还未加入公司哦..." inView:self.view];
        }
        
    }else{
        NSString *title = self.listArray[indexPath.section][indexPath.row];
        
        if ([title isEqualToString:@"创建公司"]) {
            [self creatDepartment];

        }else if ([title isEqualToString:@"申请加入公司"]){
            ApplyJoinCompanyViewController *joinVC = [[ApplyJoinCompanyViewController alloc]init];
            joinVC.companyID = self.companyID;
            joinVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:joinVC animated:YES];
        }else if ([title isEqualToString:@"邀请同事"]){
            AddColleagueViewController *addVC = [[AddColleagueViewController alloc]init];
            addVC.company_id = self.companyID;
            addVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addVC animated:YES];
            self.hidesBottomBarWhenPushed = YES;

        }else if ([title isEqualToString:@"设置"]){
            DepartmentManageViewController *departVC = [[DepartmentManageViewController alloc]init];
            departVC.company_id = self.companyID;
            departVC.personalID = self.personal_id;
            departVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:departVC animated:YES];
        }else if ([title isEqualToString:@"审批处理"]){
            ApprovalViewController *approvalVC = [[ApprovalViewController alloc]init];
            approvalVC.isSpecial = self.isSpecial;
            approvalVC.companyID = self.companyID;
            approvalVC.companyArr = self.companyArray;
            approvalVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:approvalVC animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }else if ([title isEqualToString:@"工作记录"]){
            DiaryListViewController *diaryVC = [[DiaryListViewController alloc]init];
            diaryVC.companyID = self.companyID;
            diaryVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:diaryVC animated:YES];
            self.hidesBottomBarWhenPushed = YES;

        }else if ([title isEqualToString:@"消息提醒"]){
            WorkRemindViewController *remindVC = [[WorkRemindViewController alloc]init];
            remindVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:remindVC animated:YES];
            self.hidesBottomBarWhenPushed = YES;
            
        }else if ([title isEqualToString:@"表单回执"]){
            CashierReplyViewController *cashierVC = [[CashierReplyViewController alloc]init];
            cashierVC.companyID = self.companyID;
            cashierVC.companyArr = self.companyArray;
            cashierVC.personalId = self.personal_id;
            cashierVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cashierVC animated:YES];
            self.hidesBottomBarWhenPushed = YES;
            
        }else if ([title isEqualToString:@"公司合同"]){
            CompanyContractViewController *companyVC = [[CompanyContractViewController alloc]init];
            companyVC.company_ID = self.companyID;
            companyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:companyVC animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }else if ([title isEqualToString:@"通讯录"]){
            AdressBookViewController *bookVC = [[AdressBookViewController alloc]init];
            bookVC.companyid = self.companyID;
            bookVC.loadDataType = 2;
            bookVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bookVC animated:YES];
            
        }else if ([title isEqualToString:@"合同评审单"]){
            CompanyReviewViewController *companyVC = [[CompanyReviewViewController alloc]init];
            companyVC.is_approval = NO;
            companyVC.typeStr = @"1";
            companyVC.company_id = self.companyID;
            companyVC.is_annex = YES;
            companyVC.com_contract_id = @"";
            companyVC.hidesBottomBarWhenPushed  = YES;
            [self.navigationController pushViewController:companyVC animated:YES];;//合同评审表
        }else if ([title isEqualToString:@"请款单"]){
            [self enterPaymentViewController];
            
        }else if ([title isEqualToString:@"请购单"]){
            PurchaseViewController *purchaseVC = [[PurchaseViewController alloc]init];
            purchaseVC.companyID = self.companyID;
            purchaseVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:purchaseVC animated:YES];
        }else if ([title isEqualToString:@"印章申请"]){
            StampViewController *stampVC = [[StampViewController alloc]init];
            stampVC.companyID = self.companyID;
            stampVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:stampVC animated:YES];
        }else if ([title isEqualToString:@"呈批件"]){
            ApprovalFileViewController *fileVC = [[ApprovalFileViewController alloc]init];
            fileVC.companyID = self.companyID;
            fileVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fileVC animated:YES];
        }else if ([title isEqualToString:@"报销单"]){
            ExpenseAccountViewController *expenseVC = [[ExpenseAccountViewController alloc]init];
            expenseVC.companyID = self.companyID;
            expenseVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:expenseVC animated:YES];
        }
        
    }
    self.hidesBottomBarWhenPushed = NO;
}



-(void)enterPaymentViewController
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"选择请款依据" preferredStyle:UIAlertControllerStyleActionSheet];
    CopyViewController *copyVC = [[CopyViewController alloc]init];
    copyVC.companyID = self.companyID;
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"合同评审表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        copyVC.type = 1;
        copyVC.is_selected_form = YES;
        copyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:copyVC animated:YES];
    } ]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"请购单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        copyVC.type = 3;
        copyVC.is_selected_form = YES;
        copyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:copyVC animated:YES];
        
    } ]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"呈批件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        copyVC.type = 6;
        copyVC.is_selected_form = YES;
        copyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:copyVC animated:YES];
    } ]];
//    [alertView addAction:[UIAlertAction actionWithTitle:@"其他" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        PaymentsFormViewController *payVC = [[PaymentsFormViewController alloc]init];
//        payVC.companyID = self.companyID;
//        payVC.payType = -1;
//        payVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:payVC animated:YES];
//        
//    } ]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    } ]];
    
    [self.navigationController presentViewController:alertView animated:YES completion:nil];
    
}



#pragma mark get/set
-(NSMutableArray*)companyArray
{
    if (!_companyArray) {
        _companyArray = [NSMutableArray array];
    }
    return _companyArray;
}


@end
