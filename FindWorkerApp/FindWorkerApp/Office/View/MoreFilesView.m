//
//  MoreFilesView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/10/25.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "MoreFilesView.h"

#import "CXZ.h"
#import "FileListViewController.h"

#import "FilesView.h"

#import "FileModel.h"
#import "LocalFilesModel.h"
#import "UploadImageModel.h"

#import "UploadImageCollectionViewCell.h"

@interface MoreFilesView()<UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ZLPhotoPickerBrowserViewControllerDelegate,FileViewControllerDelegate,FileViewDelegate,UploadImageCollectionViewCellDelegate>

//@property(nonatomic , strong) UIScrollView *imgScrollView;

@property(nonatomic , strong) UICollectionView *photoCollectionView;

@property(nonatomic , strong) UIView *addView;

@property(nonatomic , strong) UIView *lastView;


@property(nonatomic , strong) NSMutableArray *assets;

@property(nonatomic , strong) NSMutableArray *photos;

@property(nonatomic , strong) NSMutableArray *photosArray;

@property(nonatomic , strong) NSMutableArray *fileViewArray;

@property(nonatomic , assign) int lastIndex;

@property(nonatomic , assign) NSInteger lastFileIndex;


@end

@implementation MoreFilesView

-(id)init
{
   self = [super init];
    if (self) {
        NSArray *picArray = @[@"photo1",@"pic",@"file"];
        _addView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-16, 30)];
        [self addSubview:_addView];
        for (int i = 0; i < picArray.count; i++) {
            UIButton* button  = [CustomView customButtonWithContentView:_addView image:picArray[i] title:nil];
            button.frame = CGRectMake(40*i, 5, 20, 20);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button addTarget:self action:@selector(clickAddFiles:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            _lastView = button;
        }
        _descripeLabel = [CustomView customTitleUILableWithContentView:_addView title:nil];
        _descripeLabel.font = [UIFont systemFontOfSize:12];
        _descripeLabel.textAlignment = 2;
        _descripeLabel.frame = CGRectMake(_lastView.right, 0, SCREEN_WIDTH-_lastView.right, 30);
        _lastView = _addView;
        
//        _lastImageView = nil;
        _file_id_array = [NSMutableArray array];
        _photosArray = [NSMutableArray array];
        self.height = 30.0;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *picArray = @[@"photo1",@"pic",@"file"];
        _addView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-16, 30)];
        [self addSubview:_addView];
        for (int i = 0; i < picArray.count; i++) {
            UIButton* button  = [CustomView customButtonWithContentView:_addView image:picArray[i] title:nil];
            button.frame = CGRectMake(40*i, 5, 20, 20);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button addTarget:self action:@selector(clickAddFiles:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            _lastView = button;
        }
        _descripeLabel = [CustomView customTitleUILableWithContentView:_addView title:nil];
        _descripeLabel.font = [UIFont systemFontOfSize:12];
//        [_descripeLabel sizeToFit];
//        _descripeLabel.backgroundColor = [UIColor blueColor];
        _descripeLabel.textAlignment = 2;
        _descripeLabel.frame = CGRectMake(_lastView.right+5, 0, SCREEN_WIDTH-_lastView.right-5, 30);
        _lastView = _addView;
//        _lastImageView = nil;
        _file_id_array = [NSMutableArray array];
        _photosArray = [NSMutableArray array];
        self.height = 30.0;
    }
    return self;
}

-(void)clickAddFiles:(UIButton*)button
{
    
    NSInteger buttonIndex = button.tag;
    
    switch (buttonIndex) {
        case 0:
            //拍照
            [self takePhoto];
            break;
        case 1:
            //从相册选择
            [self localPhoto];
            break;
        case 2:
            
        { FileListViewController *guideVC = [[FileListViewController alloc]init];
            guideVC.delegate = self;
            guideVC.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:guideVC animated:YES];
            self.viewController.navigationController.hidesBottomBarWhenPushed = YES;
        }
            
            break;
        default:
            break;
    }
}


-(CGFloat)setMoreFilesViewWithArray:(NSArray*)filesArray
{
   [self removeAllSubviews];
    [self addSubview:self.addView];
    NSArray *fileArray = [LocalFilesModel objectArrayWithKeyValuesArray:filesArray];
    for (int i = 0; i < fileArray.count; i++) {
        LocalFilesModel *fileModel = fileArray[i];
        if (fileModel.type == 4) {
            FilesView *filseView = [[FilesView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, self.frame.size.width, 30)];
            NSString *title;
            if ([NSString isBlankString:fileModel.name]) {
                title = @"文档附件";
            }else{
                title = fileModel.name;
            }
            filseView.titleLabel.text = title;
            filseView.filesDict = filesArray[i];
            filseView.tag = i+100;
            filseView.delegate = self;
            [self addSubview:filseView];
            [self.fileViewArray addObject:filseView];
            [self.file_id_array addObject:filseView.filesDict];
            _lastView = filseView;
            self.height += 30.0f;
            self.lastFileIndex ++;
        }
        if (fileModel.type == 3) {
            
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.itemSize = CGSizeMake(40, 40);
            flowLayout.minimumInteritemSpacing = 0;
            flowLayout.minimumLineSpacing = 5;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            
            _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-8, 40) collectionViewLayout:flowLayout];
            _photoCollectionView.backgroundColor = [UIColor colorWithRed:233 green:233 blue:233 alpha:1];
            _photoCollectionView.dataSource = self;
            _photoCollectionView.delegate = self;
            [_photoCollectionView registerClass:[UploadImageCollectionViewCell class] forCellWithReuseIdentifier:@"UploadImageCollectionViewCell"];
            [self addSubview:_photoCollectionView];
            self.height += 40.0f;
           [self showImageViewWithModel:fileModel];
            
        }
    }
    
    
    if (_photoCollectionView) {
        CGRect frame = _photoCollectionView.frame;
        frame.origin.y = _lastView.bottom;
        _photoCollectionView.frame = frame;
    }
    return self.height+5;
}


-(void)chooseFiles:(NSMutableArray *)filesArray
{
    for (int i = 0; i < filesArray.count; i ++) {
        FileModel *fileModel = filesArray[i];
        FilesView *filseView = [[FilesView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, self.frame.size.width, 30)];
        [filseView setContentWithModel:fileModel];
        filseView.tag = i+100+self.lastFileIndex;
        filseView.delegate = self;
        [self addSubview:filseView];
        [self.fileViewArray addObject:filseView];
        [self.file_id_array addObject:filseView.filesDict];
        _lastView = filseView;
    }
    self.height += 30*filesArray.count;
    if (self.photoCollectionView) {
        self.photoCollectionView.top = _lastView.bottom;
    }
}

-(void)deleteFileView:(NSInteger)tag
{
//    NSLog(@"****%li",tag);
    FilesView *fileView = (FilesView*)[self viewWithTag:(tag)];
    [self.file_id_array removeAllObjects];
    [self.fileViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.fileViewArray removeObject:fileView];
    _lastView = self.addView;
    for (int i = 0; i < self.fileViewArray.count; i ++) {
        FilesView *filseView = self.fileViewArray[i];
        CGRect fileFrame = filseView.frame;
        fileFrame = CGRectMake(0, _lastView.bottom, self.frame.size.width, 30);
        filseView.frame = fileFrame;
        filseView.tag = i+100;
        filseView.delegate = self;
        [self addSubview:filseView];
        _lastView = filseView;
        [self.file_id_array addObject:filseView.filesDict];
        
    }
    self.height -= 30;
    if (self.photoCollectionView) {
        self.photoCollectionView.top = _lastView.bottom;
    }
    
}



-(void)showImageViewWithModel:(LocalFilesModel*)showModel
{
    [[NetworkSingletion sharedManager]getReviewAnnexDetail:@{@"enclosure_id":showModel.contract_id} onSucceed:^(NSDictionary *dict) {
        
        if ([dict[@"code"] integerValue]==0) {
            NSArray *imageArray = [dict[@"data"] objectForKey:@"picture"];
            NSInteger count = imageArray.count;
            for (int i = 0 ; i < imageArray.count ; i++) {
                NSString *pic = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,imageArray[i]];
                ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                photo.photoURL = [NSURL URLWithString:pic];
                [self.photosArray addObject:photo];
                
                UploadImageModel *imgModel = [[UploadImageModel alloc]init];
                imgModel.hashString = imageArray[i];
                imgModel.is_webImage = YES;
                imgModel.uploadProgress = 100.0;
                imgModel.tag =i;
                [imgModel setHashString:imageArray[i]];
                [self.imgArray addObject:imgModel];
            }
            _lastIndex = (int)count;
            [self.photoCollectionView reloadData];
//            photoCollectionView.contentSize = CGSizeMake(41*count, 40);
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self];
    }];
    
}

#pragma mark Cell Delegate

-(void)clickDeleteImage:(NSInteger)tag
{
    if (tag >= self.photosArray.count) {
        [self.assets removeObjectAtIndex:(tag-self.photosArray.count)];
    }else{
        [self.photosArray removeObjectAtIndex:tag];
    }
//    [self.imgArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.imgArray removeObjectAtIndex:tag];
    for (int i = 0; i < self.imgArray.count; i++) {
        UploadImageModel *imgModel = self.imgArray[i];
        imgModel.tag = i ;
        
    }
    _lastIndex = (int)self.imgArray.count;
    [self.photoCollectionView reloadData];
}


#pragma mark UICollectionView Delegate & Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgArray.count;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UploadImageCollectionViewCell * cell = (UploadImageCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"UploadImageCollectionViewCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.delegate = self;
    if (self.imgArray.count > 0) {
        [cell setUploadImageCollectonCellWithModel:self.imgArray[indexPath.row]];


    }
    return cell;
}





#pragma mark 相册

-(void)localPhoto
{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    pickerVc.maxCount = 1000;
    // Jump AssetsVc
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // Recoder Select Assets
//    pickerVc.selectPickers = self.assets;
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
        [weakSelf photoViews];
    };
    [pickerVc showPickerVc:self.viewController];
}

-(void)takePhoto
{
    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
    cameraVc.maxCount = 1000;
    __weak typeof(self) weakSelf = self;
    cameraVc.callback = ^(NSArray *cameras){
        [weakSelf.photos removeAllObjects];
        for (ZLCamera *camera in cameras) {
            [weakSelf.photos addObject:[camera photoImage]];
            ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:[camera photoImage]];
            [weakSelf.assets addObject:photo];
        }
        [weakSelf photoViews];
    };
    [cameraVc showPickerVc:self.viewController];
}


-(void)clickLargeImageView:(NSInteger)tag
{
    NSMutableArray *photos = [NSMutableArray array];
    [photos addObjectsFromArray:self.photosArray];
    [photos addObjectsFromArray:self.assets];
//    ImageUploadView *imgView = (ImageUploadView*)tap.view;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
//    NSLog(@"asset %li",self.assets.count);
    pickerBrowser.editing = YES;
    pickerBrowser.photos = photos;
    // 能够删除
    pickerBrowser.delegate = self;
    // 当前选中的值
    pickerBrowser.currentIndex = indexPath.row;
    // 展示控制器
    [pickerBrowser showPickerVc:self.viewController];
}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
   
    if (index >= self.photosArray.count) {
        [self.assets removeObjectAtIndex:(index-self.photosArray.count)];
    }else{
        [self.photosArray removeObjectAtIndex:index];
    }

    [self.imgArray removeObjectAtIndex:index];

    [self.photoCollectionView reloadData];
}

-(void)photoViews
{
    if (!_photoCollectionView) {

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(40, 40);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8,_lastView.bottom+5, SCREEN_WIDTH-8, 40) collectionViewLayout:flowLayout];
        _photoCollectionView.backgroundColor = [UIColor colorWithRed:233 green:233 blue:233 alpha:1];
        _photoCollectionView.dataSource = self;
        _photoCollectionView.delegate = self;
        [_photoCollectionView registerClass:[UploadImageCollectionViewCell class] forCellWithReuseIdentifier:@"UploadImageCollectionViewCell"];
        [self addSubview:_photoCollectionView];
        self.height += 45.0;
        
    }
    NSInteger count = self.photos.count ;

//    NSOperationQueue *queue = [NSOperationQueue mainQueue];
//    queue.maxConcurrentOperationCount = 10;
    for (int i = 0; i < count; i++) {
        UploadImageModel *imgModel = [[UploadImageModel alloc]init];
        imgModel.is_webImage = NO;
        imgModel.tag = i+_lastIndex;
        [imgModel setImage:self.photos[i]];
        [imgModel uploadPhotoWithImage];
//        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
////            NSLog(@"%i-----%@",i, [NSThread currentThread]);
//            [imgModel uploadPhotoWithImage];
//        }];
//        [queue addOperation:op];
        
       
        [self.imgArray addObject:imgModel];
    }
    _lastIndex +=count;
    [self.photoCollectionView reloadData];
    
}


#pragma mark get/set

-(NSMutableArray*)assets
{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

-(NSMutableArray*)photos
{
    if (!_photos) {
        _photos = [NSMutableArray array];
//        UIImage *img = [UIImage imageNamed:@"上传照片.jpg"];
//        [_photos addObject:img];
    }
    return _photos;
}

-(NSMutableArray*)imgArray
{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

-(NSMutableArray*)fileViewArray
{
    if (!_fileViewArray) {
        _fileViewArray = [NSMutableArray array];
    }
    return _fileViewArray;
    
}





@end
