//
//  SWMyLocationController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/28.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMyLocationController.h"

#import "CXZ.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import "SWPublishController.h"

#define padding 10

@interface SWMyLocationController ()<UITableViewDelegate,UITableViewDataSource,BMKGeoCodeSearchDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate>

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic, strong) BMKPoiSearch *poiSearch;

@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;

@property (nonatomic, strong) UITableView *nearByContent;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, assign) BOOL isFirst; // 判断是不是第一次定位

@end

@implementation SWMyLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isFirst = YES;
    
    [self setupBackw];
    
    [self setupTitleWithString:@"周边" withColor:[UIColor whiteColor]];
    
    [self initWithView];
    

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
     _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poiSearch.delegate = self;
//     _mapView.showsUserLocation = YES;//显示定位图层
    //定位到自己的位置
    [_mapView updateLocationData:_locService.userLocation];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];

}

- (void) dealloc{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geocodesearch.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poiSearch.delegate = nil;
    
}

#pragma mark -------- 设置导航栏信息 start ---------------

//设置标题
-(void)setupTitleWithString:(NSString *)text withColor:(UIColor *)color{
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-30, 0, 60, TITLE_BAR_HEIGHT)];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = text;
    
    titleView.textColor = color;
    self.navigationItem.titleView = titleView;
}

//设置返回按钮
- (void) setupBackw{
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 20, 20);
    [back setImage:[UIImage imageNamed:@"secondBack"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = rightItem;
}

- (void)onBack {
    UIViewController * controller=[self.navigationController.viewControllers objectAtIndex:0];
    if(controller == self) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -------- 设置导航栏信息 end ---------------

//初始化界面
- (void)initWithView {
    
    CGFloat maxH = [self showWorkerData];
    
    //百度地图
    if (!_mapView) {
        _mapView      = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - maxH - 64)];
      
        _mapView.zoomLevel = 12.5; //地图的放大倍数
        [self.view addSubview:_mapView];
    }
    
   
  
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [_mapView setMapType:BMKMapTypeStandard];
    
    //初始化BMKLocationService
    BMKLocationService *locationService = [[BMKLocationService alloc] init];
    
    //启动LocationService
    [locationService startUserLocationService];
    _locService = locationService;
    
    //初始化检索对象
    _poiSearch =[[BMKPoiSearch alloc]init];
    
    
    //地理查找初始化
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
   
    
}

- (CGFloat)showWorkerData {
    
    CGFloat workH = SCREEN_HEIGHT / 2;
    CGFloat workY = SCREEN_HEIGHT - workH - 64;
    
    _nearByContent = [[UITableView alloc] init];
    _nearByContent.showsVerticalScrollIndicator = NO;
    _nearByContent.dataSource = self;
    _nearByContent.delegate = self;
    _nearByContent.frame   = CGRectMake(0, workY, SCREEN_WIDTH, workH);
    _nearByContent.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    [self.view addSubview:_nearByContent];

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        
    }];
    
    [footer setTitle:@"下拉加载更多" forState:MJRefreshStateIdle];
    
    _nearByContent.mj_footer = footer;
    return workH;
    
}



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
        NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //普通态
    //以下_mapView为BMKMapView对象
    [_mapView updateLocationData:userLocation];
    
    if(userLocation.location.coordinate.latitude != 0.0f && userLocation.location.coordinate.longitude != 0.0f && _isFirst) {
        
        //反地理编码
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = pt;
        BOOL flag1= [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if(flag1)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
        
        _isFirst = NO;
        
    }
    
}



/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    //反地理编码
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){coordinate.latitude, coordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag1= [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag1)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}

//反地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        
        //发起检索
        BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
        option.pageIndex = 1;
        option.pageCapacity = 50;
        option.radius = 1000;
        option.location = CLLocationCoordinate2DMake(result.location.latitude, result.location.longitude);
        option.keyword = @"房子";
        BOOL flag = [_poiSearch poiSearchNearBy:option];
        if(flag)
        {
            NSLog(@"周边检索发送成功");
        }
        else
        {
            NSLog(@"周边检索发送失败");
        }
        
    }
}

// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"location"];
    
        
        return newAnnotationView;
    }
    return nil;
}

//POI搜索结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
//        NSLog(@"%@",poiResultList.poiInfoList);
        NSMutableArray *arr = [NSMutableArray array];
        for (BMKPoiInfo *info in poiResultList.poiInfoList) {
            
            if(![arr containsObject:info.address]){
                
                [arr addObject:info.address];
                
            }
            
        }
        
        _dataArr = arr;
        [_nearByContent reloadData];
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark -------- tableView delegate & dataSource start -----------


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"CELLID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    NSString *info = _dataArr[indexPath.row];
    
    cell.textLabel.text = info;
    
    return cell;
                             
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    if([viewController isKindOfClass:[SWPublishController class]]) {
        NSString *info = _dataArr[indexPath.row];
        SWPublishController *pubulishController = (SWPublishController *)viewController;
        pubulishController.location = info;
        [self.navigationController popToViewController:pubulishController animated:YES];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate clickMyLocation:_dataArr[indexPath.row]];
    }
    
    
}



#pragma mark -------- tableView delegate & dataSource end -----------


@end
