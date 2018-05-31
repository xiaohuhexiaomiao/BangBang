//
//  DealWithApprovalView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/8/18.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "DealWithApprovalView.h"
#import "CXZ.h"


@interface DealWithApprovalView()<ZLPhotoPickerBrowserViewControllerDelegate,UIActionSheetDelegate>

@property(nonatomic ,strong)UITextView *replyTextfield;

@property(nonatomic ,strong)UIButton *approvalButton;

@property(nonatomic ,strong)UIView *menuView;

@property(nonatomic ,strong)UIButton *photoBtn;

@property(nonatomic ,strong)UIScrollView *imageScrollview;

@property(nonatomic, strong)NSMutableArray *imgArray;

@property (nonatomic , strong) NSMutableArray *assets;

@property (nonatomic , strong) NSMutableArray *photos;

@property (nonatomic , strong) NSString *photo_id;

@property (nonatomic , assign) NSString *agreeStr;

@end

@implementation DealWithApprovalView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineview.backgroundColor = UIColorFromRGB(224, 223, 226);
        [self addSubview:lineview];
        
        _replyTextfield = [[UITextView alloc]initWithFrame:CGRectMake(8, lineview.bottom, SCREEN_WIDTH-98, 38)];
        _replyTextfield.font = [UIFont systemFontOfSize:12];
        [self addSubview:_replyTextfield];
        
        _approvalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _approvalButton.frame = CGRectMake(SCREEN_WIDTH-60, lineview.bottom, 60, 39);
        [_approvalButton setTitle:@"处理" forState:UIControlStateNormal];
        _approvalButton.backgroundColor = GREEN_COLOR;
//        _approvalButton.userInteractionEnabled = YES;
        _approvalButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_approvalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_approvalButton addTarget:self action:@selector(clickApprovalButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_approvalButton];
        
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoBtn.frame =  CGRectMake(SCREEN_WIDTH-90, lineview.bottom, 30, 39);
        [_photoBtn setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
        _photoBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        [_photoBtn addTarget:self action:@selector(clickPhotoButon) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_photoBtn];
        
        _imgArray = [NSMutableArray array];
        _photos = [NSMutableArray array];
        _assets = [NSMutableArray array];
        
    }
    return self;
}

-(void)setApprovalMenueView

{
    if (!self.is_sepcial) {
        if (self.canApproval) {
            _menuView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, self.viewController.view.bottom-160, 60, 60)];
            _menuView.hidden = YES;
            _menuView.backgroundColor = GREEN_COLOR;
            NSArray *titleArray;
            if (self.is_cashier) {
                titleArray = @[@"回执",@"忽略"];
            }else{
                titleArray = @[@"同意",@"不同意"];
            }
            for (int i = 0; i < titleArray.count; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0, 30*i, 60, 30);
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:titleArray[i] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(clickMenueButton:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i;
                button.titleLabel.font = [UIFont systemFontOfSize:12];
                [_menuView addSubview:button];
            }
            
            [self.viewController.view addSubview:_menuView];
        }
        
    }else{
        NSArray *titleArray;
        if (self.canApproval == 1) {
            _menuView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, self.viewController.view.bottom-220, 60, 120)];
            _menuView.hidden = YES;
            _menuView.backgroundColor = GREEN_COLOR;
            
            titleArray = @[@"同意",@"不同意",@"特权-同意",@"特权-不同意"];
        }else{
            _menuView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, self.viewController.view.bottom-160, 60, 60)];
            _menuView.hidden = YES;
            _menuView.backgroundColor = GREEN_COLOR;
            titleArray = @[@"特权-同意",@"特权-不同意"];
        }
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 30*i, 60, 30);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickMenueButton:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [_menuView addSubview:button];
            [self.viewController.view addSubview:_menuView];
        }
    }
}
#pragma mark 点击事件

-(void)clickPhotoButon
{
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: @"从相册选择", @"拍照",nil];
    [myActionSheet showInView:self.viewController.view];
}

-(void)clickApprovalButton:(UIButton*)button
{
    
    [UIView animateWithDuration:0.1 animations:^{
        self.menuView.hidden = NO;
    }];
   
}
-(void)clickMenueButton:(UIButton*)button
{
    [UIView animateWithDuration:0.1 animations:^{
        self.menuView.hidden = YES;
    }];
    NSInteger tag = button.tag;
    if (!self.is_sepcial) {
        if (self.canApproval == 1) {
            if (tag == 0) {
                self.agreeStr = @"1";
            }else if(tag == 1){
                self.agreeStr = @"2";
            }
            if (self.is_cashier) {
                
                [self cashierReply:self.agreeStr];
            }else{
                [self nomallApprovalWith:self.agreeStr];
            }
            
        }
    }else{
        if (self.canApproval == 1) {
            if (tag == 0) {
                self.agreeStr = @"1";
                [self nomallApprovalWith:self.agreeStr];
            }else if(tag == 1){
                self.agreeStr = @"2";
                [self nomallApprovalWith:self.agreeStr];
            }else if(tag == 2){
                self.agreeStr = @"1";
                [self sepecalApprovalWith:self.agreeStr];
            }else if(tag == 3){
                self.agreeStr = @"2";
                [self sepecalApprovalWith:self.agreeStr];
            }
        }else{
            if(tag == 0){
                self.agreeStr = @"1";
                [self sepecalApprovalWith:self.agreeStr];
            }else if(tag == 1){
                self.agreeStr = @"2";
                [self sepecalApprovalWith:self.agreeStr];
            }
        }
    }
    
    
}


#pragma mark 处理数据

-(void)uploadPhoto
{
    NSMutableArray *tokenArray = [NSMutableArray array];
    UIImage *image = [self.photos lastObject];
    if ([image isEqual:[UIImage imageNamed:@"上传照片.jpg"]]) {
        [self.photos removeLastObject];
    }
    dispatch_group_t _group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue=dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    
    for (int i = 0; i < self.photos.count; i++) {
        
        dispatch_group_async(_group, queue, ^{
            
            [[NetworkSingletion sharedManager]getQiNiuToken:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} onSucceed:^(NSDictionary *dict) {
                if ([dict[@"code"] integerValue]==0) {
                    NSString *imageToken = [dict objectForKey:@"data"];
                    [tokenArray addObject:imageToken];
                    
                }
                dispatch_semaphore_signal(semaphore);// +1
                
            } OnError:^(NSString *error) {
                [SVProgressHUD dismiss];
                [MBProgressHUD showError:error toView:self.viewController.view];
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // -1
            
        });
    }
    dispatch_group_notify(_group, queue, ^{
        //所有请求返回数据后执行
        [self uploadImageToQNFilePath:self.photos token:tokenArray];
    });
    
}

-(void)cashierReply:(NSString*)agreeStr
{
    NSString *alertTitle;
    if ( [NSString isBlankString:self.replyTextfield.text]) {
        [WFHudView showMsg:@"请输入回复内容..." inView:self.viewController.view ];
        return;
    }
    if ([agreeStr isEqualToString:@"2"]) {
        alertTitle = @"确定忽略？";
    }else{
        if ( self.photos.count == 0) {
            [WFHudView showMsg:@"请添加图片..." inView:self.viewController.view ];
            return;
        }
        alertTitle = @"确定回执";
    }
    
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:alertTitle  message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.approvalButton.userInteractionEnabled = NO;
        self.approvalButton.backgroundColor = [UIColor grayColor];
        [SVProgressHUD show];
        if ([agreeStr isEqualToString:@"1"]){
            [self uploadPhoto];
        }else{
            if (self.photos.count > 0) {
               [self uploadPhoto];
            }else{
              [self cashierDealWithContent:nil];  
            }
            
        }
        
    }]];
    [self.viewController presentViewController:alerVC animated:YES completion:nil];
}

-(void)nomallApprovalWith:(NSString*)agreeStr
{
    NSString *alertTitle;
    if ([agreeStr isEqualToString:@"2"] && [NSString isBlankString:self.replyTextfield.text]) {
        [WFHudView showMsg:@"请输入拒绝原因..." inView:self.viewController.view ];
        return;
    }
    if ([agreeStr isEqualToString:@"2"]) {
        alertTitle = @"确定要拒绝？";
    }else{
        alertTitle = @"确定同意？";
    }
    
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:alertTitle  message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.approvalButton.userInteractionEnabled = NO;
        self.approvalButton.backgroundColor = [UIColor grayColor];
        [SVProgressHUD show];
        if (self.photos.count > 0) {
            [self uploadPhoto];
        }else{
            [self dealWithContent:nil];
        }
        
    }]];
    [self.viewController presentViewController:alerVC animated:YES completion:nil];
}

-(void)cashierDealWithContent:(NSString*)photo_id
{
    NSDictionary *dict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                           @"personnel_id":self.personal_id,
                           @"finance_state":self.agreeStr,
                           @"receipt_content":self.replyTextfield.text,
                           @"approval_id":self.approvalID,
                           @"company_id":self.company_ID};
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict addEntriesFromDictionary:dict];
    if (![NSString isBlankString:photo_id]) {
        [paramDict setObject:photo_id forKey:@"receipt_pic"];
    }
    [[NetworkSingletion sharedManager]cashierReply:paramDict onSucceed:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        if ([dict[@"code"] integerValue] == 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UPLOAD_CASHIER_NEW_DATA" object:nil];
            [self.viewController.navigationController popViewControllerAnimated:YES];
        }else{
            self.approvalButton.userInteractionEnabled = YES;
            self.approvalButton.backgroundColor = GREEN_COLOR;
            [MBProgressHUD showError:dict[@"message"] toView:self];
        }
    } OnError:^(NSString *error) {
        [SVProgressHUD dismiss];
        self.approvalButton.userInteractionEnabled = YES;
        self.approvalButton.backgroundColor = GREEN_COLOR;
        [MBProgressHUD showError:error toView:self];
    }];
}

-(void)dealWithContent:(NSString*)photo_id
{
    
    if (self.formType == 0) {//公司审批 处理
        NSDictionary *dict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                               @"participation_id":self.participation_id,
                               @"is_agree":self.agreeStr,
                               @"opinion":self.replyTextfield.text,
                               @"approval_id":self.approvalID};
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict addEntriesFromDictionary:dict];
        if (![NSString isBlankString:photo_id]) {
            [paramDict setObject:photo_id forKey:@"picture"];
        }
        
        [[NetworkSingletion sharedManager]dealWithReview:paramDict onSucceed:^(NSDictionary *dict) {
            [SVProgressHUD dismiss];
            if ([dict[@"code"] integerValue] == 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"UPLOAD_NEW_DATA" object:nil];
                [self.viewController.navigationController popViewControllerAnimated:YES];
            }else{
                self.approvalButton.userInteractionEnabled = YES;
                self.approvalButton.backgroundColor = GREEN_COLOR;
                [MBProgressHUD showError:dict[@"message"] toView:self];
            }
        } OnError:^(NSString *error) {
            [SVProgressHUD dismiss];
            self.approvalButton.userInteractionEnabled = YES;
            self.approvalButton.backgroundColor = GREEN_COLOR;
            [MBProgressHUD showError:error toView:self];
        }];
    }else{//个人审批处理
        NSDictionary *dict = @{@"approval_state":self.agreeStr,
                               @"opinion":self.replyTextfield.text,
                               @"approval_personal_id":self.approval_personal_id};
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict addEntriesFromDictionary:dict];
        if (![NSString isBlankString:photo_id]) {
            [paramDict setObject:photo_id forKey:@"picture_enclosure"];
        }
        
        [[NetworkSingletion sharedManager]dealWithPersonalApproval:paramDict onSucceed:^(NSDictionary *dict) {
            [SVProgressHUD dismiss];
            if ([dict[@"code"] integerValue] == 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"UPLOAD_PERSONAL_NEW_DATA" object:nil];
                [self.viewController.navigationController popViewControllerAnimated:YES];
            }else{
                self.approvalButton.userInteractionEnabled = YES;
                self.approvalButton.backgroundColor = GREEN_COLOR;
                [MBProgressHUD showError:dict[@"message"] toView:self];
            }
        } OnError:^(NSString *error) {
            [SVProgressHUD dismiss];
            self.approvalButton.userInteractionEnabled = YES;
            self.approvalButton.backgroundColor = GREEN_COLOR;
            [MBProgressHUD showError:error toView:self];
        }];
    }
   

}

-(void)sepecalApprovalWith:(NSString*)agreeStr
{
    static NSString *alertTitle;
    if ([agreeStr isEqualToString:@"2"] && [NSString isBlankString:self.replyTextfield.text]) {
        [WFHudView showMsg:@"请输入拒绝原因..." inView:self.viewController.view ];
        return;
    }
    if ([agreeStr isEqualToString:@"2"]) {
        alertTitle = @"确定要拒绝？";
    }else{
        alertTitle = @"确定同意？";
    }
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:alertTitle  message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD show];
        self.approvalButton.userInteractionEnabled = NO;
        self.approvalButton.backgroundColor = [UIColor grayColor];
        NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                    @"approval_id":self.approvalID,
                                    @"is_agree":agreeStr,
                                    @"opinion":self.replyTextfield.text,
                                    @"participation_id":self.participation_id
                                    };
        [[NetworkSingletion sharedManager]sepecalApproval:paramDict onSucceed:^(NSDictionary *dict) {
            [SVProgressHUD dismiss];
            if ([dict[@"code"] integerValue] == 0) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"UPLOAD_NEW_DATA" object:nil];
                [self.viewController.navigationController popViewControllerAnimated:YES];
                
            }else{
                self.approvalButton.userInteractionEnabled = YES;
                self.approvalButton.backgroundColor = GREEN_COLOR;
                [MBProgressHUD showError:dict[@"message"] toView:self.viewController.view];
            }
        } OnError:^(NSString *error) {
            [SVProgressHUD dismiss];
            self.approvalButton.userInteractionEnabled = YES;
            self.approvalButton.backgroundColor = GREEN_COLOR;
            [MBProgressHUD showError:error toView:self.viewController.view];
        }];
        
    }]];
    [self.viewController presentViewController:alerVC animated:YES completion:nil];
}



#pragma mark 相册附件


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
    pickerVc.maxCount = 100;
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
        [self.assets removeAllObjects];
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:status.count];
        for (ZLPhotoAssets *assets in status) {
            ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:assets];
            photo.asset = assets;
            [photos addObject:[assets originImage]];
            [weakSelf.assets addObject:photo];
        }
        [weakSelf.photos removeAllObjects];
        [weakSelf.photos addObjectsFromArray:photos];
        [weakSelf photoViews];
    };
    [pickerVc showPickerVc:self.viewController];
}

-(void)takePhoto
{
    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
    cameraVc.maxCount = 100;
    __weak typeof(self) weakSelf = self;
    cameraVc.callback = ^(NSArray *cameras){
        
        for (ZLCamera *camera in cameras) {
            [weakSelf.photos addObject:[camera photoImage]];
            ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:[camera photoImage]];
            [weakSelf.assets addObject:photo];
        }
        [weakSelf photoViews];
        
    };
    [cameraVc showPickerVc:self.viewController];
}

-(void)photoViews
{
    if (!_imageScrollview) {
        _imageScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.viewController.view.bottom-140, SCREEN_WIDTH-120, 40)];
  
        _imageScrollview.showsVerticalScrollIndicator = NO;
        _imageScrollview.showsHorizontalScrollIndicator = YES;
        [self.viewController.view addSubview:_imageScrollview];
    }
    NSInteger count = self.photos.count ;
    [self.imgArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.imgArray removeAllObjects];
    for (int i = 0; i < count; i++) {
        UIImageView *imgview = [[UIImageView alloc]init];
        imgview.image = self.photos[i];
        imgview.tag = i;
        imgview.contentMode = UIViewContentModeScaleAspectFill;
        imgview.layer.masksToBounds = YES;
        [_imageScrollview addSubview:imgview];
        imgview.frame = CGRectMake(41*i, 0, 40, 40);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotos:)];
        imgview.userInteractionEnabled = YES;
        [imgview addGestureRecognizer:tap];
        [self.imgArray addObject:imgview];
    }
    _imageScrollview.contentSize = CGSizeMake(40*count, 40);
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
        [myActionSheet showInView:self.viewController.view];
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
        [pickerBrowser showPickerVc:self.viewController];
    }
    
}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
    if (self.assets.count > index) {
        [self.assets removeObjectAtIndex:index];
        [self.photos removeObjectAtIndex:index];
        [self photoViews];
    }
}

#pragma mark 七牛相关


- (void)uploadImageToQNFilePath:(NSArray *)imageArray token:(NSArray*)imageTokenArray{
    
    NSMutableArray *hashArray = [NSMutableArray array];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue=dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < self.photos.count; i++) {
        
        NSString *filePath = [self getImagePath:self.photos[i] index:i];
        //                NSLog(@"percent ==%@", filePath);
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
    dispatch_group_notify(group, queue, ^{
        //所有请求返回数据后执行
        NSString *hashStr = [NSString dictionaryToJson:hashArray];
        [[NetworkSingletion sharedManager]updateReviewAnnexNew:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"picture":hashStr} onSucceed:^(NSDictionary *dict) {
            [SVProgressHUD dismiss];
            if ([dict[@"code"] integerValue]==0) {
                NSInteger ennexID = [[dict[@"data"] objectForKey:@"enclosure_id"] integerValue];
                if (self.is_cashier) {
                    [self cashierDealWithContent:[NSString stringWithFormat:@"%@",@(ennexID)]];
                }else{
                  [self dealWithContent:[NSString stringWithFormat:@"%@",@(ennexID)]];
                }
            }
        } OnError:^(NSString *error) {
            [SVProgressHUD dismiss];
        }];
        
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




@end
