//
//  RecordsDetailListController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/5/10.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "RecordsDetailListController.h"
#import "CXZ.h"


#import "PublishRecordsViewController.h"
#import "RecordsDetailViewController.h"

#import "RecordDetailCell.h"

#import "RecordsDetailListModel.h"

@interface RecordsDetailListController ()<UITableViewDelegate,UITableViewDataSource,RecordDetailCellDelegate>

{
    NSInteger page;
}

@property(nonatomic ,strong)UITableView *recordsTableView;

@property(nonatomic ,strong)UIButton *applyBtn;

@property(nonatomic ,strong)NSMutableArray *listArray;

@end

@implementation RecordsDetailListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"施工记录" withColor:[UIColor whiteColor]];
    
    if (self.workerType == 2) {
        [self setupNextWithString:@"发布" withColor:TOP_GREEN];
    }
    
    
    _recordsTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _recordsTableView.height -= 104;
    _recordsTableView.delegate = self;
    _recordsTableView.dataSource = self;
    [self.view addSubview:_recordsTableView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _recordsTableView.bottom, SCREEN_WIDTH, 40)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _applyBtn.frame = CGRectMake(20, 2, SCREEN_WIDTH-40, 30);
    _applyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _applyBtn.layer.borderColor = TOP_GREEN.CGColor;
    _applyBtn.layer.borderWidth = 0.8;
    _applyBtn.layer.cornerRadius = 15;
    [_applyBtn setTitleColor:TOP_GREEN forState:UIControlStateNormal];
    _applyBtn.backgroundColor = [UIColor whiteColor];
    
    if (self.workerType == 1) {
        [_applyBtn setTitle:@"工程验收" forState:UIControlStateNormal];
    }else{
       [_applyBtn setTitle:@"申请验收" forState:UIControlStateNormal];
    }
    [_applyBtn addTarget:self action:@selector(clickApplyButton) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_applyBtn];
    
    [self getApplyStatus];
    
    _recordsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _recordsTableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_recordsTableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"LOAD_NEW_RECORD_DATA" object:nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark Private Method

-(void)clickApplyButton
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *paramDict = @{@"user_id":uid, @"contract_id":self.constractid};
    NSString *title = [self.applyBtn titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"工程验收"]) {//雇主
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确认完工，接收工程？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[NetworkSingletion sharedManager]acceptProduction:paramDict onSucceed:^(NSDictionary *dict) {
//                NSLog(@"**jieshou**%@",dict);
                if ([dict[@"code"] integerValue]==0) {
                    [MBProgressHUD showSuccess:@"验收成功" toView:self.view];
                }else{
                    [MBProgressHUD showError:dict[@"message"] toView:self.view];
                }
            } OnError:^(NSString *error) {
                [MBProgressHUD showError:error toView:self.view];
            }];
        }];
        
        UIAlertAction *dismiss=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:dismiss];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if([title isEqualToString:@"申请验收"]){//工人
        
        [[NetworkSingletion sharedManager]applyAcceptProduction:paramDict onSucceed:^(NSDictionary *dict) {
            NSLog(@"**jieshou**%@",dict);
            if ([dict[@"code"] integerValue]==0) {
                [MBProgressHUD showSuccess:@"申请成功" toView:self.view];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }

        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];

        }];
        
    }else if ([title isEqualToString:@"申请付款"]){
        [[NetworkSingletion sharedManager]applyAmount:paramDict onSucceed:^(NSDictionary *dict) {
//            NSLog(@"**shenqingfukuan**%@",dict);
            if ([dict[@"code"] integerValue]==0) {
                [MBProgressHUD showSuccess:@"申请成功" toView:self.view];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];

        }];
    }
}



#pragma mark load data

-(void)getApplyStatus
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *paramDict = @{@"user_id":uid, @"contract_id":self.constractid};
//    NSLog(@"hetong  %@",self.constractid);
    [[NetworkSingletion sharedManager]getApplyStatus:paramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"**status**%@***%@",dict,dict[@"message"]);
        if ([dict[@"code"] integerValue]==0) {
            NSInteger status = [[dict[@"data"] objectForKey:@"worker_apply"] integerValue];
            if (status == 1 && self.workerType == 2) {
                [_applyBtn setTitle:@"已申请验收，等待雇主同意" forState:UIControlStateNormal];
            }
            if (status == 2 && self.workerType == 2) {
                [_applyBtn setTitle:@"申请付款" forState:UIControlStateNormal];
            }
            if (status == 1 && self.workerType == 2) {
                [_applyBtn setTitle:@"工程已结束" forState:UIControlStateNormal];
            }
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}

-(void)loadData
{
    [self.listArray removeAllObjects];
    page = 1;
    [self load];
}

-(void)loadMoreData
{
    page ++;
    [self load];
}

-(void)load
{
    NSDictionary *paramDict = @{@"contract_id":self.constractid,@"p":@(page),@"each":@"10"};
    [[NetworkSingletion sharedManager]constuctionRecordsDetailList:paramDict onSucceed:^(NSDictionary *dict) {
        
//        NSLog(@"*detail*****%@",dict);
        [self.recordsTableView.mj_header endRefreshing];
        [self.recordsTableView.mj_footer endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            NSArray *array = [RecordsDetailListModel objectArrayWithKeyValuesArray:dict[@"data"]];
            [self.listArray addObjectsFromArray:array];
            [self.recordsTableView reloadData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
        
    } OnError:^(NSString *error) {
        [self.recordsTableView.mj_header endRefreshing];
        [self.recordsTableView.mj_footer endRefreshing];
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
//    NSLog(@"****%li",self.listArray.count);
    return self.listArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier= @"RecordDetailCell";
    RecordDetailCell *cell = (RecordDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RecordDetailCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    cell.delegate = self;
    if (self.listArray.count > 0) {
        [cell setRecordsDetailListCellWithModel:self.listArray[indexPath.row]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RecordDetailCell *cell = (RecordDetailCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.recordDetailCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listArray.count > 0) {
        RecordsDetailListModel *detailModel = self.listArray [indexPath.row];
        RecordsDetailViewController *detailVC = [[RecordsDetailViewController alloc]init];
        detailVC.detailsModel = detailModel;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
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

#pragma mark 继承方法

-(void)onNext
{
    PublishRecordsViewController *publishVC  =[[PublishRecordsViewController alloc]init];
    publishVC.constractId = self.constractid;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publishVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark get/set

-(NSMutableArray*)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

@end
