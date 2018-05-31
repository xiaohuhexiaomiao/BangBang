//
//  ShowFilesView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/10/30.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ShowFilesView.h"
#import "CXZ.h"

#import "LocalFilesModel.h"
#import "PhotoCollectionViewCell.h"

@interface ShowFilesView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic , strong)  UICollectionView *perCollectionView;

@property(nonatomic ,strong)UILabel *lookLabel;

@property(nonatomic ,strong) NSArray *manyFilesArray;

@property(nonatomic ,strong) NSMutableArray *photosArray;

@property(nonatomic ,assign) CGFloat viewheight;

@property(nonatomic ,copy) NSString *fileID;

@property(nonatomic ,strong) NSMutableArray *picUrlArray;

@end

@implementation ShowFilesView

-(id)init
{
    self = [super init];
    if (self) {
        _lookLabel = [[UILabel alloc]init];
        _lookLabel.text = @"附件：";
        _lookLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        _lookLabel.frame = CGRectMake(0, 0, self.frame.size.width, 30);
        [self addSubview:_lookLabel];
        self.viewheight = 30.0;
        _photosArray = [NSMutableArray array];
        _picUrlArray = [NSMutableArray array];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lookLabel = [[UILabel alloc]init];
        _lookLabel.text = @"";
        _lookLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        _lookLabel.frame = CGRectMake(0, 0, self.frame.size.width, 10);
        [self addSubview:_lookLabel];
        self.viewheight = 10.0;
        _photosArray = [NSMutableArray array];
        _picUrlArray = [NSMutableArray array];
    }
    return self;
}
-(CGFloat)setShowFilesViewWithArray:(NSArray*)filesArray
{
    
    if (filesArray.count == 0) {
        self.lookLabel.text = @"无附件";
        CGRect frame = self.lookLabel.frame;
        frame.size.height = 30.0;
        self.lookLabel.frame = frame;
        self.viewheight = 30.0f;
    }
    UIView *lastView = _lookLabel;
//    NSLog(@"****%li",filesArray.count);
    self.manyFilesArray = [LocalFilesModel objectArrayWithKeyValuesArray:filesArray];
    for (int i = 0; i < self.manyFilesArray.count; i++) {
        LocalFilesModel *model = self.manyFilesArray[i];
        if (model.type == 4) {
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, lastView.bottom, self.frame.size.width-16, 25)];
            titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
            titleLabel.textColor = FORMLABELTITLECOLOR;
            NSString *title;
            if ([NSString isBlankString:model.name]) {
                title = @"文档附件";
            }else{
                title = model.name;
            }
            titleLabel.text = title;
            titleLabel.tag = i;
            lastView = titleLabel;
            [self addSubview:titleLabel];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickFileLabel:)];
            titleLabel.userInteractionEnabled = YES;
            [titleLabel addGestureRecognizer:tap];
            self.viewheight += 25.0f;
        }
        if (model.type == 3) {
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.itemSize = CGSizeMake(40, 40);
            flowLayout.minimumInteritemSpacing = 0;
            flowLayout.minimumLineSpacing = 5;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            
            _perCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-8, 40) collectionViewLayout:flowLayout];
            _perCollectionView.backgroundColor = [UIColor colorWithRed:233 green:233 blue:233 alpha:1];
            _perCollectionView.dataSource = self;
            _perCollectionView.delegate = self;
            [_perCollectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
            [self addSubview:_perCollectionView];
            self.viewheight += 40.0f;
            [self showImageViewWithModel:model];
            
        }
    }
    
    if (_perCollectionView) {
        CGRect frame = _perCollectionView.frame;
        frame.origin.y = lastView.bottom;
        _perCollectionView.frame = frame;
    }
    return self.viewheight+5;
}

-(void)clickFileLabel:(UITapGestureRecognizer*)tap
{
    UILabel *label = (UILabel*)tap.view;
    LocalFilesModel *model = self.manyFilesArray[label.tag];
    
    [[NetworkSingletion sharedManager]lookFilesDetail:@{@"attachments_id":model.contract_id} onSucceed:^(NSDictionary *dict) {
        
        if ([dict[@"code"] integerValue]==0) {
            FilesModel *files = [FilesModel objectWithKeyValues:dict[@"data"]];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",IMAGE_HOST, files.attachments];
//            NSLog(@"**url*%@",urlString);
//            NSString *encodedString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            WebViewController *docVC = [[WebViewController alloc]init];
            docVC.urlStr = urlString;
            docVC.filesModel = files;
            docVC.titleString = files.file_name;
            docVC.is_Send = YES;
            [self.viewController.navigationController pushViewController:docVC animated:YES];
        }
        
    } OnError:^(NSString *error) {
        
    }];
}


-(void)showImageViewWithModel:(LocalFilesModel*)showModel
{
//     NSLog(@"**img**%@",showModel.contract_id);
    [[NetworkSingletion sharedManager]getReviewAnnexDetail:@{@"enclosure_id":showModel.contract_id} onSucceed:^(NSDictionary *dict) {
//        NSLog(@"**img**%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            NSArray *imageArray = [dict[@"data"] objectForKey:@"picture"];
            NSInteger count = imageArray.count;
            for (int i = 0 ; i < imageArray.count ; i++) {
                NSString *pic = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,imageArray[i]];
                NSString *pic1 = [NSString stringWithFormat:@"%@%@?imageView2/2/w/80/h/80",IMAGE_HOST,imageArray[i]];
                ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                photo.photoURL = [NSURL URLWithString:pic];
                [self.photosArray addObject:photo];;
                [self.picUrlArray addObject:[NSURL URLWithString:pic1]];
            }
            [self.perCollectionView reloadData];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self];
    }];

}

-(void)lookPhotos:(UITapGestureRecognizer*)tap;
{
    UIImageView *imageView = (UIImageView*)tap.view;
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(imageView.tag-100) inSection:0];
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    pickerBrowser.editing = NO;
    pickerBrowser.photos = self.photosArray;
    // 当前选中的值
    pickerBrowser.currentIndex = indexPath.row;
    // 展示控制器
    [pickerBrowser showPickerVc:self.viewController];
}


#pragma mark UICollectionView Delegate & Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.picUrlArray.count;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell * cell = (PhotoCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
  
    if (self.picUrlArray.count > 0) {
//        NSLog(@"***%@",self.picUrlArray[indexPath.row]);
        [cell.photoImageview sd_setImageWithURL:self.picUrlArray[indexPath.row] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    pickerBrowser.editing = NO;
    pickerBrowser.photos = self.photosArray;
    // 当前选中的值
    pickerBrowser.currentIndex = indexPath.row;
    // 展示控制器
    [pickerBrowser showPickerVc:self.viewController];
}


@end
