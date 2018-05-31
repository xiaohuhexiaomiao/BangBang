//
//  ProductionDetailViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/4/17.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ProductionDetailViewController.h"
#import "JXBAdPageView.h"


@interface ProductionDetailViewController ()<JXBAdPageViewDelegate>

@property(nonatomic , strong) JXBAdPageView* adView;
@property(nonatomic ,strong) UILabel *titleLabel;
@property(nonatomic ,strong) UILabel *startTimeLabel;
@property(nonatomic ,strong) UILabel *endTimeLabel;

@end

@implementation ProductionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupBackw];
    [self setupTitleWithString:@"作品详情" withColor:[UIColor whiteColor]];
    [self config];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark private

-(void)config
{
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 50, SCREEN_WIDTH-16, 25)];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.text = [NSString stringWithFormat:@"作品名称：%@",self.detailDict[@"content"]];
    _titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_titleLabel];
    
    _startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, _titleLabel.bottom+5, SCREEN_WIDTH-16, 18)];
    _startTimeLabel.font = [UIFont systemFontOfSize:12];
    _startTimeLabel.text = [NSString stringWithFormat:@"开工时间：%@",self.detailDict[@"works_time"]];
    _startTimeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_startTimeLabel];
    
    _endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, _startTimeLabel.bottom+5, SCREEN_WIDTH-16, 18)];
    _endTimeLabel.font = [UIFont systemFontOfSize:12];
    _endTimeLabel.textColor = [UIColor whiteColor];
    _endTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",self.detailDict[@"works_end_time"]];
    [self.view addSubview:_endTimeLabel];
    
    NSArray *imgArray = self.detailDict[@"picture"];
    _adView = [[JXBAdPageView alloc] initWithFrame:CGRectMake(0, _endTimeLabel.bottom+10, SCREEN_WIDTH , SCREEN_HEIGHT/3)];
    _adView.iDisplayTime = 0;
    _adView.delegate = self;
    _adView.bWebImage = YES;
    _adView.pageControl.hidden = YES;
    _adView.imgNumLabel.hidden = NO;
    _adView.imgCount = imgArray.count;
    [self.view addSubview:_adView];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *photoArray = [NSMutableArray array];
    for (int i = 0 ; i < imgArray.count ; i++) {
        NSString *pic = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,imgArray[i]];
        [imageArray addObject:pic];
        ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:pic];
        [photoArray addObject:photo];
    }
    if (imageArray.count > 0) {
        [_adView startAdsWithBlock:imageArray block:^(NSInteger clickIndex){
            // 图片游览器
            ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
            // 淡入淡出效果
            // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
            // 数据源/delegate
            pickerBrowser.editing = NO;
            pickerBrowser.photos = photoArray;
            // 当前选中的值
            pickerBrowser.currentIndex = clickIndex;
            // 展示控制器
            [pickerBrowser showPickerVc:self];
            
        }];
    }
}

- (void)setWebImage:(UIImageView*)imgView imgUrl:(NSString*)imgUrl
{
    //    NSLog(@"imgUrl:%@",imgUrl);
    [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}
    
@end
