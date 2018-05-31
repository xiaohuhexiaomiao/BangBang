//
//  SWSearchWorkerViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/2/20.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SWSearchWorkerViewController.h"
#import "CXZ.h"

#import "SWWorkerDetailController.h"
#import "SWJobDetailController.h"
#import "SWCompleteInfoController.h"
#import "PermissionUpdateViewController.h"
#import "CompanyReviewViewController.h"
#import "ShowPaymentsViewController.h"
#import "ShowPurchaseViewController.h"
#import "ShowStampViewController.h"
#import "ShowFileViewController.h"
#import "SWSearchWorkerViewController.h"
#import "ShowCompanyViewController.h"

#import "SWFindJobCell.h"
#import "SWFindWorkData.h"
#import "ApprovalTableViewCell.h"
#import "SWNearbyWorkerCell.h"
#import "SponsorTableViewCell.h"

#import "JXPopoverView.h"

#import "ReviewListModel.h"

#import <RongIMKit/RCConversationViewController.h>

@interface SWSearchWorkerViewController ()<UITableViewDelegate,UITableViewDataSource,NearbyWorkerCellDelegate,RCIMUserInfoDataSource,UISearchBarDelegate>
{
    NSInteger page;
    NSInteger type;
}
@property(nonatomic,strong)UITableView *listTbview;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UISearchBar *topsearchbar;

@property(nonatomic,strong)UIButton *typeButton;

@property(nonatomic,copy)NSString *searchWord;

@property(nonatomic,copy)NSString *typeStr;

@property (nonatomic, strong) SWWorkerData *chatData;


@end

@implementation SWSearchWorkerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.searchType == searchApprovalType ||self.searchType == searchPesonApprovalType) {
        self.typeStr =@"1";
        [self setNavigationBarView];
    }else{
        [self setupBackw];
        [self setupNextWithString:@"搜索" withColor:TOP_GREEN];
        [self setupTitle];
        
    }
    _listTbview = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-60) style:UITableViewStyleGrouped];
    _listTbview.delegate = self;
    _listTbview.dataSource = self;
//    _listTbview.hidden = YES;
    if (self.searchType == searchApprovalType) {
        _listTbview.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT-100);
        page = 1;
        _listTbview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    [self.view addSubview:_listTbview];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.searchType == searchApprovalType) {
        self.navigationController.navigationBarHidden = YES;
    }
}


-(void)setNavigationBarView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    view.backgroundColor = [UIColor blackColor];
    
    _typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeButton.frame = CGRectMake(0, 20, 70, 30);
    [_typeButton setTitle:@"我处理的" forState:UIControlStateNormal];
    _typeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_typeButton setImage:[UIImage imageNamed:@"arrow_gray"] forState:UIControlStateNormal];
    [_typeButton addTarget:self action:@selector(clickTypeButton) forControlEvents:UIControlEventTouchUpInside];
    _typeButton.showsTouchWhenHighlighted = NO;
    [view addSubview:_typeButton];
    
    _topsearchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(70, 20, SCREEN_WIDTH - 100, 30)];
    _topsearchbar.delegate = self;
    _topsearchbar.placeholder = @"请输入工程地址或标题";
    for (UIView *sv in _topsearchbar.subviews)
    {
        if ([sv isKindOfClass:NSClassFromString(@"UIView")] && sv.subviews.count > 0)
        {
            [sv.subviews.firstObject removeFromSuperview];
            UITextField *textField = sv.subviews.lastObject;
            textField.layer.borderColor = TOP_GREEN.CGColor;
            textField.layer.borderWidth = 0.5;
            textField.layer.masksToBounds = YES;
            textField.layer.cornerRadius = 15;
            textField.font = [UIFont systemFontOfSize:12];
            textField.textColor = [UIColor whiteColor];
            UIColor *color = [UIColor whiteColor];
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入工程地址或标题" attributes:@{NSForegroundColorAttributeName: color}];
            //            textField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbg"]];
            textField.backgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
            
        }
    }
    [view addSubview:_topsearchbar];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(_topsearchbar.right, _topsearchbar.top, SCREEN_WIDTH-_topsearchbar.right, _topsearchbar.height);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    
    [self.view addSubview:view];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 39)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    UIView *lineview = [CustomView customLineView:self.view];
    lineview.frame = CGRectMake(0, scrollView.bottom, SCREEN_WIDTH, 1);
    
    NSArray *signArray = @[@"请购单",@"请款单",@"合同评审表",@"印章申请单",@"呈批件"];
     NSArray *typeArray = @[@(3),@(7),@(1),@(5),@(6)];
    
    CGFloat currentX = 8;
    for (int i = 0; i < signArray.count; i++) {
        NSString *string =  signArray[i] ;
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor darkGrayColor];
        label.text = string;
        label.font = [UIFont systemFontOfSize:FONT_SIZE];
        label.textAlignment = NSTextAlignmentCenter;
        CGSize moneySize =[string sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        label.frame = CGRectMake(currentX, 0, moneySize.width+8, 39);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickFormType:)];
        label.tag = [typeArray[i] integerValue];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:tap];
        [scrollView addSubview:label];
        currentX += label.frame.size.width;
    }
    scrollView.contentSize = CGSizeMake(currentX+10, 39);
}

-(void)clickFormType:(UITapGestureRecognizer*)tap
{
   type = tap.view.tag;
    NSArray *typeArray = @[@(3),@(7),@(1),@(5),@(6)];
    for (int i = 0; i <typeArray.count; i++) {
        UILabel *label = [self.view viewWithTag:[typeArray[i] integerValue]];
        label.textColor = [UIColor darkGrayColor];
    }
    UILabel *tapLabel = [self.view viewWithTag:type];
    tapLabel.textColor = TOP_GREEN;
    page = 1;
    self.listTbview.hidden = NO;
    [self.dataArray removeAllObjects];
    [self loadApprovalWithKeyword:nil];
    
}

-(void)clickCancelButton{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

-(void)clickTypeButton
{
    JXPopoverView *popoverView = [JXPopoverView popoverView];
    JXPopoverAction *action1 = [JXPopoverAction actionWithTitle:@"我处理的" handler:^(JXPopoverAction *action) {
        self.typeStr =@"1";
        [self.typeButton setTitle:@"我处理的" forState:UIControlStateNormal];
        
    }];
    JXPopoverAction *action2 = [JXPopoverAction actionWithTitle:@"我发起的" handler:^(JXPopoverAction *action) {
        self.typeStr =@"2";
        [self.typeButton setTitle:@"我发起的" forState:UIControlStateNormal];
    }];
    [popoverView showToView:self.typeButton withActions:@[action1,action2]];
}


-(void)setupTitle
{
    _topsearchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 150, 30)];
    _topsearchbar.delegate = self;
    _topsearchbar.placeholder = @"请输入电话号码或姓名";
    for (UIView *sv in _topsearchbar.subviews)
    {
        if ([sv isKindOfClass:NSClassFromString(@"UIView")] && sv.subviews.count > 0)
        {
            [sv.subviews.firstObject removeFromSuperview];
            UITextField *textField = sv.subviews.lastObject;
            textField.layer.borderColor = TOP_GREEN.CGColor;
            textField.layer.borderWidth = 0.5;
            textField.layer.masksToBounds = YES;
            textField.layer.cornerRadius = 15;
            textField.font = [UIFont systemFontOfSize:12];
            textField.textColor = [UIColor whiteColor];
            UIColor *color = [UIColor whiteColor];
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入电话号码或姓名" attributes:@{NSForegroundColorAttributeName: color}];
            //           textField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbg"]];
            textField.backgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
            
        }
    }
    self.navigationItem.titleView = _topsearchbar;
    self.navigationItem.titleView.width = SCREEN_WIDTH-150;
    
}

-(void)onNext
{
    self.listTbview.hidden = NO;
    if (self.searchType == SearchJobType) {
        [self loadJobDataWithKeyword:_topsearchbar.text];
    }else if (self.searchType == SearchWorkerType){
        [self loadDataWithKeyword:_topsearchbar.text];
        
    }else{
        page = 1;
        self.searchWord = self.topsearchbar.text;
        [self.dataArray removeAllObjects];
        [self loadApprovalWithKeyword:_topsearchbar.text];
    }
}

-(void)loadDataWithKeyword:(NSString*)keyword
{
//    NSLog(@"888sear  %@",keyword);
    [self.dataArray removeAllObjects];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *paramDict = @{@"uid":uid,@"keyword":keyword};
    [[NetworkSingletion sharedManager]searchWorkers:paramDict onSucceed:^(NSDictionary *dict) {
//                NSLog(@"***%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            [self.dataArray addObjectsFromArray:dict[@"data"]];
            [self.listTbview reloadData];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self.navigationController.view];
        }
    } OnError:^(NSString *error) {
        [WFHudView showMsg:error inView:self.navigationController.view];
    }];
}

-(void)loadJobDataWithKeyword:(NSString*)keyword
{
    [self.dataArray removeAllObjects];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *paramDict = @{@"uid":uid,@"keyword":keyword};
    [[NetworkSingletion sharedManager]searchJobs:paramDict onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            NSArray *array = [SWFindWorkData objectArrayWithKeyValuesArray:dict[@"data"]];
            [self.dataArray addObjectsFromArray:array];
            [self.listTbview reloadData];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self.navigationController.view];
        }
        
    } OnError:^(NSString *error) {
        [WFHudView showMsg:error inView:self.navigationController.view];
    }];
}

-(void)loadMoreData
{
    page ++;
    [self loadApprovalWithKeyword:self.searchWord];
    
}

-(void)loadApprovalWithKeyword:(NSString*)keyword
{
    NSDictionary *dict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                @"company_id":self.companyID,
                                @"type":self.typeStr,
                                @"p":@(page),
                                @"each":@"10"};
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict addEntriesFromDictionary:dict];
    if (type != 0) {
        [paramDict setObject:@(type) forKey:@"approval_type"];
    }
    if (![NSString isBlankString:keyword]){
        [paramDict setObject:keyword forKey:@"select"];
    }
    [[NetworkSingletion sharedManager]searchApproval:paramDict onSucceed:^(NSDictionary *dict) {
        [self.listTbview.mj_footer endRefreshing];
//        NSLog(@"*we**%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            NSArray *array = [ReviewListModel objectArrayWithKeyValuesArray:dict[@"data"]];
            [self.dataArray addObjectsFromArray:array];
            if (array.count < 10) {
                [self.listTbview.mj_footer setState:MJRefreshStateNoMoreData];
            }
        }
        [self.listTbview reloadData];
    } OnError:^(NSString *error) {
        [self.listTbview.mj_footer endRefreshing];
         [WFHudView showMsg:error inView:self.navigationController.view];
    }];
}

-(void)loadPersonalApprovalWithKeyword:(NSString*)keyword
{
    NSDictionary *dict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"company_id":self.companyID,
                           @"type":self.typeStr,
                           @"p":@(page),
                           @"each":@"10"};
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict addEntriesFromDictionary:dict];
    if (type != 0) {
        [paramDict setObject:@(type) forKey:@"approval_type"];
    }
    if (![NSString isBlankString:keyword]){
        [paramDict setObject:keyword forKey:@"select"];
    }
    [[NetworkSingletion sharedManager]searchApproval:paramDict onSucceed:^(NSDictionary *dict) {
        [self.listTbview.mj_footer endRefreshing];
        //        NSLog(@"*we**%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            NSArray *array = [ReviewListModel objectArrayWithKeyValuesArray:dict[@"data"]];
            [self.dataArray addObjectsFromArray:array];
            if (array.count < 10) {
                [self.listTbview.mj_footer setState:MJRefreshStateNoMoreData];
            }
        }
        [self.listTbview reloadData];
    } OnError:^(NSString *error) {
        [self.listTbview.mj_footer endRefreshing];
        [WFHudView showMsg:error inView:self.navigationController.view];
    }];

}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
     [self.topsearchbar resignFirstResponder];
    self.listTbview.hidden = NO;
    if (self.searchType == SearchJobType) {
        [self loadJobDataWithKeyword:searchBar.text];
    }else if (self.searchType == SearchWorkerType){
        [self loadDataWithKeyword:searchBar.text];
    }else if (self.searchType == searchApprovalType ){
        page = 1;
        [self.dataArray removeAllObjects];
        self.searchWord = self.topsearchbar.text;
        [self loadApprovalWithKeyword:_topsearchbar.text];
    }else{
        page = 1;
        [self.dataArray removeAllObjects];
        self.searchWord = self.topsearchbar.text;
        [self loadPersonalApprovalWithKeyword:_topsearchbar.text];
    }
}

#pragma mark UITableview delegate & datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"****%li",self.dataArray.count);
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchType == SearchJobType) {
        SWFindJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        
        if(!cell) {
            
            cell = [[SWFindJobCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        }
        SWFindWorkData *data = self.dataArray[indexPath.row];
        NSArray *types = data.worker;
        NSMutableString *typeStr = [NSMutableString stringWithFormat:@"需要"];
        int j = 0;
        for (NSDictionary *typeDict in types) {
            if(j == types.count - 1) {
                [typeStr appendString:typeDict[@"type"]];
            }else {
                [typeStr appendString:[NSString stringWithFormat:@"%@,",typeDict[@"type"]]];
            }
            j++;
        }
        if(data.isface) {
            
            [cell showData:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,data.avatar] name:data.name money:@"面议" job:typeStr time:data.add_time];
            
        }else {
            
            [cell showData:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,data.avatar] name:data.name money:data.budget job:typeStr time:data.add_time];
        }
        
        return cell;
    }else if (self.searchType == SearchWorkerType){
        SWNearbyWorkerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        
        if(!cell) {
            
            cell = [[SWNearbyWorkerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        }
        cell.delegate = self;
        cell.is_Vip = self.is_vip;
        if (self.dataArray.count > 0 ) {
            NSDictionary *dict = self.dataArray[indexPath.row];
            [cell showData:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,dict[@"avatar"]] name:dict[@"name"] distance:[NSString stringWithFormat:@"%ld",[dict[@"distance"] integerValue]] jobs:dict[@"type"] phone:dict[@"phone"] year:dict[@"work_years"]];
        }
        return cell;
    }else{
        if ([self.typeStr integerValue]== 1) {
            ApprovalTableViewCell *cell = (ApprovalTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ApprovalCell"];
            if (!cell) {
                cell = [[ApprovalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApprovalCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            if (self.dataArray.count > 0) {
                [cell setSearchApprovalCellWith:self.dataArray[indexPath.row]];
            }
            return cell;
        }else{
            SponsorTableViewCell *cell = (SponsorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"SponsorCell"];
            if (!cell) {
                cell = [[SponsorTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SponsorCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.dataArray.count >0) {
                [cell setSponsorCellWith:self.dataArray[indexPath.row]];
            }
            return cell;
        }
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    [_chooseView hiddenMenu];
    if (self.searchType == SearchJobType) {//工程列表
        SWFindWorkData *data = self.dataArray[indexPath.row];
        
        NSString *roles = [[NSUserDefaults standardUserDefaults] objectForKey:@"roles"];
        
        if([roles isEqualToString:@"1"]) {
            
            SWJobDetailController *jobController = [[SWJobDetailController alloc] init];
            jobController.hidesBottomBarWhenPushed = YES;
            jobController.iid = data.iid;
            [self.navigationController pushViewController:jobController animated:YES];
            
        }else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"只有通过审核的工人才能查看详情哟" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"去完善信息" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                
                SWCompleteInfoController *completeInfoController = [[SWCompleteInfoController alloc] init];
                completeInfoController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:completeInfoController animated:YES];
                
            }]];
            // 添加按钮
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                
            }]];
            
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else if(self.searchType == SearchWorkerType){

        SWWorkerDetailController *workerController = [[SWWorkerDetailController alloc] init];
        NSDictionary *dict = self.dataArray[indexPath.row];
        workerController.uid = dict[@"uid"];
        workerController.workerName = dict[@"name"];
        workerController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:workerController animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else{
        ReviewListModel *listModel ;
        CompanyReviewViewController *reviewVC = [[CompanyReviewViewController alloc]init];
        ShowPaymentsViewController *payVC = [[ShowPaymentsViewController alloc]init];
        ShowPurchaseViewController *purchaseVC = [[ShowPurchaseViewController alloc]init];
        ShowStampViewController *stampVC = [[ShowStampViewController alloc]init];
        ShowFileViewController *fileVC = [[ShowFileViewController alloc]init];
        ShowCompanyViewController *companyVC = [[ShowCompanyViewController alloc]init];
        self.navigationController.navigationBarHidden = NO;
        listModel = self.dataArray[indexPath.row];
        reviewVC.is_aready_approval = YES;
        payVC.is_aready_approval = YES;
        purchaseVC.is_aready_approval = YES;
        stampVC.is_aready_approval = YES;
        fileVC.is_aready_approval = YES;
        companyVC.is_aready_approval = YES;
        if (listModel.type == 1 || listModel.type == 2) {
            reviewVC.typeStr = [NSString stringWithFormat:@"%@",@(listModel.type)];
            reviewVC.approval_id = listModel.approval_id;
            reviewVC.participation_id = listModel.participation_id;
            reviewVC.company_id = listModel.company_id;
            reviewVC.is_approval = YES;
            reviewVC.contractTitle = listModel.title;
            reviewVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:reviewVC animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }else if (listModel.type == 0||listModel.type == 8){
            payVC.approvalID = listModel.approval_id;
            [self.navigationController pushViewController:payVC animated:YES];
        }else if (listModel.type == 3 ||listModel.type == 7){
            purchaseVC.approvalID = listModel.approval_id;
    
            [self.navigationController pushViewController:purchaseVC animated:YES];
        }else if (listModel.type == 5){
            stampVC.approvalID = listModel.approval_id;
            [self.navigationController pushViewController:stampVC animated:YES];
        }else if (listModel.type == 6){
            fileVC.approvalID = listModel.approval_id;
            [self.navigationController pushViewController:fileVC animated:YES];
        }else if (listModel.type == 111){
            companyVC.approval_id = listModel.approval_id;
            [self.navigationController pushViewController:companyVC animated:YES];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchType == searchApprovalType) {
        if ([self.typeStr integerValue]==1) {
           return 125.0f;
        }
        return 85.0f;
    }
    return 55.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark Cell Delgate

-(void)clickPhoneWithPhone:(SWWorkerData *)workData
{
//    if ( self.is_vip == 0) {
//        
//        [self permissionUpdate];
//    }else{
    
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"找他聊聊" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"电话聊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",workData.phone];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.navigationController.view addSubview:callWebview];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"在线聊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.chatData = workData;
            //数据源方法，要传递数据必须加上
            [[RCIM sharedRCIM] setUserInfoDataSource:self];
            RCConversationViewController *chat = [[RCConversationViewController alloc] init];
            //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等0
            chat.conversationType = ConversationType_PRIVATE;
            //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
            chat.targetId = workData.uid;
            
            //设置聊天会话界面要显示的标题
            chat.title = workData.name;
            chat.hidesBottomBarWhenPushed = YES;
            //显示聊天会话界面
            [self.navigationController pushViewController:chat animated:YES];
            
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alertVC animated:YES completion:NULL];
        
//    }
}


-(void)permissionUpdate
{
    NSString *roles = [[NSUserDefaults standardUserDefaults] objectForKey:@"roles"];
    UIAlertController *alertVC;
    if ([roles isEqualToString:@"1"]) {
        alertVC= [UIAlertController alertControllerWithTitle:@"升级为雇主才可以查看信息哦.." message:nil preferredStyle:UIAlertControllerStyleAlert];
    }else{
        alertVC= [UIAlertController alertControllerWithTitle:@"赶快去升级VIP吧..." message:nil preferredStyle:UIAlertControllerStyleAlert];
    }
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PermissionUpdateViewController *vc = [PermissionUpdateViewController new];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }]];
    
    [self presentViewController:alertVC animated:YES completion:NULL];
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

#pragma mark GET/SET

-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
