//
//  SWNearbyWorkerController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/18.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWNearbyWorkerController.h"

#import "SWChooseView.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <CoreLocation/CoreLocation.h>

#import "CXZ.h"

#import "SWNearbyWorkerCell.h"

#import "SWWorkerDetailController.h"
#import "SWSearchWorkerViewController.h"
#import "PermissionUpdateViewController.h"
#import "SWPublishController.h"
#import "SWUploadPositionCmd.h"


#import "SWWorkerInfoCmd.h"
#import "SWWorkerInfo.h"
#import "SWWorkerDetail.h"
#import "SWWorkerData.h"
#import "SWWorkerArea.h"

@interface SWNearbyWorkerController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,RCIMUserInfoDataSource,SWChooseItemDelegate,NearbyWorkerCellDelegate>
{
    NSInteger is_vip;
    NSInteger page;
    BOOL is_registe;
//    BOOL is_refresh;
}

@property (nonatomic, strong) NSMutableArray *workerInfoArr;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, strong) SWWorkerData *chatData;

/** 选择的区域id */
@property (nonatomic, retain) NSString *select_areaid;

/** 选择的排序方式 */
@property (nonatomic, retain) NSString *select_order;

@property (nonatomic, assign) BOOL is_upload;

@end

@implementation SWNearbyWorkerController
{
    
    SWChooseView *_chooseView;
    BMKLocationService *_locService;
    CLLocationManager *_locationManager;//用于获取位置
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTitle];
    [self setupNextWithString:@"发布" withColor:TOP_GREEN];
    //设置界面
    [self setUpView];
    
    //默认选中
    _select_areaid = @"0";
    _select_order = @"d";
    is_registe = YES;
    
    _locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"开始定位");
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 100.0;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if (IOS8) {
            [_locationManager requestWhenInUseAuthorization];
            [_locationManager requestAlwaysAuthorization];
        }
        [_locationManager startUpdatingLocation];
    }else{
        NSLog(@"定位失败，请确定是否开启定位功能");
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _locService.delegate = nil; // 不用时，置nil
    self.is_upload = NO;
}

#pragma mark 继承方法

-(void)clickTitle
{
    SWSearchWorkerViewController *searchVC = [SWSearchWorkerViewController new];
    searchVC.is_vip = is_vip;
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (void)onNext {
    
    //    SWNearbyWorkerController *nearbyController = [[SWNearbyWorkerController alloc] init];
    //    nearbyController.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:nearbyController animated:YES];
    SWPublishController *publishController = [[SWPublishController alloc] init];
    publishController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:publishController animated:YES];
}



-(void) setupTitle
{
    UISearchBar *topsearchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 150, 30)];
    //    topsearchbar.delegate = self;
    topsearchbar.placeholder = @"请输入工人姓名或电话号码";
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
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入工人姓名或电话号码" attributes:@{NSForegroundColorAttributeName: color}];
            //            textField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbg"]];
            textField.backgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
            //            textField.leftView = [UIView new];
        }
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTitle)];
    [topsearchbar addGestureRecognizer:tap];
    self.navigationItem.titleView = topsearchbar;
    self.navigationItem.titleView.width = SCREEN_WIDTH-150;
    
}


#pragma mark private method
/** 加载数据 */
-(void)refreshData
{
     page = 1;
    is_registe = YES;
    [self.workerInfoArr removeAllObjects];
    [self loadData];
}
-(void)loadMoreData
{
    page ++;
//    if (is_registe == NO) {
////       [self loadRecommendData];
//    }else{
//      [self loadData];
//    }
    [self loadData];
}

//-(void)loadRecommendData
//{
//    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
//    if ([NSString isBlankString:self.select_wid]) {
//        self.select_wid = @"0";
//    }
//    NSDictionary *pramDict = @{@"uid":uid,
//                               @"type":self.select_wid,
//                               @"p":@(page),
//                               @"each":@"10"};
//    [[NetworkSingletion sharedManager]getRecommendWorkerList:pramDict onSucceed:^(NSDictionary *dict) {
////        NSLog(@"sdfsafffd%@",dict);
//        [self.tableView.mj_header endRefreshing];
//        if ([dict[@"code"] integerValue]==0) {
//            NSArray *array = dict[@"data"];
//            for (NSDictionary *dataDict in dict[@"data"]) {
//                SWWorkerData *data = [SWWorkerData objectWithKeyValues:dataDict];
//                data.registe = 0;
//                [self.workerInfoArr addObject:data];
//            }
//          
//////            NSArray *array = [SWWorkerData objectArrayWithKeyValuesArray:dict[@"data"]];
////            
////            [self.workerInfoArr addObjectsFromArray:array];
//            if (array.count != 10) {
//                
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }else{
//                [self.tableView.mj_footer endRefreshing];
//            }
//            [_tableView reloadData];
//        }else{
//            [MBProgressHUD showError:dict[@"message"] toView:self.view];
//        }
//    } OnError:^(NSString *error) {
//        
//    }];
//}

- (void)loadData {
    
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
   
    if ([NSString isBlankString:self.select_wid]) {
        self.select_wid = @"0";
    }
//    NSLog(@"*sdf**%@",self.select_areaid);
    NSDictionary *pramDict = @{@"uid":uid,
                               @"wid":self.select_wid,
                               @"hometown":self.select_areaid,
                               @"order":self.select_order,
                               @"p":@(page),
                               @"each":@"10"};
    
    [[NetworkSingletion sharedManager]getAllWorkerList:pramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"234234234%@",dict);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            is_vip = [[dict[@"data"] objectForKey:@"is_vip"] integerValue];
            NSArray *arr = [dict[@"data"] objectForKey:@"nworker"];

            for (NSDictionary *dataDict in arr) {
                SWWorkerData *data = [SWWorkerData objectWithKeyValues:dataDict];
                data.registe = 1;
                [self.workerInfoArr addObject:data];
            }
//            NSArray *array = [SWWorkerData objectArrayWithKeyValuesArray:arr];
//            [self.workerInfoArr addObjectsFromArray:array];
//            if (arr.count != 10) {
//                page = 0;
//                is_registe = NO;
////                if (array.count == 0) {
////                    [self loadRecommendData];
////                }
//            }
            [_tableView reloadData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}


//设置界面
- (void)setUpView {
    
    SWChooseView *chooseView   = [[SWChooseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49.0f)];
    chooseView.backgroundColor = [UIColor whiteColor];
    chooseView.itemDelegate    = self;
    [self.view addSubview:chooseView];
    _chooseView = chooseView;

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(chooseView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - 49 -104) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        [self refreshData];
        
    }];
    
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    _tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];

     self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    
}



#pragma mark ---------- tableView delegate & dataSource start  -------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _workerInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SWNearbyWorkerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    if(!cell) {
        
        cell = [[SWNearbyWorkerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        
    }
//    cell.delegate = self;
    cell.is_Vip = is_vip;
    if (_workerInfoArr.count > 0) {
        SWWorkerData *workerData = _workerInfoArr[indexPath.section];
        [cell showData:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,workerData.avatar] name:workerData.name distance:[NSString stringWithFormat:@"%ld",workerData.distance] jobs:workerData.type phone:workerData.phone year:workerData.work_years];
        [cell setWokerData:workerData];
        cell.workData = workerData;
    }
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SWWorkerDetailController *workerController = [[SWWorkerDetailController alloc] init];
    SWWorkerData *workerData = _workerInfoArr[indexPath.section];
    if (workerData.registe == 1) {
        workerController.uid = workerData.uid;
        workerController.workerName = workerData.name;
        workerController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:workerController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
        [MBProgressHUD showError:@"此工人还未填写资料..." toView:self.view];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

#pragma mark ---------- cell Delegate -------------

//-(void)clickPhoneWithPhone:(SWWorkerData *)workData
//{
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"找他聊聊" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        [alertVC addAction:[UIAlertAction actionWithTitle:@"电话聊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",workData.phone];
//            UIWebView *callWebview = [[UIWebView alloc] init];
//            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//            [self.navigationController.view addSubview:callWebview];
//        }]];
//        [alertVC addAction:[UIAlertAction actionWithTitle:@"在线聊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            self.chatData = workData;
//            //数据源方法，要传递数据必须加上
//            [[RCIM sharedRCIM] setUserInfoDataSource:self];
//            RCConversationViewController *chat = [[RCConversationViewController alloc] init];
//            //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等0
//            chat.conversationType = ConversationType_PRIVATE;
//            //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
//            chat.targetId = workData.uid;
//
//            //设置聊天会话界面要显示的标题
//            chat.title = workData.name;
//            //显示聊天会话界面
//            chat.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:chat animated:YES];
//
//        }]];
//        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }]];
//
//        [self presentViewController:alertVC animated:YES completion:NULL];
//
//}

//-(void)permissionUpdate
//{
//    NSString *roles = [[NSUserDefaults standardUserDefaults] objectForKey:@"roles"];
//    UIAlertController *alertVC;
//    if ([roles isEqualToString:@"1"]) {
//        alertVC= [UIAlertController alertControllerWithTitle:@"升级为雇主才可以查看信息哦.." message:nil preferredStyle:UIAlertControllerStyleAlert];
//    }else{
//        alertVC= [UIAlertController alertControllerWithTitle:@"赶快去升级VIP吧..." message:nil preferredStyle:UIAlertControllerStyleAlert];
//    }
//    
//    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    [alertVC addAction:[UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        PermissionUpdateViewController *vc = [PermissionUpdateViewController new];
//        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
//        
//    }]];
//    
//    [self presentViewController:alertVC animated:YES completion:NULL];
//}


#pragma mark ------------- SWChooseItemDelegate start -----------------

- (void)selectItem:(NSString *)itemName {
    
    if([itemName isEqualToString:@"距离"]) {
        
        _select_order = @"d";
        
    }else if([itemName isEqualToString:@"好评率"]) {
        
        _select_order = @"n";
        
    }else if([itemName isEqualToString:@"雇佣次数"]) {
        
        _select_order = @"w";
        
    }
    
    [_tableView.mj_header beginRefreshing];
    
}

- (void)selectTypeItem:(NSString *)wid {
    
    _select_wid = wid;
    
    [_tableView.mj_header beginRefreshing];
    
}

- (void)selectAddressItem:(NSString *)wid {
    
//    NSLog(@"***%@",wid);
    _select_areaid = wid;
    
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark ------------- SWChooseItemDelegate end -------------------


#pragma mark 百度地图

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *location = [locations lastObject];
    CGFloat  latitude = location.coordinate.latitude;
    CGFloat longitude = location.coordinate.longitude;

    //    NSLog(@"纬度--%f 经度--%f",userCoord.latitude,userCoord.longitude);
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *place = placemarks[0];
        NSString *admin = place.administrativeArea;//省
//        NSString *city = place.locality;
//        NSString *subLocality = place.subLocality;
//        NSString *thorough = place.thoroughfare;
//        NSString *subThorough = place.subThoroughfare;
        
        if (!self.is_upload) {
            SWUploadPositionCmd *uploadCmd = [[SWUploadPositionCmd alloc] init];
            uploadCmd.latitude = latitude;
            uploadCmd.longitude = longitude;
            uploadCmd.region = admin;
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
            uploadCmd.uid = uid;
            [[HttpNetwork getInstance] requestPOST:uploadCmd success:^(BaseRespond *respond) {
                if (respond.code == 0) {
                    self.is_upload = YES;
                }
            } failed:^(BaseRespond *respond, NSString *error) {
                
            }];
        }
        
    }];
   
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败%@",[error description] );
    
}


#pragma  mark get/set


-(NSMutableArray*)workerInfoArr
{
    if (!_workerInfoArr) {
        _workerInfoArr = [NSMutableArray array];
    }
    return _workerInfoArr;
}


@end
