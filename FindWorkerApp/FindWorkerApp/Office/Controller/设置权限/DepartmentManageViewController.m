//
//  DepartmentManageViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "DepartmentManageViewController.h"
#import "CXZ.h"

#import "DepartmentTableViewCell.h"
#import "AdressBookViewController.h"
#import "AddProjectViewController.h"
#import "CreatCompanyViewController.h"
#import "CompanyPersonManageViewController.h"
#import "ManagerViewController.h"
#import "SetReceiptViewController.h"

@interface DepartmentManageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *departmentTableview;

@property(nonatomic ,strong)UIWindow *bgWindow;

@property(nonatomic ,strong)UITextField *nameTxt;

@end

@implementation DepartmentManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackw];
    [self setupTitleWithString:@"公司管理" withColor:[UIColor whiteColor]];
    [self setupNextWithString:@"解散" withColor:TOP_GREEN];
    _departmentTableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _departmentTableview.height = self.view.frame.size.height - 64;
    _departmentTableview.delegate = self;
    _departmentTableview.dataSource = self;
    [self.view addSubview:_departmentTableview];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark 
-(void)onNext
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定要解散公司么？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                    @"company_id":self.company_id,
                                    @"personnel_id":self.personalID};
        [[NetworkSingletion sharedManager]quiteCompany:paramDict onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue]==0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
               [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }]];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
}



#pragma mark 添加部门

-(void)setAddDepartmentView
{
    if (!_bgWindow) {
        _bgWindow = [[UIWindow alloc]initWithFrame:self.view.bounds];
        _bgWindow.windowLevel = UIWindowLevelNormal;
        _bgWindow.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 30, 240, 160)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.center = _bgWindow.center;
        bgView.top = 80;
        bgView.layer.cornerRadius = 3;
        [_bgWindow addSubview:bgView];
        
        UILabel *titleLabel = [CustomView customTitleUILableWithContentView:bgView title:@"添加部门"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(0, 0, bgView.width, 30);
        
        UIView *line = [CustomView customLineView:bgView];
        line.frame = CGRectMake(0, titleLabel.bottom, bgView.width, 1);
        
        
        _nameTxt = [CustomView customUITextFieldWithContetnView:bgView placeHolder:@"请输入部门名称"];
        _nameTxt.textAlignment = NSTextAlignmentCenter;
        _nameTxt.frame = CGRectMake(5, line.bottom+20, bgView.width-10, 40);
        
        
        UIButton *canCelBtn = [CustomView customButtonWithContentView:bgView image:nil title:@"取消"];
        [canCelBtn addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        canCelBtn.frame = CGRectMake(0, _nameTxt.bottom+20, bgView.width/2, 40);
        
        UIButton *confirmBtn = [CustomView customButtonWithContentView:bgView image:nil title:@"添加"];
        [confirmBtn addTarget:self action:@selector(clickAddDepartmentButton:) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.frame = CGRectMake(canCelBtn.right,canCelBtn.top, canCelBtn.width, canCelBtn.height);
        [self.view addSubview:_bgWindow];
    }
    _bgWindow.hidden = NO;
    [_bgWindow makeKeyWindow];
}

-(void)clickCancelButton:(UIButton*)bton
{
    _bgWindow.hidden = YES;
    [_bgWindow resignKeyWindow];
}

//创建部门
-(void)clickAddDepartmentButton:(UIButton*)bton
{
    if (self.nameTxt.text.length > 0) {
        NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                    @"department_name":self.nameTxt.text,
                                    @"company_id":self.company_id};
        [[NetworkSingletion sharedManager]creatDepartment:paramDict onSucceed:^(NSDictionary *dict) {
            
            if ([dict[@"code"] integerValue]==0) {
                self.nameTxt.text = @"";
                [self.departmentTableview reloadData];
                [MBProgressHUD showSuccess:@"添加成功" toView:self.view];
            }else{
                [MBProgressHUD showError:dict[@"error"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }else{
        [WFHudView showMsg:@"请输入部门名称" inView:self.view];
    }
}




#pragma mark UITableview Delegate & Datasource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *titleArray = @[@"创建群组",@"添加部门",@"添加管理员",@"添加工程项目",@"公司人员设置",@"设置回执人员",@"设置审批人员"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"];
    }
    cell.textLabel.text = titleArray[indexPath.section];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
//    cell.textLabel.textColor = TOP_GREEN;
    //        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        CreatCompanyViewController *creatVC = [[CreatCompanyViewController alloc]init];
        creatVC.is_creat_subCompany = YES;
        creatVC.compony_id = self.company_id;
        creatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:creatVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (indexPath.section == 1){
        [self setAddDepartmentView];
    }else if (indexPath.section == 2){
        AdressBookViewController *bookVC = [[AdressBookViewController alloc]init];
        bookVC.isSelect = YES;
        bookVC.isAddManager = YES;
        bookVC.companyid = self.company_id;
        bookVC.loadDataType = 2;
        bookVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bookVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (indexPath.section == 3){
        AddProjectViewController *projectVC = [[AddProjectViewController alloc]init];
        projectVC.company_id = self.company_id;
        projectVC.is_add_project = YES;
        projectVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:projectVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (indexPath.section == 4){
        CompanyPersonManageViewController *companyVC = [[CompanyPersonManageViewController alloc]init];
        companyVC.company_id = self.company_id;
        companyVC.personalID = self.personalID;
        companyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:companyVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (indexPath.section == 5){
        SetReceiptViewController *receipt = [[SetReceiptViewController alloc]init];
        receipt.compony_id = self.company_id;
        receipt.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:receipt animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (indexPath.section == 6){
        ManagerViewController *rightsVC = [[ManagerViewController alloc]init];
        rightsVC.personID = self.personalID;
        rightsVC.compony_id = self.company_id;
        rightsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rightsVC animated:YES];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    return 10.0;
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

@end
