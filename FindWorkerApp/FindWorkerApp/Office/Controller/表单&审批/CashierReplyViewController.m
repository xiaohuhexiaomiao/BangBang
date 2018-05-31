//
//  CashierReplyViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/10/18.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CashierReplyViewController.h"
#import "CXZ.h"
#import "JXPopoverView.h"

#import "ApprovalTableViewCell.h"
#import "SponsorTableViewCell.h"
#import "ReviewListModel.h"

#import "SWSearchWorkerViewController.h"
#import "CompanyReviewViewController.h"
#import "ShowPaymentsViewController.h"
#import "ShowFileViewController.h"
#import "ShowPurchaseViewController.h"
#import "ShowCompanyViewController.h"
#import "ShowStampViewController.h"

@interface CashierReplyViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSInteger page;
    NSInteger selectedIndex;
}
@property(nonatomic ,strong) UIScrollView *scrollview;

@property(nonatomic ,strong) UITableView *firstTableview;

@property(nonatomic ,strong) UITableView *sencondTableview;


@property(nonatomic ,strong) UISegmentedControl *segmentBtn;

@property (nonatomic , strong) UIButton *changeButton;

@property(nonatomic ,strong) NSMutableArray *firstArray;

@property(nonatomic ,strong) NSMutableArray *secondArray;


@end

@implementation CashierReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"表单回执" withColor:[UIColor whiteColor]];
//    [self setupTitle];
    if (self.companyArr.count > 1) {
        [self setupNextWithString:@"切换"];
    }
    
    [self config];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadNewData) name:@"UPLOAD_CASHIER_NEW_DATA" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark publish Method

-(void)setupNextWithString:(NSString *)text
{
    _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeButton.frame = CGRectMake(SCREEN_WIDTH-50, 10, 50, 20);
    [_changeButton setTitle:@"切换" forState:UIControlStateNormal];
    _changeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_changeButton addTarget:self action:@selector(changeCompany) forControlEvents:UIControlEventTouchUpInside];
    _changeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_changeButton];
}

-(void) setupTitle
{
    UISearchBar *topsearchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 150, 30)];
    //    topsearchbar.delegate = self;
    topsearchbar.placeholder = @"请输入工程地址或标题";
    for (UIView *sv in topsearchbar.subviews)
    {
        if ([sv isKindOfClass:NSClassFromString(@"UIView")] && sv.subviews.count > 0)
        {
            [sv.subviews.firstObject removeFromSuperview];
            UITextField *textField = sv.subviews.lastObject;
            textField.userInteractionEnabled = NO;
            textField.layer.borderColor = TOP_GREEN.CGColor;
            textField.layer.borderWidth = 0.5;
            textField.layer.masksToBounds = YES;
            textField.layer.cornerRadius = 15;
            textField.font = [UIFont systemFontOfSize:12];
            UIColor *color = [UIColor whiteColor];
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入工程地址或标题" attributes:@{NSForegroundColorAttributeName: color}];
            //            textField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbg"]];
            textField.backgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
            //            textField.leftView = [UIView new];
        }
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSearch)];
    [topsearchbar addGestureRecognizer:tap];
    self.navigationItem.titleView = topsearchbar;
    self.navigationItem.titleView.width = SCREEN_WIDTH-150;
    
}

#pragma mark PrivateMethod
-(void)config{
    
    CGFloat heheight = 44;
    CGFloat segHeight = heheight+64;
    NSArray *titleArray = @[@"未处理",@"已处理"];
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
    _scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*2,SCREEN_HEIGHT-segHeight);
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
    
}

-(void)changeCompany
{
    if (self.companyArr.count>0) {
        JXPopoverView *popoverView = [JXPopoverView popoverView];
        popoverView.style = PopoverViewStyleDark;
        NSMutableArray *actionArray = [NSMutableArray array];
 
        for (int i = 0 ; i < self.companyArr.count; i++) {
            NSDictionary *company = self.companyArr[i];
            JXPopoverAction *action1 = [JXPopoverAction actionWithTitle:company[@"company_name"] handler:^(JXPopoverAction *action) {
                self.companyID = company[@"company_id"];
                [self.firstArray removeAllObjects];
                [self.secondArray removeAllObjects];
              
                [self loadFirstData];
            }];
            
            [actionArray addObject:action1];
        }
        [popoverView showToView:self.changeButton withActions:actionArray];
    }
    
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
                default:
            break;
    }
}


-(void)listChange:(UISegmentedControl*)control
{
    NSInteger index = control.selectedSegmentIndex;
    [self reloadDataWithIndex:index];
    [_scrollview scrollRectToVisible:CGRectMake(SCREEN_WIDTH*index, 0, SCREEN_WIDTH, SCREEN_HEIGHT-35) animated:YES];
}

-(void)loadNewData
{
    [self.firstArray removeAllObjects];
    [self.firstTableview.mj_header beginRefreshing];
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
                                @"each":@"10",
                                @"company_id":self.companyID};
    [[NetworkSingletion sharedManager]getReceiptDisposeList:paramDict onSucceed:^(NSDictionary *dict) {
        
//                NSLog(@"list %@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            
            NSArray *array = [ReviewListModel objectArrayWithKeyValuesArray:dict[@"data"]];
            switch (selectedIndex) {
                case 0:[self.firstArray addObjectsFromArray:array];
                    
                    break;
                case 1:[self.secondArray addObjectsFromArray:array];break;
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
            default:
                break;
        }
        
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
    
}
#pragma mark UITableview Delegate & Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.firstTableview) {
        return self.firstArray.count;
    }else {
        return self.secondArray.count;
    }
    //    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       ApprovalTableViewCell *cell = (ApprovalTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ApprovalCell"];
    if (!cell) {
        cell = [[ApprovalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApprovalCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.is_More = self.companyArr.count > 1 ? YES :NO;
    cell.companyName.hidden = YES;
    if (tableView == _firstTableview) {
        if (self.firstArray.count>0) {
            cell.timeLabel.hidden = YES;
            [cell setCashierApprovalCellWith:self.firstArray[indexPath.row]];
        }
    }else{
        if (self.secondArray.count > 0) {
            cell.timeLabel.hidden = NO;
            [cell setCashierApprovalCellWith:self.secondArray[indexPath.row]];
        }
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 122.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewListModel *listModel ;

    CompanyReviewViewController *reviewVC = [[CompanyReviewViewController alloc]init];
    ShowPaymentsViewController *payVC = [[ShowPaymentsViewController alloc]init];
    ShowPurchaseViewController *purchaseVC = [[ShowPurchaseViewController alloc]init];
    ShowStampViewController *stampVC = [[ShowStampViewController alloc]init];
    ShowFileViewController *fileVC = [[ShowFileViewController alloc]init];
    ShowCompanyViewController *companyVC = [[ShowCompanyViewController alloc]init];
    
    if (tableView == self.firstTableview) {
        listModel = self.firstArray[indexPath.row];
        payVC.is_aready_approval = NO;
        purchaseVC.is_aready_approval = NO;
        reviewVC.is_aready_approval = NO;
        stampVC.is_aready_approval = NO;
        fileVC.is_aready_approval = NO;
        companyVC.is_aready_approval = NO;
    }else{
        listModel = self.secondArray[indexPath.row];
        payVC.is_aready_approval = YES;
        purchaseVC.is_aready_approval = YES;
        reviewVC.is_aready_approval = YES;
        stampVC.is_aready_approval = YES;
        fileVC.is_aready_approval = YES;
        companyVC.is_aready_approval = YES;
    }
   if (listModel.type == 0||listModel.type == 8||listModel.type == 9){        payVC.approvalID = listModel.approval_id;
        payVC.personal_id = self.personalId;
        payVC.is_cashier = YES;
        [self.navigationController pushViewController:payVC animated:YES];
   }else if (listModel.type == 3 ||listModel.type == 7||listModel.type == 10){       purchaseVC.approvalID = listModel.approval_id;
       purchaseVC.is_cashier = YES;
       purchaseVC.personal_id = self.personalId;
       [self.navigationController pushViewController:purchaseVC animated:YES];
   }else if (listModel.type == 1 || listModel.type == 2) {
       reviewVC.typeStr = [NSString stringWithFormat:@"%@",@(listModel.type)];
       reviewVC.approval_id = listModel.approval_id;
       reviewVC.participation_id = listModel.participation_id;
       reviewVC.company_id = listModel.company_id;
       reviewVC.is_approval = YES;
       reviewVC.contractTitle = listModel.title;
         reviewVC.personal_id = self.personalId;
       reviewVC.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:reviewVC animated:YES];
       self.hidesBottomBarWhenPushed = YES;
   }else if (listModel.type == 111){
       companyVC.approval_id = listModel.approval_id;
       companyVC.personal_id = self.personalId;
       companyVC.is_cashier = YES;
       [self.navigationController pushViewController:companyVC animated:YES];
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





@end
