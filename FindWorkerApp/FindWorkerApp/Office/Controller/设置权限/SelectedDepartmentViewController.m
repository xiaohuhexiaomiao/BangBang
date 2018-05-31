//
//  SelectedDepartmentViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/12.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SelectedDepartmentViewController.h"

#import "CXZ.h"

@interface SelectedDepartmentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *selectedTbleview;

@property (nonatomic , strong)NSMutableArray *dataArray;

@end

@implementation SelectedDepartmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"选择部门" withColor:[UIColor whiteColor]];
    [self config];
    [self loadDepartmentData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark Private Method

-(void)config
{
    _selectedTbleview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _selectedTbleview.delegate =self;
    _selectedTbleview.dataSource = self;
    _selectedTbleview.height = self.view.frame.size.height-64;
    [self.view addSubview:_selectedTbleview];
}

-(void)loadDepartmentData
{
    //加载部门信息
    [[NetworkSingletion sharedManager]getDepartmentData:@{@"company_id":self.companyid} onSucceed:^(NSDictionary *dict) {
//                NSLog(@"**department*%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            [self.dataArray addObjectsFromArray:dict[@"data"]];
            [self.selectedTbleview reloadData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}

#pragma mark UITableview Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = TITLECOLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (self.dataArray.count > 0) {
        cell.textLabel.text = [self.dataArray[indexPath.row] objectForKey:@"department_name"];
    }
     cell.textLabel.textColor = TITLECOLOR;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate didSelectedDepartment:self.dataArray[indexPath.row]];
    }
   
}



-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
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


#pragma mark get/set

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
