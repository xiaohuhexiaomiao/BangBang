//
//  RCMChatListViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/5/11.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "RCMChatListViewController.h"
#import "CXZ.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import "RCMChatViewController.h"
@interface RCMChatListViewController ()<RCIMUserInfoDataSource>

@end

@implementation RCMChatListViewController

-(id)init
{
    self = [super init];
    if (self) {
        //设置需要显示哪些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP)]];
        //        [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
//        [RCIM sharedRCIM].userInfoDataSource = self ;
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
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"群助手";
    self.navigationItem.titleView = titleLabel;
    
    self.conversationListTableView.tableFooterView = [UIView new];
    
    
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"UNREAD"];
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
    if (model.conversationType == ConversationType_PRIVATE) {
        
        
        //        self.chatData = self.dataArray[indexPath.row];
        //数据源方法，要传递数据必须加上
        RCConversationViewController *VC = [[RCConversationViewController alloc]init];
        VC.conversationType = model.conversationType;
        VC.targetId = model.targetId;
        VC.title = @"聊天";
        [self.navigationController pushViewController:VC  animated:YES];
        
    }else if (model.conversationType==ConversationType_GROUP){//群聊
        
        RCMChatViewController *_conversationVC = [[RCMChatViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.groupName = model.conversationTitle;
        [self.navigationController pushViewController:_conversationVC animated:YES];
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

@end
