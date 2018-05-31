//
//  RCMAddGroupMemberViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/5/10.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "RCMAddGroupMemberViewController.h"
#import "CXZ.h"
#import "RCMAddMemberTableViewCell.h"

#import "SWWorkerData.h"
@interface MemberCollectionCell : UICollectionViewCell

@property(nonatomic,strong)UILabel* nameLabel;//姓名

@property(nonatomic,strong)UIImageView *headImgView;//头像

-(void)setHeadImgViewWithUrl:(NSURL*)url Title:(NSString*)title;

@end

@implementation MemberCollectionCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 2, 30, 30)];
        _headImgView.center = CGPointMake(self.bounds.size.width/2, 17);
        _headImgView.layer.cornerRadius = 15;
        _headImgView.layer.masksToBounds = YES;
        _headImgView.image = nil;
        [self addSubview:_headImgView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, self.bounds.size.width-1, 18)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_nameLabel];
    }
    return self;
}
-(void)setHeadImgViewWithUrl:(NSURL*)url Title:(NSString*)title
{
    [self.headImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"temp"]];
    self.nameLabel.text = title;
}

@end

@interface RCMAddGroupMemberViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,RCMAddMemberCellDelegate>
{
    NSUInteger page;
}
@property(nonatomic, strong) UITableView *tableView;

@property (nonatomic , weak) UICollectionView *toolBarThumbCollectionView;// 底部CollectionView

@property(nonatomic, strong) NSMutableArray *members;

@property(nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation RCMAddGroupMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeTapGestureRecognizer];
    [self setupBackw];
    [self setupTitleWithString:@"添加群成员" withColor:[UIColor whiteColor]];
    [self setUpNextWithFirstImages:@"search" Second:@"done"];
    [self setupNextWithImage:[UIImage imageNamed:@"done"]];
    UISearchBar *topsearchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH - 16, 30)];
    //    topsearchbar.delegate = self;
    topsearchbar.placeholder = @"请输入工人姓名或电话号码";
    for (UIView *sv in topsearchbar.subviews)
    {
        if ([sv isKindOfClass:NSClassFromString(@"UIView")] && sv.subviews.count > 0)
        {
            [sv.subviews.firstObject removeFromSuperview];
            UITextField *textField = sv.subviews.lastObject;
            textField.layer.borderColor = TOP_GREEN.CGColor;
            textField.layer.borderWidth = 0.5;
            textField.layer.masksToBounds = YES;
            textField.layer.cornerRadius = 15;
            textField.returnKeyType = UIReturnKeyGoogle;
            textField.font = [UIFont systemFontOfSize:12];
            UIColor *color = [UIColor whiteColor];
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入姓名" attributes:@{NSForegroundColorAttributeName: color}];
            //            textField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbg"]];
            textField.backgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
            //            textField.leftView = [UIView new];
        }
    }
    [self.view addSubview:topsearchbar];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, topsearchbar.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-50-64-30) style:UITableViewStylePlain];
    _tableView.delegate =  self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    __weak typeof(self) weakself = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshData];
    }];
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    [_tableView.mj_header beginRefreshing];
    
    [self setUpToolBar];
}


-(void)onNext
{
    [self.delegate selectedMember:self.selectedArray];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Private Method
//设置底部bar
-(void)setUpToolBar
{
    CGFloat height = 50;
    
    UIView* toolView = [[UIView alloc]initWithFrame:CGRectMake(0, _tableView.bottom, SCREEN_WIDTH, height)];
    toolView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = LINE_GRAY;
    [toolView addSubview:lineView];
    
//    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    okBtn.frame = CGRectMake(SCREEN_WIDTH-58, 5, 50, 40);
//    okBtn.backgroundColor = ORANGE_COLOR;
//    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    okBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [okBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
//    [toolView addSubview:okBtn];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(35, height);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // CGRectMake(0, 22, 300, 44)
    UICollectionView *toolBarThumbCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) collectionViewLayout:flowLayout];
    toolBarThumbCollectionView.backgroundColor = [UIColor clearColor];
    toolBarThumbCollectionView.dataSource = self;
    toolBarThumbCollectionView.delegate = self;
    [toolBarThumbCollectionView registerClass:[MemberCollectionCell class] forCellWithReuseIdentifier:@"MemberCollectionCell"];
    self.toolBarThumbCollectionView = toolBarThumbCollectionView;
    [toolView addSubview:toolBarThumbCollectionView];
    
    [self.view addSubview:toolView];
    
}


#pragma mark 加载数据


-(void)refreshData
{
    page = 1;
    [self.members removeAllObjects];
    [self loadData];
}
-(void)loadMoreData
{
    page ++;
    [self loadData];
}


- (void)loadData {
    
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSDictionary *pramDict = @{@"uid":uid,
                               @"p":@(page),
                               @"each":@"10"};
    
    [[NetworkSingletion sharedManager]getAllWorkerList:pramDict onSucceed:^(NSDictionary *dict) {
        //        NSLog(@"234234234%@",dict);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            NSArray *arr = [dict[@"data"] objectForKey:@"nworker"];
            
            for (NSDictionary *dataDict in arr) {
                SWWorkerData *data = [SWWorkerData objectWithKeyValues:dataDict];
                [self.members addObject:data];
            }
            [_tableView reloadData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark RCMAddMemberCellDelegate

-(void)clickSelected:(NSInteger)tag is_seleted:(BOOL)is_selected
{
    SWWorkerData *model = self.members[tag];
    model.is_selected = is_selected;
    if (is_selected) {
        [self.selectedArray addObject:model];
    }else{
        [self.selectedArray removeObject:model];
    }
    [self.toolBarThumbCollectionView reloadData];
}

#pragma mark UITableView Delegate & DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.members.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RCMAddMemberTableViewCell";
    RCMAddMemberTableViewCell *cell = (RCMAddMemberTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[RCMAddMemberTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    if (self.members.count > 0) {
        [cell setModel:self.members[indexPath.row]];
    }
    cell.delegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectedArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"MemberCollectionCell";
    MemberCollectionCell *cell = (MemberCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (self.selectedArray.count > 0) {
        SWWorkerData *workData = self.selectedArray[indexPath.row];
        [cell setHeadImgViewWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,workData.avatar]] Title:workData.name];
    }
    
    return cell;
}

#pragma makr UICollectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWWorkerData *workData = self.selectedArray[indexPath.row];
    workData.is_selected = NO;
    [self.tableView reloadData];
    [self.selectedArray removeObject:workData];
    [self.toolBarThumbCollectionView deleteItemsAtIndexPaths:@[indexPath]];
}

#pragma mark get/set

-(NSMutableArray*)members
{
    if (!_members) {
        _members = [NSMutableArray array];
    }
    return _members;
}

-(NSMutableArray*)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}


#pragma mark warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
