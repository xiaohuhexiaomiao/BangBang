//
//  SWMyPublishDetailController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/23.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMyPublishDetailController.h"

#import "CXZ.h"

#import "SWBaseTopView.h"

#import "SWSeeWokerView.h"

#import "SWMyPublishDetailCmd.h"
#import "SWMyPublishDetailInfo.h"
#import "SWMyPublishDetailData.h"
#import "SWFindWorkType.h"

#import "SWLookUserCmd.h"
#import "SWLookUserInfo.h"
#import "SWLookUserData.h"
#import "SWLookUserDetail.h"

#import "SWAuditWorkerCmd.h"
#import "SWAuditWorkerInfo.h"

#import "SWCancelEmployeeCmd.h"
#import "SWCancelEmployeeInfo.h"

#import "SWStartCmd.h"
#import "SWStartInfo.h"

#import "SWStopCmd.h"
#import "SWStopInfo.h"

#import "SWUploadContractCmd.h"
#import "SWUploadContractInfo.h"

#import "SWWorkerDetailController.h"
#import "SWMyFavoriteController.h"
#import "SignNameViewController.h"
#import "ListViewController.h"
#import "SeeWorkerCell.h"
#import "ProjectDetailCell.h"

#import "SWAlipay.h"

#import "SWPayBackCmd.h"
#import "SWPayBackInfo.h"

#define padding 10

@interface SWMyPublishDetailController ()<SWSeeWorkerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UIScrollView *contentView;

@property (nonatomic, retain) UIView *headerView;

@property (nonatomic, retain) UIView *footerView;

@property (nonatomic , retain) UITableView *listTabelview;

@property (nonatomic, retain) SWBaseTopView *topView;

@property (nonatomic, retain) UIButton *startBtn; // 启动施工按钮

@property (nonatomic, retain) SWMyPublishDetailData *detailData;

@property (nonatomic, retain) SWLookUserDetail *userDetail;

@property (nonatomic, retain) NSMutableArray *dataSource;

/**
 当前页
 */
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic ,copy) NSString *workid;//工人ID

@property (nonatomic, strong) SWLookUserData *userdata;



@end

@implementation SWMyPublishDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self removeTapGestureRecognizer];
    _dataSource = [NSMutableArray array];
    
    [self setupBackw];
    if (!self.is_ending) {
        [self setupNextWithString:@"结束报名" withColor:TOP_GREEN];
    }
    [self loadInfoData];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    _listTabelview = tableView;
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)onNext
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否结束报名？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NetworkSingletion sharedManager]endApplyProject:@{@"iid":self.detailData.iid} onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue]==0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                 [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
            
        } OnError:^(NSString *error) {
           
        }];
    }]];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
}
-(void)setDetailTitle:(NSString *)detailTitle {
    
    _detailTitle = detailTitle;
    
    [self setupTitleWithString:_detailTitle withColor:[UIColor whiteColor]];
    
}



#pragma mark 加载数据
/** 加载工作详情 */
- (void)loadInfoData {
    
    SWMyPublishDetailCmd *detailCmd = [[SWMyPublishDetailCmd alloc] init];
    detailCmd.iid = self.iid;
    
    [[HttpNetwork getInstance] requestPOST:detailCmd success:^(BaseRespond *respond) {
        
        SWMyPublishDetailInfo *detailInfo = [[SWMyPublishDetailInfo alloc] initWithDictionary:respond.data];
        
        if(detailInfo.code == 0) {
            
            SWMyPublishDetailData *detailData = detailInfo.data;
            _detailData = detailData;
            [self loadWorkerData:1];
        }
    } failed:^(BaseRespond *respond, NSString *error) {
    
    }];
}

- (void)loadWorkerData:(NSInteger)state {
    
    SWLookUserCmd *userCmd = [[SWLookUserCmd alloc] init];
    userCmd.type = state;
    userCmd.iid = self.iid;
    [_dataSource removeAllObjects];
    [[HttpNetwork getInstance] requestPOST:userCmd success:^(BaseRespond *respond) {
        
        if (respond.code == 0) {
            SWLookUserInfo *userInfo = [[SWLookUserInfo alloc] initWithDictionary:respond.data];
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray: userInfo.data];
        }
        [self.listTabelview reloadData];
    } failed:^(BaseRespond *respond, NSString *error) {
        
    }];
    
}

#pragma mark

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        ProjectDetailCell *cell = (ProjectDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"ProjectDetailCell"];
        if (!cell) {
            cell = [[ProjectDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProjectDetailCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.detailData) {
            [cell showProjectDetail:self.detailData];
        }
        return cell;
    }
    SeeWorkerCell *cell = (SeeWorkerCell*)[tableView dequeueReusableCellWithIdentifier:@"SeeWorkerCell"];
    if (!cell) {
        cell = [[SeeWorkerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SeeWorkerCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    cell.type = self.currentPage-1;
    if (self.dataSource.count > 0) {
        SWLookUserData *userData = self.dataSource[indexPath.row];
        cell.data = userData;
         [cell showUnWorkerData:userData.avatar name:userData.name jobs:userData.type status:userData.status is_send:userData.is_contract];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ProjectDetailCell *cell = (ProjectDetailCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    return 55.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 69.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count>0) {
        SWLookUserData *userData = self.dataSource[indexPath.row];
        SWWorkerDetailController *workerDetailController = [[SWWorkerDetailController alloc] init];
        workerDetailController.uid = userData.uid;
        workerDetailController.workerName = userData.name;
       
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:workerDetailController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _contentView                 = [[UIScrollView alloc] init];
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.frame           = CGRectMake(0, 0, SCREEN_WIDTH, 69);
    _contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    SWBaseTopView *topView = [[SWBaseTopView alloc] initWithFrame:CGRectMake(0,  padding, SCREEN_WIDTH, 49)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.titleArr       = @[@"申请的工人",@"浏览的工人",@"雇佣的工人"];
    topView.totalPage      = 3;
    topView.isClick = YES;
    [_contentView addSubview:topView];
    _topView = topView;
    
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageChange:) name:PAGE_CHANGE object:nil];
    
    return _contentView;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark 



- (void)pageChange:(NSNotification *)notif {
   
    NSString *page = notif.userInfo[@"page"];
    
     self.currentPage= [page integerValue];
    
    [self loadWorkerData:self.currentPage];
}



#pragma mark ---- SWSeeWorkerView Delegate start --------------------


- (void)applyWorker:(SWSeeWokerView *)workerView data:(SWLookUserData *)data {
    self.userdata = data;
    ListViewController *postVC = [[ListViewController alloc]init];
    postVC.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    postVC.workID = workerView.data.uid;
    postVC.list_type = 1;
    postVC.project_id = self.detailData.iid;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;

}



@end
