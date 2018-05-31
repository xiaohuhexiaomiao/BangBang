//
//  WorkerListViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/10/16.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "WorkerListViewController.h"
#import "CXZ.h"
#import "DepartmentTableViewCell.h"

@interface WorkerListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,DepartmentCellDelegate>
{
    NSInteger page;
    BOOL is_search;
}
@property(nonatomic , strong)UITableView *adressTableview;

@property(nonatomic,strong)UISearchBar *topsearchbar;

@property(nonatomic , strong)NSMutableArray *indextArray;

@property(nonatomic , strong)NSMutableArray *selectedArray;

@property(nonatomic , copy)NSString *keyWords;

@end

@implementation WorkerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setupBackw];
    [self setupTitle];
    if (self.is_search) {
        [self setupNextWithString:@"搜索" withColor:[UIColor whiteColor]];
    }else{
        [self setupNextWithString:@"确定" withColor:[UIColor whiteColor]];
    }
    
    _adressTableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-60) style:UITableViewStyleGrouped];
    _adressTableview.delegate = self;
    _adressTableview.dataSource = self;
    [self.view addSubview:_adressTableview];
    
    _adressTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadFirstPageData];
    }];
    _adressTableview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    [_adressTableview.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark Private Method

-(void)setupTitle
{
    _topsearchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 150, 30)];
    _topsearchbar.delegate = self;
    _topsearchbar.placeholder = @"请输入电话号码或姓名";
    for (UIView *sv in _topsearchbar.subviews)
    {
        if ([sv isKindOfClass:NSClassFromString(@"UIView")] && sv.subviews.count > 0)
        {
            [sv.subviews.firstObject removeFromSuperview];
            UITextField *textField = sv.subviews.lastObject;
            textField.layer.borderColor = TOP_GREEN.CGColor;
            textField.layer.borderWidth = 0.5;
            textField.layer.masksToBounds = YES;
            textField.layer.cornerRadius = 15;
            textField.font = [UIFont systemFontOfSize:12];
            textField.textColor = [UIColor whiteColor];
            UIColor *color = [UIColor whiteColor];
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入电话号码或姓名" attributes:@{NSForegroundColorAttributeName: color}];
            //            textField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbg"]];
            textField.backgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
            
        }
    }
    self.navigationItem.titleView = _topsearchbar;
    self.navigationItem.titleView.width = SCREEN_WIDTH-150;
    
}

-(void)onNext
{
    if (self.is_search) {
        is_search = YES;
        self.keyWords = _topsearchbar.text;
        [self loadFirstPageData];
    }else{
        [self.delegate didSelsectWorker:self.selectedArray];
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}

#pragma mark Load data

-(void)loadFirstPageData
{
    page = 1;
    [self.indextArray removeAllObjects];
    if (is_search) {
        [self loadSearchDataWithKeyWords];
    }else{
       [self loadData];
    }
    
}

-(void)loadMoreData
{
    page ++;
    if (is_search) {
        [self loadSearchDataWithKeyWords];
    }else{
        [self loadData];
    }
}

-(void)loadData
{
    NSDictionary  *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                 @"p":@(page),
                                 @"each":@(15)
                                 };
    [[NetworkSingletion sharedManager]getAllWorkerList:paramDict onSucceed:^(NSDictionary *dict) {
        [self.adressTableview.mj_header endRefreshing];
        [self.adressTableview.mj_footer endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            
            [self.indextArray addObjectsFromArray:[dict[@"data"] objectForKey:@"nworker"]];
            [self.adressTableview reloadData];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}

-(void)loadSearchDataWithKeyWords
{
    if ([NSString isBlankString:self.keyWords]) {
        [MBProgressHUD showError:@"请输入姓名或联系电话" toView:self.view];
        return;
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *paramDict = @{@"uid":uid,@"keyword":self.keyWords,@"p":@(page),@"each":@(15)};
    [[NetworkSingletion sharedManager]searchWorkers:paramDict onSucceed:^(NSDictionary *dict) {
//                        NSLog(@"***%@",dict);
        if ([dict[@"code"] integerValue]==0) {
//            NSArray *array = [PersonelModel objectArrayWithKeyValuesArray:dict[@"data"]];
            [self.indextArray addObjectsFromArray:dict[@"data"]];
            [self.adressTableview reloadData];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self.navigationController.view];
        }
    } OnError:^(NSString *error) {
        [WFHudView showMsg:error inView:self.navigationController.view];
    }];

}

#pragma mark Cell Delegate

-(void)clickSeleteButton:(BOOL)isSeleted tag:(NSInteger)tag
{
    
     PersonelModel *person = self.indextArray[tag];
    if (isSeleted) {
        [self.selectedArray addObject:person];
    }else{
        [self.selectedArray removeObject:person];
    }
    
}

#pragma mark SearchDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    is_search = YES;
    self.keyWords = searchBar.text;
    [self.topsearchbar resignFirstResponder];
    [self loadFirstPageData];
}

#pragma mark UITabelview Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.indextArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DepartmentTableViewCell *cell = (DepartmentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"DepartmentCell"];
    if (!cell) {
        cell = [[DepartmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DepartmentCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row+indexPath.section*1000;
    cell.delegate = self;
   
    if (self.indextArray.count > 0) {
        
         PersonelModel *person = [PersonelModel objectWithKeyValues:self.indextArray[indexPath.row]];
        [cell setSelectDeparmentCellWith:person];
        [cell.selectBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        cell.selectBtn.userInteractionEnabled = YES;
        if (self.alreadySelectedArray.count > 0) {
            for (NSDictionary *tempDict in self.alreadySelectedArray) {
                if ([tempDict[@"uid"] isEqualToString:person.uid]) {
                    [cell.selectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
                    cell.selectBtn.userInteractionEnabled = NO;
                    break;
                }
            }

        }
        if (is_search && self.selectedArray.count > 0) {
            for (NSDictionary *tempDict in self.selectedArray) {
                if ([tempDict[@"uid"] isEqualToString:person.uid]) {
                    [cell.selectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
                    break;
                }
            }
        }
        if (self.is_single) {
            cell.selectBtn.hidden = YES;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.is_single) {
        if (self.indextArray.count > 0) {
            [self.delegate didSelsectOneWorker:self.indextArray[indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     return 10.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark get/set

-(NSMutableArray*)indextArray
{
    if (!_indextArray) {
        _indextArray = [NSMutableArray array];
    }
    return _indextArray;
}

-(NSMutableArray*)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}



@end
