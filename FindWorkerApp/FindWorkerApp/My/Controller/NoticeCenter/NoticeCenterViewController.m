//
//  NoticeCenterViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/4/24.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "NoticeCenterViewController.h"
#import "CXZ.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>

#import "PersonApprovalViewController.h"
#import "NoticeViewController.h"
#import "ReceiveContractController.h"
#import "RCMGroupListViewController.h"
#import "RCMChatViewController.h"
#import "RCMChatListViewController.h"

#import "NormalCell.h"

#import "SWUserData.h"

@interface NoticeCenterViewController ()<RCIMUserInfoDataSource>

@property(nonatomic ,strong)RCUserInfo *chatData;

@property(nonatomic ,strong)NSMutableArray *dataArray;
@end

@implementation NoticeCenterViewController

-(id)init
{
    self = [super init];
    if (self) {
        //设置需要显示哪些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP)]];
        //        [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
        [RCIM sharedRCIM].userInfoDataSource = self ;
        //设置需要将哪些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[@(ConversationType_GROUP)]];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 20, 20);
    [back setImage:[UIImage imageNamed:@"secondBack"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = leftItem;
    
//    UIButton* right = [UIButton buttonWithType:UIButtonTypeCustom];
//    right.frame = CGRectMake(0, 0, 20, 20);
//    [right setImage:[UIImage imageNamed:@"creat"] forState:UIControlStateNormal];
//    [right addTarget:self action:@selector(clickRightItem) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:right];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"通知";
    self.navigationItem.titleView = titleLabel;
    
    self.conversationListTableView.tableFooterView = [UIView new];
//    [self loadData];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"UNREAD"];
}

-(void)clickRightItem
{
    
}

-(void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Load Data

-(void)loadData
{
    //    NSDictionary *paramDict = @{@"company_id":self.companyID};
    [[NetworkSingletion sharedManager]getNewRemindData:nil onSucceed:^(NSDictionary *dict) {
        //        NSLog(@"****haha %@",dict);
//        [self.tableview.mj_header endRefreshing];
//        if ([dict[@"code"] integerValue]==0) {
////            self.remindModel = [RemindModel objectWithKeyValues:dict[@"data"]];
//            [self.tableview reloadData];
//        }
        
    } OnError:^(NSString *error) {
        
    }];
}


#pragma mark

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath
{
    
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION){//群聊
        RCMChatListViewController *temp = [[RCMChatListViewController alloc] init];
        NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
        [temp setDisplayConversationTypes:array];
        [temp setCollectionConversationType:nil];
        temp.isEnteredToCollectionViewController = YES;
        [self.navigationController pushViewController:temp animated:YES];

    }else{
        if (model.conversationType == ConversationType_PRIVATE) {
            //        self.chatData = self.dataArray[indexPath.row];
            //数据源方法，要传递数据必须加上
            RCConversationViewController *VC = [[RCConversationViewController alloc]init];
            VC.conversationType = model.conversationType;
            VC.targetId = model.targetId;
            if (model.objectName) {
                VC.title = model.objectName;
            }else{
                VC.title = @"聊天";
            }
            
            [self.navigationController pushViewController:VC  animated:YES];
            
        }
    }
    
}

- (void)didTapCellPortrait:(RCConversationModel *)model {
    
    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
                //如果是单聊，不显示发送方昵称
        if (model.conversationType == ConversationType_PRIVATE) {
            RCConversationViewController *VC = [[RCConversationViewController alloc]init];
            VC.conversationType = model.conversationType;
            VC.targetId = model.targetId;
            if (model.objectName) {
                VC.title = model.objectName;
            }else{
                VC.title = @"聊天";
            }
            
            [self.navigationController pushViewController:VC  animated:YES];

        }
    }
    
    //聚合会话类型，此处自定设置。
    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        
        RCMChatListViewController *temp = [[RCMChatListViewController alloc] init];
        NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
        [temp setDisplayConversationTypes:array];
        [temp setCollectionConversationType:nil];
        temp.isEnteredToCollectionViewController = YES;
        [self.navigationController pushViewController:temp animated:YES];
    }
    
}
#pragma mark - 融云代理 -


- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion {
//    NSLog(@"***%@",userId);
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
        [self refreshConversationTableViewIfNeeded];
    }
    
}

#pragma mark UITableview Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 240.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = 60;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    headView.backgroundColor = [UIColor whiteColor];
    
    NSArray *imgArray = @[@"SystomNotice",@"myDianping",@"shenpihuifu",@"group"];
    NSArray *titleArray = @[@"系统消息",@"审批处理",@"我收到的合同",@"群组"];
    for (int i = 0; i < imgArray.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, height*i, SCREEN_WIDTH, height)];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 44, 44)];
        [imgView setImage:[UIImage imageNamed:imgArray[i]]];
        [view addSubview:imgView];
        
        UIButton *titleButton = [CustomView customButtonWithContentView:view image:nil title:titleArray[i]];
        titleButton.frame = CGRectMake(imgView.right+8, imgView.top, SCREEN_WIDTH-imgView.right-16, 44);
        titleButton.tag = 100+i;
        [titleButton addTarget:self action:@selector(clickTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        titleButton.titleLabel.font = [UIFont systemFontOfSize:16];
        
        UIView *line = [CustomView customLineView:view];
        line.frame = CGRectMake(8, 59, SCREEN_WIDTH-16, 1);
        
        [headView addSubview:view];
    }
    return headView;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark Private Method

-(void)clickTitleButton:(UIButton*)button
{
    NSInteger tag = button.tag;
    if (tag == 100) {
        NoticeViewController *noticeVC = [[NoticeViewController alloc]init];
        noticeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:noticeVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (tag == 101){
        PersonApprovalViewController *personVC = [[PersonApprovalViewController alloc]init];
        personVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        
    }else if(tag == 102){
        ReceiveContractController *receiveVC = [[ReceiveContractController alloc]init];
        receiveVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:receiveVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if(tag == 103){
        RCMGroupListViewController *groupVC = [[RCMGroupListViewController alloc]init];
        groupVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:groupVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}


#pragma mark Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
