//
//  SWPublishWaitingView.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWPublishWaitingView.h"

#import "CXZ.h"

#import "SWPublishedCell.h"

#import "SWMyPublishDetailController.h"

#import "SWMyPublishCmd.h"
#import "SWMyPublishInfo.h"
#import "SWMyPublishData.h"
#import "SWTools.h"

@interface SWPublishWaitingView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSArray *dataSource;

@end

@implementation SWPublishWaitingView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        //初始化界面
        [self initWithView];
        
        [self loadData];
        
    }
    
    return self;
    
}

- (void)loadData {
    
    SWMyPublishCmd *publishCmd = [[SWMyPublishCmd alloc] init];
    publishCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    publishCmd.status = 1;
    
    [[HttpNetwork getInstance] requestPOST:publishCmd success:^(BaseRespond *respond) {
        
        SWMyPublishInfo *publishInfo = [[SWMyPublishInfo alloc] initWithDictionary:respond.data];
        
        _dataSource = publishInfo.data;
        
        [_tableView reloadData];
        
        [_tableView.mj_header endRefreshing];
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        [_tableView.mj_header endRefreshing];
        
    }];
    
}

//初始化界面
- (void)initWithView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    tableView.tableFooterView = [UIView new];
    [self addSubview:tableView];
    _tableView = tableView;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        [self loadData];
        
    }];
    
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    
    _tableView.mj_header = header;
    
}

#pragma mark ------------ tableView delegate & dataSource start ------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 49.0f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    return view;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SWPublishedCell *waitingCell = [SWPublishedCell initWithTableViewCell:tableView];
    
    SWMyPublishData *taskData = _dataSource[indexPath.row];
    
    [waitingCell showData:[SWTools dateFormate:taskData.add_time formate:@"yyyy-MM-dd"] content:taskData.title];
    
    return waitingCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataSource.count > 0) {
        SWMyPublishData *taskData = _dataSource[indexPath.row];
        
        SWMyPublishDetailController *myPublishDetailController = [[SWMyPublishDetailController alloc] init];
        myPublishDetailController.iid = taskData.iid;
        myPublishDetailController.detailTitle = taskData.title;
        myPublishDetailController.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:myPublishDetailController animated:YES];
    }
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark ------------ tableView delegate & dataSource end ------------------

@end
