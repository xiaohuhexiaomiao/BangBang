//
//  DiaryRemindViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/12/8.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "DiaryRemindViewController.h"
#import "CXZ.h"
#import "DiaryListCell.h"

#import "CreatPlanViewController.h"
#import "DiaryDetailViewController.h"
#import "WorkSignViewController.h"
#import "SignDetailViewController.h"

#import "DiaryModel.h"


@interface DiaryRemindViewController ()<UITableViewDelegate,UITableViewDataSource,DiaryListCellDelegate>
{
    NSInteger page;
    NSInteger selectedIndex;
}
@property(nonatomic , strong) UIScrollView *scrollView;

@property(nonatomic , strong) UITableView *firstTabelview;

@property(nonatomic , strong) UITableView *secondTabelview;

@property(nonatomic , strong) UISegmentedControl *segmentBtn;

@property(nonatomic , strong) NSMutableArray *firstArray;

@property(nonatomic , strong) NSMutableArray *secondArray;

@end

@implementation DiaryRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"日志点评" withColor:[UIColor whiteColor]];
     [self removeTapGestureRecognizer];
    [self config];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark 数据

-(void)loadFirstData
{
 
    page = 1;
    [self loadData];
}

-(void)loadMoreData
{
    page ++;
    [self loadData];
}

-(void)loadData
{
    NSDictionary *paramDict = @{
                                @"p":@(page),
                                @"each":@(15),
                                @"type":@(selectedIndex+1)};
    [[NetworkSingletion sharedManager]needReviewList:paramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"list %@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            NSArray *diaryArray = [DiaryModel objectArrayWithKeyValuesArray:dict[@"data"]];
            NSArray *resultArray = [diaryArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                DiaryModel *model1 = (DiaryModel*)obj1;
                DiaryModel *model2 = (DiaryModel*)obj2;
                NSComparisonResult result = [model1.add_time compare:model2.add_time];
                return result == NSOrderedAscending;  // 升序
            }];
           
            switch (selectedIndex) {
                case 0:[self.firstArray addObjectsFromArray:resultArray];
                    
                    break;
                case 1:[self.secondArray addObjectsFromArray:resultArray];break;
                default:
                    break;
            }
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
        switch (selectedIndex) {
            case 0:[self.firstTabelview.mj_header endRefreshing];
                [self.firstTabelview.mj_footer endRefreshing];
                [self.firstTabelview reloadData];
                break;
            case 1:[self.secondTabelview.mj_header endRefreshing];
                [self.secondTabelview.mj_footer endRefreshing];
                [self.secondTabelview reloadData];
                break;
            default:
                break;
        }

    } OnError:^(NSString *error) {
        
    }];

}

#pragma mark PrivateMethod

-(void)config{
    
    CGFloat heheight = 44;
    CGFloat segHeight = heheight+64;
    NSArray *titleArray = @[@"未点评",@"已点评"];
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
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, lineView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-segHeight)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2,SCREEN_HEIGHT-segHeight);
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    _firstTabelview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-segHeight) style:UITableViewStylePlain];
    _firstTabelview.tableFooterView = [UIView new];
    _firstTabelview.delegate = self;
    _firstTabelview.dataSource = self;
    __weak typeof(self) weakself = self;
    _firstTabelview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.firstArray removeAllObjects];
        [weakself loadFirstData];
    }];
    _firstTabelview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    [_firstTabelview.mj_header beginRefreshing];
    [_scrollView addSubview:_firstTabelview];
    
    _secondTabelview = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-segHeight) style:UITableViewStylePlain];
    _secondTabelview.tableFooterView = [UIView new];
    _secondTabelview.delegate = self;
    _secondTabelview.dataSource = self;
    [_scrollView addSubview:_secondTabelview];
    
    _secondTabelview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.secondArray removeAllObjects];
        [weakself loadFirstData];
    }];
    _secondTabelview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    
}

-(void)reloadDataWithIndex:(NSInteger)index
{
    selectedIndex = index;
    switch (index) {
        case 0:
            if (self.firstArray.count==0) {
                
                [self.firstTabelview.mj_header beginRefreshing];
            }else{
                [self.firstTabelview reloadData];
            }
            break;
        case 1:
            if (self.secondArray.count==0) {
                
                [self.secondTabelview.mj_header beginRefreshing];
            }else{
                [self.secondTabelview reloadData];
            }
            break;
        default:
            break;
    }
}


-(void)listChange:(UISegmentedControl*)control
{
    NSInteger index = control.selectedSegmentIndex;
    [self reloadDataWithIndex:index];
    [self.scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH*index, 0, SCREEN_WIDTH, SCREEN_HEIGHT-35) animated:YES];
}





#pragma mark UITableView Delegate & DataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.firstTabelview) {
        return self.firstArray.count;
    }else {
        return self.secondArray.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiaryListCell *cell = (DiaryListCell *)[tableView dequeueReusableCellWithIdentifier:@"DiaryListCell"];
    if (!cell) {
        cell = [[DiaryListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DiaryListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (tableView == _firstTabelview && self.firstArray.count > 0) {
        [cell setDiaryListCellWithModel:self.firstArray[indexPath.row]];
    }
    if (tableView == _secondTabelview && self.secondArray.count > 0) {
        [cell setDiaryListCellWithModel:self.secondArray[indexPath.row]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiaryListCell* cell = (DiaryListCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiaryModel *model ;
    if (tableView == _firstTabelview ) {
        if (self.firstArray.count > 0) {
            model = self.firstArray[indexPath.row];
        }
    }
    if (tableView == _secondTabelview ) {
        if (self.secondArray.count > 0) {
            model = self.secondArray[indexPath.row];
        }
    }
    if (model.form_type == 1) {
        DiaryDetailViewController *detailVC = [[DiaryDetailViewController alloc]init];
        detailVC.publish_id = model.publish_id;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if(model.form_type == 2){
        SignDetailViewController *detailVC = [[SignDetailViewController alloc]init];
        detailVC.publish_id = model.publish_id;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

#pragma mark get/set

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

@end
