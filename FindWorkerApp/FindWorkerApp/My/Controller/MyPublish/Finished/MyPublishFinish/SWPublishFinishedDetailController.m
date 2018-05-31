//
//  SWPublishFinishedDetailController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/26.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWPublishFinishedDetailController.h"
#import "SWWorkerDetailController.h"
#import "CXZ.h"

#import "SWSeeWokerView.h"

#import "SWEvaluateWorkerController.h"
#import "SWMyFavoriteController.h"
#import "SWMyPublishDetailCmd.h"
#import "SWMyPublishDetailInfo.h"
#import "SWMyPublishDetailData.h"
#import "SWFindWorkType.h"

#import "SWLookUserCmd.h"
#import "SWLookUserInfo.h"
#import "SWLookUserDetail.h"
#import "SWLookUserData.h"

#import "SWCommentingView.h"

#define padding 10

@interface SWPublishFinishedDetailController ()<SWSeeWorkerDelegate>

@property (nonatomic, retain) UIScrollView *contentView;

@property (nonatomic, retain) UIView *headerView;

@property (nonatomic, retain) UIView *footerView;

@property (nonatomic, retain) NSMutableArray *viewArr;

@property (nonatomic, retain) UIButton *startBtn; // 启动施工按钮

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, retain) SWMyPublishDetailData *detailData;

@property (nonatomic, retain) NSArray *dataSource;

@property (nonatomic, retain) UIView *shadownView;

@property (nonatomic, retain) SWCommentingView *commentView;

@end

@implementation SWPublishFinishedDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewArr = [NSMutableArray array];
    
    _state = 4;
    
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
//        NSLog(@"**user data **%@",userInfo);
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
//    
//    UIButton *startJob = [[UIButton alloc] init];
//    startJob.frame     = CGRectMake(0, SCREEN_HEIGHT - 64 - 39, SCREEN_WIDTH, 39);
//    startJob.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
//    [startJob setTitle:@"立即评价" forState:UIControlStateNormal];
//    startJob.titleLabel.font = [UIFont systemFontOfSize:12];
//    [startJob addTarget:self action:@selector(startJobClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:startJob];
//    _startBtn = startJob;
    
    [self setUpHeadView];
    
    [self loadWorkerData];
    
}

- (void)startJobClick:(UIButton *)sender {
    
    SWEvaluateWorkerController *evaluateController = [[SWEvaluateWorkerController alloc] init];
    evaluateController.workerArr = _dataSource;
    [self.navigationController pushViewController:evaluateController animated:YES];
    
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
        seeView.backgroundColor = [UIColor whiteColor];
        //        [seeView showUnWorkerData:@"temp" name:@"xhr" jobs:@[@"水电工",@"水电工",@"水电工"]];
//        [seeView showWorkerData:userData.avatar name:userData.name jobs:userData.type state:_state];
        seeView.seeDelegate = self;
        seeView.data = userData;
        [seeView showWorkerCommentView:userData.avatar name:userData.name jobs:userData.type status:userData.rate];
        
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
    
}
/**
 点击查看工人详情
 
 @param gesture 点击手势
 */
- (void)pushToWorkerDetail:(UITapGestureRecognizer *)gesture {
    
    
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

- (void)commentToWorker:(SWSeeWokerView *)workerView {
    
    [self showCommentView:workerView];
    
}

- (void)showCommentView:(SWSeeWokerView *)workerView {
    
    if(!_shadownView) {
        
        _shadownView = [[UIView alloc] init];
        _shadownView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _shadownView.backgroundColor = [UIColor blackColor];
        _shadownView.alpha = 0.7;
        [[UIApplication sharedApplication].keyWindow addSubview:_shadownView];
        
        UITapGestureRecognizer *tapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [_shadownView addGestureRecognizer:tapGestrue];
        
        CGFloat workerX = padding;
        CGFloat workerY = 80;
        CGFloat workerW = SCREEN_WIDTH - 2 * workerX;
        CGFloat workerH = padding;
        
        _commentView = [[SWCommentingView alloc] initWithFrame:CGRectMake(workerX, workerY, workerW, workerH)];
        _commentView.backgroundColor = [UIColor whiteColor];
        _commentView.layer.cornerRadius = 6;
        _commentView.infomation_id = self.iid;
        _commentView.layer.masksToBounds = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:_commentView];
        
        
    }else {
        
        _shadownView.hidden = NO;
        _commentView.hidden = NO;
        
    }
    
    _commentView.data = workerView.data;
    [_commentView showData:workerView.data.avatar name:workerView.data.name jobArr:workerView.data.type];
    
}

- (void)hideView {
    
    _shadownView.hidden = YES;
    _commentView.hidden = YES;
    
}

@end
