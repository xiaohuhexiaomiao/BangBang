//
//  SWOngoingView.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWOngoingView.h"

#import "CXZ.h"

#import "SWOngoingCell.h"

#import "SWMyTaskCmd.h"
#import "SWMyTaskInfo.h"
#import "SWMyTaskData.h"
#import "SWTools.h"
#import "SWJobDetailController.h"

@interface SWOngoingView ()<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic, retain) NSArray *dataSource;

@end

@implementation SWOngoingView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        //初始化界面
        [self initWithView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"UPDATE_ONGOINGCELL" object:nil];
        
        
    }
    
    return self;
    
}

- (void)updateData {
    
    [_tableView.mj_header beginRefreshing];
    
}

- (void)loadData {
    
    SWMyTaskCmd *taskCmd = [[SWMyTaskCmd alloc] init];
    taskCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    taskCmd.build_status = 3;
    
    [[HttpNetwork getInstance] requestPOST:taskCmd success:^(BaseRespond *respond) {
        
        SWMyTaskInfo *taskInfo = [[SWMyTaskInfo alloc] initWithDictionary:respond.data];
        
        _dataSource = taskInfo.data;
        
        [_tableView reloadData];
        
        [_tableView.mj_header endRefreshing];
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        [_tableView.mj_header endRefreshing];
        
        [MBProgressHUD showError:@"加载数据失败" toView:self];
        
    }];
    
}

//初始化界面
- (void)initWithView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 64)];
    tableView.delegate = self;
    tableView.dataSource = self;
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
    
    [_tableView.mj_header beginRefreshing];
    
}


#pragma mark ------------ tableView delegate & dataSource start ------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataSource.count;
    
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
    
    SWOngoingCell *waitingCell = [SWOngoingCell initWithTableViewCell:tableView];
    
    SWMyTaskData *taskData = _dataSource[indexPath.section];
    waitingCell.taskData = taskData;
    
    [waitingCell showData:[SWTools dateFormate:taskData.add_time formate:@"yyyy-MM-dd"] content:taskData.title status:taskData.status];
    
    return waitingCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_dataSource.count > 0) {
        SWJobDetailController *jobController = [[SWJobDetailController alloc] init];
        SWMyTaskData *taskData = _dataSource[indexPath.section];
        jobController.iid = taskData.information_id;
        jobController.type = 3;
        jobController.waitingStatus = taskData.status;
        [self.viewController.navigationController pushViewController:jobController animated:YES];
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
#pragma mark ------------ tableView delegate & dataSource end ------------------


@end
