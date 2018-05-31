//
//  WorkerTypeViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/22.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "WorkerTypeViewController.h"
#import "CXZ.h"
#import "AllCateItemCell.h"
#import "AllCateItemHeaderView.h"
#import "AllCateItemFooterView.h"

#import "WokerTypeModel.h"

static NSString *reuseID = @"itemCell";
static NSString *sectionHeaderID = @"sectionHeader";
static NSString *sectionFooterID = @"sectionFooter";

@interface WorkerTypeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

{
    BOOL is_manager;
}
@property(nonatomic ,strong)UICollectionView *collectionView;

@property(nonatomic ,strong)UIWindow *bgWindow;

@property(nonatomic ,strong)UITextField *nameTxt;

@property(nonatomic ,strong)NSMutableArray *wokerTypeArray;

@property(nonatomic ,strong)NSMutableArray *bossTypeArray;


@end

@implementation WorkerTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"选择工种类型" withColor:[UIColor whiteColor]];
    [self removeTapGestureRecognizer];
     self.view.backgroundColor = [UIColor whiteColor];
    [self setupCollectionView];
    [self loadWorkerTypeData];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 20.0)/ 4, 38);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake((SCREEN_WIDTH - 20.0), 30);
    layout.footerReferenceSize = CGSizeMake((SCREEN_WIDTH - 20.0), 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT ) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[AllCateItemCell class] forCellWithReuseIdentifier:reuseID];
    [_collectionView registerClass:[AllCateItemHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID];
    [_collectionView registerClass:[AllCateItemFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sectionFooterID];
}

-(void)loadWorkerTypeData
{
    [[NetworkSingletion sharedManager]getWorkerTypeList:nil onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue ]== 0) {
            NSArray *workArray = [WokerTypeModel objectArrayWithKeyValuesArray:[dict[@"data"] objectForKey:@"no_manage"]];
            NSArray *bossArray =[WokerTypeModel objectArrayWithKeyValuesArray:[dict[@"data"] objectForKey:@"is_manage"]];
            [self.wokerTypeArray addObjectsFromArray:workArray];
            [self.bossTypeArray addObjectsFromArray:bossArray];
//            WokerTypeModel *typeModel = [[WokerTypeModel alloc]init];
//            typeModel.type_name = @"自定义";
//            [self.wokerTypeArray addObject:typeModel];
//            [self.bossTypeArray addObject: typeModel];
            [self.collectionView reloadData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        
    }];
}

#pragma mark 自定义工种

-(void)setAddWorkerView
{
    if (!_bgWindow) {
        _bgWindow = [[UIWindow alloc]initWithFrame:self.view.bounds];
        _bgWindow.windowLevel = UIWindowLevelNormal;
        _bgWindow.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH-70, 151)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.center = _bgWindow.center;
        bgView.top = 80;
        bgView.layer.cornerRadius = 3;
        [_bgWindow addSubview:bgView];
        
        UILabel *titleLabel = [CustomView customTitleUILableWithContentView:bgView title:@"自定义职位"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(0, 0, bgView.width, 30);
        
        UIView *line = [CustomView customLineView:bgView];
        line.frame = CGRectMake(0, titleLabel.bottom, bgView.width, 1);
        
        
        _nameTxt = [CustomView customUITextFieldWithContetnView:bgView placeHolder:@"请输入职位名称"];
        _nameTxt.textAlignment = NSTextAlignmentCenter;
        _nameTxt.frame = CGRectMake(5, line.bottom+20, bgView.width-10, 40);
        
        
        UIButton *canCelBtn = [CustomView customButtonWithContentView:bgView image:nil title:@"取消"];
        [canCelBtn addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        canCelBtn.frame = CGRectMake(0, _nameTxt.bottom+20, bgView.width/2, 40);
        
        UIButton *confirmBtn = [CustomView customButtonWithContentView:bgView image:nil title:@"确定"];
        [confirmBtn addTarget:self action:@selector(clickAddDepartmentButton:) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.frame = CGRectMake(canCelBtn.right,canCelBtn.top, canCelBtn.width, canCelBtn.height);
        [self.view addSubview:_bgWindow];
    }
    _bgWindow.hidden = NO;
    [_bgWindow makeKeyWindow];
}

-(void)clickCancelButton:(UIButton*)bton
{
    _bgWindow.hidden = YES;
    [_bgWindow resignKeyWindow];
}

-(void)clickAddDepartmentButton:(UIButton*)bton
{
   
    if (![NSString isBlankString:self.nameTxt.text]) {
        NSDictionary *paramDict = @{@"type_name":self.nameTxt.text,
                                    @"is_manage":@(is_manager)
                                    };
        [[NetworkSingletion sharedManager]customWorkerType:paramDict onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue]== 0) {
                WokerTypeModel *type = [[WokerTypeModel alloc]init];
                type.type_name = self.nameTxt.text;
                if (is_manager) {
                    [self.bossTypeArray insertObject:type atIndex:self.bossTypeArray.count-1];
                }else{
                    [self.wokerTypeArray insertObject:type atIndex:self.wokerTypeArray.count-1];
                }
                [self.collectionView reloadData];
                _bgWindow.hidden = YES;
                [_bgWindow resignKeyWindow];
                
            }
        } OnError:^(NSString *error) {
            
        }];
    }else{
        [WFHudView showMsg:@"请输入职位名称" inView:self.view];
    }
}


#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.wokerTypeArray.count;
    }
    return self.bossTypeArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AllCateItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];

    if (indexPath.section == 0 && self.wokerTypeArray.count > 0) {
        WokerTypeModel *type = self.wokerTypeArray[indexPath.row];
        cell.titleLabel.text = type.type_name;
    }else{
        WokerTypeModel *type = self.bossTypeArray[indexPath.row];
        cell.titleLabel.text = type.type_name;
    }
    if ([cell.titleLabel.text isEqualToString:@"自定义"]) {
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.titleLabel.font = [UIFont systemFontOfSize:13 weight:0.8];
    }
    [cell.titleLabel setHidden:NO];
    [cell.icon setHidden:YES];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        AllCateItemHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID forIndexPath:indexPath];
        NSArray *titleArray = @[@"工人类",@"管理类"];
        NSArray *imageArray = @[@"worker",@"boss"];
        headerView.title = titleArray[indexPath.section];
        headerView.iconUrl = imageArray[indexPath.section];
        
        return headerView;
    }else if (kind == UICollectionElementKindSectionFooter){
        
        AllCateItemFooterView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sectionFooterID forIndexPath:indexPath];
        
        return footView;
    }
    else {
        return nil;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == 0  ) {
        if (indexPath.row == self.wokerTypeArray.count-1) {
            is_manager = NO;
            [self setAddWorkerView];
        }else{
            [self.delegate selectedWorkerType:self.wokerTypeArray[indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    if (indexPath.section == 1 ) {
        if (indexPath.row == self.bossTypeArray.count-1) {
            is_manager = YES;
            [self setAddWorkerView];
        }else{
            [self.delegate selectedWorkerType:self.bossTypeArray[indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}


#pragma mark get/set

-(NSMutableArray*)wokerTypeArray
{
    if (!_wokerTypeArray) {
        _wokerTypeArray = [NSMutableArray array];
    }
    return _wokerTypeArray;
}

-(NSMutableArray*)bossTypeArray
{
    if (!_bossTypeArray) {
        _bossTypeArray = [NSMutableArray array];
    }
    return _bossTypeArray;
}

@end
