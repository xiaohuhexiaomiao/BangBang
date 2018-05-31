//
//  PublishStatusViewController.m
//  fansClient
//
//  Created by cxz on 2017/3/6.
//  Copyright © 2017年 com.gyl.team. All rights reserved.
//

#import "PublishStatusViewController.h"


@interface PublishStatusViewController ()<UIActionSheetDelegate,UITextViewDelegate,ZLPhotoPickerBrowserViewControllerDelegate>

@property(nonatomic, strong)UIScrollView *scrollView;

//@property(nonatomic, strong)UITextView *contentView;

@property (nonatomic, strong)UITextField *titleTxtfield;

@property (nonatomic, strong)UILabel *startLabel;

@property (nonatomic, strong)UILabel *endLabel;

@property(nonatomic, strong)UIView *photoBgView;

@property(nonatomic, strong)NSMutableArray *imgArray;

@property (nonatomic , strong) NSMutableArray *assets;

@property (nonatomic , strong) NSMutableArray *photos;

@property(nonatomic ,assign)BOOL isCommit;
@end

@implementation PublishStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"发布作品" withColor:[UIColor whiteColor]];
    [self setupNextWithString:@"发布" withColor:TOP_GREEN];
    self.view.backgroundColor = UIColorFromRGB(243, 243, 243);
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(addStatus)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self config];
    
    [self photoViews];
    
    
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
    
    UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 75, 22)];
    tLabel.text = @"作品名称：";
    tLabel.textColor = TITLECOLOR;
    tLabel.font = [UIFont systemFontOfSize:14];
    [_scrollView addSubview:tLabel];
    
    _titleTxtfield = [[UITextField alloc]initWithFrame:CGRectMake(tLabel.right , tLabel.top, SCREEN_WIDTH-tLabel.right-8, tLabel.height)];
    _titleTxtfield.borderStyle = UITextBorderStyleRoundedRect;
    _titleTxtfield.font = [UIFont systemFontOfSize:14];
    _titleTxtfield.layer.borderColor = [UIColor grayColor].CGColor;
    _titleTxtfield.layer.borderWidth = 0.5;
    _titleTxtfield.layer.cornerRadius = 5;
    [_scrollView addSubview:_titleTxtfield];
    
    UILabel *sLabel = [[UILabel alloc]initWithFrame:CGRectMake(tLabel.left , tLabel.bottom+8, tLabel.width, tLabel.height)];
    sLabel.text = @"开工时间：";
    sLabel.textColor = TITLECOLOR;
    sLabel.font = [UIFont systemFontOfSize:14];
    [_scrollView addSubview:sLabel];
    
    _startLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleTxtfield.left, sLabel.top, _titleTxtfield.width, sLabel.height)];
    _startLabel.font = [UIFont systemFontOfSize:14];
    _startLabel.textColor = TITLECOLOR;
    _startLabel.layer.borderColor = [UIColor grayColor].CGColor;
    _startLabel.layer.borderWidth = 0.5;
    _startLabel.layer.cornerRadius = 5;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTime:)];
    _startLabel.tag= 1;
    _startLabel.userInteractionEnabled = YES;
    [_startLabel addGestureRecognizer:tap1];
    [_scrollView addSubview:_startLabel];
    
    UILabel *eLabel = [[UILabel alloc]initWithFrame:CGRectMake(sLabel.left , sLabel.bottom+8, tLabel.width, tLabel.height)];
    eLabel.text = @"结束时间：";
    eLabel.textColor = TITLECOLOR;
    eLabel.font = [UIFont systemFontOfSize:14];
    [_scrollView addSubview:eLabel];
    
    _endLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleTxtfield.left, eLabel.top, _titleTxtfield.width, eLabel.height)];
    _endLabel.font = [UIFont systemFontOfSize:14];
    _endLabel.textColor = TITLECOLOR;
    _endLabel.layer.borderColor = [UIColor grayColor].CGColor;
    _endLabel.layer.borderWidth = 0.5;
    _endLabel.layer.cornerRadius = 5;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTime:)];
    _endLabel.tag= 2;
    _endLabel.userInteractionEnabled = YES;
    [_endLabel addGestureRecognizer:tap2];
    [_scrollView addSubview:_endLabel];
    
    
}

-(void)selectTime:(UITapGestureRecognizer*)tap
{
    [self.titleTxtfield resignFirstResponder];
    
    NSInteger tag = ((UILabel*)tap.view).tag;
    
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.maximumDate = [NSDate date];
    picker.frame = CGRectMake(0, 40, 320, 200);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择时间\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSDate *date = picker.date;
        if (tag == 1) {
            _startLabel.text = [date stringWithFormat:@"yyyy-MM-dd"];
        }else{
            _endLabel.text = [date stringWithFormat:@"yyyy-MM-dd"];
        }
        
        
    }];
    [alertController.view addSubview:picker];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)photoViews
{
    NSInteger count = self.photos.count >= 9 ? 9 : self.photos.count;
    UIImageView *lastImg;
    UIImageView *sLastImg;
    CGFloat width = (SCREEN_WIDTH-32-15)/4;

    [self.imgArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.imgArray removeAllObjects];
    for (int i = 0; i < count; i++) {
        if (i <= 3) {
            UIImageView *imgview = [[UIImageView alloc]init];
            imgview.image = self.photos[i];
            imgview.tag = i;
            imgview.contentMode = UIViewContentModeScaleAspectFill;
            imgview.layer.masksToBounds = YES;
            [_scrollView addSubview:imgview];
            imgview.frame = CGRectMake(16+(width+5)*i, _endLabel.bottom+20, width, width);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotos:)];
            imgview.userInteractionEnabled = YES;
            [imgview addGestureRecognizer:tap];
            [self.imgArray addObject:imgview];
            lastImg = imgview;
        }
        if (i > 3 && i <= 7) {
            UIImageView *imgview = [[UIImageView alloc]init];
            imgview.image = self.photos[i];
            imgview.tag = i;
            [_scrollView addSubview:imgview];
            imgview.contentMode = UIViewContentModeScaleAspectFill;
            imgview.layer.masksToBounds = YES;
            CGFloat leftFloat = 16+(i-4)*(width+5);
            imgview.frame = CGRectMake(leftFloat, lastImg.bottom+5, width, width);
             [self.imgArray addObject:imgview];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotos:)];
            imgview.userInteractionEnabled = YES;
            [imgview addGestureRecognizer:tap];
            sLastImg = imgview;
        }
        if(i > 7){
            UIImageView *imgview = [[UIImageView alloc]init];
            imgview.image = self.photos[i];
            imgview.tag = i;
            [_scrollView addSubview:imgview];
            imgview.contentMode = UIViewContentModeScaleAspectFill;
            imgview.layer.masksToBounds = YES;
            CGFloat leftFloat = 16+(i-8)*(width+5);
            imgview.frame = CGRectMake(leftFloat, sLastImg.bottom+5, width, width);
            [self.imgArray addObject:imgview];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotos:)];
            imgview.userInteractionEnabled = YES;
            [imgview addGestureRecognizer:tap];
        }
            
    }
    CGFloat bgHeight;
    if (count %4 > 0) {
        bgHeight = ((NSInteger)count/4+1)*width;
    }else{
        bgHeight =((NSInteger)count/4)*width;
    }
//    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(180+bgHeight+5);
//    }];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 130+bgHeight+5);
    _scrollView.height = 130+bgHeight+5;
}

-(void)addPhotos:(UITapGestureRecognizer*)tap
{
    UIImageView *imgView = (UIImageView*)tap.view;
    UIImage *tempImg = [UIImage imageNamed:@"上传照片.jpg"];
    NSData *tempData = UIImagePNGRepresentation(tempImg);
    NSData *data = UIImagePNGRepresentation(imgView.image);
    if ( [data isEqualToData:tempData]) {
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                        initWithTitle:nil
                                        delegate:self
                                        cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles: @"从相册选择", @"拍照",nil];
        [myActionSheet showInView:self.view];
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

-(void)localPhoto
{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    pickerVc.maxCount = 9;
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
            [photos addObject:[assets thumbImage]];
            [weakSelf.assets addObject:photo];
        }
        [weakSelf.photos removeAllObjects];
        [weakSelf.photos addObjectsFromArray:photos];
        [weakSelf.photos addObject:[UIImage imageNamed:@"上传照片.jpg"]];
        [weakSelf photoViews];
    };
    [pickerVc showPickerVc:self];
}

-(void)takePhoto
{
    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
    if (self.assets.count >= 9) {
        cameraVc.maxCount = 0;
    }else{
        cameraVc.maxCount = 9 - self.assets.count;
    }
    __weak typeof(self) weakSelf = self;
    cameraVc.callback = ^(NSArray *cameras){
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

-(void)onNext
{
    [self.photos removeLastObject];
    if ([NSString isBlankString:self.titleTxtfield.text]) {
        [MBProgressHUD showError:@"请输入作品名称" toView:self.view];
        return;
    }
    
    if ([NSString isBlankString:self.startLabel.text]) {
        [MBProgressHUD showError:@"请选择开工时间" toView:self.view];
        return;
    }
    if ([NSString isBlankString:self.endLabel.text]) {
        [MBProgressHUD showError:@"请选择结束时间" toView:self.view];
        return;
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

-(void)commitProductionWith:(NSArray*)imgArray
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSDictionary *paramDict = @{@"uid":uid,@"content":self.titleTxtfield.text,
                                @"works_time":self.startLabel.text,
                                @"works_end_time":self.endLabel.text,
                                @"picture":[NSString dictionaryToJson:imgArray ]};
    [[NetworkSingletion sharedManager]uploadMyProductionNew:paramDict onSucceed:^(NSDictionary *dict) {
                NSLog(@"*upalo****%@",dict);
                 NSLog(@"*****%@",dict[@"message"]);
        if ([dict[@"code"] integerValue]==0) {
            [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            self.isCommit = NO;
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
        
    } OnError:^(NSString *error) {
        self.isCommit = NO;
        [MBProgressHUD showError:error toView:self.view];
    }];
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
        
        [self commitProductionWith:hashArray];
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

#pragma mark ZLPhotoPickerBrowserViewControllerDelegate

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
    if (self.assets.count > index) {
        [self.assets removeObjectAtIndex:index];
        [self.photos removeObjectAtIndex:index];
        [self photoViews];
    }
}

#pragma mark UITextview Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    return YES;
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
