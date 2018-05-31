//
//  NoticeViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/1/3.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "NoticeViewController.h"
#import "CXZ.h"
#import "NoticeTableViewCell.h"
#import "NoticeModel.h"
#import "SWTabController.h"
#import "SWJobDetailController.h"
#import "SWMyContractController.h"
#import "SWMyJobController.h"
#import "SWMyPublishDetailController.h"
#import "MyWorkersViewController.h"
#import "TransactionLogViewController.h"
#import "ApprovalViewController.h"

@interface NoticeViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
}
@property (nonatomic, strong)UITableView *noticeTblview;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    
    [self setupNextWithString:@"清空" withColor:TOP_GREEN];
    
    [self setupTitleWithString:@"消息中心" withColor:[UIColor whiteColor]];
    
//    NSLog(@"***%lf , %lf , %lf ,%d,%d",SCREEN_HEIGHT, FRAME_HEIGHT, STATUS_BAR_HEIGHT, TITLE_BAR_HEIGHT,TITLE_BAR_HEIGHT);
    self.noticeTblview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.noticeTblview.delegate = self;
    self.noticeTblview.dataSource = self;
    self.noticeTblview.tableFooterView = [UIView new];
    [self.view addSubview:self.noticeTblview];
    self.noticeTblview.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self reloadData];
    }];
    self.noticeTblview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    [self.noticeTblview.mj_header beginRefreshing];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)onNext
{
    
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"确定要清除全部消息么？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self  clearAllNotice];
        
    }]];
    [self presentViewController:alerVC animated:YES completion:nil];
    
}

#pragma mark Private Method

-(void)clearAllNotice
{
    [[NetworkSingletion sharedManager]clearNotice:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            [self.dataArray removeAllObjects];
            [self.noticeTblview.mj_header beginRefreshing];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.navigationController.view];
    }];
}

-(void)reloadData
{
    page = 1;
    [self.dataArray removeAllObjects];
    [self loadData];
}

-(void)loadMoreData
{
    page ++;
    [self loadData];
}
-(void)loadData{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    [[NetworkSingletion sharedManager]getNoticeList:@{@"uid":uid,@"p":@(page),@"each":@"10"} onSucceed:^(NSDictionary *dict) {
        [self.noticeTblview.mj_header endRefreshing];
        [self.noticeTblview.mj_footer endRefreshing];
//        NSLog(@"***%@",dict);
        [self.dataArray removeAllObjects];
        if ([dict[@"code"] integerValue] == 0) {
            NSArray *array = [dict objectForKey:@"data"];
            for (int i = 0; i < array.count; i++) {
                NoticeModel *notice = [NoticeModel objectWithKeyValues:array[i]];
                [self.dataArray addObject:notice];
            }
        }
        [self.noticeTblview reloadData];
    } OnError:^(NSString *error) {
        [self.noticeTblview.mj_header endRefreshing];
        [self.noticeTblview.mj_footer endRefreshing];
        [MBProgressHUD showError:error toView:self.navigationController.view];
    }];
}

-(void)clickNotice:(NoticeModel*)notice
{
    if ([notice.type isEqualToString:@"worker_audit_agree"]) {//主页>找活干
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
    }else{
        if ([notice.type isEqualToString:@"employment_invitation"]) {//我的任务
            SWMyJobController *jobVC = [[SWMyJobController alloc] init];
            jobVC.hidesBottomBarWhenPushed = YES;
            jobVC.segmentControl.selectIndex = 0;
            [self.navigationController pushViewController:jobVC animated:YES];
        }else if ([notice.type isEqualToString:@"new_project_informatin"]){//工程详情
            SWJobDetailController *jobController = [[SWJobDetailController alloc] init];
            jobController.hidesBottomBarWhenPushed = YES;
            if ([NSString isBlankString:notice.information_id]) {
                return;
            }
            jobController.iid = notice.information_id;
            [self.navigationController pushViewController:jobController animated:YES];
        }else if ([notice.type isEqualToString:@"receive_employment_contract"]||[notice.type isEqualToString:@"contract_modifyed"]){//我的合同-我收到
            SWMyContractController *contractVC = [[SWMyContractController alloc] init];
            contractVC.hidesBottomBarWhenPushed = YES;
            contractVC.segmentControl.selectIndex = 1;
            [self.navigationController pushViewController:contractVC animated:YES];
        }else if ([notice.type isEqualToString:@"employment_contract_agree"]||[notice.type isEqualToString:@"employment_invitation_agree"]||[notice.type isEqualToString:@"contract_not_agree"]||[notice.type isEqualToString:@"contract_refuse"]){//我的合同-我发布
            SWMyContractController *contractVC = [[SWMyContractController alloc] init];
            contractVC.hidesBottomBarWhenPushed = YES;
            contractVC.segmentControl.selectIndex = 0;
            
            [self.navigationController pushViewController:contractVC animated:YES];
        }else if ([notice.type isEqualToString:@"project_receive_worker_ask"]||[notice.type isEqualToString:@"employment_invitation_refuse"]||[notice.type isEqualToString:@"worker_confirm_over"]){//我发布的-工程详情
            SWMyPublishDetailController *publishVC = [SWMyPublishDetailController new];
            publishVC.hidesBottomBarWhenPushed = YES;
            if ([NSString isBlankString:notice.information_id]) {
                return;
            }

            publishVC.iid = notice.information_id;
            [self.navigationController pushViewController:publishVC animated:YES];
        }else if ([notice.type isEqualToString:@"employer_pay_subsist"]){//我的任务>待开始
            SWMyJobController *jobVC = [[SWMyJobController alloc] init];
            jobVC.hidesBottomBarWhenPushed = YES;
            jobVC.segmentControl.selectIndex = 1;
     
            [self.navigationController pushViewController:jobVC animated:YES];
        }else if ([notice.type isEqualToString:@"employer_information_begin"]){//我的任务>进行中
            SWMyJobController *jobVC = [[SWMyJobController alloc] init];
            jobVC.hidesBottomBarWhenPushed = YES;
            jobVC.segmentControl.selectIndex = 2;
         
            [self.navigationController pushViewController:jobVC animated:YES];
        }else if ([notice.type isEqualToString:@"employer_confirm_information_over"]){//我的任务>已完成
            SWMyJobController *jobVC = [[SWMyJobController alloc] init];
            jobVC.hidesBottomBarWhenPushed = YES;
            jobVC.segmentControl.selectIndex = 3;
   
            [self.navigationController pushViewController:jobVC animated:YES];
        }else if ([notice.type isEqualToString:@"worker_apply_money"]){//我要发工资
            MyWorkersViewController *workVC = [[MyWorkersViewController alloc] init];
            workVC.hidesBottomBarWhenPushed = YES;
        
            [self.navigationController pushViewController:workVC animated:YES];
        }else if ([notice.type isEqualToString:@"employer_pay_money"]){//交易记录
            TransactionLogViewController *logVC = [[TransactionLogViewController alloc] init];
            logVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:logVC animated:YES];
        }else if ([notice.type isEqualToString:@"receive_company_contract"]
                  || [notice.type isEqualToString:@"company_contract_not_agree"]
                  || [notice.type isEqualToString:@"company_contract_agree"]
                  || [notice.type isEqualToString:@"company_contract_refuse"]
                  || [notice.type isEqualToString:@"company_contract_modifyed"]
                  ||[notice.type isEqualToString:@"company_contract_verify_pass"]
                  ||[notice.type isEqualToString:@"company_contract_verify_refuse"]
                  || [notice.type isEqualToString:@"receive_new_verify"]
                  || [notice.type isEqualToString:@"verify_pass"]
                  || [notice.type isEqualToString:@"verify_refuse"])
        {
            ApprovalViewController *approvalVC = [[ApprovalViewController alloc]init];
            approvalVC.companyID = notice.information_id;
            approvalVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:approvalVC animated:YES];
        }
    }
    
}


#pragma mark UITableViewDelegate & Datasource

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
     static NSString *identifier = @"NoticeCell";
    NoticeTableViewCell *cell = (NoticeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.dataArray.count > 0) {
        [cell setNoticeCell:self.dataArray[indexPath.row]];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        [self clickNotice:self.dataArray[indexPath.row]];
    }
    
}

#pragma mark SET/GET

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
