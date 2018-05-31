//
//  SWFindWorkerController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/17.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWFindWorkerController.h"
#import "CXZ.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "BMKPointAnnotation+SWBMKPointTag.h"


#import "SWNearbyWorkerController.h"
#import "SWPublishController.h"
#import "SWWorkerDetailController.h"
#import "PermissionUpdateViewController.h"
#import "SWSearchWorkerViewController.h"

#import "SWNearbyWorkerCell.h"
#import "ToolCollectionCell.h"

#import "SWWorkerInfoCmd.h"
#import "SWWorkerInfo.h"
#import "SWWorkerDetail.h"
#import "SWWorkerData.h"
#import "SWWorkerArea.h"

#import "SWUploadPositionCmd.h"
#import "SWUploadInfo.h"

#import "SWFindWorkerUtils.h"

#import "SWNearbyWorkerView.h"

#define padding 10



@interface SWFindWorkerController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,RCIMUserInfoDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ToolCollectionCellDelegate,NearbyWorkerViewDelegate>
{
    NSInteger is_vip;
}

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic, retain) UIScrollView *workerInfoView;

@property (nonatomic, retain) NSMutableArray *workerArr;

@property (nonatomic, retain) NSString *select_workerId; //选中工人的id

@property (nonatomic, assign) BOOL is_upload;//判断是否已经上传位置

@property (nonatomic, retain) NSMutableArray *locationArr; //工人的位置

@property (nonatomic , strong) UICollectionView *topCollectionView;// 顶部CollectionView

@property (nonatomic , strong) NSMutableArray *workerTypeArray;

@property (nonatomic, strong) SWWorkerData *chatData;

@end



@implementation SWFindWorkerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _is_upload = NO;
    _locationArr = [NSMutableArray array];
    _workerTypeArray = [NSMutableArray array];
    [self setupBackWithString:@"   " withColor:TOP_GREEN];
    [self setupNextWithString:@"发布工程" withColor:TOP_GREEN];
//    [self setupBackWithImage:[UIImage imageNamed:@"feedback"] withString:nil];
    [self setupTitle];
    
    //初始化地图
    [self initWithMap];
    
    [self configTopView];
    [self loadWorkerType];
    
    
}

//上传我的位置
- (void)uploadMyPosition:(AfterProcess)after latitude:(CGFloat)latitude longtitude:(CGFloat)longtitude {
    
    SWUploadPositionCmd *uploadCmd = [[SWUploadPositionCmd alloc] init];
    uploadCmd.latitude = latitude;
    uploadCmd.longitude = longtitude;
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    uploadCmd.uid = uid;
    
    [[HttpNetwork getInstance] requestPOST:uploadCmd success:^(BaseRespond *respond) {
        
        SWUploadInfo *uploadInfo = [[SWUploadInfo alloc] initWithDictionary:respond.data];
    
        if(uploadInfo.code == 0) {
            
            after();
            
        }else {
            
          
            
            BOOL is_login = [[NSUserDefaults standardUserDefaults] boolForKey:@"IS_LOGIN"];
            
            if(!is_login) {
                
                
                [MBProgressHUD showError:@"请先登录" toView:self.view];
                
                
            }else {
                
                [MBProgressHUD showError:uploadInfo.message toView:self.view];
                
            }
            
            
            
        }
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        
        [MBProgressHUD showError:error toView:self.view];
        
    }];
    
}

-(void)loadWorkerType
{
    __weak typeof(self) weakself = self;
     NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    [[NetworkSingletion sharedManager]getWorkerType:nil onSucceed:^(NSDictionary *dict) {
//                NSLog(@"**23*%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            [self.workerTypeArray addObject:@{@"type_name":@"全部",@"wid":@"0"}];
            [self.workerTypeArray addObjectsFromArray: dict[@"data"]];
            [self.topCollectionView reloadData];
        }
    } OnError:^(NSString *error) {
        [weakself loadWorkerType];
    }];
}

//加载数据
- (void)loadData {
    
    SWWorkerInfoCmd *cmd = [[SWWorkerInfoCmd alloc] init];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    cmd.uid = uid;
//    cmd.size = 10000;
    
    [[HttpNetwork getInstance] requestPOST:cmd success:^(BaseRespond *respond) {
        
//        NSLog(@"*sdfsddfs**%@",respond.data);
        is_vip = [[respond.data[@"data"] objectForKey:@"is_vip"] integerValue];
        
        SWWorkerInfo *workerInfo = [[SWWorkerInfo alloc] initWithDictionary:respond.data];
        
        SWWorkerDetail *workerDetail = workerInfo.data;
        
        [_mapView removeAnnotations:_locationArr];
        
        for (SWWorkerData *data in workerDetail.nworker) {
            
            NSString *jobs = [data.type componentsJoinedByString:@","];

            
//            [self showLocation:[data.latitude doubleValue] longitude:[data.longitude doubleValue] title:data.name subtitle:jobs user_id:data.uid];
            
        }
        
        _workerArr = [NSMutableArray arrayWithArray:workerDetail.nworker];
        
        CGFloat maxH = [self showWorkerData];
        
        _mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - maxH - 64 - 49);
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    CGFloat maxH = 0;
    if (!_mapView) {
        _mapView      = [[BMKMapView alloc] init];
        _mapView.frame            = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - maxH - 64 - 49);
        _mapView.zoomLevel = 12.5; //地图的放大倍数
        [self.view addSubview:_mapView];
        [self.view sendSubviewToBack:_mapView];
    }
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [_mapView setMapType:BMKMapTypeStandard];
    //定位到自己的位置
    [_mapView updateLocationData:_locService.userLocation];
     [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil; // 不用时，置nil
    _is_upload = NO;
    [_mapView removeFromSuperview];
//    NSLog(@"dealloc1 %p",_mapView);
    _mapView = nil;
//    NSLog(@"dealloc2 %p",_mapView);
}

#pragma mark ------ Private Method -------------

- (void)initWithMap {
    
    
    //初始化BMKLocationService
    BMKLocationService *locationService = [[BMKLocationService alloc]init];
    
    //启动LocationService
    [locationService startUserLocationService];
    _locService = locationService;
    _locService.delegate = self;

}

-(void)configTopView
{
    CGFloat height = 40.0f;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(70, height);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // CGRectMake(0, 22, 300, 44)
    _topCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, height) collectionViewLayout:flowLayout];
    _topCollectionView.dataSource = self;
    _topCollectionView.delegate = self;
    _topCollectionView.backgroundColor = [UIColor whiteColor];
    [_topCollectionView registerClass:[ToolCollectionCell class] forCellWithReuseIdentifier:@"ToolCollectionCell"];
    [self.view addSubview:_topCollectionView];
  
    
}


//底部显示工人信息视图
- (CGFloat)showWorkerData {
    
    CGFloat maxH = 0;
    
    CGFloat workH = 100;
    CGFloat workY = SCREEN_HEIGHT - workH - 64;
    
    _workerInfoView = [[UIScrollView alloc] init];
    _workerInfoView.showsVerticalScrollIndicator = NO;
    _workerInfoView.frame   = CGRectMake(0, workY, SCREEN_WIDTH, workH);
    _workerInfoView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    [self.view addSubview:_workerInfoView];
    [self.view bringSubviewToFront:self.topCollectionView];
    
    UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    inputView.backgroundColor = [UIColor whiteColor];
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 2, 25, 25)];
    imgview.image = [UIImage imageNamed:@"pencil"];
    [inputView addSubview:imgview];
    
    UILabel *inputLabel = [[UILabel alloc]initWithFrame:CGRectMake(imgview.right, 0, SCREEN_WIDTH-40, 29)];
    inputLabel.textColor = [UIColor grayColor];
    inputLabel.font = [UIFont systemFontOfSize:12];
    inputLabel.text = @"快来发布工程吧..";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBack)];
    inputLabel.userInteractionEnabled = YES;
    [inputLabel addGestureRecognizer:tap];
    [inputView addSubview:inputLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 1)];
    line.backgroundColor = LINE_GRAY;
    [inputView addSubview:line];
    [_workerInfoView addSubview:inputView];
    
    
    CGFloat viewX = 0;
    CGFloat viewY = padding;
    CGFloat viewW = SCREEN_WIDTH;
    CGFloat viewH = 55.0f;
    
    NSInteger worker_interger = 2;
    
    if(_workerArr.count < worker_interger) {
        
        worker_interger = _workerArr.count;
        
    }
    
    for (int i = 0; i < worker_interger; i++) {
        
        SWWorkerData *data = _workerArr[i];
        
        viewY = (viewH+1) * i+30;
        
        SWNearbyWorkerView *workerView = [[SWNearbyWorkerView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        workerView.tag = [data.uid integerValue];
        workerView.backgroundColor = [UIColor whiteColor];
        workerView.is_Vip = is_vip;
        [workerView showData:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,data.avatar] name:data.name distance:[NSString stringWithFormat:@"%ld",data.distance] jobs:data.type phone:data.phone year:data.work_years];
        workerView.delegate = self;
        workerView.workData = data;
        [_workerInfoView addSubview:workerView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushController:)];
        [workerView addGestureRecognizer:tapGesture];
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(viewX, CGRectGetMaxY(workerView.frame), viewW, 1)];
        lineView.backgroundColor = LINE_GRAY;
        [_workerInfoView addSubview:lineView];
        maxH = CGRectGetMaxY(lineView.frame);
        
    }
    
    workH = maxH + 49;
    workY = SCREEN_HEIGHT - workH - 64;
    _workerInfoView.frame   = CGRectMake(0, workY, SCREEN_WIDTH, workH);
    _workerInfoView.contentSize = CGSizeMake(0, maxH);
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [_workerInfoView.mj_footer endRefreshing];
        SWNearbyWorkerController *nearbyController = [[SWNearbyWorkerController alloc] init];
        nearbyController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nearbyController animated:YES];
        
    }];
    
    [footer setTitle:@"下拉加载更多工人" forState:MJRefreshStateIdle];
    
    _workerInfoView.mj_footer = footer;
    return maxH;
    
}

- (void)pushController:(UITapGestureRecognizer *)gesture {
    
//    NSString *roles = [[NSUserDefaults standardUserDefaults] objectForKey:@"roles"];
//    if ( is_vip == 0) {
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"升级为雇主才可以查看信息哦" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//           
//        }]];
//        [alertVC addAction:[UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            PermissionUpdateViewController *vc = [PermissionUpdateViewController new];
//            self.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//            self.hidesBottomBarWhenPushed = NO;
//            
//        }]];
//        
//        [self presentViewController:alertVC animated:YES completion:NULL];
//       
//    }else{
//        
//    }
    NSString *workerName = @"";
    for (SWWorkerData *data in _workerArr) {
        
        if([data.uid isEqualToString:[NSString stringWithFormat:@"%ld",gesture.view.tag]]){
            
            workerName = data.name;
            
        }
        
    }
    SWWorkerDetailController *workerDetail = [[SWWorkerDetailController alloc] init];
    workerDetail.hidesBottomBarWhenPushed = YES;
    workerDetail.workerName = workerName;
    workerDetail.uid  = [NSString stringWithFormat:@"%ld",gesture.view.tag];
    [self.navigationController pushViewController:workerDetail animated:YES];
}

#pragma mark NearbyViewDelegate
-(void)clickPhoneWithData:(SWWorkerData *)workData
{
    NSString *roles = [[NSUserDefaults standardUserDefaults] objectForKey:@"roles"];

//    if ( is_vip == 0) {
//        UIAlertController *alertVC;
//        if ([roles isEqualToString:@"1"]) {
//            alertVC= [UIAlertController alertControllerWithTitle:@"升级为雇主才可以查看信息哦.." message:nil preferredStyle:UIAlertControllerStyleAlert];
//        }else{
//            alertVC= [UIAlertController alertControllerWithTitle:@"赶快去升级VIP吧..." message:nil preferredStyle:UIAlertControllerStyleAlert];
//        }
//        
//        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }]];
//        [alertVC addAction:[UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            PermissionUpdateViewController *vc = [PermissionUpdateViewController new];
//            self.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//            self.hidesBottomBarWhenPushed = NO;
//            
//        }]];
//        
//        [self presentViewController:alertVC animated:YES completion:NULL];
//        
//    }else{
    
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"找他聊聊" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"电话聊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",workData.phone];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.navigationController.view addSubview:callWebview];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"在线聊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.chatData = workData;
            //数据源方法，要传递数据必须加上
            [[RCIM sharedRCIM] setUserInfoDataSource:self];
            RCConversationViewController *chat = [[RCConversationViewController alloc] init];
            //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等0
            chat.conversationType = ConversationType_PRIVATE;
            //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
            chat.targetId = workData.uid;
            
            //设置聊天会话界面要显示的标题
            chat.title = workData.name;
            //显示聊天会话界面
            chat.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chat animated:YES];
    
            
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alertVC animated:YES completion:NULL];
        
//    }

}

#pragma mark - 融云代理 -


- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion {
    
    //自己的信息
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    
    if ([uid isEqualToString:userId]) {
        
        RCUserInfo *user = [RCIM sharedRCIM].currentUserInfo;
        return completion(user);
    }else{
        RCUserInfo *user = [[RCDataBaseManager shareInstance]getUserByUserId:userId];
        if (user) {
            return completion(user);
        }else{
            [[NetworkSingletion sharedManager]getUserInfo:@{@"uid":userId} onSucceed:^(NSDictionary *dict) {
                
                if ([dict[@"code"] integerValue]==0) {
                    NSString* portraitUrl;
                    NSString *avatar = [dict[@"data"] objectForKey:@"avatar"];
                    if (![NSString isBlankString:avatar]) {
                        portraitUrl = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,avatar];
                    }else{
                        portraitUrl = @"";
                    }
                    NSString *name = [dict[@"data"] objectForKey:@"name"];
                    if ([NSString isBlankString:name]) {
                        name = @"";
                    }
                    RCUserInfo *user = [[RCUserInfo alloc]initWithUserId:userId name:name portrait:portraitUrl];
                    [[RCDataBaseManager shareInstance] insertUserToDB:user];
                    
                    return completion(user);
                    
                }
            } OnError:^(NSString *error) {
            }];
        }
        
    }

}



#pragma mark UICollection delegate & datasource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.workerTypeArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"ToolCollectionCell";
    ToolCollectionCell *cell = (ToolCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (self.workerTypeArray.count > 0) {
        [cell setHeadImgViewWithUrl:nil Title:[self.workerTypeArray[indexPath.row] objectForKey:@"type_name"]];
        cell.dict = self.workerTypeArray[indexPath.row];
    }
    cell.delegate = self;
    
    return cell;
}

-(void)clickCollectionCell:(NSString *)workID
{
//    NSLog(@"8888***%@",workID);
    SWNearbyWorkerController *nearbyController = [[SWNearbyWorkerController alloc] init];
    nearbyController.select_wid = workID;
    nearbyController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nearbyController animated:YES];
}

#pragma mark ---------- 地图的delegate start ------------

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
    [_mapView updateLocationData:userLocation];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //普通态
    //以下_mapView为BMKMapView对象
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView updateLocationData:userLocation];
    
    if(userLocation.location.coordinate.latitude != 0.0 && userLocation.location.coordinate.longitude != 0.0 && !_is_upload) {
    _is_upload = YES;
        [self uploadMyPosition:^{
           
            [self loadData];
            
        } latitude:userLocation.location.coordinate.latitude longtitude:userLocation.location.coordinate.longitude];
        
    }
}

////在地图上显示用户或工人信息
//- (void)showLocation:(double)latitude longitude:(double)longitude title:(NSString *)title subtitle:(NSString *)subtitle user_id:(NSString *)user_id{
//    
//    //添加覆盖层
//    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
//    //设置经纬度
//    CLLocationCoordinate2D coor;
//    coor.latitude = latitude;
//    coor.longitude = longitude;
//    annotation.coordinate = coor;
//    annotation.title = title;
//    annotation.tag = user_id;
//    annotation.subtitle = subtitle;
//    [_mapView addAnnotation:annotation];
//    [_locationArr addObject:annotation];
//}

//// Override
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
//        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
//        newAnnotationView.image = [UIImage imageNamed:@"location"];
//        
//        BMKActionPaopaoView *paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:nil];
//        newAnnotationView.paopaoView = paopaoView;
//        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
//        [paopaoView addGestureRecognizer:tapGes];
//        
//        return newAnnotationView;
//    }
//    return nil;
//}

#pragma mark ---------- 地图的delegate start ------------

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    
    BMKPointAnnotation *pointAnnotation = view.annotation;
    
    if([pointAnnotation.title isEqualToString:@"我的位置"]) {
        _select_workerId = @"0";
        return;
        
    }
    
    NSLog(@"%s:%@",__func__,pointAnnotation.tag);
    _select_workerId = pointAnnotation.tag;
    
}

- (void)select:(UITapGestureRecognizer *)tapGesture {
    
    if([_select_workerId isEqualToString:@"0"]) {
    
        return;
        
    }
    
    NSString *workerName = @"";
    for (SWWorkerData *data in _workerArr) {
        
        if([data.uid isEqualToString:_select_workerId]){
            
            workerName = data.name;
            
        }
        
    }
    
    SWWorkerDetailController *workerView = [[SWWorkerDetailController alloc] init];
    workerView.uid = _select_workerId;
    workerView.workerName = workerName;
    workerView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:workerView animated:YES];
    
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

@end
