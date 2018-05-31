//
//  SWWorkerDetailController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/23.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWWorkerDetailController.h"
#import "CXZ.h"

#import "SWCommentView.h"

#import "SWWorkerDetailCmd.h"
#import "SWWorkerDetailInfo.h"
#import "SWWorkerDetailData.h"
#import "SWDetailWorkerInfo.h"
#import "SWDetailWorkerComments.h"

#import "SWWorkerLocationController.h"
#import "SWCollectCmd.h"
#import "SWCollectInfo.h"

#import "SWInviteCmd.h"
#import "SWInviteInfo.h"

#import "SWMyPublishCmd.h"
#import "SWMyPublishInfo.h"
#import "SWMyPublishData.h"

#import "SWUploadContractCmd.h"
#import "SWUploadContractInfo.h"

#import "XRWaterfallLayout.h"
#import "ProductionCollectionViewCell.h"
#import "SWEvaluateCell.h"
#import "SWEvaluteFrame.h"
#import "SWMyEvaluateCmd.h"
#import "SWMyEvaluateInfo.h"
#import "SWEvaluateData.h"
#import "SWTools.h"

#import "SWPublishController.h"
#import "SWMyLocationController.h"
#import "SignNameViewController.h"
#import "ListViewController.h"
#import "MyProductionViewController.h"
#import "SWMyEvaluateController.h"
#import "ProductionDetailViewController.h"
#import "PaymentsFormViewController.h"
#import "PurchaseViewController.h"
#import "ApprovalFileViewController.h"
#import "ExpenseAccountViewController.h"
#import "StartViewController.h"
#import "RechargeViewController.h"

@interface SWWorkerDetailController ()<UITableViewDelegate,UITableViewDataSource,ProductionCellDelegate,MyLocationControllerDelegate,RCIMUserInfoDataSource>

{
    NSArray *titleArray;
}

@property (nonatomic, retain) SWDetailWorkerInfo *workerInfo; //工人信息

@property (nonatomic, retain) UIButton *likeBtn;
//
@property (nonatomic, strong) UITableView *detailTableView;

@property (nonatomic, strong) UIImageView *headImgview;

@property (nonatomic, strong) UIImageView *shadowImgview;

@property (nonatomic, strong) UIButton *productonButton;

@property (nonatomic ,strong) UILabel *nameLable;

//@property (nonatomic ,strong) UIButton *locoalButton;

@property (nonatomic ,strong) UIButton *phoneButton;

@property (nonatomic ,strong) UIButton *commentButton;

@property (nonatomic ,strong) NSMutableArray *dataArray;

@property (nonatomic, retain) SWWorkerDetailData *workerDetailData;

@property (nonatomic, copy) NSString *contractName;

@property (nonatomic, strong) SWMyPublishData *myPublishData;

@property (nonatomic, copy) NSString *companyID;

@end

@implementation SWWorkerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

   self.view.backgroundColor = [UIColor whiteColor];
    [self setupBackw];
    [self setupNextWithImage:[UIImage imageNamed:@"WorkerLocation"]];
    
    _detailTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _detailTableView.height = SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT;
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    [self.view addSubview:_detailTableView];
    _detailTableView.hidden = YES;
    
    if(!_is_detail)
    {
        [self configBottomView];
    }
    titleArray = @[@"工种",@"好评度",@"被雇佣次数",@"工龄",@"期望薪资",@"身份证",@"籍贯",@"QQ",@"微信",@"暂住地址",@"个人评价"];
    [self isPayForWorker];
    [self loadProductionOfWorker];
//    [self loadWorkerDetailData];
}

#pragma mark 获取数据

-(void)loadWorkerDetailData{
    SWWorkerDetailCmd *detailCmd = [[SWWorkerDetailCmd alloc] init];
    detailCmd.uid = _uid;
    detailCmd.user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    [[HttpNetwork getInstance] requestPOST:detailCmd success:^(BaseRespond *respond) {
        
        SWWorkerDetailInfo *workerDetailInfo = [[SWWorkerDetailInfo alloc] initWithDictionary:respond.data];
//                NSLog(@"*gongre**%@",respond);
        if(workerDetailInfo.code == 0) {
            
            SWWorkerDetailData *workerDetailData = workerDetailInfo.data;
            _workerDetailData = workerDetailData;
            
            SWDetailWorkerInfo *workerInfo = workerDetailData.worker;
            _workerInfo = workerInfo;
            self.detailTableView.hidden = NO;
            [self.detailTableView reloadData];
            
        }else {
            [MBProgressHUD showError:@"获取工人信息失败" toView:self.view];
        }
    } failed:^(BaseRespond *respond, NSString *error) {
        
    }];
    
}

-(void)loadProductionOfWorker
{
    [[NetworkSingletion sharedManager]getMyProductionList:@{@"uid":self.uid} onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            NSMutableArray *arrray = [NSMutableArray array];
            [arrray addObjectsFromArray:dict[@"data"]];
            if (arrray.count > 0) {
                NSDictionary *dict = arrray[0];
                NSArray *picArray = dict[@"picture"];
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,picArray[0]];
                //        NSLog(@"**uir *%@",urlStr);
                [self.shadowImgview sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"worker_tips"]];
            }
        }
       
    } OnError:^(NSString *error) {
       
    }];
}

-(void)isPayForWorker
{
    [[NetworkSingletion sharedManager]isPayForTheWorker:@{@"target_uid":self.uid} onSucceed:^(NSDictionary *dict) {
                NSLog(@"**uir *%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            NSInteger status = [[dict[@"data"] objectForKey:@"status"] integerValue];
            if (status == 1) {
                self.detailTableView.hidden = NO;
                [self loadWorkerDetailData];
            }else{
                [self toPayTips];
            }
        }
    } OnError:^(NSString *error) {
        
    }];
}

-(void)toPayForWorker
{
    [[NetworkSingletion sharedManager]toPayForTheWorkerFromCount:@{@"target_uid":self.uid} onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            NSInteger status = [[dict[@"data"] objectForKey:@"status"] integerValue];
            if (status == 1) {//付款成功可以查看
                self.detailTableView.hidden = NO;
                [self loadWorkerDetailData];
            }else{//2  余额不足请充值
                [self toCharge];
            }
        }
    } OnError:^(NSString *error) {
        
    }];
}

-(void)toPayTips
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"查看工人信息，需向工人支付1元费用" message:@"是否继续？" preferredStyle:UIAlertControllerStyleAlert];

    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    } ]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self toPayForWorker];
    } ]];
    [self.navigationController presentViewController:alertView animated:YES completion:nil];
}
-(void)toCharge
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"余额不足请充值" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    } ]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self toPayForWorker];
        RechargeViewController *rechargeVC = [[RechargeViewController alloc]init];
        rechargeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rechargeVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    } ]];
    [self.navigationController presentViewController:alertView animated:YES completion:nil];
}

#pragma mark Private Method


-(void)configBottomView
{
    CGFloat btnW = SCREEN_WIDTH / 2;
    CGFloat btnH = 39;
    CGFloat btnY = SCREEN_HEIGHT - btnH - 64;
    
    
    CGFloat inviteX = 0;
    
    UIButton *sendBtn = [[UIButton alloc] init];
    sendBtn.frame     = CGRectMake(inviteX, btnY, btnW, btnH);
    sendBtn.backgroundColor = [UIColor whiteColor];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sendBtn setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendContract:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.titleEdgeInsets = UIEdgeInsetsMake(10, 5, 10, -5);
    [sendBtn setTitle:@"发送..." forState:UIControlStateNormal];
    [self.view addSubview:sendBtn];
    
    CGFloat likeX = CGRectGetMaxX(sendBtn.frame);
    
    UIButton *likeBtn = [[UIButton alloc] init];
    likeBtn.frame     = CGRectMake(likeX, btnY, btnW, btnH);
    likeBtn.backgroundColor = [UIColor whiteColor];
    [likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    likeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    [likeBtn setImage:[UIImage imageNamed:@"favorite_unclick"] forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"favorite_click"] forState:UIControlStateSelected];
    likeBtn.selected = _workerDetailData.issc;
    likeBtn.titleEdgeInsets = UIEdgeInsetsMake(10, 5, 10, -5);
    [likeBtn setTitle:@"加入收藏" forState:UIControlStateNormal];
    [likeBtn setTitle:@"取消收藏" forState:UIControlStateSelected];
    [self.view addSubview:likeBtn];
}

#pragma mark ScrollView Delegate


- (void)setWorkerName:(NSString *)workerName {
    
    _workerName = workerName;
    
    [self setupTitleWithString:[NSString stringWithFormat:@"%@%@",workerName,@"的介绍"] withColor:[UIColor whiteColor]];
}




#pragma mark --------- tableViewDelegate & tableViewDataSource start --------------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return titleArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"NormallCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = TITLECOLOR;
    cell.detailTextLabel.textColor = SUBTITLECOLOR;
    if (indexPath.row == titleArray.count-1) {
        cell.detailTextLabel.numberOfLines = 2;
    }
    if (self.workerInfo) {
        NSString *workerNum;
        if(IS_EMPTY(_workerInfo.work_num)) {
            workerNum = [NSString stringWithFormat:@"%@次",@"0"];
        }else {
            workerNum = [NSString stringWithFormat:@"%@次",_workerInfo.work_num];
        }
        NSString *address;
        if ([NSString isBlankString:self.workerInfo.address]) {
            address = @"未填写居住地址";
        }else{
            address = self.workerInfo.address;
        }
        NSString *evaluation;
        if ([NSString isBlankString:self.workerInfo.self_evaluation]) {
            evaluation = @"未填写个人评论";
        }else{
            evaluation = self.workerInfo.self_evaluation;
        }
        NSString *work_year;
        if ([NSString isBlankString:self.workerInfo.work_years]) {
            work_year = @"未填写工龄";
        }else{
            work_year = self.workerInfo.work_years;
        }
        NSString *qq;
        if ([NSString isBlankString:self.workerInfo.qq]) {
            qq = @"未填写QQ";
        }else{
            qq = self.workerInfo.qq;
        }
        NSString *wechat;
        if ([NSString isBlankString:self.workerInfo.wechat]) {
            wechat = @"未填写微信";
        }else{
            wechat = self.workerInfo.wechat;
        }
        NSString *hometown;
        if ([NSString isBlankString:self.workerInfo.hometown]) {
            hometown = @"未填写籍贯";
        }else{
            hometown = self.workerInfo.hometown;
        }
        NSString *workerType;
        if (self.workerInfo.type.count > 0) {
            workerType = [self.workerInfo.type componentsJoinedByString:@","];
        }else{
            workerType = @"未填写工种";
        }
        NSString *name;
        if ([NSString isBlankString:self.workerInfo.name]) {
            name = @"未填写姓名";
        }else{
            name = self.workerInfo.name;
        }
        NSArray *contenArray = @[workerType,self.workerInfo.nice,workerNum,work_year,self.workerInfo.salary,self.workerInfo.idcard,hometown,qq,wechat,address,evaluation];
        cell.detailTextLabel.text = contenArray[indexPath.row];
        cell.textLabel.text = titleArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40.0f;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SCREEN_WIDTH/5*3+70;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/5*3+70)];
    headView.backgroundColor = [UIColor whiteColor];
    _shadowImgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/5*3)];
    _shadowImgview.image = [UIImage imageNamed:@"worker_tips"];
    _shadowImgview.contentMode = UIViewContentModeScaleAspectFill;
    [headView addSubview:_shadowImgview];
    
    UIView *line = [CustomView customLineView:headView];
    line.frame = _shadowImgview.frame;
    line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    
    _productonButton = [CustomView customButtonWithContentView:headView image:@"production" title:@"作品集"];
    _productonButton.frame = CGRectMake(SCREEN_WIDTH-118, SCREEN_WIDTH/5*3-50, 110, 40);
    [_productonButton addTarget:self action:@selector(clickProductonButton) forControlEvents:UIControlEventTouchUpInside];
    
    _headImgview = [[UIImageView alloc]initWithFrame:CGRectMake(8, _shadowImgview.bottom-20, 80, 80)];
    _headImgview.image = [UIImage imageNamed:@"temp"];
    _headImgview.layer.cornerRadius = 40.0;
    _headImgview.layer.masksToBounds = YES;
    [headView addSubview:_headImgview];
    
    _nameLable = [CustomView customContentUILableWithContentView:headView title:nil];
    _nameLable.frame = CGRectMake(_headImgview.right+8, _shadowImgview.bottom, 150, 30);
    
    _commentButton = [CustomView customButtonWithContentView:headView image:@"myrecommend" title:@"评价"];
    _commentButton.frame = CGRectMake(SCREEN_WIDTH-58, _nameLable.top+10, 50, 40);
    [_commentButton addTarget:self action:@selector(clickCommentButton) forControlEvents:UIControlEventTouchUpInside];
    
    _phoneButton = [CustomView customButtonWithContentView:headView image:@"phone" title:nil];
    _phoneButton.frame = CGRectMake(_headImgview.right+8, _nameLable.bottom, 130, 30);
    [_phoneButton addTarget:self action:@selector(callClick:) forControlEvents:UIControlEventTouchUpInside];
//    _phoneButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
    if (self.workerInfo) {
        NSString *hearUrl = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,self.workerInfo.avatar];
        [_headImgview sd_setImageWithURL:[NSURL URLWithString:hearUrl] placeholderImage:[UIImage imageNamed:@"temp"]];
        _nameLable.text = self.workerInfo.name;
        [_phoneButton setTitle:self.workerInfo.phone forState:UIControlStateNormal];
    }
    
    return headView;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}



#pragma mark 合同相关

- (void)sendContract:(UIButton *)sender {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"发送合同" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.contractName  = @"";
        ListViewController *postVC = [[ListViewController alloc]init];
        postVC.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        postVC.workID = self.uid;
        postVC.list_type = 1;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:postVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"验收单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        StartViewController *startVC = [[StartViewController alloc]init];
        startVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:startVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"请购单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PurchaseViewController *purchaseVC = [[PurchaseViewController alloc]init];
        purchaseVC.form_type = 1;
         purchaseVC.worker_user_id = self.uid;
        purchaseVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:purchaseVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"请款单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self enterPaymentViewController];
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"呈批件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ApprovalFileViewController *fileVC = [[ApprovalFileViewController alloc]init];
        fileVC.form_type = 1;
        fileVC.worker_user_id = self.uid;
        fileVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fileVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"报销单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ExpenseAccountViewController *expenseVC = [[ExpenseAccountViewController alloc]init];
        expenseVC.form_type = 1;
        expenseVC.worker_user_id = self.uid;
        expenseVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:expenseVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertVC animated:YES completion:NULL];
    
}

-(void)enterPaymentViewController
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"选择请款依据" preferredStyle:UIAlertControllerStyleActionSheet];
    CopyViewController *copyVC = [[CopyViewController alloc]init];
    copyVC.companyID = self.companyID;
    copyVC.formType = 1;
    copyVC.is_selected_form = YES;
    copyVC.worker_user_id = self.uid;
    [alertView addAction:[UIAlertAction actionWithTitle:@"请购单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        copyVC.type = 1;
        copyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:copyVC animated:YES];
        
    } ]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"呈批件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        copyVC.type = 3;
        copyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:copyVC animated:YES];
    } ]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    } ]];
    
    [self.navigationController presentViewController:alertView animated:YES completion:nil];
}

#pragma  IBAction

- (void)likeClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    SWCollectCmd *collectCmd = [[SWCollectCmd alloc] init];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    collectCmd.uid = uid;
    collectCmd.worker_id = self.uid;
    collectCmd.status = !sender.isSelected;
    [[HttpNetwork getInstance] requestPOST:collectCmd success:^(BaseRespond *respond) {
        
        SWCollectInfo *collectInfo = [[SWCollectInfo alloc] initWithDictionary:respond.data];
        
        if(collectInfo.code == 0){
            
            sender.selected = !sender.isSelected;
            CGFloat likeX = sender.frame.origin.x;
            CGFloat likeY = sender.frame.origin.y;
            CGFloat likeW = sender.bounds.size.width;
            CGFloat likeH = sender.bounds.size.height;
            sender.frame = CGRectMake(likeX, likeY, likeW, likeH);
            
        }
        
        sender.userInteractionEnabled = YES;
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        sender.userInteractionEnabled = YES;
        
    }];
}

- (void)callClick:(UIButton *)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"找他聊聊" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"电话聊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.workerInfo.phone];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.navigationController.view addSubview:callWebview];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"在线聊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //数据源方法，要传递数据必须加上
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        RCConversationViewController *chat = [[RCConversationViewController alloc] init];
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等0
        chat.conversationType = ConversationType_PRIVATE;
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = self.uid;
        
        //设置聊天会话界面要显示的标题
        chat.title = self.workerInfo.name;
        //显示聊天会话界面
        chat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chat animated:YES];
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)onNext {
    
    SWWorkerLocationController *workerLocationController = [[SWWorkerLocationController alloc] init];
    workerLocationController.workerName = _workerInfo.name;
    workerLocationController.uid = _uid;
    workerLocationController.latitude   = [self.workerInfo.latitude doubleValue];
    workerLocationController.longtitude = [self.workerInfo.longitude doubleValue];
    [self.navigationController pushViewController:workerLocationController animated:YES];
    
}


-(void)clickProductonButton
{
    MyProductionViewController *procutionVC = [[MyProductionViewController alloc]init];
    procutionVC.is_other_worker = YES;
    procutionVC.other_worker_uid = self.uid;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:procutionVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

-(void)clickCommentButton
{
    SWMyEvaluateController *evaluatenVC = [[SWMyEvaluateController alloc]init];
    evaluatenVC.is_other_worker = YES;
    evaluatenVC.other_worker_uid = self.uid;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:evaluatenVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}


#pragma mark - 融云代理 -


- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion {
    
    //自己的信息
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    
    if ([uid isEqualToString:userId]) {
        
        RCUserInfo *user = [RCIM sharedRCIM].currentUserInfo;
        return completion(user);
    }else{
        RCUserInfo *user = [[RCDataBaseManager shareInstance]getUserByUserId:userId];
        if (user) {
            return completion(user);
        }else{
            [[NetworkSingletion sharedManager]getUserInfo:@{@"uid":userId} onSucceed:^(NSDictionary *dict) {
                
                if ([dict[@"code"] integerValue]==0) {
                    NSString* portraitUrl;
                    NSString *avatar = [dict[@"data"] objectForKey:@"avatar"];
                    if (![NSString isBlankString:avatar]) {
                        portraitUrl = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,avatar];
                    }else{
                        portraitUrl = @"";
                    }
                    NSString *name = [dict[@"data"] objectForKey:@"name"];
                    if ([NSString isBlankString:name]) {
                        name = @"";
                    }
                    RCUserInfo *user = [[RCUserInfo alloc]initWithUserId:userId name:name portrait:portraitUrl];
                    [[RCDataBaseManager shareInstance] insertUserToDB:user];
                    
                    return completion(user);
                    
                }
            } OnError:^(NSString *error) {
            }];
        }
        
    }
    
}



#pragma mark 设置cell分割线边缘位置
-(void)viewDidLayoutSubviews
{
    if ([self.detailTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.detailTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.detailTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.detailTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark get/set

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}




@end
