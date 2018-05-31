//
//  SWPublishOngoingDetailController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWPublishOngoingDetailController.h"
#import "SWWorkerDetailController.h"
#import "SWMyFavoriteController.h"
#import "CXZ.h"

#import "SWSeeWokerView.h"

#import "SWMyPublishDetailCmd.h"
#import "SWMyPublishDetailInfo.h"
#import "SWMyPublishDetailData.h"
#import "SWFindWorkType.h"

#import "SWLookUserCmd.h"
#import "SWLookUserInfo.h"
#import "SWLookUserData.h"
#import "SWLookUserDetail.h"

#import "SWSWEmployerConfirmCmd.h"
#import "SWEmployessComfirmInfo.h"

#define padding 10

@interface SWPublishOngoingDetailController ()

@property (nonatomic, retain) UIScrollView *contentView;

@property (nonatomic, retain) UIView *headerView;

@property (nonatomic, retain) UIView *footerView;

@property (nonatomic, retain) NSMutableArray *viewArr;

@property (nonatomic, retain) UIButton *startBtn; // 启动施工按钮

@property (nonatomic, retain) SWMyPublishDetailData *detailData;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, retain) NSArray *dataSource;

@end

@implementation SWPublishOngoingDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewArr = [NSMutableArray array];
    
    _state = 2;
    
    [self setupBackw];
    [self setupNextWithString:@"收藏" withColor:TOP_GREEN];
    [self loadInfoData];
}

-(void)onNext
{
    SWMyFavoriteController *favorite = [SWMyFavoriteController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:favorite animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)setTitleStr:(NSString *)titleStr {
    
    _titleStr = titleStr;
    
    [self setupTitleWithString:titleStr withColor:[UIColor whiteColor]];
    
}

//加载详情
- (void)loadInfoData {
    
    SWMyPublishDetailCmd *detailCmd = [[SWMyPublishDetailCmd alloc] init];
    detailCmd.iid = self.iid;
    
    [[HttpNetwork getInstance] requestPOST:detailCmd success:^(BaseRespond *respond) {
        
        SWMyPublishDetailInfo *detailInfo = [[SWMyPublishDetailInfo alloc] initWithDictionary:respond.data];
        
        if(detailInfo.code == 0) {
            
            SWMyPublishDetailData *detailData = detailInfo.data;
            _detailData = detailData;
            
            
            [self initWithView];
            
            
        }
        
        
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        
        
    }];
    
}

- (void)loadWorkerData {
    
    SWLookUserCmd *userCmd = [[SWLookUserCmd alloc] init];
    userCmd.type = 3;
    userCmd.iid = self.iid;
    
    [[HttpNetwork getInstance] requestPOST:userCmd success:^(BaseRespond *respond) {
        
        SWLookUserInfo *userInfo = [[SWLookUserInfo alloc] initWithDictionary:respond.data];
        
        
        _dataSource = userInfo.data;
        
        [self setUpBottomView];
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        
        
    }];
    
}

//初始化视图
- (void)initWithView {
    
    _contentView                 = [[UIScrollView alloc] init];
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.frame           = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    _contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    [self.view addSubview:_contentView];
    
    UIButton *startJob = [[UIButton alloc] init];
    startJob.frame     = CGRectMake(0, SCREEN_HEIGHT - 64 - 44-39, SCREEN_WIDTH, 39);
    startJob.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
    [startJob setTitle:@"确认完工" forState:UIControlStateNormal];
    startJob.titleLabel.font = [UIFont systemFontOfSize:12];
    [startJob addTarget:self action:@selector(startJobClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startJob];
    _startBtn = startJob;
    
    [self setUpHeadView];
    
    [self loadWorkerData];
    
}

- (void)startJobClick:(UIButton *)sender {
    
    
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"确定完成施工么？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        SWSWEmployerConfirmCmd *comfirmCmd = [[SWSWEmployerConfirmCmd alloc] init];
        comfirmCmd.information_id = self.iid;
        
        [[HttpNetwork getInstance] requestPOST:comfirmCmd success:^(BaseRespond *respond) {
            
            SWEmployessComfirmInfo *employeeInfo = [[SWEmployessComfirmInfo alloc] initWithDictionary:respond.data];
            
            if(employeeInfo.code == 0) {
                
                [sender setTitle:@"已完成施工" forState:UIControlStateNormal];
                [MBProgressHUD showError:@"已完成施工" toView:self.view];
                
            }else {
                
                [MBProgressHUD showError:employeeInfo.message toView:self.view];
                
            }
            
        } failed:^(BaseRespond *respond, NSString *error) {
            
            [MBProgressHUD showError:@"网络异常" toView:self.view];
            
        }];
    }]];
    [self presentViewController:alerVC animated:YES completion:nil];
    
}

- (void)setUpBottomView {
    
    CGFloat viewX = 0;
    CGFloat viewY = padding + CGRectGetMaxY(_headerView.frame);
    CGFloat viewW = SCREEN_WIDTH;
    CGFloat viewH = 55.0f;
    
    CGFloat maxHeight = 0;
    
    for (int i = 0; i < _dataSource.count; i++) {
        
        SWLookUserData *userData = _dataSource[i];
        
        viewY = padding * (i + 1) + viewH * i + CGRectGetMaxY(_headerView.frame);
        
        SWSeeWokerView *seeView = [[SWSeeWokerView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        seeView.data = userData;
        seeView.backgroundColor = [UIColor whiteColor];
        [seeView showOngoingWorkerData:userData.avatar name:userData.name jobs:userData.type status:userData.status];
        [_contentView addSubview:seeView];
        maxHeight = CGRectGetMaxY(seeView.frame) + padding;
        [self.viewArr addObject:seeView];
        NSString *str = seeView.btnStr;
        
        CGSize strSize = [str sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        
        //手势view
        UIView *gestureView = [[UIView alloc] init];
        gestureView.frame   = CGRectMake(0, 0, SCREEN_WIDTH - strSize.width - 2 *padding, viewH);
        gestureView.tag     = [userData.uid integerValue];
        [seeView insertSubview:gestureView atIndex:0];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToWorkerDetail:)];
        
        [gestureView addGestureRecognizer:tapGesture];
    }
    
    _contentView.contentSize = CGSizeMake(0, maxHeight + padding + 39);
    [self.view bringSubviewToFront:_startBtn];
}
/**
 点击查看工人详情
 
 @param gesture 点击手势
 */
- (void)pushToWorkerDetail:(UITapGestureRecognizer *)gesture {
    
    SWWorkerDetailController *workerDetailController = [[SWWorkerDetailController alloc] init];
    workerDetailController.uid = [NSString stringWithFormat:@"%ld",gesture.view.tag];
    
    SWSeeWokerView *workerView = (SWSeeWokerView *)[gesture.view superview];
    workerDetailController.workerName = workerView.data.name;
    workerDetailController.is_detail = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:workerDetailController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
//设置头部视图
- (void)setUpHeadView {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame   = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    headerView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:headerView];
    _headerView = headerView;
    
    NSMutableString *str = [NSMutableString string];
    
    for (SWFindWorkType *workerType in _detailData.worker) {
        
        [str appendString:[NSString stringWithFormat:@"%@(%@名) ",workerType.type,workerType.num]];
        
    }
    
    NSString *remark = _detailData.remark;
    if(IS_EMPTY(_detailData.remark)) {
        
        remark = @"无";
        
    }
    
    NSArray *titleArr = @[@"位置",@"开始时间",@"用工数",@"总预算",@"工期",@"有效期",@"备注"];
    NSArray *contentArr = @[_detailData.address,_detailData.start_time,str,[NSString stringWithFormat:@"%@元",_detailData.budget],_detailData.schedule,@"3天",remark];
    
    CGFloat contentX = 0;
    CGFloat contentY = padding;
    
    for (int i = 0; i < titleArr.count; i++) {
        
        CGFloat nowY = [self showLabel:headerView frame:CGRectMake(contentX, contentY, 0, 0) title:titleArr[i] content:contentArr[i]];
        
        contentY = nowY + padding;
        
    }
    
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, contentY);
    
}

//显示信息
- (CGFloat)showLabel:(UIView *)contentView frame:(CGRect)frame title:(NSString *)title content:(NSString *)content {
    
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.frame    = CGRectMake(padding, frame.origin.y, titleSize.width, titleSize.height);
    titleLbl.text     = title;
    titleLbl.font     = [UIFont systemFontOfSize:12];
    titleLbl.textColor = [UIColor colorWithRed:0.17 green:0.18 blue:0.19 alpha:1.00];
    [contentView addSubview:titleLbl];
    
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH - 3 * padding - titleSize.width];
    
    UILabel *contentLbl = [[UILabel alloc] init];
    contentLbl.frame    = CGRectMake(SCREEN_WIDTH - padding - contentSize.width, frame.origin.y, contentSize.width, contentSize.height);
    contentLbl.text     = content;
    contentLbl.numberOfLines = 0;
    contentLbl.textColor = [UIColor colorWithRed:0.05 green:0.07 blue:0.09 alpha:1.00];
    contentLbl.font     = [UIFont systemFontOfSize:12];
    [contentView addSubview:contentLbl];
    
    return CGRectGetMaxY(contentLbl.frame) + padding;
    
}




@end
