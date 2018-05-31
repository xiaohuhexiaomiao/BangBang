//
//  AddColleagueViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/12.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "AddColleagueViewController.h"
#import "CXZ.h"
//#import "JXPopoverView.h"
#import "MenuView.h"
#import "SelectedDepartmentViewController.h"
#import "WorkerListViewController.h"

#import "CompanyDepartmentModel.h"

@interface AddColleagueViewController ()<SelectedDepartmentDelegate,MenuViewDelegate,WorkerListControllerDelegate>

@property(nonatomic ,strong)UIWindow *bgWindow;

@property(nonatomic ,strong)UITextField *nameTxt;//职位名称

@property (nonatomic , strong)UITextField *nametextField;//姓名

@property (nonatomic , strong)UITextField *phoneTextfield;

@property (nonatomic , strong) UILabel *selectLabel;;

@property (nonatomic , strong) UILabel *selectPositionLabel;;

@property (nonatomic , strong) MenuView *menuView2;

@property (nonatomic , strong) UIButton *bookButton;

@property (nonatomic , strong) UIButton *addBtn;

@property (nonatomic , copy) NSString *departmentID;

@property (nonatomic , assign) NSInteger jobID;

@property (nonatomic , strong)CompanyDepartmentModel *departModel;

@end

@implementation AddColleagueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    if (self.isUpdate) {
        [self setupTitleWithString:@"更改部门" withColor:[UIColor whiteColor]];
    }else{
        [self setupTitleWithString:@"邀请同事" withColor:[UIColor whiteColor]];
    }
    self.departmentID = self.personal.department_id;
    [self config];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



#pragma mark Private Method

-(void)config
{
    UILabel *namelabel = [CustomView customTitleUILableWithContentView:self.view title:@"姓名："];
    namelabel.frame = CGRectMake(8, 0, 80, 40);
    
    _nametextField = [CustomView customUITextFieldWithContetnView:self.view placeHolder:@"请输入姓名"];
    _nametextField.frame = CGRectMake(namelabel.right, 0, SCREEN_WIDTH-namelabel.right-38, namelabel.height);
    _nametextField.textAlignment = NSTextAlignmentRight;
    
    _bookButton = [CustomView customButtonWithContentView:self.view image:@"AdressBook" title:nil];
    _bookButton.frame = CGRectMake(_nametextField.right, 5, 28, 28);
    _bookButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [_bookButton addTarget:self action:@selector(clickAdressBookButton:) forControlEvents:UIControlEventTouchUpInside];

    UIView *line = [CustomView customLineView:self.view];
    line.frame  = CGRectMake(namelabel.left, _nametextField.bottom, SCREEN_WIDTH-16, 1);
    
    UILabel *phoneLabel = [CustomView customTitleUILableWithContentView:self.view title:@"手机号码："];
    phoneLabel.frame = CGRectMake(namelabel.left, line.bottom, namelabel.width, namelabel.height);
    
    _phoneTextfield = [CustomView customUITextFieldWithContetnView:self.view placeHolder:@"请输入手机号码"];
    _phoneTextfield.frame = CGRectMake(_nametextField.left, phoneLabel.top, _nametextField.width, _nametextField.height);
    _phoneTextfield.keyboardType = UIKeyboardTypePhonePad;
    _phoneTextfield.backgroundColor = [UIColor whiteColor];
    _phoneTextfield.font = [UIFont systemFontOfSize:FONT_SIZE];
    _phoneTextfield.textAlignment = NSTextAlignmentRight;
    
    
    UIView *line1 = [CustomView customLineView:self.view];
    line1.frame  = CGRectMake(namelabel.left, phoneLabel.bottom, line.width, 1);
    
    UILabel *departLabel = [CustomView customTitleUILableWithContentView:self.view title:@"部门："];
    departLabel.frame = CGRectMake(namelabel.left, line1.bottom, namelabel.width, namelabel.height);
    
    _selectLabel = [CustomView customContentUILableWithContentView:self.view title:nil];
    if (![NSString isBlankString:self.personal.department_name]) {
        _selectLabel.text = self.personal.department_name;
    }
    
    _selectLabel.frame = CGRectMake(_nametextField.left, departLabel.top, _nametextField.width, _nametextField.height);
    _selectLabel.textAlignment = NSTextAlignmentRight;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDepartment:)];
    _selectLabel.userInteractionEnabled = YES;
    [_selectLabel addGestureRecognizer:tap];

    UIView *line2 = [CustomView customLineView:self.view];
    line2.frame  = CGRectMake(namelabel.left, _selectLabel.bottom, line.width, 1);
    
    UIView *lastView = line2;
    
    if (self.isUpdate) {
        
        UILabel *projectLabel = [CustomView customTitleUILableWithContentView:self.view title:@"职位："];
        projectLabel.frame = CGRectMake(namelabel.left, line2.bottom, namelabel.width, namelabel.height);
        
        
        _selectPositionLabel = [CustomView customContentUILableWithContentView:self.view title:@"请选择职位"];
        if (![NSString isBlankString:self.personal.department_name]) {
            _selectPositionLabel.text = self.personal.job_name;
        }
        _selectPositionLabel.frame = CGRectMake(_nametextField.left, projectLabel.top, _nametextField.width, _nametextField.height);
        _selectPositionLabel.textAlignment = NSTextAlignmentRight;
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectProject:)];
        _selectPositionLabel.userInteractionEnabled = YES;
        [_selectPositionLabel addGestureRecognizer:tap2];
        
        UIView *line3 = [CustomView customLineView:self.view];
        line3.frame  = CGRectMake(namelabel.left, _selectPositionLabel.bottom, line.width, 1);
        
        lastView = line3;
        
        _menuView2 = [[MenuView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-98, _selectPositionLabel.bottom, 90, 120)];
        _menuView2.delegate = self;
        _menuView2.hidden = YES;
        [self.view addSubview:_menuView2];
        _menuView2.layer.cornerRadius = 5;
        _menuView2.layer.borderColor = LINE_GRAY.CGColor;
        _menuView2.layer.borderWidth = 0.5;
        _menuView2.layer.masksToBounds = YES;
        
        self.nametextField.userInteractionEnabled = NO;
        self.phoneTextfield.userInteractionEnabled = NO;
        self.nametextField.text = self.personal.name;
        self.phoneTextfield.text = self.personal.phone;
        //        tipLabel.hidden = YES;
    }
   
    
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame = CGRectMake(8, lastView.bottom+80, SCREEN_WIDTH-16, _selectLabel.height);
    _addBtn.backgroundColor = TOP_GREEN;
    [_addBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addBtn.layer.cornerRadius = 5;
    [_addBtn addTarget:self action:@selector(addColleague:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addBtn];
    
}

-(void)clickAdressBookButton:(UIButton*)button
{
    WorkerListViewController *nearbyController = [[WorkerListViewController alloc] init];
    nearbyController.delegate = self;
    nearbyController.is_single = YES;
    nearbyController.is_search = YES;
    nearbyController.hidesBottomBarWhenPushed = YES;
    //    bookVC.areadySelectArray = self.alreadySelectedPersonArray;
    nearbyController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nearbyController animated:YES];
    self.hidesBottomBarWhenPushed = YES;

}


-(void)selectProject:(UITapGestureRecognizer*)tap
{
    if (self.departModel) {
        _menuView2.hidden = NO;
        [self.view bringSubviewToFront:_menuView2];
        NSMutableArray *jobArray = [NSMutableArray array];
        [jobArray addObjectsFromArray:self.departModel.job];
        [jobArray addObject:@{@"job_name":@"自定义职位"}];
        [_menuView2 loadJobData:jobArray];
        
    }else{
        [WFHudView showMsg:@"请先选择部门" inView:self.view];
    }
}



-(void)selectDepartment:(UITapGestureRecognizer*)tap
{
    [self.phoneTextfield resignFirstResponder];
    SelectedDepartmentViewController *selectVC = [[SelectedDepartmentViewController alloc]init];
    selectVC.delegate = self;
    selectVC.companyid = self.company_id;
    selectVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selectVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

-(void)addColleague:(UIButton*)button
{
    if (self.isUpdate) {
//        NSLog(@"compay %@",self.company_id);
        NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                    @"department_id":self.departmentID,
                                    @"personnel_id":self.personal.personnel_id,
                                    @"job_id":@(self.jobID),
                                    @"company_id":self.company_id
                                   };
        [[NetworkSingletion sharedManager]updateDepartment:paramDict onSucceed:^(NSDictionary *dict) {
//            NSLog(@"***%@,%@",dict,dict[@"message"]);
            if ([dict[@"code"] integerValue] == 0) {
                [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:dict[@"error"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
        
    }else{
        if ([NSString isBlankString:self.nametextField.text]) {
            [MBProgressHUD showError:@"请输入同事姓名" toView:self.view];
            return;
        }
        if ([NSString isBlankString:self.phoneTextfield.text]) {
            [MBProgressHUD showError:@"请输入手机号码" toView:self.view];
            return;
        }
        if ([NSString isBlankString:self.departmentID]) {
            [MBProgressHUD showError:@"请选择部门" toView:self.view];
            return;
        }
        NSDictionary *paramDict = @{@"company_id":self.company_id,
                                    @"department_id":self.departmentID,
                                    @"name":self.nametextField.text,
                                    @"phone":self.phoneTextfield.text};
        [[NetworkSingletion sharedManager]addColleague:paramDict onSucceed:^(NSDictionary *dict) {
            //        NSLog(@"**df**%@",dict);
            if ([dict[@"code"] integerValue] == 0) {
                [MBProgressHUD showSuccess:@"邀请成功" toView:self.view];
                self.nametextField.text = @"";
                self.phoneTextfield.text = @"";
            }else{
                [MBProgressHUD showError:dict[@"error"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }
}

#pragma mark Controller Delegate
-(void)didSelsectOneWorker:(NSDictionary *)personDict
{
    if (![NSString isBlankString:personDict[@"name"]]) {
        self.nametextField.text = personDict[@"name"];
    }
    if (![NSString isBlankString:personDict[@"phone"]]) {
        self.phoneTextfield.text = personDict[@"phone"];
    }
}

#pragma mark MenueView Delegate

-(void)selectedDepartment:(NSDictionary *)dict is_department:(BOOL)is_selected_depart
{
    //     NSLog(@"***%@",dict);
    if (!is_selected_depart) {
        NSString *job = [dict objectForKey:@"job_name"];
        if ([job isEqualToString:@"自定义职位"]) {
            [self setAddDepartmentView];
        }else{
            self.selectPositionLabel.text = job;
            self.jobID = [[dict objectForKey:@"job_id"] integerValue];
        }
  
    }
}



#pragma mark 自定义职位

-(void)setAddDepartmentView
{
    if (!_bgWindow) {
        _bgWindow = [[UIWindow alloc]initWithFrame:self.view.bounds];
        _bgWindow.windowLevel = UIWindowLevelNormal;
        _bgWindow.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH-70, 151)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.center = _bgWindow.center;
        bgView.top = 80;
        bgView.layer.cornerRadius = 3;
        [_bgWindow addSubview:bgView];
        
        UILabel *titleLabel = [CustomView customTitleUILableWithContentView:bgView title:@"自定义职位"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(0, 0, bgView.width, 30);
        
        UIView *line = [CustomView customLineView:bgView];
        line.frame = CGRectMake(0, titleLabel.bottom, bgView.width, 1);
        
        
        _nameTxt = [CustomView customUITextFieldWithContetnView:bgView placeHolder:@"请输入职位名称"];
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

-(void)clickAddDepartmentButton:(UIButton*)bton
{
    if (self.nameTxt.text.length > 0) {
        NSDictionary *paramDict = @{@"job_name":self.nameTxt.text,
                                    @"department_id":self.departmentID,
                                    @"num":@(1),
                                    @"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]};
        [[NetworkSingletion sharedManager]customPosition:paramDict onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue]== 0) {
                NSMutableArray *jobArray = [NSMutableArray array];
                NSDictionary *jobDict = @{@"job_name":self.nameTxt.text,@"job_id":dict[@"data"]};
                [jobArray addObjectsFromArray:self.departModel.job];
                [jobArray addObject:jobDict];
                self.departModel.job = jobArray;
                self.selectPositionLabel.text = self.nameTxt.text;
                self.jobID = [dict[@"data"] integerValue];
                _bgWindow.hidden = YES;
                [_bgWindow resignKeyWindow];
                
            }
        } OnError:^(NSString *error) {
            
        }];
    }else{
        [WFHudView showMsg:@"请输入职位名称" inView:self.view];
    }
}

#pragma mark Delegate Method

-(void)didSelectedDepartment:(NSDictionary *)department
{
     self.departModel = [CompanyDepartmentModel objectWithKeyValues:department];
    self.departmentID = [NSString stringWithFormat:@"%li",self.departModel.department_id];
    self.selectLabel.text = self.departModel.department_name ;
}

@end
