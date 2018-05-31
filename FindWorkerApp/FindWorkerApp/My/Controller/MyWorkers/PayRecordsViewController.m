//
//  PayRecordsViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/3/21.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "PayRecordsViewController.h"
#import "CXZ.h"
#import "DatePickerView.h"
#import "JXPopoverView.h"
#import "PayRecordsCell.h"

#import "PayRecordsModel.h"
@interface PayRecordsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSInteger page;
}
@property(nonatomic , strong)UILabel *titleLabel;

@property(nonatomic , strong) UIButton *changeButton;

@property(nonatomic , strong) UITableView *listTableView;

@property(nonatomic, strong)UISearchBar *topsearchbar;

@property(nonatomic , copy) NSString *year;

@property(nonatomic , copy) NSString *month;

@property(nonatomic , strong) NSMutableArray *dataArray;

@property(nonatomic , strong) NSMutableDictionary *paramDictionary;

//@property(nonatomic , assign) NSInteger records_type;//1出账 2入账

@end

@implementation PayRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paramDictionary = [NSMutableDictionary dictionary];
    if (self.phone.length>0) {
        [self.paramDictionary setObject:self.phone forKey:@"phone"];
    }
     [self.paramDictionary setObject:@(1) forKey:@"type"];
//    self.records_type = 1;
    [self setupBackw];
    [self setupTitle];
    [self setupNextWithString:nil];
    self.view.backgroundColor = UIColorFromRGB(235, 234, 241);

    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    _topsearchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 3, SCREEN_WIDTH , 30)];
    _topsearchbar.delegate = self;
    _topsearchbar.placeholder = @"请输入手机号码";
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
            textField.textColor = [UIColor darkGrayColor];
            textField.placeholder = @"请输入手机号码";
            textField.backgroundColor = [UIColor whiteColor];
            
        }
    }
    [searchView addSubview:_topsearchbar];
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,searchView.bottom, SCREEN_WIDTH, self.view.frame.size.height-64-35) style:UITableViewStyleGrouped];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [self.view addSubview:_listTableView];
    __weak typeof(self) weakself = self;
    _listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstPage];
    }];
    _listTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    [_listTableView.mj_header beginRefreshing];
    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Systom Method

-(void)setupTitle
{
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 0, 200, 40)];
    _titleLabel.font  = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [ UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"账单";
    self.navigationItem.titleView = _titleLabel;
}

-(void)setupNextWithString:(NSString *)text
{
    _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeButton.frame = CGRectMake(SCREEN_WIDTH-50, 10, 50, 20);
    [_changeButton setTitle:@"筛选" forState:UIControlStateNormal];
    _changeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_changeButton addTarget:self action:@selector(changeCompany) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_changeButton];
}


#pragma mark Private Method

-(void)changeCompany
{
    JXPopoverView *popoverView = [JXPopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    NSMutableArray *actionArray = [NSMutableArray array];
    JXPopoverAction *action1 = [JXPopoverAction actionWithTitle:@" 年 " handler:^(JXPopoverAction *action) {
        DatePickerView *picker = [[DatePickerView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 200)];
        picker.datePickerType = 1;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择年\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            self.year = [picker.yearString substringToIndex:(picker.yearString.length-1)];
            self.month = nil;
            self.titleLabel.text = [NSString stringWithFormat:@"%@年",self.year];
            [self.paramDictionary setObject:self.year forKey:@"year"];
            [self.paramDictionary removeObjectForKey:@"month"];
            [self loadFirstPage];
        }];
        [alertController.view addSubview:picker];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];

    [actionArray addObject:action1];
    JXPopoverAction *action2 = [JXPopoverAction actionWithTitle:@" 月 " handler:^(JXPopoverAction *action) {
        DatePickerView *picker = [[DatePickerView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 200)];
        picker.datePickerType = 0;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择月份\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            self.year = [picker.yearString substringToIndex:(picker.yearString.length-1)];
            self.month = [picker.monthString substringToIndex:(picker.monthString.length-1)];
            self.titleLabel.text = [NSString stringWithFormat:@"%@年%@月",self.year,self.month];
            [self.paramDictionary setObject:self.year forKey:@"year"];
             [self.paramDictionary setObject:self.month forKey:@"month"];
            [self loadFirstPage];
        }];
        [alertController.view addSubview:picker];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    [actionArray addObject:action2];
    
    JXPopoverAction *action3 = [JXPopoverAction actionWithTitle:@" 出账 " handler:^(JXPopoverAction *action) {
//        self.records_type = 1;
        [self.paramDictionary setObject:@(1) forKey:@"type"];
        [self loadFirstPage];
    }];
    [actionArray addObject:action3];
    JXPopoverAction *action4 = [JXPopoverAction actionWithTitle:@" 入账 " handler:^(JXPopoverAction *action) {
//        self.records_type = 2;
        [self.paramDictionary setObject:@(2) forKey:@"type"];
        [self loadFirstPage];
    }];
    [actionArray addObject:action4];
    [popoverView showToView:self.changeButton withActions:actionArray];
}

-(void)loadFirstPage
{
    page = 1;
    [self.dataArray removeAllObjects];
    [self loadData];
}
-(void)loadMoreData
{
    page++;
    [self loadData];
}

-(void)loadData
{
    
    [self.paramDictionary setObject:@(page) forKey:@"p"];
    [self.paramDictionary setObject:@(15) forKey:@"each"];
//     NSLog(@"***%@",self.paramDictionary);
    [[NetworkSingletion sharedManager]searchPayRecords:self.paramDictionary onSucceed:^(NSDictionary *dict) {
        NSLog(@"***%@",dict);
        [self.listTableView.mj_footer endRefreshing];
        [self.listTableView.mj_header endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            NSArray *array = [PayRecordsModel objectArrayWithKeyValuesArray:dict[@"data"]];
            [self.dataArray addObjectsFromArray:array];
        }
        [self.listTableView reloadData];
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}


#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if(searchBar.text.length>0) {
        [self.paramDictionary setObject:searchBar.text forKey:@"phone"];
        [self loadFirstPage];
    }
}

#pragma  mark UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayRecordsCell *cell = (PayRecordsCell*)[tableView dequeueReusableCellWithIdentifier:@"PayRecordsCell"];
    if (!cell) {
        cell = [[PayRecordsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PayRecordsCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count > 0) {
        [cell setPayRecordsWithModel:self.dataArray[indexPath.section]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayRecordsCell *cell = (PayRecordsCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 15, SCREEN_WIDTH-16, 15)];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:12];
    if (self.dataArray.count > 0) {
        PayRecordsModel *model = self.dataArray[section];
        label.text = model.add_time;
    }
    label.textColor = [UIColor grayColor];
    return label;
}

#pragma mark get/set

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



@end
