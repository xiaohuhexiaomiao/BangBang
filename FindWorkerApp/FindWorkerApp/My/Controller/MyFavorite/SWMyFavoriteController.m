//
//  SWMyFavoriteController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMyFavoriteController.h"

#import "CXZ.h"

#import "SWFavoriteCell.h"

#import "SWFavoriteCmd.h"
#import "SWMyFavoriteInfo.h"
#import "SWMyFavoriteData.h"
#import "SWMyFavoriteWorker.h"

#import "SWWorkerDetailController.h"

@interface SWMyFavoriteController ()<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic, retain) NSArray *dataSource;

@end

@implementation SWMyFavoriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBackw];
    
    [self setupTitleWithString:@"我的收藏" withColor:[UIColor whiteColor]];
    
    [self initWithView];
    
    
    [self loadData];

}

- (void)loadData {
    
    SWFavoriteCmd *favoriteCmd = [[SWFavoriteCmd alloc] init];
    favoriteCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    [[HttpNetwork getInstance] requestPOST:favoriteCmd success:^(BaseRespond *respond) {
        
        SWMyFavoriteInfo *favoriteInfo = [[SWMyFavoriteInfo alloc] initWithDictionary:respond.data];
        
        _dataSource = favoriteInfo.data;
        
        //加载数据
        [self.tableView reloadData];

        [_tableView.mj_header endRefreshing];
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        [MBProgressHUD showError:@"加载数据失败" toView:self.view];
        [_tableView.mj_header endRefreshing];
        
    }];
    
    
}

- (void)initWithView {
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame        = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    tableView.delegate     = self;
    tableView.dataSource   = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    tableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        [self loadData];
        
    }];
    
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    
    _tableView.mj_header = header;
    
}

#pragma mark ------------- tableView delegate & dataSource start ---------------------

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
    
    return 55.0f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    return view;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SWFavoriteCell *cell = [SWFavoriteCell initWithTableViewCell:tableView];
    
    SWMyFavoriteData *favoriteData = _dataSource[indexPath.section];
    
    SWMyFavoriteWorker *favoriteWorker = favoriteData.worker;
    
    cell.favoriteWorker = favoriteWorker;
    
    [cell showData:favoriteWorker.avatar name:favoriteWorker.name jobs:favoriteWorker.type];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataSource.count > 0) {
        SWMyFavoriteData *favoriteData = _dataSource[indexPath.section];
        
        SWMyFavoriteWorker *favoriteWorker = favoriteData.worker;
        
        SWWorkerDetailController *detailController = [[SWWorkerDetailController alloc] init];
        detailController.uid = favoriteWorker.uid;
        detailController.workerName = favoriteWorker.name;
        detailController.is_detail = NO;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}



#pragma mark ------------- tableView delegate & dataSource end ---------------------


@end
