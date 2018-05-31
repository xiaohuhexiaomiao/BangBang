//
//  SWMySendController.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "NotStartController.h"

#import "CXZ.h"
#import "SWAlipay.h"

#import "NotStarCell.h"

#import "ContractStatusModel.h"

#define padding 10


@interface NotStartController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger page;
}
@property (nonatomic, retain) UITableView *contentView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *contractid;//合同ID

@property (nonatomic, assign)BOOL isDateType;


@end

@implementation NotStartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray array];
    [self initWithView];
   
}

-(void)loadFirstData
{
    page = 1;
    [self.dataSource removeAllObjects];
    [self loadData];
}

-(void)loadMoreData
{
    page ++;
    [self loadData];
}

- (void)loadData
{
    [[NetworkSingletion sharedManager]sendContractList:@{@"identity":@(2),@"type":@(1),@"p":@(page),@"each":@(15)} onSucceed:^(NSDictionary *dict) {
        [_contentView.mj_header endRefreshing];
        [_contentView.mj_footer endRefreshing];
//        NSLog(@"*haha***%@",dict);
        if ([dict[@"code"] integerValue ]== 0) {
            NSArray *array = [ContractStatusModel objectArrayWithKeyValuesArray:dict[@"data"]];
            [self.dataSource addObjectsFromArray:array];
        }
        [self.contentView reloadData];
    } OnError:^(NSString *error) {
        [_contentView.mj_header endRefreshing];
        [_contentView.mj_footer endRefreshing];
        [MBProgressHUD showError:error toView:self.view];
    }];
    
}

- (void)initWithView {
    
    _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - 49 - 49 - 10) style:UITableViewStylePlain];
    _contentView.tableFooterView = [UIView new];
    _contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    _contentView.delegate = self;
    _contentView.dataSource = self;
    [self.view addSubview:_contentView];
    
    __weak typeof(self) weakself = self;
    _contentView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstData];
    }];
    
    
    _contentView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    [_contentView.mj_header beginRefreshing];
    
}

#pragma mark ------------ tableView delegate & dataSource start ------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 8.0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 115.0f;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotStarCell *cell = (NotStarCell*)[tableView  dequeueReusableCellWithIdentifier:@"NotStarCell"];
    if (!cell) {
        cell = [[NotStarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotStarCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count > 0) {
         [cell setNotStarCellWithModel:self.dataSource[indexPath.section]];
    }
   
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataSource.count > 0) {
        ContractStatusModel *statusModel = self.dataSource[indexPath.row];
        
        EditWebViewController *web = [[EditWebViewController alloc]init];
        if (![NSString isBlankString:statusModel.contract_name]) {
            web.titleString = statusModel.contract_name;
        }
        web.editType = 7;
        web.workID = statusModel.worker_id;
        web.form_Type_ID = statusModel.contract_type_id;
        web.contractID = statusModel.contract_id;
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
    
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}



@end
