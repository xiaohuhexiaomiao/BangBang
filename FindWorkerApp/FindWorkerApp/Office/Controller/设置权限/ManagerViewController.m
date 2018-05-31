//
//  ManagerViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/21.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ManagerViewController.h"
#import "CXZ.h"
#import "ResetManagerViewController.h"
@interface ManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)UITableView *tableview;

@property (nonatomic , strong)NSArray *formArray;

@end

@implementation ManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitleWithString:@"设置审批人员" withColor:[UIColor whiteColor]];
    [self setupBackw];
    
    self.formArray = @[@"合同评审表",@"请购单",@"请款单",@"印章申请",@"呈批件",@"报销单"];
    
    _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.height = self.view.frame.size.height - 64;
    [self.view addSubview:_tableview];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
#pragma mark UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    NSLog(@"***%li",self.positionArray.count);
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.formArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.formArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
    
}

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
    NSArray *typeArray = @[@"1",@"7",@"8",@"5",@"6",@"11"];
    ResetManagerViewController *manager = [[ResetManagerViewController alloc]init];
    manager.compony_id = self.compony_id;
    manager.form_type = [typeArray[indexPath.row] integerValue];
    manager.form_title = [NSString stringWithFormat:@"%@审批人员",self.formArray[indexPath.row]];
    manager.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:manager animated:YES];
    self.hidesBottomBarWhenPushed = YES;
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
