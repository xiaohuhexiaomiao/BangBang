//
//  WorkRemindViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/12/4.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "WorkRemindViewController.h"
#import "CXZ.h"
#import "NormalCell.h"

#import "ReceiveCommentViewController.h"
#import "DiaryRemindViewController.h"
#import "PersonWorkListViewController.h"

@interface RemindModel :NSObject

@property(nonatomic ,strong)NSDictionary* liked_me;

@property(nonatomic ,strong)NSDictionary* reply_me;

@property(nonatomic ,strong)NSDictionary* reviewed_me;

@property(nonatomic ,strong)NSDictionary* wait_reviewed;

@property(nonatomic ,strong)NSDictionary* reply_me_approval;

@end

@implementation RemindModel



@end

@interface WorkRemindViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic , strong)UITableView *tableview;

@property(nonatomic , strong) RemindModel *remindModel;

@end

@implementation WorkRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"消息提醒" withColor:[UIColor whiteColor]];

    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [UIView new];
    _tableview.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableview];
    __weak typeof(self) weakself = self;
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark Load Data

-(void)loadData
{
//    NSDictionary *paramDict = @{@"company_id":self.companyID};
    [[NetworkSingletion sharedManager]getNewRemindData:nil onSucceed:^(NSDictionary *dict) {
//        NSLog(@"****haha %@",dict);
        [self.tableview.mj_header endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            self.remindModel = [RemindModel objectWithKeyValues:dict[@"data"]];
            [self.tableview reloadData];
        }
        
    } OnError:^(NSString *error) {
        
    }];
}


#pragma mark 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalCell *cell = (NormalCell*)[tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
    if (!cell) {
        cell = [[NormalCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NormalCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *imgArray = @[@"myDianping",@"mycomment",@"shenpihuifu",@"myzan",@"mylog"];
    NSArray *titleArray = @[@"日志提醒",@"回复我的日志",@"回复我的审批",@"我收到的赞",@"我发出的工作"];
    [cell setImageViewWithImage:imgArray[indexPath.row] Title:titleArray[indexPath.row] SubTitle:nil];
    if (self.remindModel) {
        if (indexPath.row ==0 && self.remindModel.wait_reviewed ) {
            NSDictionary *dict = self.remindModel.wait_reviewed;
            cell.subtitleLabel.text = [NSString stringWithFormat:@"您有%li篇日志未点评",[dict[@"unread_num"] integerValue]];
        }
        if (indexPath.row == 1 && self.remindModel.reply_me) {
            NSDictionary *dict = self.remindModel.reply_me;
            cell.subtitleLabel.text = [NSString stringWithFormat:@"%@回复：%@",dict[@"name"],dict[@"description"]];
        }
        if (indexPath.row == 2 && self.remindModel.reply_me_approval) {
            NSDictionary *dict = self.remindModel.reply_me_approval;
            cell.subtitleLabel.text = [NSString stringWithFormat:@"%@回复了我的审批",dict[@"name"]];
        }
        if (indexPath.row == 3 && self.remindModel.liked_me) {
            NSDictionary *dict = self.remindModel.liked_me;
            cell.subtitleLabel.text = [NSString stringWithFormat:@"%@赞了我",dict[@"name"]];
        }   
        if (indexPath.row == 4 && self.remindModel.reviewed_me) {
            NSDictionary *dict = self.remindModel.reviewed_me;
            cell.subtitleLabel.text = [NSString stringWithFormat:@"%@点评了我的日志",dict[@"name"]];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        DiaryRemindViewController *remindVC = [[DiaryRemindViewController alloc]init];
        remindVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:remindVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (indexPath.row == 1 || indexPath.row == 2|| indexPath.row == 3){
        ReceiveCommentViewController *commentVC = [[ReceiveCommentViewController alloc]init];
        commentVC.remindType = indexPath.row;
        commentVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (indexPath.row == 4){
        PersonWorkListViewController *workVC = [[PersonWorkListViewController alloc]init];
        workVC.look_uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
        workVC.type = 1;
        workVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:workVC animated:YES];
    }
    
}



@end
