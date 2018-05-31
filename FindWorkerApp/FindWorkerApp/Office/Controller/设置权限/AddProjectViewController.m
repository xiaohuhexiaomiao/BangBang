//
//  AddProjectViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/21.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "AddProjectViewController.h"

#import "CXZ.h"


@interface AddProjectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)UITableView *tableview;

@property(nonatomic ,strong)UIWindow *bgWindow;

@property(nonatomic ,strong)UITextField *nameTxt;

@property(nonatomic ,strong)NSMutableArray *projectArray;

@end

@implementation AddProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitleWithString:@"添加工程项目" withColor:[UIColor whiteColor]];
    [self setupBackw];
    
    _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.height = self.view.frame.size.height-64;
    
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadPojectData];
    }];
    [_tableview.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark 数据相关

-(void)loadPojectData
{
    [self.projectArray removeAllObjects];
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"company_id":self.company_id};
    [[NetworkSingletion sharedManager]getProjectList:paramDict onSucceed:^(NSDictionary *dict) {
//         NSLog(@"***%@",dict);
      [self.tableview.mj_header endRefreshing];
        if ([dict[@"code"]integerValue]==0) {
            [self.projectArray addObjectsFromArray:dict[@"data"]];
            [self.tableview reloadData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [self.tableview.mj_header endRefreshing];
    }];
    
}

#pragma mark Private Method
-(void)clickCancelButton:(UIButton*)bton
{
    _bgWindow.hidden = YES;
    [_bgWindow resignKeyWindow];
}

-(void)clickAddDepartmentButton:(UIButton*)bton
{
    if (![NSString isBlankString:self.nameTxt.text]) {
        NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                    @"company_id":self.company_id,
                                    @"project_name":self.nameTxt.text};
        [[NetworkSingletion sharedManager]addProjectOfCompany:paramDict onSucceed:^(NSDictionary *dict) {
//           NSLog(@"***%@",dict);
            if ([dict[@"code"] integerValue]==0) {
                NSDictionary *dict = @{@"project_name":self.nameTxt.text};
                [self.projectArray addObject:dict];
                [self.tableview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
     
    }else{
        [WFHudView showMsg:@"请输入工程项目名称" inView:self.view];
    }
    
}

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
        
        UILabel *titleLabel = [CustomView customTitleUILableWithContentView:bgView title:@"添加工程"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(0, 0, bgView.width, 30);
        
        UIView *line = [CustomView customLineView:bgView];
        line.frame = CGRectMake(0, titleLabel.bottom, bgView.width, 1);
        
        
        _nameTxt = [CustomView customUITextFieldWithContetnView:bgView placeHolder:@"请输入工程名称"];
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


#pragma mark UITableview Delegate & DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.is_add_project) {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.is_add_project) {
        if (section == 0) {
            return 1;
        }
        return self.projectArray.count;
    }
     return self.projectArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
    if (!cell  ) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"];
    }
    if (self.is_add_project) {
        if (indexPath.section == 0) {
            cell.textLabel.text = @"添加工程";
        }else{
            if (self.projectArray.count > 0) {
                cell.textLabel.text = [self.projectArray[indexPath.row] objectForKey:@"project_name"];
            }
        }
    }else{
        cell.textLabel.text = [self.projectArray[indexPath.row] objectForKey:@"project_name"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.is_add_project) {
        if (indexPath.section == 0) {
            [self setAddDepartmentView];
        }
    }else{
        if (self.projectArray.count > 0) {
            [self.delegate selectedProject:self.projectArray[indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark get/set

-(NSMutableArray*)projectArray
{
    if (!_projectArray) {
        _projectArray = [NSMutableArray array];
    }
    return _projectArray;
}


@end
