//
//  ResetManagerViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ResetManagerViewController.h"
#import "CXZ.h"

#import "SetManagerCell.h"

#import "AdressBookViewController.h"

@interface ResetManagerViewController ()<UITableViewDelegate ,UITableViewDataSource,AdressBookDelegate,SetManagerCellDelegate>

@property(nonatomic ,strong) UITableView *tableview;

@property(nonatomic ,strong) NSMutableArray *managerArray;

@end

@implementation ResetManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitleWithString:self.form_title withColor:[UIColor whiteColor]];
    [self setupBackw];
    [self setupNextWithString:@"添加" withColor:[UIColor whiteColor]];
    
    _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableview.height = SCREEN_HEIGHT-104;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    
    
    UIButton *nextBtn =[CustomView customButtonWithContentView:self.view image:nil title:@"保存"];
    nextBtn.frame = CGRectMake(0, _tableview.bottom, SCREEN_WIDTH, 40);
    [nextBtn addTarget:self action:@selector(clickNextButton) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = TOP_GREEN;
    nextBtn.layer.cornerRadius = 3;

    [self loadApprovalData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
#pragma mark Data Method

-(void)loadApprovalData
{
    NSDictionary *paramDict = @{@"company_id":self.compony_id,@"type":@(self.form_type)};
    [[NetworkSingletion sharedManager]getFormApprovalPerson:paramDict onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            [self.managerArray addObjectsFromArray:dict[@"data"]];
            [self.tableview reloadData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        
    }];
}

#pragma mark Systom Mehod

-(void)onNext
{
   
    AdressBookViewController *bookVC = [[AdressBookViewController alloc]init];
//    bookVC.areadySelectArray = self.managerArray;
    bookVC.companyid = self.compony_id;
    bookVC.isSelect = YES;
    bookVC.delegate = self;
    bookVC.loadDataType = 2;
    bookVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bookVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;

    
}


#pragma mark Private Method

-(void)clickNextButton
{

    NSMutableArray *paramArray = [NSMutableArray array];
    if (self.managerArray.count == 0) {
        [MBProgressHUD showError:@"您还未设置审批人员" toView:self.view];
    }
    for (NSDictionary *dict in self.managerArray) {
        [paramArray addObject:@{@"uid":dict[@"uid"]}];
    }
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                @"company_id":self.compony_id,
                                @"type":@(self.form_type),
                                @"sequence":[NSString dictionaryToJson:paramArray]
                                };
    [[NetworkSingletion sharedManager]setApprovalList:paramDict onSucceed:^(NSDictionary *dict) {
        //                    NSLog(@"**set**%@***%@",dict,dict[@"message"]);
        if ([dict[@"code"] integerValue]==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}





#pragma mark Delegate Method


-(void)saveAdressBook:(NSMutableArray*)selectedArray
{
//    [self.managerArray removeAllObjects];

    [self.managerArray addObjectsFromArray:selectedArray];
    [self.tableview reloadData];
}


-(void)moveUpOrDownCell:(NSInteger)row is_up:(BOOL)is_up
{
    if (is_up && row !=0) {
        [self.managerArray exchangeObjectAtIndex:row withObjectAtIndex:(row-1)];
        [self.tableview reloadData];
    }
    
    if (!is_up && row != (self.managerArray.count-1)) {
        [self.managerArray exchangeObjectAtIndex:row withObjectAtIndex:(row+1)];
        [self.tableview reloadData];
    }
}

-(void)deleteCell:(NSInteger)row
{
    [self.managerArray removeObjectAtIndex:row];
    [self.tableview reloadData];
}

#pragma mark UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.managerArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SetManagerCell *cell = (SetManagerCell*)[tableView dequeueReusableCellWithIdentifier: @"DepartmentTableViewCell"];
    if (!cell) {
        cell = [[SetManagerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DepartmentTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;

    cell.tag = indexPath.row;
    if (self.managerArray.count > 0) {
        PersonelModel *person = [PersonelModel objectWithKeyValues:self.managerArray[indexPath.row]];
        [cell setManagerCellWith:person];
    }
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

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark get/set

-(NSMutableArray*)managerArray
{
    if (!_managerArray) {
        _managerArray = [NSMutableArray array];
    }
    return _managerArray;
}



@end
