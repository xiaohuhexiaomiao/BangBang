//
//  ReceiveCommentViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/12/7.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ReceiveCommentViewController.h"
#import "CXZ.h"
#import "DiaryRemindCell.h"

#import "RemindDetailModel.h"
#import "ReplyApprovalContentModel.h"

#import "DiaryDetailViewController.h"
#import "SignDetailViewController.h"

#import "ShowPaymentsViewController.h"
#import "StampViewController.h"
#import "ShowFileViewController.h"
#import "ShowPurchaseViewController.h"
#import "ShowCompanyViewController.h"
#import "ShowExpenseAccountViewController.h"
#import "ShowStampViewController.h"

@interface ReceiveCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
}
@property(nonatomic ,strong)UITableView *tableview;

@property(nonatomic ,strong)NSMutableArray *dataArray;

@end

@implementation ReceiveCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self removeTapGestureRecognizer];
    [self setupBackw];
    if (self.remindType == 1) {
        [self setupTitleWithString:@"回复我的" withColor:[UIColor whiteColor]];
    }
    if (self.remindType == 2) {
        [self setupTitleWithString:@"审批回复" withColor:[UIColor whiteColor]];
    }
    if (self.remindType == 3) {
        [self setupTitleWithString:@"我收到的赞" withColor:[UIColor whiteColor]];
    }
    
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [UIView new];
    _tableview.separatorColor = [UIColor clearColor];
    _tableview.height = self.view.bounds.size.height-64;
    [self.view addSubview:_tableview];
    
    __weak typeof(self) weakself = self;
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstData];
    }];
    _tableview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    [_tableview.mj_header beginRefreshing];
}     

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark  Data Method

-(void)loadFirstData
{
    [self.dataArray removeAllObjects];
    page = 1;
    [self loadData];
}

-(void)loadMoreData
{
    page ++;
    [self loadData];
}

-(void)loadData
{
    NSDictionary *paramDict = @{
                                @"p":@(page),
                                @"each":@(15)};
    if (self.remindType == 1) {
        [[NetworkSingletion sharedManager]getMyReply:paramDict onSucceed:^(NSDictionary *dict) {
            [self.tableview.mj_header endRefreshing];
            [self.tableview.mj_footer endRefreshing];
//           NSLog(@"****haha %@",dict);
            if ([dict[@"code"] integerValue]==0) {
                NSArray *array = [dict objectForKey:@"data"];
                for (NSDictionary *dataDict in array) {
                    RemindDetailModel *detailModel = [RemindDetailModel objectWithKeyValues:dataDict];
                    if (![NSString isBlankString:dataDict[@"description"]]) {
                        detailModel.description_detail = dataDict[@"description"];
                    }else{
                        detailModel.description_detail = nil;
                    }
                    [self.dataArray addObject:detailModel];
                }
                [self.tableview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            
        }];
    }else if (self.remindType == 2){
        [[NetworkSingletion sharedManager]getReplyApprovalMessageList:paramDict onSucceed:^(NSDictionary *dict) {
            [self.tableview.mj_header endRefreshing];
            [self.tableview.mj_footer endRefreshing];
            //            NSLog(@"****haha %@",dict);
            if ([dict[@"code"] integerValue]==0) {
                NSArray *array = [dict objectForKey:@"data"];
                for (NSDictionary *dataDict in array) {
                    ReplyApprovalContentModel *detailModel = [ReplyApprovalContentModel objectWithKeyValues:dataDict];
                    if (![NSString isBlankString:dataDict[@"description"]]) {
                        detailModel.descriptionStr = dataDict[@"description"];
                    }
                    [self.dataArray addObject:detailModel];
                }
                [self.tableview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
            
        } OnError:^(NSString *error) {
            
        }];
    }else if (self.remindType == 3){
        [[NetworkSingletion sharedManager]getMyGood:paramDict onSucceed:^(NSDictionary *dict) {
            [self.tableview.mj_header endRefreshing];
            [self.tableview.mj_footer endRefreshing];
//            NSLog(@"****haha %@",dict);
            if ([dict[@"code"] integerValue]==0) {
                NSArray *array = [dict objectForKey:@"data"];
                for (NSDictionary *dataDict in array) {
                    RemindDetailModel *detailModel = [RemindDetailModel objectWithKeyValues:dataDict];
                    if (![NSString isBlankString:dataDict[@"description"]]) {
                        detailModel.description_detail = dataDict[@"description"];
                    }
                    [self.dataArray addObject:detailModel];
                }
                [self.tableview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }

        } OnError:^(NSString *error) {
            
        }];
    }
}



#pragma mark UITableView Delegate  & Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiaryRemindCell *cell = (DiaryRemindCell*)[tableView dequeueReusableCellWithIdentifier:@"DiaryRemindCell"];
    if (!cell) {
        cell = [[DiaryRemindCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DiaryRemindCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count > 0) {
        if (self.remindType == 1) {
            [cell setDiaryRemindCellWithCommentModel:self.dataArray[indexPath.row]];
        }else if(self.remindType == 2){
            [cell setDiaryRemindCellWithReplyContentModel:self.dataArray[indexPath.row]];
        }else if(self.remindType == 3){
            [cell setDiaryRemindCellWithZanModel:self.dataArray[indexPath.row]];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        if (self.remindType == 2) {
            ReplyApprovalContentModel *listModel = self.dataArray[indexPath.row];
            ShowPaymentsViewController *payVC = [[ShowPaymentsViewController alloc]init];
            ShowPurchaseViewController *purchaseVC = [[ShowPurchaseViewController alloc]init];
            ShowStampViewController *stampVC = [[ShowStampViewController alloc]init];
            ShowFileViewController *fileVC = [[ShowFileViewController alloc]init];
            ShowCompanyViewController *companyVC = [[ShowCompanyViewController alloc]init];
            ShowExpenseAccountViewController *expenseAccountVC = [[ShowExpenseAccountViewController alloc]init];
            payVC.is_reply = YES;
            purchaseVC.is_reply = YES;
            stampVC.is_reply = YES;
            fileVC.is_reply = YES;
            companyVC.is_reply = YES;
            expenseAccountVC.is_reply = YES;
            
            payVC.is_aready_approval = YES;
            purchaseVC.is_aready_approval = YES;
            stampVC.is_aready_approval = YES;
            fileVC.is_aready_approval = YES;
            companyVC.is_aready_approval = YES;
            expenseAccountVC.is_aready_approval = YES;
            if (listModel.type == 0||listModel.type == 8||listModel.type == 9){
                payVC.approvalID = listModel.approval_id;
    
                [self.navigationController pushViewController:payVC animated:YES];
            }else if (listModel.type == 3 ||listModel.type == 7||listModel.type == 10){
                purchaseVC.approvalID = listModel.approval_id;
    
                [self.navigationController pushViewController:purchaseVC animated:YES];
            }else if (listModel.type == 5){
                stampVC.approvalID = listModel.approval_id;
                [self.navigationController pushViewController:stampVC animated:YES];
            }else if (listModel.type == 6){
                fileVC.approvalID = listModel.approval_id;
                [self.navigationController pushViewController:fileVC animated:YES];
            }else if (listModel.type == 111){
                companyVC.approval_id = listModel.approval_id;
                [self.navigationController pushViewController:companyVC animated:YES];
            }else if (listModel.type == 11){
                expenseAccountVC.approvalID = listModel.approval_id;
                [self.navigationController pushViewController:expenseAccountVC animated:YES];
            }

        }else{
            RemindDetailModel *model = self.dataArray[indexPath.row];
            if (model.publish_type == 1) {
                DiaryDetailViewController *detailVC = [[DiaryDetailViewController alloc]init];
                detailVC.publish_id = model.publish_id;
                [self.navigationController pushViewController:detailVC animated:YES];
            }else if(model.publish_type == 2){
                SignDetailViewController *detailVC = [[SignDetailViewController alloc]init];
                detailVC.publish_id = model.publish_id;
                [self.navigationController pushViewController:detailVC animated:YES];
            }

        }
    }
    
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
