//
//  SWFindJobsController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/17.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWFindJobsController.h"

#import "SWChooseJobView.h"

#import "CXZ.h"

#import "SWFindJobCell.h"

#import "SWJobDetailController.h"

#import "SWFindWorkCmd.h"
#import "SWFindWorkInfo.h"
#import "SWFindWorkData.h"
#import "SWFindWorkType.h"

#import "SWCompleteInfoController.h"
#import "SWSearchWorkerViewController.h"
#import "SWPublishController.h"
#import "ToolCollectionCell.h"

#define padding 10

@interface SWFindJobsController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) NSMutableArray *workArr; //工作的数组

@property (nonatomic, retain) NSString *select_workerId; //选中工人的id

@property (nonatomic ,retain) UITableView *tableView;

@property (nonatomic, retain) NSString *select_wid; //筛选的工人类型id

@property (nonatomic, retain) NSString *select_order; //筛选的排序

@property (nonatomic, retain) NSMutableArray *locationArr; //工人的位置

//@property (nonatomic , weak) UICollectionView *TitleCollectionView;//
//
//@property (nonatomic , strong) UICollectionView *topCollectionView;// 顶部CollectionView

@property (nonatomic , strong) NSArray *workerTypeArray;

@end

@implementation SWFindJobsController
{

    SWChooseJobView *_chooseView;
    NSInteger page;
}

#pragma mark ------------- controller 生命周期 start --------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBackw];
    _locationArr = [NSMutableArray array];
    _workArr = [NSMutableArray array];
    [self setupTitleWithString:@"工程" withColor:[UIColor whiteColor]];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    //    tableView.frame        = CGRectMake(0, CGRectGetMaxY(chooseView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(chooseView.frame) - 64 - 49);
    tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.tableFooterView = [UIView new];
    ;
    _tableView = tableView;
    
    __weak typeof(self) weakself = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadJobData];
    }];
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    [_tableView.mj_header beginRefreshing];
    [self.tableView.mj_header beginRefreshing];
    
}


#pragma mark 数据相关
- (void)loadJobData {
    
    page = 1;
    [self.workArr removeAllObjects];
    [self loadData];
}

-(void)loadMoreData
{
    page++;
    [self loadData];
}

-(void)loadData{
    if (self.isCompany) {
        SWFindWorkCmd *workCmd = [[SWFindWorkCmd alloc] init];
        workCmd.order = _select_order;
        workCmd.wid = _select_wid;
        workCmd.each = @"10";
        workCmd.p = page;
        workCmd.company_id = self.companyid;
        [[HttpNetwork getInstance] requestPOST:workCmd success:^(BaseRespond *respond) {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            if (respond.code == 0) {
                SWFindWorkInfo *workInfo = [[SWFindWorkInfo alloc] initWithDictionary:respond.data];
                [self.workArr addObjectsFromArray: workInfo.data];
            }else{
                [MBProgressHUD showError:respond.message toView:self.view];
            }
            
        } failed:^(BaseRespond *respond, NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }];
    }else{
        NSDictionary *dict = @{@"p":@(page),@"each":@"15"};
        [[NetworkSingletion sharedManager]nearbyPersonalProject:dict onSucceed:^(NSDictionary *dict) {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            if ([dict[@"code"] integerValue]==0) {
                NSArray *array = [SWFindWorkData objectArrayWithKeyValuesArray:dict[@"data"]];
                [self.workArr addObjectsFromArray: array];
            }
        } OnError:^(NSString *error) {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }];
    }
   
}



#pragma mark ---------- tableView代理方法 start ------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.workArr.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SWFindJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    if(!cell) {
    
        cell = [[SWFindJobCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        
    }
    if (self.workArr.count > 0) {
        
        SWFindWorkData *data = self.workArr[indexPath.section];
        NSArray *types = data.worker;
        
        NSMutableString *typeStr = [NSMutableString stringWithFormat:@"需要"];
        
        int j = 0;
        
        for (SWFindWorkType *workType in types) {
            
            if(j == types.count - 1) {
                
                if (![NSString isBlankString:workType.type]) {
                    [typeStr appendString:workType.type];
                }
                
            }else {
                if (![NSString isBlankString:workType.type]) {
                    [typeStr appendString:[NSString stringWithFormat:@"%@,",workType.type]];
                }
            }
            
            j++;
        }
        
        if(data.isface) {
            
            [cell showData:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,data.avatar] name:data.name money:@"面议" job:typeStr time:data.add_time];
            
        }else {
            
            [cell showData:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,data.avatar] name:data.name money:data.budget job:typeStr time:data.add_time];
            
        }
    }
 
    
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.workArr) {
        SWFindWorkData *data = _workArr[indexPath.section];
        SWJobDetailController *jobController = [[SWJobDetailController alloc] init];
        jobController.hidesBottomBarWhenPushed = YES;
        jobController.iid = data.iid;
        jobController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jobController animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55.0f;
    
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
