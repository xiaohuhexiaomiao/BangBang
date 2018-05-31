//
//  SWMyController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/17.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMyController.h"
#import "CXZ.h"
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "SWMyAccountController.h"
#import "SWMyFavoriteController.h"
#import "SWMyJobController.h"
#import "SWMyPublishController.h"
#import "SWMyEvaluateController.h"
#import "SWBindBankController.h"
#import "SWMyContractController.h"
#import "SWLoginController.h"
#import "SWCompleteInfoController.h"
#import "NoticeViewController.h"
#import "MyWorkersViewController.h"
#import "TransactionLogViewController.h"
#import "RecommendFriendViewController.h"
#import "MyProductionViewController.h"
#import "ToPayViewController.h"
#import "IdeaBackViewController.h"
#import "ConstructionRecordsViewController.h"
#import "SWDailyOfficeViewController.h"
#import "SWUserData.h"
#import "ToPayViewController.h"
#import "NoticeCenterViewController.h"
#import "RechargeViewController.h"

#import "SWMyUserInfoCmd.h"
#import "SWMyUserInfo.h"
#import "SWMyUserData.h"

//自定义的Switch
#import "LQXSwitch.h"

#import "SWButton.h"

#import "SWFindWorkerUtils.h"

#import "SWChangeJobStateCmd.h"
#import "SWChangeJobStateInfo.h"

#import "WXApi.h"

#import "JPUSHService.h"

#define padding 30

@interface TableViewCell : UITableViewCell

@property (nonatomic, retain) UIImageView *leftImageV;
@property (nonatomic, retain) UILabel *titleLab;

- (void)setLeftImage:(UIImage *)img title:(NSString *)titleStr;

@end
@implementation TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.leftImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 14, 14)];
        [self addSubview:self.leftImageV];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImageV.right + 10, self.leftImageV.top, 150, self.leftImageV.height)];
        self.titleLab.textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.00];
        self.titleLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.titleLab];
    }
    return self;
}

- (void)setLeftImage:(UIImage *)img title:(NSString *)titleStr
{
    self.leftImageV.image = img;
    self.titleLab.text = titleStr;
}

@end

@interface SWMyController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) UIView *headerView;

@property (nonatomic, retain) UIImageView *icon;

@property (nonatomic, retain) UIView *shareShadowView; //分享背后阴影view

@property (nonatomic, retain) UIView *shareView; //分享View

@property (nonatomic, retain) UIButton *usernameBtn;

@property (nonatomic, strong) UILabel *redLabel;

@property (nonatomic, strong) UIButton *typeBtn;//身份

@property (nonatomic, retain) LQXSwitch *switchBtn;

@property (nonatomic, retain) LQXSwitch *voiceBtn;

@property (nonatomic, assign) BOOL is_error; //为了解决，switch开关循环切换的问题

@property (nonatomic, retain) UIButton *editBtn;

@property (nonatomic ,assign) NSInteger workState;//我要接活状态

@property (nonatomic ,assign) NSInteger voiceState;//语音提示状态

@property (nonatomic, assign)  BOOL is_Login;

@property (nonatomic, strong) NSArray *bossNameArray;

@property (nonatomic, strong) NSArray *bossArray;

@property (nonatomic, strong) NSArray *bossImageArray;

//@property (nonatomic, strong) NSArray *workerNameArray;
//
//@property (nonatomic, strong) NSArray *workerArray;

@end

@implementation SWMyController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _is_error = NO;
    _is_Login = [[NSUserDefaults standardUserDefaults] boolForKey:@"IS_LOGIN"];
    
    NSString *voice = [[NSUserDefaults standardUserDefaults] objectForKey:@"VoiceState"];
    if (voice) {
        _voiceState = [voice integerValue];
    }else{
        _voiceState = 0;
    }
    
    _bossNameArray = @[@[@"通知",@"我发布的工程",@"我发出的合同",@"我的作品"],@[@"我要发工资",@"我的账户",@"充值",@"我的收藏"],@[@"推荐好友",@"分享APP",@"清除缓存",@"投诉意见",@"关于我们"]];
    
    _bossImageArray = @[@[@"message",@"published",@"transaction_records",@"my_works"],@[@"myWorkers",@"account",@"recharge",@"favorite"],@[@"frends",@"share",@"clean",@"feedback",@"about"]];
    
    _bossArray = @[@[@"NoticeCenterViewController",@"SWMyPublishController",@"SWMyContractController",@"MyProductionViewController"],@[@"ToPayViewController",@"SWMyAccountController",@"RechargeViewController",@"SWMyFavoriteController"],@[@"RecommendFriendViewController",@"IdeaBackViewController"]];

    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    [self setupTitleWithString:@"我的" withColor:[UIColor whiteColor]];
    
    [self setupNextWithString:@"联系客服" withColor:TOP_GREEN];
 
    
    [self setUpView];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *unreadStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"UNREAD"];
    self.tabBarItem.badgeValue = unreadStr;
}

-(void)setupNextWithString:(NSString *)text withColor:(UIColor *)color
{
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16] width:100];
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width+4, 44)];
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    back.frame = CGRectMake(0, 0, size.width, 44);
    [back setTitle:text forState:UIControlStateNormal];
    [back setTitleColor:color forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:back];
    _redLabel = [[UILabel alloc]initWithFrame:CGRectMake(rightView.width-8, 8, 8, 8)];
    _redLabel.layer.cornerRadius = 4;
    _redLabel.layer.masksToBounds = YES;
    _redLabel.backgroundColor = [UIColor redColor];
    NSString *numberStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"NoticeNumber"];
    NSInteger  num = [numberStr integerValue];
    if (num> 0) {
        _redLabel.hidden = NO;
    }else{
        _redLabel.hidden = YES;
    }
    [rightView addSubview:_redLabel];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//客服电话
-(void)onNext
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"客服1 ：0571-86704660" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0571-86704660"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"客服2 ：0571-86704661" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0571-86704661"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:NULL];
}


- (void)checkMyState:(next)next {
    
    //设置用户名
    if(self.is_Login){
        
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        
        SWMyUserInfoCmd *userCmd = [[SWMyUserInfoCmd alloc] init];
        userCmd.uid = uid;
        
        [[HttpNetwork getInstance] requestPOST:userCmd success:^(BaseRespond *respond) {
            
            SWMyUserInfo *userInfo = [[SWMyUserInfo alloc] initWithDictionary:respond.data];
            SWMyUserData *userData = userInfo.data;
            
            next(userData.work_status);
            
        } failed:^(BaseRespond *respond, NSString *error) {
            
        }];
        
    }else {
        
        [MBProgressHUD showError:@"请先登录" toView:self.view];
        
    }
}

-(void)setXunFeiVoiceType{
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"设置语音类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"普通话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]setObject:@"xiaoyan" forKey:@"XUNFEIVOICE"];
    }]];
    
    [alerVC addAction:[UIAlertAction actionWithTitle:@"四川话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]setObject:@"xiaorong" forKey:@"XUNFEIVOICE"];
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"河南话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]setObject:@"xiaokun" forKey:@"XUNFEIVOICE"];
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"湖南话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]setObject:@"xiaoqiang" forKey:@"XUNFEIVOICE"];
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"粤语" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]setObject:@"xiaomei" forKey:@"XUNFEIVOICE"];
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"台湾普通话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]setObject:@"xiaolin" forKey:@"XUNFEIVOICE"];
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"蜡笔小新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]setObject:@"xiaoxin" forKey:@"XUNFEIVOICE"];
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    } ]];
    [self presentViewController:alerVC animated:YES completion:nil];
}

//设置界面
- (void)setUpView {
    
    //设置头文件
    [self setTableViewHeader];
    
    [self setUpMyWantToJob];
    
    UITableView *tableView    = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.frame           = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - 64 - 49 + 15);
    tableView.delegate        = self;
    tableView.dataSource      = self;
    tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    tableView.tableFooterView = [UIView new];
//    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:tableView];
    _tableView                = tableView;
    
    //设置尾视图
    [self setTableViewFooter];
    
}

/** 设置我要接活的view */
- (void)setUpMyWantToJob {
    
    UIView *jobView = [[UIView alloc] init];
    jobView.backgroundColor = [UIColor whiteColor];
    jobView.frame = CGRectMake(0, 165 * (SCREEN_HEIGHT * 1.0f / 667), SCREEN_WIDTH, 49);
    
    UIView *top_line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    top_line.backgroundColor = LINE_GRAY;
    [jobView addSubview:top_line];
    //
    UIView *view = [[UIView alloc] init];
    UILabel *title2  = [[UILabel alloc] init];
    title2.frame     = CGRectMake(20, (20 - 15) / 2, 100, 100);
    title2.textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.00];
    title2.font      = [UIFont systemFontOfSize:12];
    title2.text      = @"语音提示";
    [title2 sizeToFit];
    [view addSubview:title2];
    _voiceBtn = [[LQXSwitch alloc] initWithFrame:CGRectMake(title2.right + 5, 0, 40, 20) onColor:[UIColor colorWithRed:0.48 green:0.72 blue:0.72 alpha:1.00] offColor:[UIColor colorWithRed:0.93 green:0.95 blue:0.95 alpha:1.00] font:[UIFont systemFontOfSize:12] ballSize:15];
    if (_voiceState == 0) {
        _voiceBtn.on = YES;
    }else{
        _voiceBtn.on = NO;
    }
    [_voiceBtn addTarget:self action:@selector(changeVoiceStates:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:_voiceBtn];
    
    view.frame = CGRectMake((SCREEN_WIDTH - CGRectGetMaxX(_voiceBtn.frame)) / 2, (49 - 20) / 2, CGRectGetMaxX(_voiceBtn.frame), 20.0f * (SCREEN_HEIGHT * 1.0f / 667.0f));
    [jobView addSubview:view];
    UIView *bottom_line = [[UIView alloc] initWithFrame:CGRectMake(0, jobView.frame.size.height - 0.5, SCREEN_WIDTH, 0.5)];
    bottom_line.backgroundColor = LINE_GRAY;
    [jobView addSubview:bottom_line];
    
    UIButton *setButton = [CustomView customButtonWithContentView:jobView image:@"set" title:nil];
    setButton.frame = CGRectMake(view.right, 12, 20, 20);
    [setButton addTarget:self action:@selector(setXunFeiVoiceType) forControlEvents:UIControlEventTouchUpInside];
    
    [_headerView addSubview: jobView];
    
}

//设置头视图
- (void)setTableViewHeader {
    
    UIView *headerView         = [[UIView alloc] init];
    headerView.frame           = CGRectMake(0, 0, SCREEN_WIDTH, 212.0f * (SCREEN_HEIGHT * 1.0 / 667));
    headerView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    _headerView = headerView;
    
    //设置头像
    UIImageView *icon = [[UIImageView alloc] init];
    icon.frame        = CGRectMake(SCREEN_WIDTH / 2 - 30, 30.0f * (SCREEN_HEIGHT * 1.0f / 667.0f), 60, 60);
    icon.layer.cornerRadius  = 30;
    icon.layer.masksToBounds = YES;
    icon.layer.borderWidth   = 3;
    icon.image               = [UIImage imageNamed:@"temp"];
    icon.userInteractionEnabled = YES;
    icon.layer.borderColor   = [UIColor colorWithRed:0.55 green:0.77 blue:0.99 alpha:1.00].CGColor;
    [headerView addSubview:icon];
    _icon = icon;
    
    UIButton *username  = [[UIButton alloc] init];
    NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    //设置用户名
    NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"realname"];
    if(self.is_Login){
        
        if([NSString isBlankString:name]){
          name = @"";
        }
        //        NSLog(@"***%@",Userdata.avatar);
       [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,avatar]] placeholderImage:[UIImage imageNamed:@"temp"]];
        username.userInteractionEnabled = NO;
    }else {
        username.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Logout)];
        [icon addGestureRecognizer:tapGesture];
        
        name = @"点击登录";
        
    }
    username.frame     = CGRectMake((SCREEN_WIDTH -100) / 2, CGRectGetMaxY(icon.frame) + 5, 100, 15);
    [username setTitle:name forState:UIControlStateNormal];
    username.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [username setTitleColor:[UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1.00] forState:UIControlStateNormal];
    username.titleLabel.font      = [UIFont systemFontOfSize:12];
    [username addTarget:self action:@selector(QuitLogin:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:username];
    _usernameBtn = username;
    
    
    //点击编辑
    UIButton *editBtn = [[UIButton alloc] init];
    editBtn.frame     = CGRectMake(CGRectGetMaxX(icon.frame) + 7, CGRectGetMaxY(icon.frame) - 20, 100, 100);
    [editBtn setTitle:@"点击编辑" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(pushEditing:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [editBtn setTitleColor:[UIColor colorWithRed:0.45 green:0.62 blue:0.61 alpha:1.00] forState:UIControlStateNormal];
    [editBtn sizeToFit];
    [headerView addSubview:editBtn];
    _editBtn = editBtn;

}

- (void)changeInfo:(UIButton *)sender {
    
    
    if(self.is_Login) {
        
        SWCompleteInfoController *completeController = [[SWCompleteInfoController alloc] init];
        NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
        completeController.phone = phone;
        completeController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:completeController animated:YES];
        
    }else {
        
        [MBProgressHUD showError:@"请先登录" toView:self.view];
        
    }
    
    
}



//设置尾视图
- (void)setTableViewFooter {
    
    CGFloat footerH = 100;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, footerH)];
    
    CGFloat logoutH = 39;
    CGFloat logoutX = 40;
    
    UIButton *logoutBtn = [[UIButton alloc] init];
    logoutBtn.frame     = CGRectMake(logoutX, (footerH - logoutH) / 2, SCREEN_WIDTH - 2 * logoutX, logoutH);
    logoutBtn.backgroundColor = ORANGE_COLOR;
    
    logoutBtn.layer.cornerRadius = 5;
    logoutBtn.layer.masksToBounds = YES;
    
    logoutBtn.titleLabel.font  = [UIFont systemFontOfSize:14];
    [footerView addSubview:logoutBtn];
    
    if(self.is_Login) {
        [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutBtn addTarget:self action:@selector(logoutClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [logoutBtn setTitle:@"点击登录" forState:UIControlStateNormal];
        [logoutBtn addTarget:self action:@selector(Logout) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _tableView.tableFooterView = footerView;
    
}

-(void)changeVoiceStates:(LQXSwitch *)sender
{
    [self checkMyState:^(NSInteger state) {
        
        if (self.voiceState == 0) {
            
//            NSLog(@"guan bi");
            self.voiceState = 1;
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"VoiceState"];
        }else{
//            NSLog(@"kaiqi");
            self.voiceState = 0;
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"VoiceState"];
        }
        
    }];
}

- (void)Logout {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IS_LOGIN"];
    
    [SWFindWorkerUtils jumpLogin];
    
}

-(void)updateVip
{
    
}

- (void)QuitLogin:(UIButton *)sender {
    
    
    sender.userInteractionEnabled = NO;
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IS_LOGIN"];
    
    [SWFindWorkerUtils jumpLogin];
    
    sender.userInteractionEnabled = YES;
    
}

- (void)logoutClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"确定要退出登录么？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IS_LOGIN"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"LOG"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"user_id"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"IS_FINISH"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"realname"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"RongYunToken"];
        [SWFindWorkerUtils jumpLogin];
        
    }]];
    [self presentViewController:alerVC animated:YES completion:nil];
    sender.userInteractionEnabled = YES;
    
    
}

- (void)pushEditing:(UIButton *)sender {
    
    if(self.is_Login) {
        
        SWCompleteInfoController *completeController = [[SWCompleteInfoController alloc] init];
        
        NSString *roles = [[NSUserDefaults standardUserDefaults] objectForKey:@"roles"];
        NSString *is_finish = [[NSUserDefaults standardUserDefaults] objectForKey:@"IS_FINISH"];
        NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
        completeController.phone = phone;
        completeController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:completeController animated:YES];
        
    }else {
        
        [MBProgressHUD showError:@"请先登录" toView:self.view];
        
    }
}



#pragma  mark UITableview Datasource & Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.bossNameArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.bossNameArray[section];
    return array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";

    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setLeftImage:[UIImage imageNamed:self.bossImageArray[indexPath.section][indexPath.row]] title:self.bossNameArray[indexPath.section][indexPath.row]];
//     NSString *unreadNum = [[NSUserDefaults standardUserDefaults]objectForKey:@"UNREAD"];
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        if ([unreadNum integerValue] > 0 ) {
//            NSString *title =[NSString stringWithFormat:@"聊天记录（%@条未读消息）",unreadNum];
//            NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:title];
//            [titleStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, title.length-4)];
//            cell.titleLab.attributedText = titleStr;
//        }else{
//            cell.titleLab.text = @"聊天记录";
//        }
//        
//    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 49.0f * (SCREEN_HEIGHT * 1.0f / 667.0f);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.is_Login) {
        if (indexPath.section == self.bossNameArray.count-1) {
            
            if (indexPath.row == 0) {
                
                RecommendFriendViewController *friendVC = [[RecommendFriendViewController alloc]init];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:friendVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
                
            }

            else if (indexPath.row == 1){
                [self share];
            }else if(indexPath.row == 2){
                CGFloat size = [self readCacheSize];
                UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"确定要清除缓存么？" message:[NSString stringWithFormat:@"合计：%.2fM",size] preferredStyle:UIAlertControllerStyleAlert];
                
                [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self  cleanCache];
                    
                }]];
                [self presentViewController:alerVC animated:YES completion:nil];
            }else if(indexPath.row == 3){
                IdeaBackViewController *ideaVC = [[IdeaBackViewController alloc]init];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:ideaVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }else if (indexPath.row == 4){
                WebViewController *web = [WebViewController new];
                web.urlStr = ABUOTUS_HOST;
                web.titleString = @"关于我们";
                web.isAboutUs = YES;
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:web animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
        }else{
            NSString *className = self.bossArray[indexPath.section][indexPath.row];
            if (NSClassFromString(className)) {
                Class aClass = NSClassFromString(className);
                id instance = [[aClass alloc]init];
                if ([instance isKindOfClass:[UIViewController class]]) {
                    ((UIViewController *)instance).hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:(UIViewController *)instance
                                                         animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }
            }
        }
        
    }else{
        [WFHudView showMsg:@"请先登录哦！" inView:self.view];
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 212.0f * (SCREEN_HEIGHT * 1.0 / 667);
    }
    return 5.0f;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return _headerView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark 清除缓存
//获取缓存文件的大小
-( float )readCacheSize
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [ self folderSizeAtPath :cachePath];
}

// 遍历文件夹获得文件夹大小，返回多少 M
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    
    return folderSize/( 1024.0 * 1024.0);
    
}
// 计算 单个文件的大小
- ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}

-(void)cleanCache
{
    [SVProgressHUD showWithStatus:@"正在清除缓存···"];

    
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
    [SVProgressHUD dismiss];
}

#pragma mark 自定义分享View
- (void)createShareView {
    
    CGFloat shareViewH = 100;
    CGFloat shareViewY = SCREEN_HEIGHT - shareViewH;
    
    if(_shareShadowView == nil) {
        
        UIView *shareShadowView = [[UIView alloc] init];
        shareShadowView.frame   = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        shareShadowView.backgroundColor = [UIColor blackColor];
        shareShadowView.alpha = 0.5;
        [[UIApplication sharedApplication].keyWindow addSubview:shareShadowView];
        _shareShadowView = shareShadowView;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [_shareShadowView addGestureRecognizer:tapGesture];
        
        UIView *shareView = [[UIView alloc] init];
        shareView.frame   = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, shareViewH);
        shareView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        [[UIApplication sharedApplication].keyWindow addSubview:shareView];
        _shareView = shareView;
        
        [UIView animateWithDuration:0.6f animations:^{
            
            shareView.frame = CGRectMake(0, shareViewY, SCREEN_WIDTH, shareViewH);
            
        }];
        
        [self addShareViewToView];
        
        
        
    }else {
        
        _shareView.hidden = NO;
        _shareShadowView.hidden = NO;
        
        [UIView animateWithDuration:0.6f animations:^{
            
            _shareView.frame = CGRectMake(0, shareViewY, SCREEN_WIDTH, shareViewH);
            
        }];
    }
}

-(void)share
{
    NSString *text = @"一款维修装置O2O移动互联网平台产品，一方面他能为业主提供广大的维修师傅信息及定位，另一方面为师傅提供业主需求信息及定位。他作为两个平台，当用户家中出现需要维修的问题，可以直接搜索定位工人信息，第一时间赶赴现场解决问题，当师傅们需要找活干，可以直接搜索定位用户信息，第一时间找到就近雇主，找到活干。";
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:[UIImage imageNamed:@"旭邦装饰名片 - 副本"]
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/index.php/Mobile/Aboutme/share",API_HOST]]
                                      title:@"邦邦师傅"
                                       type:SSDKContentTypeAuto];
    NSArray *shareList = @[@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeWechatSession)];
    //、分享（可以弹出我们的分享菜单和编辑界面）
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                                                     items:shareList
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           
                                                           switch (state) {
                                                               case SSDKResponseStateSuccess:
                                                               {
                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                                                       message:nil
                                                                                                                      delegate:nil
                                                                                                             cancelButtonTitle:@"确定"
                                                                                                             otherButtonTitles:nil];
                                                                   [alertView show];
                                                                   break;
                                                               }
                                                               case SSDKResponseStateFail:
                                                               {
                                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                                                  delegate:nil
                                                                                                         cancelButtonTitle:@"OK"
                                                                                                         otherButtonTitles:nil, nil];
                                                                   [alert show];
                                                                   break;
                                                               }
                                                               default:
                                                                   break;
                                                           }
                                                       }
                                             ];
    
    
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    
}


//在分享界面添加视图
- (void)addShareViewToView {
    
    CGFloat weChatX = padding;
    
    UIImage *weChatImage = [UIImage imageNamed:@"wechat"];
    
    //分享微信按钮
    SWButton *weChatBtn = [[SWButton alloc] init];
    [weChatBtn setImage:weChatImage forState:UIControlStateNormal];
    [weChatBtn setTitle:@"微信分享" forState:UIControlStateNormal];
    weChatBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [weChatBtn addTarget:self action:@selector(weChatShare:) forControlEvents:UIControlEventTouchUpInside];
    [weChatBtn sizeToFit];
    
    
    CGFloat weChatW = weChatBtn.bounds.size.width;
    CGFloat weChatH = weChatBtn.bounds.size.height;
    CGFloat weChatY = (_shareView.bounds.size.height - weChatH) / 2;
    
    weChatBtn.frame = CGRectMake(weChatX, weChatY, weChatW, weChatH);
    
    CGFloat midX = weChatBtn.frame.size.width / 2;
    CGFloat midY = weChatBtn.frame.size.height/ 2 ;
    weChatBtn.titleLabel.center = CGPointMake(midX, midY + 15);
    weChatBtn.imageView.center = CGPointMake(midX, midY - 10);
    [weChatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_shareView addSubview:weChatBtn];
    
    //分享朋友圈按钮
    SWButton *friendCircleBtn = [[SWButton alloc] init];
    [friendCircleBtn setImage:[UIImage imageNamed:@"friendCircle"] forState:UIControlStateNormal];
    [friendCircleBtn setTitle:@"朋友圈分享" forState:UIControlStateNormal];
    friendCircleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [friendCircleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [friendCircleBtn addTarget:self action:@selector(friendCircleClick:) forControlEvents:UIControlEventTouchUpInside];
    [friendCircleBtn sizeToFit];
    
    CGFloat friendCircleW = friendCircleBtn.bounds.size.width;
    CGFloat friendCircleH = friendCircleBtn.bounds.size.height;
    CGFloat friendCircleX = (SCREEN_WIDTH - friendCircleW) / 2;
    CGFloat friendCircleY = (_shareView.bounds.size.height - friendCircleH) / 2;
    
    friendCircleBtn.frame = CGRectMake(friendCircleX, friendCircleY, friendCircleW, friendCircleH);
    [_shareView addSubview:friendCircleBtn];
    
    //复制链接按钮
    SWButton *copyLinkBtn = [[SWButton alloc] init];
    [copyLinkBtn setImage:[UIImage imageNamed:@"CopyLink"] forState:UIControlStateNormal];
    [copyLinkBtn setTitle:@"复制链接" forState:UIControlStateNormal];
    [copyLinkBtn addTarget:self action:@selector(copyClick:) forControlEvents:UIControlEventTouchUpInside];
    copyLinkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [copyLinkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [copyLinkBtn sizeToFit];
    
    CGFloat copyLinkW = copyLinkBtn.bounds.size.width;
    CGFloat copyLinkH = copyLinkBtn.bounds.size.height;
    CGFloat copyLinkX = SCREEN_WIDTH - friendCircleW - padding;
    CGFloat copyLinkY = (_shareView.bounds.size.height - friendCircleH) / 2;
    
    copyLinkBtn.frame = CGRectMake(copyLinkX, copyLinkY, copyLinkW, copyLinkH);
    [_shareView addSubview:copyLinkBtn];
    
    
}

#pragma mark --------- 分享功能实现 start -------------------

/** 微信分享 */
- (void)weChatShare:(UIButton *)sender {
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"快来加入我们吧";
    message.description = @"最好用的找工人软件";
    [message setThumbImage:[UIImage imageNamed:@"temp"]];
    
    WXWebpageObject *webPageObject = [WXWebpageObject object];
    webPageObject.webpageUrl = @"https://www.baidu.com";
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

/** 朋友圈分享 */
- (void)friendCircleClick:(UIButton *)sender {
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"快来加入我们吧";
    message.description = @"最好用的找工人软件";
    [message setThumbImage:[UIImage imageNamed:@"temp"]];
    
    WXWebpageObject *webPageObject = [WXWebpageObject object];
    webPageObject.webpageUrl = @"https://www.baidu.com";
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    
}

/** 复制链接 */
- (void)copyClick:(UIButton *)sender {
    
    [MBProgressHUD showError:@"已经复制链接" toView:_shareShadowView];
    
    UIPasteboard *pastBroad = [UIPasteboard generalPasteboard];
    
    [pastBroad setURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    
}

#pragma mark --------- 分享功能实现 end -------------------

- (void)hideView {
    
    CGFloat shareViewH = 100;
    
    [UIView animateWithDuration:0.6f animations:^{
        
        _shareView.frame   = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, shareViewH);
        
    } completion:^(BOOL finished) {
        
        _shareView.hidden = YES;
        _shareShadowView.hidden = YES;
        
    }];
    
}


@end
