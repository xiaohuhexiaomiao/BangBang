//
//  WorkSignViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/15.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "WorkSignViewController.h"
#import "CXZ.h"

#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <CoreLocation/CoreLocation.h>

#import "SWMyLocationController.h"

#import "DiaryFileView.h"
#import "DiarySendRangeView.h"

@interface WorkSignViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,CLLocationManagerDelegate,MyLocationControllerDelegate>
{
    CLLocationManager *_locationManager;//用于获取位置
    CLLocation *_checkLocation;//用于保存位置信息
}

@property(nonatomic ,strong) UIButton *locationButton;

@property(nonatomic ,strong) UITextView *contentView;

@property(nonatomic ,strong) DiaryFileView *fileView;

@property(nonatomic , strong) DiarySendRangeView *rangeView;

@property(nonatomic ,copy) NSString *locoalString;

@property(nonatomic ,assign) CGFloat longitude;

@property(nonatomic ,assign) CGFloat latitude;

@end

@implementation WorkSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"签到" withColor:[UIColor whiteColor]];
    [self setupNextWithString:@"发送" withColor:[UIColor whiteColor]];
    
    [self config];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark Public Method

-(void)onBack
{
    [self.fileView removeObserver:self forKeyPath:@"height"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNext
{
    NSMutableArray *hushArray = [NSMutableArray array];
    if (self.fileView.imgArray.count > 0) {
        for (int i = 0; i < self.fileView.imgArray.count; i++) {
            UploadImageModel *imgView = self.fileView.imgArray[i];
            if ([NSString isBlankString:imgView.hashString]) {
                [WFHudView showMsg:@"图片正在上传中，请稍后提交.." inView:self.view];
                return;
            }
            [hushArray addObject:imgView.hashString];
            
        }
        [self uploadPhotos:hushArray];
    }else{
        [self publishDayPlanWithImageId:nil];
    }
}


#pragma mark Private Method

-(void)publishDayPlanWithImageId:(NSString*)imageId
{
    NSMutableArray *enclosureArray = [NSMutableArray array];
    if (self.fileView.file_id_array.count > 0) {
        [enclosureArray addObjectsFromArray:self.fileView.file_id_array];
    }
    if (![NSString isBlankString:imageId]) {
        NSDictionary *dict = @{@"contract_id":imageId,@"type":@(3),@"name":@"图片"};
        [enclosureArray addObject:dict];
    }
    NSString *content ;
    if ([NSString isBlankString:self.contentView.text]) {
        content = @"签到";
    }else{
        content = self.contentView.text;
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSDictionary *dict = @{@"company_id":self.company_id,
                           @"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"longitude":@(self.longitude),
                           @"latitude":@(self.latitude),
                           @"describe":self.locoalString,
                           @"remarks":content,
                           };
    [paramDict addEntriesFromDictionary:dict];
    if (enclosureArray.count > 0) {
        [paramDict setObject:[NSString dictionaryToJson:enclosureArray] forKey:@"enclosure"];
    }
    if (self.rangeView.rangeArray.count > 0) {
        [paramDict setObject:[NSString dictionaryToJson:self.rangeView.rangeArray] forKey:@"json"];
    }
    [[NetworkSingletion sharedManager]workOutSignIn:paramDict onSucceed:^(NSDictionary *dict) {
        //        NSLog(@"publish %@",dict);
        if ([dict[@"code"] integerValue]==0) {
            [self.fileView removeObserver:self forKeyPath:@"height"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        
    }];
    
}



//上传附件
-(void)uploadPhotos:(NSMutableArray*)hashArray
{
    NSString *hashStr = [NSString dictionaryToJson:hashArray];
    [[NetworkSingletion sharedManager]updateReviewAnnexNew:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"picture":hashStr} onSucceed:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        if ([dict[@"code"] integerValue]==0) {
            NSInteger enclosureId = [[dict[@"data"] objectForKey:@"enclosure_id"] integerValue];
            [self publishDayPlanWithImageId:[NSString stringWithFormat:@"%li",enclosureId]];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self.view];
        }
    } OnError:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
    
}


-(void)clickLocationButton
{
    SWMyLocationController *myLocationController = [[SWMyLocationController alloc] init];
    myLocationController.delegate = self;
    [self.navigationController pushViewController:myLocationController animated:YES];
}

-(void)clickMyLocation:(NSString *)addressString
{
    self.locoalString = addressString;
    [self.locationButton setTitle:addressString forState:UIControlStateNormal];
}



#pragma mark 界面

-(void)config
{
    _locationButton = [CustomView customButtonWithContentView:self.view image:@"blue_position" title:nil];
    [_locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(8);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(35);
    }];
    _locationButton.layer.cornerRadius = 3;
    _locationButton.layer.masksToBounds = YES;
    _locationButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _locationButton.backgroundColor = FONTBACKGROUNDCOLOR;
    [_locationButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
    _locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_locationButton addTarget:self action:@selector(clickLocationButton) forControlEvents:UIControlEventTouchUpInside];
    
    _contentView = [CustomView customUITextViewWithContetnView:self.view placeHolder:nil];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_locationButton.mas_left);
        make.top.mas_equalTo(_locationButton.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(_locationButton.mas_width);
        make.height.mas_equalTo(100);
    }];
    _contentView.layer.cornerRadius = 3;
    _contentView.layer.masksToBounds = YES;
    _contentView.backgroundColor =  UIColorFromRGB(248, 249, 248);
    
    _rangeView = [[DiarySendRangeView alloc]initWithFrame:CGRectMake(0, _contentView.bottom, SCREEN_WIDTH, 25)];
    _rangeView.company_id = self.company_id;
    _rangeView.commentsButton.hidden = YES;
    [self.view addSubview:_rangeView];
    [_rangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_contentView.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(25);
    }];
    
    _fileView = [[DiaryFileView alloc]initWithFrame:CGRectMake(8, _rangeView.bottom+10, SCREEN_WIDTH-16, 30)];
    [self.view addSubview:_fileView];
    [_fileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_rangeView.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(30);
    }];
    [_fileView addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"height"] ) {
        CGFloat newHeight = [change[@"new"] floatValue];
        //        CGFloat oldMoney = [change[@"old"] floatValue];
        //        NSLog(@"**height*%lf",newHeight);
        [self.fileView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(newHeight);
        }];
       
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark 地理位置相关

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D userCoord = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    //    NSLog(@"纬度--%f 经度--%f",userCoord.latitude,userCoord.longitude);
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *place = placemarks[0];
        NSString *admin = place.administrativeArea;
        NSString *city = place.locality;
        NSString *subLocality = place.subLocality;
        NSString *thorough = place.thoroughfare;
        NSString *subThorough = place.subThoroughfare;
        
//                                NSLog(@"地理位置--%@%@%@%@%",admin,city,subLocality,thorough);
        self.locoalString =  @"";
        if (![NSString isBlankString:admin]) {
            self.locoalString = [self.locoalString stringByAppendingString:admin];
        }
        if (![NSString isBlankString:city]) {
            self.locoalString = [self.locoalString stringByAppendingString:city];
        }
        if (![NSString isBlankString:subLocality]) {
            self.locoalString = [self.locoalString stringByAppendingString:subLocality];
        }
        if (![NSString isBlankString:thorough]) {
            self.locoalString = [self.locoalString stringByAppendingString:thorough];
        }
        NSLog(@"地理位置--%@",self.locoalString);
        if (![NSString isBlankString:self.locoalString]) {
             [self.locationButton setTitle:self.locoalString forState:UIControlStateNormal];
        }
//       self.locoalString = [NSString stringWithFormat:@"%@%@%@%@",admin,city,subLocality,thorough];
//        [self.locationButton setTitle:self.locoalString forState:UIControlStateNormal];
    }];
    self.latitude = userCoord.latitude;
    self.longitude = userCoord.longitude;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败%@",[error description] );
    
}

@end
