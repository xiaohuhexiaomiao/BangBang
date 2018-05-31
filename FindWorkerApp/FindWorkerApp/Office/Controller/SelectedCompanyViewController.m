//
//  SelectedCompanyViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/1.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SelectedCompanyViewController.h"
#import "CXZ.h"

#import "JXPopoverView.h"
#import "CompanyInfoCell.h"
#import "CompanyInfoModel.h"

@interface SelectedCompanyViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSInteger page;
    BOOL is_search;
}
@property(nonatomic ,strong)UITableView *companyTableview;

@property(nonatomic ,strong)UIWindow *bgWindow;

@property(nonatomic ,strong)UITextField *nameTxt;

@property(nonatomic ,strong)NSMutableArray *dataArray;

@property(nonatomic ,strong)CompanyInfoModel *companyModel;

@property(nonatomic ,copy)NSString *keyWords;


@end

@implementation SelectedCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackw];
    [self setupTitle];
    
    _companyTableview  = [[UITableView alloc]init];
    _companyTableview.delegate = self;
    _companyTableview.dataSource = self;
    _companyTableview.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_companyTableview];
    [_companyTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.mas_equalTo(0);
    }];
    __weak typeof(self) weakself = self;
    _companyTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadNewData];
    }];
    _companyTableview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    [_companyTableview.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void) setupTitle
{
    UISearchBar *topsearchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 150, 30)];
    topsearchbar.delegate = self;
    topsearchbar.placeholder = @"请输入公司名称";
    for (UIView *sv in topsearchbar.subviews)
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
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入公司名称" attributes:@{NSForegroundColorAttributeName: color}];
            //            textField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbg"]];
            textField.backgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
            //            textField.leftView = [UIView new];
        }
    }
    ;
    self.navigationItem.titleView = topsearchbar;
    self.navigationItem.titleView.width = SCREEN_WIDTH-150;
    
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    is_search = YES;
    self.keyWords = searchBar.text;
    [self loadNewData];
}

#pragma mark 数据相关
-(void)loadNewData
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
    if (is_search) {
        NSDictionary *dict = @{@"company_name":self.keyWords,@"p":@(page),@"each":@(15)};
        [[NetworkSingletion sharedManager]searchCompany:dict onSucceed:^(NSDictionary *dict) {
            //        NSLog(@"**all Company***%@",dict);
            [self.companyTableview.mj_header endRefreshing];
            [self.companyTableview.mj_footer endRefreshing];
            if ([dict[@"code"]integerValue]==0) {
                NSArray *array = dict[@"data"];
                if (array.count > 0) {
                    NSArray *modelArray = [CompanyInfoModel objectArrayWithKeyValuesArray:dict[@"data"]];
                    [self.dataArray addObjectsFromArray:modelArray];
                }
                [self.companyTableview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }else{
        NSDictionary *dict = @{@"p":@(page),@"each":@(15)};
        [[NetworkSingletion sharedManager]getAllCompanyList:dict onSucceed:^(NSDictionary *dict) {
            //        NSLog(@"**all Company***%@",dict);
            [self.companyTableview.mj_header endRefreshing];
            [self.companyTableview.mj_footer endRefreshing];
            if ([dict[@"code"]integerValue]==0) {
                NSArray *array = dict[@"data"];
                if (array.count > 0) {
                    NSArray *modelArray = [CompanyInfoModel objectArrayWithKeyValuesArray:dict[@"data"]];
                    [self.dataArray addObjectsFromArray:modelArray];
                }
                [self.companyTableview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }
   
}

#pragma mark UITableView Delegate & DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyInfoCell *infoCell = (CompanyInfoCell*)[tableView dequeueReusableCellWithIdentifier:@"CompanyInfoCell"];
    if (!infoCell) {
        infoCell = [[CompanyInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CompanyInfoCell"];
    }
    infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count > 0) {
        [infoCell setCompanyInfoCellWithModel:self.dataArray[indexPath.row]];
    }
    
    return infoCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyInfoCell *cell = (CompanyInfoCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.infoCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        self.companyModel = self.dataArray[indexPath.row];
        [self setAddDepartmentView];
    }
}

#pragma mark 留言

-(void)setAddDepartmentView
{
    if (!_bgWindow) {
        _bgWindow = [[UIWindow alloc]initWithFrame:self.view.bounds];
        _bgWindow.windowLevel = UIWindowLevelNormal;
        _bgWindow.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH-70, 151)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.center = _bgWindow.center;
        bgView.top = 80;
        bgView.layer.cornerRadius = 3;
        [_bgWindow addSubview:bgView];
        
        UILabel *titleLabel = [CustomView customTitleUILableWithContentView:bgView title:@"申请加入公司"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(0, 0, bgView.width, 40);
        
        UIView *line = [CustomView customLineView:bgView];
        line.frame = CGRectMake(0, titleLabel.bottom, bgView.width, 1);
        
        
        _nameTxt = [CustomView customUITextFieldWithContetnView:bgView placeHolder:@"请输入留言"];
        _nameTxt.textAlignment = NSTextAlignmentCenter;
        _nameTxt.frame = CGRectMake(5, line.bottom+10, bgView.width-10, 40);
        
        
        UIButton *canCelBtn = [CustomView customButtonWithContentView:bgView image:nil title:@"取消"];
        [canCelBtn addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        canCelBtn.frame = CGRectMake(0, _nameTxt.bottom+20, bgView.width/2, 40);
        
        UIButton *confirmBtn = [CustomView customButtonWithContentView:bgView image:nil title:@"确定"];
        [confirmBtn addTarget:self action:@selector(clickAddDepartmentButton:) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.frame = CGRectMake(canCelBtn.right,canCelBtn.top, canCelBtn.width, canCelBtn.height);
        [self.view addSubview:_bgWindow];
    }
    _bgWindow.hidden = NO;
    [_bgWindow makeKeyWindow];
}

-(void)clickCancelButton:(UIButton*)bton
{
    _bgWindow.hidden = YES;
    [_bgWindow resignKeyWindow];
}

-(void)clickAddDepartmentButton:(UIButton*)bton
{
    
    NSDictionary *dict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"company_id":self.companyModel.company_id,
                           @"content":self.nameTxt.text};
    [[NetworkSingletion sharedManager]applyJoinCompany:dict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"****%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        
        [MBProgressHUD showError:error toView:self.view];
    }];
   
    
}



#pragma mark get set

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
