//
//  DiaryListViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/6.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "DiaryListViewController.h"
#import "CXZ.h"

#import "DiaryTypeView.h"
#import "DiarySubTypeView.h"
#import "DiaryListCell.h"

#import "CreatPlanViewController.h"
#import "DiaryDetailViewController.h"
#import "WorkSignViewController.h"
#import "SignDetailViewController.h"

#import "DiaryModel.h"

@interface DiaryListViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,DiaryViewDelegate,DiaryListCellDelegate,DiarySubTypeViewDelegate>
{
    NSInteger page;
}
@property(nonatomic ,strong) DiaryTypeView *diaryTypeView;

@property(nonatomic ,strong) DiarySubTypeView *diarySubTypeView;

@property(nonatomic ,strong) UIScrollView *bgScrollView;

@property(nonatomic ,strong) UITableView *diaryListTableview;

@property(nonatomic ,strong) UITableView *signListTableview;//签到列表

@property(nonatomic ,strong) UIButton* backButton;

@property(nonatomic ,strong) UIButton* rightButton;

@property(nonatomic ,strong) UIView* titleLine1;

@property(nonatomic ,strong) NSMutableArray *diaryArray;

@property(nonatomic ,strong) NSMutableArray *signArray;

@property(nonatomic ,assign) NSInteger listType;//1日志   2签到

@end

@implementation DiaryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
//    [self setupTitleWithString:@"工作记录" withColor:[UIColor whiteColor]];
    [self setupTitle];
    [self removeTapGestureRecognizer];
    [self setupNextWithImage:[UIImage imageNamed:@"creat"]];
    self.view.backgroundColor = UIColorFromRGB(241, 241, 241);
    self.listType = 1;
    
    _bgScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.delegate = self;
    _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, self.view.bounds.size.height);
    [self.view addSubview:_bgScrollView];
    
    _diaryListTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _diaryListTableview.height = self.view.bounds.size.height-64;
    _diaryListTableview.delegate = self;
    _diaryListTableview.dataSource = self;
    _diaryListTableview.tableFooterView = [UIView new];
    _diaryListTableview.separatorColor = [UIColor clearColor];
    [_bgScrollView addSubview:_diaryListTableview];
    __weak typeof(self) weakself = self;
    _diaryListTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstDate];
    }];
    _diaryListTableview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreDate];
    }];
    [_diaryListTableview.mj_header beginRefreshing];
    
    
    _signListTableview = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _signListTableview.height = self.view.bounds.size.height-64;
    _signListTableview.delegate = self;
    _signListTableview.dataSource = self;
    _signListTableview.tableFooterView = [UIView new];
    _signListTableview.separatorColor = [UIColor clearColor];
    [_bgScrollView addSubview:_signListTableview];
    _signListTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.listType = 2;
        [weakself loadFirstDate];
    }];
    _signListTableview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreDate];
    }];
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark Date 相关

-(void)loadFirstDate
{
    if (self.listType == 1) {
        [self.diaryArray removeAllObjects];
    }else{
        [self.signArray removeAllObjects];
    }
    
    page = 1;
    [self loadDate];
}

-(void)loadMoreDate
{
    page ++;
    [self loadDate];
}

-(void)loadDate
{

    NSDictionary *paramDict = @{@"company_id":self.companyID,
                                @"p":@(page),
                                @"each":@(15),
                                @"type":@(self.listType)};
    [[NetworkSingletion sharedManager]getPlanList:paramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"plane %@",dict);
        [self.diaryListTableview.mj_header endRefreshing];
        [self.diaryListTableview.mj_footer endRefreshing];
        [self.signListTableview.mj_header endRefreshing];
        [self.signListTableview.mj_footer endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            NSArray *diaryArray = [DiaryModel objectArrayWithKeyValuesArray:dict[@"data"]];
            NSArray *resultArray = [diaryArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                DiaryModel *model1 = (DiaryModel*)obj1;
                DiaryModel *model2 = (DiaryModel*)obj2;
                NSComparisonResult result = [model1.add_time compare:model2.add_time];
                return result == NSOrderedAscending;  // 升序
            }];
            if (self.listType == 1) {
                [self.diaryArray addObjectsFromArray:resultArray];
                [self.diaryListTableview reloadData];
            }else{
                [self.signArray addObjectsFromArray:resultArray];
                [self.signListTableview reloadData];
            }
            
        }
        
    } OnError:^(NSString *error) {
        [self.diaryListTableview.mj_header endRefreshing];
        [self.diaryListTableview.mj_footer endRefreshing];
        [self.signListTableview.mj_header endRefreshing];
        [self.signListTableview.mj_footer endRefreshing];
    }];
}


#pragma mark Public Method

-(void)setupBackw{
     _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, 0, 20, 20);
    [_backButton setImage:[UIImage imageNamed:@"secondBack"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = rightItem;

}

-(void)setupNextWithImage:(UIImage *)image
{
     UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 46)];
     _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(45, 0, 44, 44);
    [_rightButton setImage:image forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_rightButton];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightItem;
}


-(void)setupTitle
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 40)];
    UIButton *button1 = [CustomView customButtonWithContentView:view image:nil title:@"日志"];
    button1.frame = CGRectMake(0, 7, 35, 25);
    button1.tag = 101;
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [button1 addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLine1 = [CustomView customLineView:view];
    _titleLine1.frame = CGRectMake(3, button1.bottom, 30, 1);
    _titleLine1.backgroundColor = ORANGE_COLOR;
    
    UIButton *button2 = [CustomView customButtonWithContentView:view image:nil title:@"签到"];
    button2.frame = CGRectMake(button1.right+5, button1.top, button1.width, button1.height);
    button2.tag = 102;
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [button2 addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = view;
    
}


-(void)onNext
{
    if (!_diaryTypeView) {
        _diaryTypeView = [[DiaryTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _diaryTypeView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        _diaryTypeView.hidden = YES;
        _diaryTypeView.delegate =self;
    }
    
    UIWindow *bgWindow =  [[UIApplication sharedApplication] keyWindow];
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.1 animations:^{
         weakself.diaryTypeView.hidden = NO;
        weakself.backButton.hidden = YES;
        [bgWindow addSubview:_diaryTypeView];
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        weakself.rightButton.transform = CGAffineTransformMakeRotation(M_PI/4);
    }];
}

#pragma mark Private Method

-(void)clickTitle:(UIButton*)button
{
    NSInteger tag = button.tag;
    NSLog(@"tag %li",tag);
    if (tag == 102) {
        self.listType = 2;
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.titleLine1.frame;
            frame.origin.x = 42.0;
            self.titleLine1.frame = frame;
            
        }];
        [self.bgScrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.view.bounds.size.height) animated:YES];
        if (self.signArray.count == 0) {
            [self.signListTableview.mj_header beginRefreshing];
        }
    }else{
         self.listType = 1;
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.titleLine1.frame;
            frame.origin.x = 3.0;
            self.titleLine1.frame = frame;
        }];
        [self.bgScrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height) animated:YES];
    }
}


#pragma mark Delegate

-(void)close
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakself.diaryTypeView.hidden = YES;
        weakself.backButton.hidden = NO;
        [weakself.diaryTypeView removeFromSuperview];
        
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        weakself.rightButton.transform = CGAffineTransformMakeRotation(0);
    }];
    
}

-(void)clickViewType:(NSInteger)tag
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakself.diaryTypeView.hidden = YES;
        weakself.backButton.hidden = NO;
        [weakself.diaryTypeView removeFromSuperview];
        
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        weakself.rightButton.transform = CGAffineTransformMakeRotation(0);
    }];
    
    if (tag == 0) {
        if (!_diarySubTypeView) {
            _diarySubTypeView = [[DiarySubTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            _diarySubTypeView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            _diarySubTypeView.hidden = YES;
            _diarySubTypeView.delegate = self;
           
        }
         _diarySubTypeView.diaryType = tag+1;
        [_diarySubTypeView loadDiaryType];
        UIWindow *bgWindow =  [[UIApplication sharedApplication] keyWindow];
        __weak typeof(self) weakself = self;
        [UIView animateWithDuration:0.1 animations:^{
            weakself.diarySubTypeView.hidden = NO;
            weakself.backButton.hidden = NO;
            [bgWindow addSubview:_diarySubTypeView];
        }];
        
    }
    
    if (tag == 1 || tag == 2) {
        CreatPlanViewController *creatVC = [[CreatPlanViewController alloc]init];
        creatVC.company_id = self.companyID;
        creatVC.type = tag+1;
        creatVC.form_id = 99+tag;
        [self.navigationController pushViewController:creatVC animated:YES];
    }

    if (tag == 3) {
        WorkSignViewController *signVC = [[WorkSignViewController alloc]init];
        signVC.company_id = self.companyID;
        [self.navigationController pushViewController:signVC animated:YES];
    }
    
    
}

-(void)selectedDiarySubType:(NSDictionary *)typeDict type:(NSInteger)type
{
    CreatPlanViewController *creatVC = [[CreatPlanViewController alloc]init];
    creatVC.company_id = self.companyID;
    creatVC.type = type;
    creatVC.form_id = [typeDict[@"log_type_id"] integerValue];
    creatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:creatVC animated:YES];

}


#pragma mark Cell Delegate

-(void)deleteDiary:(DiaryModel *)diary
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"publish_id":diary.publish_id};
    [[NetworkSingletion sharedManager]deleteDiary:paramDict onSucceed:^(NSDictionary *dict) {
//                NSLog(@"plane %@",dict);
       
        if ([dict[@"code"] integerValue]==0) {
            if (self.listType == 1) {
                [self.diaryArray removeObject:diary];
                [self.diaryListTableview reloadData];
            }else{
                [self.signArray removeObject:diary];
                [self.signListTableview reloadData];
            }
            
        }
        
    } OnError:^(NSString *error) {
       
    }];
}

#pragma mark UITableView Delegate  DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.diaryListTableview) {
        return self.diaryArray.count;
    }else{
        return self.signArray.count;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiaryListCell *cell = (DiaryListCell *)[tableView dequeueReusableCellWithIdentifier:@"DiaryListCell"];
    if (!cell) {
        cell = [[DiaryListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DiaryListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (tableView == self.diaryListTableview) {
        if (self.diaryArray.count > 0) {
            [cell setDiaryListCellWithModel:self.diaryArray[indexPath.section]];
        }
    }else{
        if (self.signArray.count > 0) {
            [cell setSignListCellWithModel:self.signArray[indexPath.section]];
        }
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
    if (self.listType == 1) { 
        if (self.diaryArray.count > 0) {
            DiaryModel *model = self.diaryArray[indexPath.section];
            DiaryDetailViewController *detailVC = [[DiaryDetailViewController alloc]init];
//            detailVC.company_id = model.company_id;
            detailVC.publish_id = model.publish_id;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
  
    }else if (self.listType == 2){
        if (self.signArray.count > 0) {
            DiaryModel *model = self.signArray[indexPath.section];
            SignDetailViewController *detailVC = [[SignDetailViewController alloc]init];
//            detailVC.company_id = model.company_id;
            detailVC.publish_id = model.publish_id;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
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

#pragma mark UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_bgScrollView]) {
        NSInteger index = (scrollView.contentOffset.x)/SCREEN_WIDTH;
        if (index == 1) {
            self.listType = 2;
            [UIView animateWithDuration:0.2 animations:^{
                CGRect frame = self.titleLine1.frame;
                frame.origin.x = 42.0;
                self.titleLine1.frame = frame;
                
            }];
            if (self.signArray.count == 0) {
                [self.signListTableview.mj_header beginRefreshing];
            }
        }else{
            self.listType = 1;
            [UIView animateWithDuration:0.1 animations:^{
                CGRect frame = self.titleLine1.frame;
                frame.origin.x = 3.0;
                self.titleLine1.frame = frame;
            }];
        }
    }
}


#pragma mark get/set

-(NSMutableArray*)diaryArray
{
    if (!_diaryArray) {
        _diaryArray = [NSMutableArray array];
    }
    return _diaryArray;
}

-(NSMutableArray*)signArray
{
    if (!_signArray) {
        _signArray = [NSMutableArray array];
    }
    return _signArray;
}


@end
