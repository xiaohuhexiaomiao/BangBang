//
//  PersonApprovalViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/5/7.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "PersonApprovalViewController.h"
#import "CXZ.h"

#import "SWSearchWorkerViewController.h"
#import "CompanyReviewViewController.h"
#import "ShowPaymentsViewController.h"
#import "StampViewController.h"
#import "ShowFileViewController.h"
#import "ShowPurchaseViewController.h"
#import "ShowCompanyViewController.h"
#import "ShowExpenseAccountViewController.h"
#import "ShowStampViewController.h"

#import "ApprovalTableViewCell.h"
#import "SponsorTableViewCell.h"
#import "ReviewListModel.h"


@interface PersonApprovalViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SponsorTableViewCellDelegate>
{
    NSInteger page;
    NSInteger selectedIndex;
}
@property(nonatomic ,strong) UIScrollView *scrollview;

@property(nonatomic ,strong) UITableView *firstTableview;

@property(nonatomic ,strong) UITableView *sencondTableview;

@property(nonatomic ,strong) UITableView *thirdTableview;

@property(nonatomic ,strong) UISegmentedControl *segmentBtn;

@property(nonatomic ,strong) NSMutableArray *firstArray;

@property(nonatomic ,strong) NSMutableArray *secondArray;

@property(nonatomic ,strong) NSMutableArray *thirdArray;


@end

@implementation PersonApprovalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"审批处理" withColor:[UIColor whiteColor]];
    [self setupNextWithImage:[UIImage imageNamed:@"search"]];
    [self config];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadNewData) name:@"UPLOAD_PERSONAL_NEW_DATA" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark public Method



#pragma mark Private Method

-(void)loadNewData
{
    [self.firstArray removeAllObjects];
    [self.firstTableview.mj_header beginRefreshing];
}

-(void)onNext
{
    SWSearchWorkerViewController *searchVC = [SWSearchWorkerViewController new];
    searchVC.searchType = searchPesonApprovalType;
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    self.hidesBottomBarWhenPushed =  YES;
}

-(void)config{
    
    CGFloat heheight = 50;
    CGFloat segHeight = heheight+64;
    NSArray *titleArray = @[@"未处理",@"已处理",@"我发起的"];
    _segmentBtn = [[UISegmentedControl alloc]initWithItems:titleArray];
    _segmentBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, heheight-1);
    _segmentBtn.selectedSegmentIndex = 0;
    selectedIndex = 0;
    [_segmentBtn setTintColor:[UIColor whiteColor]];
    _segmentBtn.backgroundColor  = [UIColor clearColor];
    [_segmentBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [_segmentBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:TOP_GREEN} forState:UIControlStateSelected];
    [_segmentBtn addTarget:self action:@selector(listChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _segmentBtn.bottom, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = UIColorFromRGB(224, 223, 226);
    [self.view addSubview:lineView];
    
    _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, lineView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-segHeight)];
    _scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*3,SCREEN_HEIGHT-segHeight);
    _scrollview.delegate = self;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.pagingEnabled = YES;
    [self.view addSubview:_scrollview];
    
    _firstTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-segHeight) style:UITableViewStylePlain];
    _firstTableview.tableFooterView = [UIView new];
    _firstTableview.delegate = self;
    _firstTableview.dataSource = self;
    __weak typeof(self) weakself = self;
    _firstTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.firstArray removeAllObjects];
        [weakself loadFirstData];
    }];
    _firstTableview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    [_firstTableview.mj_header beginRefreshing];
    [_scrollview addSubview:_firstTableview];
    
    _sencondTableview = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-segHeight) style:UITableViewStylePlain];
    _sencondTableview.tableFooterView = [UIView new];
    _sencondTableview.delegate = self;
    _sencondTableview.dataSource = self;
    [_scrollview addSubview:_sencondTableview];
    
    _sencondTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.secondArray removeAllObjects];
        [weakself loadFirstData];
    }];
    _sencondTableview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    
    
    _thirdTableview = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-segHeight) style:UITableViewStylePlain];
    _thirdTableview.tableFooterView = [UIView new];
    _thirdTableview.delegate = self;
    _thirdTableview.dataSource = self;
    [_scrollview addSubview:_thirdTableview];
    _thirdTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.thirdArray removeAllObjects];
        [weakself loadFirstData];
    }];
    _thirdTableview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    
}

-(void)listChange:(UISegmentedControl*)control
{
    NSInteger index = control.selectedSegmentIndex;
    [self reloadDataWithIndex:index];
    [_scrollview scrollRectToVisible:CGRectMake(SCREEN_WIDTH*index, 0, SCREEN_WIDTH, SCREEN_HEIGHT-35) animated:YES];
}

-(void)reloadDataWithIndex:(NSInteger)index
{
    selectedIndex = index;
    switch (index) {
        case 0:
            if (self.firstArray.count==0) {
                
                [self.firstTableview.mj_header beginRefreshing];
            }else{
                [self.firstTableview reloadData];
            }
            break;
        case 1:
            if (self.secondArray.count==0) {
                
                [self.sencondTableview.mj_header beginRefreshing];
            }else{
                [self.sencondTableview reloadData];
            }
            break;
        case 2:
            if (self.thirdArray.count==0) {
                
                [self.thirdTableview.mj_header beginRefreshing];
            }else{
                [self.thirdTableview reloadData];
            }
            
        default:
            break;
    }
}

-(void)loadFirstData
{
    page = 1;
    [self loadData];
}

-(void)loadMoreData
{
    page ++;
    //    NSLog(@"***%li",page);
    [self loadData];
}

-(void)loadData
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"type":@(selectedIndex+1),
                                @"p":@(page),
                                @"each":@"10"};
    [[NetworkSingletion sharedManager]getPersonalApprovalList:paramDict onSucceed:^(NSDictionary *dict) {
        
//                NSLog(@"list %@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            
            NSArray *array = [ReviewListModel objectArrayWithKeyValuesArray:dict[@"data"]];
            switch (selectedIndex) {
                case 0:[self.firstArray addObjectsFromArray:array];
                    
                    break;
                case 1:[self.secondArray addObjectsFromArray:array];break;
                case 2:[self.thirdArray addObjectsFromArray:array];break;
                default:
                    break;
            }
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
        switch (selectedIndex) {
            case 0:[self.firstTableview.mj_header endRefreshing];
                [self.firstTableview.mj_footer endRefreshing];
                [self.firstTableview reloadData];
                break;
            case 1:[self.sencondTableview.mj_header endRefreshing];
                [self.sencondTableview.mj_footer endRefreshing];
                [self.sencondTableview reloadData];
                break;
            case 2:[self.thirdTableview.mj_header endRefreshing];
                [self.thirdTableview.mj_footer endRefreshing];
                [self.thirdTableview reloadData];
                break;
            default:
                break;
        }
        
    } OnError:^(NSString *error) {
//        [MBProgressHUD showError:error toView:self.view];
    }];
    
}
#pragma mark SponsorTableViewCell Delegate

-(void)clickSeeDetail:(NSInteger)index
{
    ReviewListModel *model = self.thirdArray[index];
    
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"approval_personal_id":model.approval_id,
                               };
    [[NetworkSingletion sharedManager]deletePersonalApproval:paramDict onSucceed:^(NSDictionary *dict) {
        //        NSLog(@"*%@**%@",dict,dict[@"message"]);
        if ([dict[@"code"] integerValue]==0) {
            [self.thirdArray removeObject:model];
            [self.thirdTableview reloadData];
        }
    } OnError:^(NSString *error) {
        
    }];
}
#pragma mark UITableview Delegate & Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.firstTableview) {
        return self.firstArray.count;
    }else if (tableView == self.sencondTableview){
        return self.secondArray.count;
    }else{
        return self.thirdArray.count;
    }
    //    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.thirdTableview) {
        SponsorTableViewCell *cell = (SponsorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"SponsorCell"];
        if (!cell) {
            cell = [[SponsorTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SponsorCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.tag = indexPath.row;
        if (self.thirdArray.count >0) {
            [cell setPersonalSponsorCellWith:self.thirdArray[indexPath.row]];
        }
        return cell;
    }
    ApprovalTableViewCell *cell = (ApprovalTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ApprovalCell"];
    if (!cell) {
        cell = [[ApprovalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApprovalCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.is_More = NO;
    cell.formType = 1;
    if (tableView == _firstTableview) {
        if (self.firstArray.count>0) {
            [cell setApprovalCellWith:self.firstArray[indexPath.row]];
        }
    }else{
        if (self.secondArray.count > 0) {
            [cell setSearchApprovalCellWith:self.secondArray[indexPath.row]];
        }
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _sencondTableview) {
        ApprovalTableViewCell *cell = (ApprovalTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    if (tableView == _thirdTableview) {
        SponsorTableViewCell *cell = (SponsorTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    
    return 100.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewListModel *listModel ;
//    CompanyReviewViewController *reviewVC = [[CompanyReviewViewController alloc]init];
    ShowPaymentsViewController *payVC = [[ShowPaymentsViewController alloc]init];
    ShowPurchaseViewController *purchaseVC = [[ShowPurchaseViewController alloc]init];
//    ShowStampViewController *stampVC = [[ShowStampViewController alloc]init];
    ShowFileViewController *fileVC = [[ShowFileViewController alloc]init];
//    ShowCompanyViewController *companyVC = [[ShowCompanyViewController alloc]init];
    ShowExpenseAccountViewController *expenseAccountVC = [[ShowExpenseAccountViewController alloc]init];
    purchaseVC.form_type = 1;
     payVC.form_type = 1;
    fileVC.form_type = 1;
    expenseAccountVC.form_type = 1;
    if (tableView == self.firstTableview) {
        if (self.firstArray.count > 0) {
            listModel = self.firstArray[indexPath.row];
        }
        payVC.is_aready_approval = NO;
        purchaseVC.is_aready_approval = NO;
        fileVC.is_aready_approval = NO;
        expenseAccountVC.is_aready_approval = NO;
        
        payVC.is_reply = YES;
        purchaseVC.is_reply = YES;
        fileVC.is_reply = YES;
        expenseAccountVC.is_reply = YES;
        
    }else if (tableView == self.sencondTableview){
        if (self.secondArray.count >0) {
            listModel = self.secondArray[indexPath.row];
            if (listModel.approval_state == 0) {
                payVC.is_reply = YES;
                purchaseVC.is_reply = YES;
                fileVC.is_reply = YES;
                expenseAccountVC.is_reply = YES;
            }
        }
        payVC.is_aready_approval = YES;
        purchaseVC.is_aready_approval = YES;
        fileVC.is_aready_approval = YES;
        expenseAccountVC.is_aready_approval = YES;
    }else{
        if (self.thirdArray.count > 0) {
            listModel = self.thirdArray[indexPath.row];
        }
        payVC.is_aready_approval = YES;
        payVC.is_cancel = NO;
       
        
        purchaseVC.is_aready_approval = YES;
        purchaseVC.is_cancel = NO;
        
        
        fileVC.is_aready_approval = YES;
        fileVC.is_cancel = NO;
        
        
        expenseAccountVC.is_aready_approval = YES;
        expenseAccountVC.is_cancel = NO;
        
    }
    if (listModel) {
        if (listModel.type == 2){
            payVC.approvalID = listModel.approval_personal_id;

            [self.navigationController pushViewController:payVC animated:YES];
        }else if (listModel.type == 1){
            purchaseVC.approvalID = listModel.approval_personal_id;
     
            [self.navigationController pushViewController:purchaseVC animated:YES];
        }else if (listModel.type == 3){
            fileVC.approvalID = listModel.approval_personal_id;
           
            [self.navigationController pushViewController:fileVC animated:YES];
        }else if (listModel.type == 4){
            expenseAccountVC.approvalID = listModel.approval_personal_id;
            [self.navigationController pushViewController:expenseAccountVC animated:YES];
        }
    }
    
    
}

#pragma mark UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollview]) {
        NSInteger index = (scrollView.contentOffset.x)/SCREEN_WIDTH;
        _segmentBtn.selectedSegmentIndex = index;
        
    }
}

# pragma mark get/set

-(NSMutableArray*)firstArray
{
    if (!_firstArray) {
        _firstArray = [NSMutableArray array];
    }
    return _firstArray;
}

-(NSMutableArray*)secondArray
{
    if (!_secondArray) {
        _secondArray = [NSMutableArray array];
    }
    return _secondArray;
}

-(NSMutableArray*)thirdArray
{
    if (!_thirdArray) {
        _thirdArray = [NSMutableArray array];
    }
    return _thirdArray;
}


@end
