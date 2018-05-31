//
//  SWMyEvaluateController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMyEvaluateController.h"

#import "CXZ.h"

#import "SWEvaluateCell.h"
#import "SWEvaluteFrame.h"

#import "SWMyEvaluateCmd.h"
#import "SWMyEvaluateInfo.h"
#import "SWEvaluateData.h"
#import "SWTools.h"

@interface SWMyEvaluateController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSArray *dataSource;

@end

@interface SWMyEvaluateController ()

@end

@implementation SWMyEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBackw];
    
    if (self.is_other_worker) {
        [self setupTitleWithString:@"金主评价" withColor:[UIColor whiteColor]];
    }else{
        [self setupTitleWithString:@"我的评价" withColor:[UIColor whiteColor]];
    }
   
    
    [self initWithView];
    
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
    
    [_tableView.mj_header beginRefreshing];
    
}

- (void)loadData {
    
    if (self.is_other_worker) {
        
        SWMyEvaluateCmd *evaluateCmd = [[SWMyEvaluateCmd alloc] init];
        evaluateCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        
        [[HttpNetwork getInstance] requestPOST:evaluateCmd success:^(BaseRespond *respond) {
            [self.tableView.mj_header endRefreshing];
            NSMutableArray *arr = [NSMutableArray array];
            SWMyEvaluateInfo *evaluateInfo = [[SWMyEvaluateInfo alloc] initWithDictionary:respond.data];
            for (SWEvaluateData *data in evaluateInfo.data) {
                
                SWEvaluteFrame *evaluateFrame = [[SWEvaluteFrame alloc] init];
                evaluateFrame.evaluateData = data;
                [arr addObject:evaluateFrame];
            }
            _dataSource = arr;
            [self.tableView reloadData];
        } failed:^(BaseRespond *respond, NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
            [self.tableView.mj_header endRefreshing];
        }];

    }else{
        SWMyEvaluateCmd *evaluateCmd = [[SWMyEvaluateCmd alloc] init];
        evaluateCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        
        [[HttpNetwork getInstance] requestPOST:evaluateCmd success:^(BaseRespond *respond) {
            
            SWMyEvaluateInfo *evaluateInfo = [[SWMyEvaluateInfo alloc] initWithDictionary:respond.data];
            
            NSMutableArray *arr = [NSMutableArray array];
            
            for (SWEvaluateData *data in evaluateInfo.data) {
                
                SWEvaluteFrame *evaluateFrame = [[SWEvaluteFrame alloc] init];
                evaluateFrame.evaluateData = data;
                [arr addObject:evaluateFrame];
                
            }
            
            _dataSource = arr;
            
            //加载数据
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
            
        } failed:^(BaseRespond *respond, NSString *error) {
            
            [self.tableView.mj_header endRefreshing];
            
        }];

    }
    
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
    
    SWEvaluteFrame *frame = _dataSource[indexPath.section];
    
    return frame.cellH;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    return view;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SWEvaluateCell *cell = [SWEvaluateCell initWithTableViewCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SWEvaluteFrame *frame = _dataSource[indexPath.section];
    
    cell.itemFrame = frame;
    
    SWEvaluateData *data = frame.evaluateData;
    
    [cell showData:data.avatar phone:data.phone time:[SWTools dateFormate:data.add_time formate:@"yyyy-MM-dd HH-mm"] content:data.details state:data.rated_type];
    
    return cell;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
#pragma mark ------------- tableView delegate & dataSource end ---------------------

@end
