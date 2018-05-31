//
//  PersonDetailViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/24.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "CXZ.h"

#import "PersonWorkListViewController.h"

@interface PersonDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong)UITableView *personTableview;

@property(nonatomic ,strong) UIImageView *headImageView;

@property(nonatomic, strong) UILabel *nameLabel;

@property(nonatomic, strong) PersonelModel *personInfo;

@end

@implementation PersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
   
    _personTableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _personTableview.delegate = self;
    _personTableview.dataSource = self;
    [self.view addSubview:_personTableview];
    __weak typeof(self) weakself = self;
    _personTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    [_personTableview.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(void)loadData
{
    
    [[NetworkSingletion sharedManager]getMangerRightInfoOfCompany:@{@"uid":self.look_uid,@"company_id":self.companyID} onSucceed:^(NSDictionary *dict) {
//                NSLog(@"***haha*%@",dict);
        [self.personTableview.mj_header endRefreshing];
        if ([dict[@"code"] integerValue] == 0) {
            self.personInfo = [PersonelModel objectWithKeyValues:dict[@"data"]];
            [self.personTableview reloadData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [self.personTableview.mj_header endRefreshing];
      
    }];
}

-(void)callPhone
{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.personInfo.phone];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.navigationController.view addSubview:callWebview];
}

#pragma mark

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"NormalCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    NSArray *array = @[@[@"电话",@"所属部门"],@[@"工作记录",@"外勤签到"]];;
    cell.textLabel.text = array[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = self.personInfo.phone;
        }else if (indexPath.row == 1){
            cell.detailTextLabel.text =self.personInfo.department_name;
        }
    }
    if (indexPath.section == 1) {
        cell.detailTextLabel.text = @"更多...";
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return SCREEN_WIDTH/2;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, SCREEN_WIDTH/4-60, 60, 60)];
        _headImageView.layer.cornerRadius = 30;
        _headImageView.layer.masksToBounds = YES;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,self.personInfo.avatar]] placeholderImage:[UIImage imageNamed:@"temp"]];
        [view addSubview:_headImageView];
        
        _nameLabel = [CustomView customContentUILableWithContentView:view title:nil];
        _nameLabel.frame = CGRectMake(0, _headImageView.bottom+5, SCREEN_WIDTH, 15);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = self.personInfo.name;
        
        UIButton *phoneButton = [CustomView customButtonWithContentView:view image:@"callHim" title:self.personInfo.phone];
        phoneButton.frame = CGRectMake(0, _nameLabel.bottom+5, SCREEN_WIDTH, 20);
        [phoneButton addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:phoneButton];
        
        return view;
    }

    return nil;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        PersonWorkListViewController *workVC = [[PersonWorkListViewController alloc]init];
        workVC.look_uid = self.look_uid;
        workVC.companyID = self.companyID;
        workVC.type = indexPath.row+1;
        workVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:workVC animated:YES];
    }
    
}


@end
