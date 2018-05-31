//
//  SWRepeatController.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/19.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWRepeatController.h"

#import "CXZ.h"

#import "SWMyTaskCmd.h"
#import "SWMyTaskInfo.h"
#import "SWMyTaskData.h"
#import "SWTools.h"

#import "SWWaitingCell.h"

#import "SWJobDetailController.h"

@interface SWRepeatController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UITableView *contentView;

@property (nonatomic, retain) NSArray *dataSource;

@end

@implementation SWRepeatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initWithView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"UPDATE_REPEAT" object:nil];
    
}

- (void)updateData {
    
    [_contentView.mj_header beginRefreshing];
    
}

/**
 初始化界面
 */
- (void)initWithView {

    _contentView = [[UITableView alloc] init];
    _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    _contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    _contentView.tableFooterView = [UIView new];
    _contentView.delegate = self;
    _contentView.dataSource = self;
    [self.view addSubview:_contentView];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        [self loadData];
        
    }];
    
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    
    _contentView.mj_header = header;
    
    [_contentView.mj_header beginRefreshing];
    
}


/**
 加载数据
 */
- (void)loadData {
    
    SWMyTaskCmd *taskCmd = [[SWMyTaskCmd alloc] init];
    taskCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    taskCmd.build_status = 1;
    
    [[HttpNetwork getInstance] requestPOST:taskCmd success:^(BaseRespond *respond) {
        
        SWMyTaskInfo *taskInfo = [[SWMyTaskInfo alloc] initWithDictionary:respond.data];
        
        _dataSource = taskInfo.data;
        
        [_contentView reloadData];
        
        [_contentView.mj_header endRefreshing];
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        [_contentView.mj_header endRefreshing];
        
        [MBProgressHUD showError:@"加载数据失败" toView:self.view];
        
    }];
    
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
    
    SWWaitingCell *waitingCell = [SWWaitingCell initWithTableViewCell:tableView];
    
    SWMyTaskData *taskData = _dataSource[indexPath.section];
    
    [waitingCell showData:[SWTools dateFormate:taskData.add_time formate:@"yyyy-MM-dd"] content:taskData.title data:taskData];
    
    return waitingCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataSource.count > 0) {
        SWJobDetailController *jobDetailController = [[SWJobDetailController alloc] init];
        SWMyTaskData *taskData = _dataSource[indexPath.section];
        jobDetailController.iid = taskData.information_id;
        jobDetailController.type = 1;
        jobDetailController.eid = taskData.eid;
        jobDetailController.detailTitle = taskData.title;
        [self.navigationController pushViewController:jobDetailController animated:YES];
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
#pragma mark ------------ tableView delegate & dataSource end ------------------




@end
