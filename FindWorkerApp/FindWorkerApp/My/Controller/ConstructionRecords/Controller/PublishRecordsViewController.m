//
//  PublishRecordsViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/5/11.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "PublishRecordsViewController.h"

#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

#import "CXZ.h"



@interface PublishRecordsViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,ZLPhotoPickerBrowserViewControllerDelegate,CLLocationManagerDelegate,UITextViewDelegate>

{
    CLLocationManager *_locationManager;//用于获取位置
    CLLocation *_checkLocation;//用于保存位置信息
}

@property(nonatomic, strong)BMKLocationService *locService;

@property(nonatomic, strong)BMKGeoCodeSearch *geocodesearch;

@property(nonatomic, strong)UIScrollView *scrollView;

@property(nonatomic, strong)UITextView *contentTextView;

@property(nonatomic, strong)UILabel *adressLabel;

@property(nonatomic, strong)UIButton *selectedButton;

@property(nonatomic, strong)UIView *photoBgView;

@property (nonatomic ,strong) UIButton * publishBtn;


@property(nonatomic, strong)NSMutableArray *imgArray;

@property (nonatomic , strong) NSMutableArray *assets;

@property (nonatomic , strong) NSMutableArray *photos;

@property(nonatomic ,assign)BOOL isCommit;

@property (nonatomic, copy) NSString *locationString ;


@end

@implementation PublishRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackw];
    [self setupTitleWithString:@"发布施工记录" withColor:[UIColor whiteColor]];
    
    [self config];
    
    [self photoViews];
    
    
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

#pragma mark PrivateMethod

-(void)config
{
    _scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    
    _contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH-16, 100)];
    _contentTextView.layer.borderColor = UIColorFromRGB(233, 233, 233).CGColor;
    _contentTextView.layer.cornerRadius = 5.0;
    _contentTextView.layer.borderWidth = 0.8;
    _contentTextView.textColor = UIColorFromRGB(233, 233, 233);
    _contentTextView.delegate = self;
    _contentTextView.text = @"说点什么吧...";
    _contentTextView.font = [UIFont systemFontOfSize:14];
    [_scrollView addSubview:_contentTextView];
    
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedButton.frame = CGRectMake(_contentTextView.left, _contentTextView.bottom+2, 20, 20);
    [_selectedButton setImage:[UIImage imageNamed:@"dow_select"] forState:UIControlStateNormal];
    [_selectedButton addTarget:self action:@selector(clickSelectedAddress) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_selectedButton];
    
    _adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_selectedButton.right, _selectedButton.top, SCREEN_WIDTH-_selectedButton.right-8, 20)];
    _adressLabel.font = [UIFont systemFontOfSize:12];
    _adressLabel.textColor = TITLECOLOR;
    [_scrollView addSubview:_adressLabel];
    
    _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _publishBtn.frame = CGRectMake(16, self.view.frame.size.height-150, SCREEN_WIDTH-32, 40);
    _publishBtn.layer.cornerRadius = 5;
    _publishBtn.layer.borderColor = TOP_GREEN.CGColor;
    _publishBtn.layer.borderWidth = 0.8;
    [_publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    _publishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_publishBtn setTitleColor:TOP_GREEN forState:UIControlStateNormal];
    [_publishBtn addTarget:self action:@selector(clickPublishButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_publishBtn];
    [self.view bringSubviewToFront:_publishBtn];
}

-(void)clickSelectedAddress
{
    NSData *tempData = UIImagePNGRepresentation([UIImage imageNamed:@"dow_unselect"]);
    UIImage *image = _selectedButton.imageView.image;
    NSData *data = UIImagePNGRepresentation(image);
    if ([data isEqualToData:tempData]) {
        [_selectedButton setImage:[UIImage imageNamed:@"dow_select"] forState:UIControlStateNormal];
        self.locationString = self.adressLabel.text;
    }else{
        [_selectedButton setImage:[UIImage imageNamed:@"dow_unselect"] forState:UIControlStateNormal];
        self.locationString = @"";
    }
        
    
}

-(void)clickPublishButton
{
    if ([self.contentTextView.text isEqualToString:@"说点什么吧..."]) {
        self.contentTextView.text = @" ";
    }
    NSMutableArray *tokenArray = [NSMutableArray array];
    UIImage *image = [self.photos lastObject];
    if ([image isEqual:[UIImage imageNamed:@"上传照片.jpg"]]) {
        [self.photos removeLastObject];
    }
    if (!self.isCommit) {
        [SVProgressHUD show];
        dispatch_group_t _group = dispatch_group_create();
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_queue_t queue=dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
        
        for (int i = 0; i < self.photos.count; i++) {
            
            dispatch_group_async(_group, queue, ^{
                
                [[NetworkSingletion sharedManager]getQiNiuToken:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} onSucceed:^(NSDictionary *dict) {
                    if ([dict[@"code"] integerValue]==0) {
                        NSString *imageToken = [dict objectForKey:@"data"];
                        [tokenArray addObject:imageToken];
                        self.isCommit = YES;
                    }else{
                        [SVProgressHUD dismiss];
                        [MBProgressHUD showError:dict[@"message"] toView:self.view];
                        self.isCommit = NO;
                        return ;
                    }
                    dispatch_semaphore_signal(semaphore);// +1
                    
                } OnError:^(NSString *error) {
                    [SVProgressHUD dismiss];
                    [MBProgressHUD showError:error toView:self.view];
                }];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // -1
                
            });
        }
        dispatch_group_notify(_group, queue, ^{
            //所有请求返回数据后执行
            [self uploadImageToQNFilePath:self.photos token:tokenArray];
        });
    }
}

-(void)commitRecordsList:(NSArray*)imgArray
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSDictionary *paramDict = @{@"uid":uid,
                                @"contract_id":self.constractId,
                                @"content":self.contentTextView.text,
                                @"position":self.locationString,
                                @"picture":[NSString dictionaryToJson:imgArray ]};
    [[NetworkSingletion sharedManager]uploadConstructionRecordsNew:paramDict  onSucceed:^(NSDictionary *dict) {
        //        NSLog(@"******%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}

-(void)photoViews
{
    NSInteger num = self.photos.count /4;
    NSInteger count = self.photos.count%4 == 0 ? num : (num+1);
    CGFloat width = (SCREEN_WIDTH-32-15)/4;
    CGFloat top = 140;
    
    [self.imgArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.imgArray removeAllObjects];

    for (int i = 0; i < count; i++) {
        if (4*i +0 < self.photos.count) {
            UIImageView *imgview = [[UIImageView alloc]init];
            imgview.image = self.photos[4*i +0];
            imgview.tag = 4*i +0;
            imgview.contentMode = UIViewContentModeScaleAspectFill;
            imgview.layer.masksToBounds = YES;
            [_scrollView addSubview:imgview];
            imgview.frame = CGRectMake(8, top+(width+5)*i, width, width);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotos:)];
            imgview.userInteractionEnabled = YES;
            [imgview addGestureRecognizer:tap];
            [self.imgArray addObject:imgview];
        }
        if (4*i +1 < self.photos.count) {
            UIImageView *imgview = [[UIImageView alloc]init];
            imgview.image = self.photos[4*i +1];
            imgview.tag = 4*i +1;
            [_scrollView addSubview:imgview];
            imgview.contentMode = UIViewContentModeScaleAspectFill;
            imgview.layer.masksToBounds = YES;
            imgview.frame = CGRectMake(8+width+5, top+(width+5)*i, width, width);
            [self.imgArray addObject:imgview];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotos:)];
            imgview.userInteractionEnabled = YES;
            [imgview addGestureRecognizer:tap];
        }
        if(4*i +2 < self.photos.count){
            UIImageView *imgview = [[UIImageView alloc]init];
            imgview.image = self.photos[4*i +2];
            imgview.tag = 4*i +2;
            [_scrollView addSubview:imgview];
            imgview.contentMode = UIViewContentModeScaleAspectFill;
            imgview.layer.masksToBounds = YES;
            imgview.frame = CGRectMake(8+(width+5)*2, top+(width+5)*i, width, width);
            [self.imgArray addObject:imgview];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotos:)];
            imgview.userInteractionEnabled = YES;
            [imgview addGestureRecognizer:tap];
        }
        if(4*i +3 < self.photos.count){
            UIImageView *imgview = [[UIImageView alloc]init];
            imgview.image = self.photos[4*i +3];
            imgview.tag = 4*i +3;
            [_scrollView addSubview:imgview];
            imgview.contentMode = UIViewContentModeScaleAspectFill;
            imgview.layer.masksToBounds = YES;
            imgview.frame = CGRectMake(8+(width+5)*3, top+(width+5)*i, width, width);
            [self.imgArray addObject:imgview];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotos:)];
            imgview.userInteractionEnabled = YES;
            [imgview addGestureRecognizer:tap];
        }
        
    }
    CGFloat bgHeight = count *width;

    
//    NSLog(@"**height %lf ****%li",bgHeight,count);
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 150+bgHeight+5);
    _scrollView.height = 150+bgHeight+5;
}

#pragma mark 七牛相关
- (void)uploadImageToQNFilePath:(NSArray *)imageArray token:(NSArray*)imageTokenArray{
    
    NSMutableArray *hashArray = [NSMutableArray array];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue=dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < imageArray.count; i++) {
        
        NSString *filePath = [self getImagePath:imageArray[i] index:i];
        dispatch_group_async(group, queue, ^{
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
                //        NSLog(@"percent == %.2f", percent);
            }
                                                                         params:nil
                                                                       checkCrc:NO
                                                             cancellationSignal:nil];
            [upManager putFile:filePath key:nil token:imageTokenArray[i] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                //        NSLog(@"info ===== %@", info);
                //        NSLog(@"resp ===== %@", resp);
                NSString *hash = [resp objectForKey:@"hash"];
                [hashArray addObject:hash];
                dispatch_semaphore_signal(semaphore);
            }
                        option:uploadOption];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
        
    }
    [SVProgressHUD dismiss];
    dispatch_group_notify(group, queue, ^{
        //所有请求返回数据后执行
        [self commitRecordsList:hashArray];
    });
    
}

//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image index:(NSInteger)index
{
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [NSString stringWithFormat:@"/theImage%li.png",index];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}


#pragma mark 上传照片

-(void)addPhotos:(UITapGestureRecognizer*)tap
{
    UIImageView *imgView = (UIImageView*)tap.view;
    UIImage *tempImg = [UIImage imageNamed:@"上传照片.jpg"];
    NSData *tempData = UIImagePNGRepresentation(tempImg);
    NSData *data = UIImagePNGRepresentation(imgView.image);
    if ( [data isEqualToData:tempData]) {
        
        [self takePhoto];
//        UIActionSheet *myActionSheet = [[UIActionSheet alloc]
//                                        initWithTitle:nil
//                                        delegate:self
//                                        cancelButtonTitle:@"取消"
//                                        destructiveButtonTitle:nil
//                                        otherButtonTitles: @"从相册选择", @"拍照",nil];
//        [myActionSheet showInView:self.view];
        
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:imgView.tag inSection:0];
        // 图片游览器
        ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
        // 淡入淡出效果
        // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
        // 数据源/delegate
        pickerBrowser.editing = YES;
        pickerBrowser.photos = self.assets;
        // 能够删除
        pickerBrowser.delegate = self;
        // 当前选中的值
        pickerBrowser.currentIndex = indexPath.row;
        // 展示控制器
        [pickerBrowser showPickerVc:self];
    }
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //从相册选择
            [self localPhoto];
            break;
        case 1:
            //拍照
            [self takePhoto];
            break;
        default:
            break;
    }
}

//相册
-(void)localPhoto
{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    pickerVc.maxCount = 20;
    // Jump AssetsVc
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // Recoder Select Assets
    pickerVc.selectPickers = self.assets;
    // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    // Desc Show Photos, And Suppor Camera
    pickerVc.topShowPhotoPicker = YES;
    // CallBack
    __weak typeof(self)weakSelf = self;
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:status.count];
        for (ZLPhotoAssets *assets in status) {
            ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:assets];
            photo.asset = assets;
            [photos addObject:[assets originImage]];
            [weakSelf.assets addObject:photo];
        }
        [weakSelf.photos removeAllObjects];
        [weakSelf.photos addObjectsFromArray:photos];
        [weakSelf.photos addObject:[UIImage imageNamed:@"上传照片.jpg"]];
        [weakSelf photoViews];
    };
    [pickerVc showPickerVc:self];
}

//拍照
-(void)takePhoto
{
    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
    if (self.assets.count >= 20) {
        cameraVc.maxCount = 0;
    }else{
        cameraVc.maxCount = 20 - self.assets.count;
    }
    __weak typeof(self) weakSelf = self;
    
    cameraVc.callback = ^(NSArray *cameras){
//        NSLog(@"cameras  %li",cameras.count);
        [weakSelf.photos removeLastObject];
        for (ZLCamera *camera in cameras) {
            [weakSelf.photos addObject:[camera photoImage]];
            ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:[camera photoImage]];
            [weakSelf.assets addObject:photo];
        }
        [weakSelf.photos addObject:[UIImage imageNamed:@"上传照片.jpg"]];
        [weakSelf photoViews];
        
    };
    [cameraVc showPickerVc:self];
}
#pragma mark ZLPhotoPickerBrowserViewControllerDelegate

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
    if (self.assets.count > index) {
        [self.assets removeObjectAtIndex:index];
        [self.photos removeObjectAtIndex:index];
        [self photoViews];
    }
}

#pragma mark UITextView Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    textView.text = @"";
    return YES;
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
        
//                        NSLog(@"地理位置--%@%@%@%@%",admin,city,subLocality,thorough);
        self.adressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",admin,city,subLocality,thorough];
        self.locationString = [NSString stringWithFormat:@"%@%@%@%@",admin,city,subLocality,thorough];
    }];
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败%@",[error description] );

}



#pragma mark SET/GET

-(NSMutableArray*)imgArray
{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
        
    }
    return _imgArray;
}

-(NSMutableArray*)photos
{
    if (!_photos) {
        _photos = [NSMutableArray array];
        UIImage *img = [UIImage imageNamed:@"上传照片.jpg"];
        [_photos addObject:img];
    }
    return _photos;
}
-(NSMutableArray*)assets
{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}


@end
