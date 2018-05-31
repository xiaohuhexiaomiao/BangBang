//
//  ApplyJoinCompanyViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/1.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ApplyJoinCompanyViewController.h"
#import "CXZ.h"

#import "ApplyJoinCompanyCell.h"
#import "JXPopoverView.h"
#import "MenuView.h"
#import "CompanyInfoModel.h"
#import "ApplyCompanyModel.h"
#import "CompanyDepartmentModel.h"

#import "SelectedCompanyViewController.h"
#import "SelectedDepartmentViewController.h"

@interface ApplyJoinCompanyViewController ()<UITableViewDelegate, UITableViewDataSource,UITextViewDelegate,ApplyCompanyCellDelegate,MenuViewDelegate>
{
    NSInteger page;
}
@property(nonatomic ,strong)UITableView *applyTableview;

@property(nonatomic ,strong)NSMutableArray *dataArray;

@property(nonatomic ,strong)UIWindow *bgWindow;

@property(nonatomic ,strong)UITextField *nameTxt;

@property(nonatomic ,strong)UIWindow *applyWindow;

@property(nonatomic ,strong)UIView *joinView;

@property(nonatomic ,strong)UIView *bgSelectView;

@property(nonatomic ,strong)UIView *selectedView;

@property(nonatomic ,strong)UILabel *selectedDepartmentLabel;

@property(nonatomic ,strong)UILabel *selectedJobLabel;

@property(nonatomic ,strong)MenuView *menuView1;

@property(nonatomic ,strong)MenuView *menuView2;

@property(nonatomic ,copy)NSString *apply_Company_id;//申请加入的公司ID

@property(nonatomic ,assign)NSInteger apply_type;//身份类型

@property(nonatomic ,strong)ApplyCompanyModel *agreeTempModel;

@property (nonatomic , strong)CompanyDepartmentModel *departModel;

@property(nonatomic ,copy)NSString *apply_Department_id;//选择加入的部门ID

@property(nonatomic ,assign)NSInteger apply_Job_id;//选择职位ID

@end

@implementation ApplyJoinCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    
    _applyTableview  = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _applyTableview.delegate = self;
    _applyTableview.dataSource = self;
    _applyTableview.rowHeight = UITableViewAutomaticDimension;
  
    [self.view addSubview:_applyTableview];
    [_applyTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.mas_equalTo(0);
    }];
    __weak typeof(self) weakself = self;
    _applyTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadNewData];
    }];
    _applyTableview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    [_applyTableview.mj_header beginRefreshing];
    
//    [self setSelectDepartmentView];
//    [UIView animateWithDuration:0.5 animations:^{
//        self.bgSelectView.hidden = NO;
//        [self.bgSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(-64);
//        }];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark 界面


-(void)setSelectDepartmentView
{
    if (!_bgSelectView) {
        
        _bgSelectView = [[UIView alloc]init];
        [self.view addSubview:_bgSelectView];
        _bgSelectView.hidden = YES;
        [_bgSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.applyTableview.mas_bottom);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(SCREEN_HEIGHT);
        }];
        _bgSelectView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        _selectedView = [[UIView alloc]init];
        [_bgSelectView addSubview:_selectedView];
        [_selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(240);
            make.height.mas_equalTo(160);
            make.center.mas_equalTo(_bgSelectView);
        }];
        _selectedView.backgroundColor = [UIColor whiteColor];
        _selectedView.layer.cornerRadius = 10;
        _selectedView.layer.borderColor = LINE_GRAY.CGColor;
        _selectedView.layer.borderWidth = 0.5;
        
        UILabel *titleLabel = [self customUILabelWithView:_selectedView title:@"选择要加入部门"];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        
      
        CGSize size = [@"部门：" sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *title = [self customUILabelWithView:_selectedView title:@"部门："];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(size.width+1);
            make.height.mas_equalTo(38);
        }];
        
        _selectedDepartmentLabel = [self customUILabelWithView:_selectedView title:nil];
        [_selectedDepartmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom);
            make.left.mas_equalTo(title.mas_right);
            make.right.mas_equalTo(-38);
            make.height.mas_equalTo(38);
        }];
        
        
        UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedView addSubview:listButton];
        [listButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom);
            make.right.mas_equalTo(-8);
            make.width.height.mas_equalTo(30);
        }];
        [listButton setImage:[UIImage imageNamed:@"arrow_gray"] forState:UIControlStateNormal];
        [listButton addTarget:self action:@selector(clickselectedButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *projectLabel = [self customUILabelWithView:_selectedView title:@"职位："];
        [projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(title.mas_bottom);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(size.width+1);
            make.height.mas_equalTo(38);
        }];

        
        _selectedJobLabel = [self customUILabelWithView:_selectedView title:nil];
        [_selectedJobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(projectLabel.mas_top);
            make.left.mas_equalTo(projectLabel.mas_right);
            make.right.mas_equalTo(-38);
            make.height.mas_equalTo(38);
        }];

        UIButton *listButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedView addSubview:listButton2];
        [listButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_selectedJobLabel.mas_top);
            make.right.mas_equalTo(-8);
            make.width.height.mas_equalTo(30);
        }];
        [listButton2 setImage:[UIImage imageNamed:@"arrow_gray"] forState:UIControlStateNormal];
        [listButton2 addTarget:self action:@selector(selectProject:) forControlEvents:UIControlEventTouchUpInside];

        
        
        _menuView1 = [[MenuView alloc]init];
        _menuView1.delegate = self;
        _menuView1.hidden = YES;
        [_bgSelectView addSubview:_menuView1];
        [_menuView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.selectedDepartmentLabel.mas_bottom);
            make.right.mas_equalTo(self.selectedView.mas_right);
            make.height.mas_equalTo(150);
            make.width.mas_equalTo(100);
        }];
        [_menuView1 setTableviewFrame];
        _menuView1.layer.cornerRadius = 5;
        _menuView1.layer.borderColor = LINE_GRAY.CGColor;
        _menuView1.layer.borderWidth = 0.5;
        _menuView1.layer.masksToBounds = YES;
        
        _menuView2 = [[MenuView alloc]init];
        _menuView2.delegate = self;
        _menuView2.hidden = YES;
        [_bgSelectView addSubview:_menuView2];
        [_menuView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.selectedJobLabel.mas_bottom);
            make.right.mas_equalTo(self.selectedView.mas_right);
            make.height.mas_equalTo(150);
            make.width.mas_equalTo(100);
        }];
        [_menuView2 setTableviewFrame];
        _menuView2.layer.cornerRadius = 5;
        _menuView2.layer.borderColor = LINE_GRAY.CGColor;
        _menuView2.layer.borderWidth = 0.5;
        _menuView2.layer.masksToBounds = YES;
        
        UIView *line = [self customUIViewWithContentView:_selectedView];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(projectLabel.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
//
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom);
            make.left.bottom.mas_equalTo(0);
            make.width.mas_equalTo(80);
        }];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelAgree:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedView addSubview:confirmButton];
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom);
            make.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(cancelButton.mas_width);
        }];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [confirmButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmAgree:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(UILabel*)customUILabelWithView:(UIView*)superView title:(NSString*)title
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    if (title) {
        titleLabel.text = title;
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [superView addSubview:titleLabel];
    return titleLabel;
}

#pragma mark 点击事件

-(void)clickselectedButton:(UIButton*)button
{
    _menuView1.hidden = NO;
    _menuView1.companyID = self.companyID;
    [_menuView1 loadMenuData];
    
}

-(void)selectProject:(UIButton*)tap
{
    if (self.departModel) {
        
        _menuView2.hidden = NO;
        [_menuView2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.selectedJobLabel.mas_bottom);
        }];
        NSMutableArray *jobArray = [NSMutableArray array];
        [jobArray addObjectsFromArray:self.departModel.job];
        [jobArray addObject:@{@"job_name":@"自定义职位"}];
        [_menuView2 loadJobData:jobArray];
        
    }else{
        [WFHudView showMsg:@"请先选择部门" inView:self.view];
    }
}

-(void)cancelAgree:(UIButton*)button
{
    self.bgSelectView.hidden = YES;
    [self.bgSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.applyTableview.mas_bottom);
    }];
}

-(void)confirmAgree:(UIButton*)button
{
    
    if ([NSString isBlankString:self.apply_Department_id]) {
        [WFHudView showMsg:@"请选择部门" inView:self.bgSelectView];
        return;
    }
    button.userInteractionEnabled = NO;
    NSDictionary *dict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                               @"request_uid":self.agreeTempModel.request_user_id,
                               @"request_id":self.agreeTempModel.request_id,
                               @"is_agree":@(1),
                               @"company_id":self.agreeTempModel.company_id,
                               @"department_id":self.apply_Department_id,
                               @"deal_with_id":self.agreeTempModel.deal_with_id};
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict addEntriesFromDictionary:dict];
    if (![NSString isBlankString:self.selectedJobLabel.text]) {
        [paramDict setObject:@(self.apply_Job_id) forKey:@"job_id"];
    }
    [[NetworkSingletion sharedManager]approvalApplyJoinCompany:paramDict onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            self.bgSelectView.hidden = YES;
            [self.bgSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.applyTableview.mas_bottom);
            }];
            [self.applyTableview reloadData];
        }else{
            
            [MBProgressHUD showError:dict[@"message"] toView:self.bgSelectView];
        }
        button.userInteractionEnabled = YES;
    } OnError:^(NSString *error) {
        button.userInteractionEnabled = YES;
    }];
}





#pragma mark ViewController Delegate

-(void)approvalApplyComapany:(NSInteger)agreeType withModel:(ApplyCompanyModel *)model
{
//    NSLog(@"***%li",agreeType);
    self.agreeTempModel = model;
    if (agreeType == 1) {//同意
        [self setSelectDepartmentView];
        [UIView animateWithDuration:0.5 animations:^{
            self.bgSelectView.hidden = NO;
            [self.bgSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-64);
            }];
        }];
        
    }else{
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"确定拒绝么？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSDictionary *parmDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                       @"request_uid":self.agreeTempModel.request_user_id,
                                       @"request_id":self.agreeTempModel.request_id,
                                       @"is_agree":@(2),
                                       @"company_id":self.agreeTempModel.company_id,
                                       @"deal_with_id":self.agreeTempModel.deal_with_id};
            [[NetworkSingletion sharedManager]approvalApplyJoinCompany:parmDict onSucceed:^(NSDictionary *dict) {
                if ([dict[@"code"] integerValue]==0) {
                    self.bgSelectView.hidden = YES;
                    [self.bgSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.applyTableview.mas_bottom);
                    }];
                    [self.applyTableview reloadData];
                }else{
                    
                    [MBProgressHUD showError:dict[@"message"] toView:self.bgSelectView];
                }
               
            } OnError:^(NSString *error) {
               
            }];
        }]];
        [self presentViewController:alerVC animated:YES completion:nil];
    }
}

-(void)selectedDepartment:(NSDictionary *)dict is_department:(BOOL)is_selected_depart
{
//     NSLog(@"***%@",dict);
    if (is_selected_depart) {
        self.departModel = [CompanyDepartmentModel objectWithKeyValues:dict];
        self.selectedDepartmentLabel.text = dict[@"department_name"];
        self.apply_Department_id = dict[@"department_id"];

    }else{
         NSString *job = [dict objectForKey:@"job_name"];
        if ([job isEqualToString:@"自定义职位"]) {
             [self setAddDepartmentView];
        }else{
            self.selectedJobLabel.text = job;
            self.apply_Job_id = [[dict objectForKey:@"job_id"] integerValue];
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
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 30, 240, 160)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.center = _bgWindow.center;
//        bgView.top = 80;
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
                                    @"department_id":self.apply_Department_id,
                                    @"num":@(1),
                                    @"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]};
        [[NetworkSingletion sharedManager]customPosition:paramDict onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue]== 0) {
                NSMutableArray *jobArray = [NSMutableArray array];
                NSDictionary *jobDict = @{@"job_name":self.nameTxt.text,@"job_id":dict[@"data"]};
                [jobArray addObjectsFromArray:self.departModel.job];
                [jobArray addObject:jobDict];
                self.departModel.job = jobArray;
                self.selectedJobLabel.text = self.nameTxt.text;
                self.apply_Job_id = [dict[@"data"] integerValue];
                _bgWindow.hidden = YES;
                [_bgWindow resignKeyWindow];
                
            }
        } OnError:^(NSString *error) {
            
        }];
    }else{
        [WFHudView showMsg:@"请输入职位名称" inView:self.view];
    }
}


#pragma mark 数据相关

-(void)loadNewData
{
    page = 1;
    [self.dataArray removeAllObjects];
    [self loadData];
}
-(void)loadMoreData
{
    page++;
    [self loadData];
}
-(void)loadData
{
    if (self.companyID) {
        NSDictionary *dict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                               @"company_id":self.companyID,
                               @"p":@(page),
                               @"each":@(10)};
        [[NetworkSingletion sharedManager]listOfapplyJoinCompany:dict onSucceed:^(NSDictionary *dict) {
//            NSLog(@"**ceshi join**%@",dict);
            [self.applyTableview.mj_header endRefreshing];
            [self.applyTableview.mj_footer endRefreshing];
            if ([dict[@"code"]integerValue]==0) {
                NSArray *array = dict[@"data"];
                if (array.count > 0) {
                    NSArray *modelArray = [ApplyCompanyModel objectArrayWithKeyValuesArray:dict[@"data"]];
                    [self.dataArray addObjectsFromArray:modelArray];
                }
                [self.applyTableview reloadData];
            }else{
//                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            
        }];
    }else{
        [self.applyTableview.mj_header endRefreshing];
        [self.applyTableview.mj_footer endRefreshing];
    }
    
}



#pragma mark UITableView Delegate  & DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"申请加入公司";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = TOP_GREEN;
        return cell;
    }
    ApplyJoinCompanyCell *cell = (ApplyJoinCompanyCell*)[tableView dequeueReusableCellWithIdentifier:@"ApplyJoinCompanyCell"];
    if (!cell) {
        cell = [[ApplyJoinCompanyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApplyJoinCompanyCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (self.dataArray.count > 0) {
        cell.applyModel = self.dataArray[indexPath.row];
       [cell setApplyJoinCellWith:self.dataArray[indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SelectedCompanyViewController *companyVC = [[SelectedCompanyViewController alloc]init];
        companyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:companyVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }
    ApplyJoinCompanyCell *cell = (ApplyJoinCompanyCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 20;
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

#pragma mark Custom View Method

-(UILabel*)customUILabelWithTitle:(NSString*)title
{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = FORMLABELTITLECOLOR;
    label.text = title;
    return label;
}

-(UITextField*)customUITextFieldwithContent
{
    UITextField *textfield = [[UITextField alloc]init];
    textfield.font = [UIFont systemFontOfSize:14];
    textfield.textColor = FORMTITLECOLOR;
    return textfield;
}

-(UIView*)customUIViewWithContentView:(UIView*)contentView;
{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(224, 223, 226);
    [contentView addSubview:line];
    return line;
}

#pragma mark GET / SET

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
