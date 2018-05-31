//
//  SWDepositHistoryController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWDepositHistoryController.h"

#import "CXZ.h"

#import "SWDepositCell.h"

#import "SWWithDrawCmd.h"
#import "SWWithDrawInfoHistory.h"
#import "SWWithDrawData.h"

@interface SWDepositHistoryController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) NSArray *dataSource;

@property (nonatomic, retain) UITableView *tableView;

@end

@implementation SWDepositHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBackw];
    
    [self setupTitleWithString:@"提现记录" withColor:[UIColor whiteColor]];
    
    [self initWithView];
    
}

- (void)loadData {

    SWWithDrawCmd *withDraw = [[SWWithDrawCmd alloc] init];
    withDraw.user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    [[HttpNetwork getInstance] requestPOST:withDraw success:^(BaseRespond *respond) {
        
        SWWithDrawInfoHistory *withDrawInfo = [[SWWithDrawInfoHistory alloc] initWithDictionary:respond.data];
        
        _dataSource = withDrawInfo.data;
        
        [_tableView reloadData];
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        
        
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
    
    [self loadData];
    
}

#pragma mark ------------- tableView delegate & dataSource start ---------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
    
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
    
    SWDepositCell *cell = [SWDepositCell initWithTableViewCell:tableView];
    
    SWWithDrawData *data = _dataSource[indexPath.section];
    
    [cell showData:data.time money:data.money state:data.money_status];
    
    return cell;
    
}

#pragma mark ------------- tableView delegate & dataSource end ---------------------


@end
