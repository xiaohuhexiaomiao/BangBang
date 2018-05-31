//
//  MyProductionViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/4/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "MyProductionViewController.h"
#import "PublishStatusViewController.h"
#import "ProductionCollectionViewCell.h"
#import "ProductionDetailViewController.h"
#import "XRWaterfallLayout.h"
@interface MyProductionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,XRWaterfallLayoutDelegate,ProductionCellDelegate>

@property (nonatomic, strong) UICollectionView *collecView;

@property (nonatomic ,strong)NSMutableArray *dataArray;

@end

@implementation MyProductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    if (self.is_other_worker) {
        [self setupTitleWithString:@"往期作品" withColor:[UIColor whiteColor]];
    }else{
        [self setupTitleWithString:@"我的作品" withColor:[UIColor whiteColor]];
        UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        uploadBtn.frame = CGRectMake(8, self.collecView.bottom, SCREEN_WIDTH-16, 39);
        uploadBtn.layer.cornerRadius = 5;
        uploadBtn.layer.masksToBounds = YES;
        uploadBtn.backgroundColor = TOP_GREEN;
        [uploadBtn setTitle:@"上传作品" forState:UIControlStateNormal];
        [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        uploadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [uploadBtn addTarget:self action:@selector(clickUploadButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:uploadBtn];
        [self.view bringSubviewToFront:uploadBtn];
    }
    
     XRWaterfallLayout *waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
    [waterfall setColumnSpacing:5 rowSpacing:5 sectionInset:UIEdgeInsetsMake(8, 8, 8, 8)];
     waterfall.delegate = self;
    
    self.collecView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:waterfall];
    self.collecView.height = self.view.bounds.size.height-104;
    self.collecView.backgroundColor = [UIColor whiteColor];
    [self.collecView registerNib:[UINib nibWithNibName:@"ProductionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductionCell"];
    self.collecView.dataSource = self;
    self.collecView.delegate = self;
    [self.view addSubview:self.collecView];
    
    __weak typeof(self) weakself = self;
    self.collecView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    [self.collecView.mj_header beginRefreshing];
    
    
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark PrivateMethd

-(void)loadData
{
    if (self.is_other_worker) {
        [self.dataArray removeAllObjects];
        [[NetworkSingletion sharedManager]getMyProductionList:@{@"uid":self.other_worker_uid} onSucceed:^(NSDictionary *dict) {
            //        NSLog(@"list  %@",dict);
            [self.collecView.mj_header endRefreshing];
            if ([dict[@"code"] integerValue]==0) {
                [self.dataArray addObjectsFromArray:dict[@"data"]];
                
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
            [self.collecView reloadData ];
        } OnError:^(NSString *error) {
            [self.collecView.mj_header endRefreshing];
            [MBProgressHUD showError:error toView:self.view];
        }];
    }else{
        [self.dataArray removeAllObjects];
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        [[NetworkSingletion sharedManager]getMyProductionList:@{@"uid":uid} onSucceed:^(NSDictionary *dict) {
            //        NSLog(@"list  %@",dict);
            [self.collecView.mj_header endRefreshing];
            if ([dict[@"code"] integerValue]==0) {
                [self.dataArray addObjectsFromArray:dict[@"data"]];
                
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
            [self.collecView reloadData ];
        } OnError:^(NSString *error) {
            [self.collecView.mj_header endRefreshing];
            [MBProgressHUD showError:error toView:self.view];
        }];
    }
}

-(void)clickUploadButton
{
    PublishStatusViewController *publishVC = [PublishStatusViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publishVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark Collection

- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    

    return (SCREEN_WIDTH-40)/2+30;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductionCollectionViewCell *cell = (ProductionCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ProductionCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (self.dataArray.count > 0) {
        NSDictionary *dict = self.dataArray[indexPath.row];
        cell.productionDict = dict;
        NSArray *picArray = dict[@"picture"];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,picArray[0]];
//        NSLog(@"**uir *%@",urlStr);
        [cell.productionImgview sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
        cell.productionTitleLabel.text = dict[@"content"];
        cell.productionTimeLabel.text = dict[@"works_time"];
    }
    return cell;
}


#pragma mark Cell Delegate

-(void)clickProductionCollectionViewCell:(NSDictionary *)dict
{
    ProductionDetailViewController *detailVC = [[ProductionDetailViewController alloc]init];
    detailVC.detailDict = dict;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark GET / SET

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
