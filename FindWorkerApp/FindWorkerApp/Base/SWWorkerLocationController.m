//
//  SWWorkerLocationController.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/5.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWWorkerLocationController.h"

#import "CXZ.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

#import "SWWorkerLocationCmd.h"
#import "SWWorkerLocationInfo.h"
#import "SWWorkerLocationData.h"

@interface SWWorkerLocationController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView *_mapView1;
}

@property (nonatomic, strong) BMKLocationService *locService;



@property (nonatomic, strong) BMKPointAnnotation *annotation;

@property (nonatomic, strong) BMKGeoCodeSearch *searcher;

@end

@implementation SWWorkerLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackw];
    
    //初始化界面
    [self initWithView];
}

- (void)viewWillAppear:(BOOL)animated {
    
//    [super viewWillAppear:animated];
    [_mapView1 viewWillAppear];
    _mapView1.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
     _searcher.delegate = self;

    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView1 viewWillDisappear];
    _mapView1.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _searcher.delegate = nil;
}


- (void) dealloc{
   [_mapView1 viewWillDisappear];
    _mapView1.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _searcher.delegate = nil;
}

- (void)setWorkerName:(NSString *)workerName {
    
    _workerName = workerName;
    
    [self setupTitleWithString:[NSString stringWithFormat:@"%@的位置",_workerName] withColor:[UIColor whiteColor]];
    
}

//初始化界面
- (void)initWithView {
    

    if (!_mapView1) {
        _mapView1      = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];

    }
    [self.view addSubview:_mapView1];
    _mapView1.zoomLevel = 12.5; //地图的放大倍数
    _mapView1.userTrackingMode = BMKUserTrackingModeFollow;
        _mapView1.showsUserLocation = YES;//显示定位图层
    [_mapView1 setMapType:BMKMapTypeStandard];

    
    _annotation = [[BMKPointAnnotation alloc] init];
    //设置经纬度
    CLLocationCoordinate2D coor;
    coor.latitude = self.latitude;
    coor.longitude =self.longtitude;
    _annotation.coordinate = coor;
    [_mapView1 addAnnotation:_annotation];
    _mapView1.centerCoordinate = coor;
    _mapView1.zoomLevel = 15.0;
    
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){self.latitude, self.longtitude};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }else{
        NSLog(@"反geo检索发送失败");
    }

    
}

//实现Deleage处理回调结果
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
   
    if (error == BMK_SEARCH_NO_ERROR) {
        self.annotation.title = [NSString stringWithFormat:@"%@",result.address];
    }
    else {
//        NSLog(@"抱歉，未找到结果");
    }
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

#pragma mark -------- 位置的代理方法 & 覆盖方法 start ----------


// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
//        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"location"];
        
        return newAnnotationView;
    }
    return nil;
}

#pragma mark -------- 位置的代理方法 & 覆盖方法 end ----------

//-(BMKMapView*)mapView{
//    if (!_mapView) {
//         _mapView      = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
//        
//    }
//    return _mapView;
//}

@end
