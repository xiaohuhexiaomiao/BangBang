//
//  ChatListViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/7/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "RCMChatViewController.h"
#import "CXZ.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import "RCDUserInfoManager.h"

#import "SWUserData.h"

#import "RCMEditGroupViewController.h"

@interface RCMChatViewController ()<UIActionSheetDelegate, RCRealTimeLocationObserver, UIAlertViewDelegate, RCMessageCellDelegate>


@property(nonatomic ,strong)NSMutableArray *dataArray;

@property(nonatomic, strong) RCDGroupInfo *groupInfo;

@property(nonatomic, strong) RCUserInfo *cardInfo;


@end

@implementation RCMChatViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 20, 20);
    [back setImage:[UIImage imageNamed:@"secondBack"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton* right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 20, 20);
    [right setImage:[UIImage imageNamed:@"group_set"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(clickRightItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.groupName;
    self.navigationItem.titleView = titleLabel;
    
    //刷新个人或群组的信息
    [self refreshUserInfoOrGroupInfo];
    
}

#pragma mark Private Method

-(void)onBack
{
 [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightItem
{
    RCMEditGroupViewController *editVC = [[RCMEditGroupViewController alloc]init];
    editVC.groupID = self.targetId;
    editVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}


#pragma mark - RCIMConnectionStatusDelegate

/**
 *  网络状态变化。
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    NSLog(@"RCConnectionStatus = %ld",(long)status);
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:@"您的帐号已在别的设备上登录，\n您被迫下线！"
                              delegate:self
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[RCIMClient sharedRCIMClient] disconnect:YES];
    }];
    
    
}

#pragma mark 
- (void)refreshUserInfoOrGroupInfo {
    //打开单聊强制从demo server 获取用户信息更新本地数据库
    
        //打开群聊强制从demo server 获取群组信息更新本地数据库
    if (self.conversationType == ConversationType_GROUP) {
        __weak typeof(self) weakSelf = self;
        [RCDHTTPTOOL getGroupByID:self.targetId
                successCompletion:^(RCDGroupInfo *group) {
                    RCGroup *Group = [[RCGroup alloc] initWithGroupId:weakSelf.targetId
                                                            groupName:group.groupName
                                                          portraitUri:group.portraitUri];
                    [[RCIM sharedRCIM] refreshGroupInfoCache:Group withGroupId:weakSelf.targetId];
                    
                }];
    }
    //更新群组成员用户信息的本地缓存
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *groupList = [[RCDataBaseManager shareInstance] getGroupMember:self.targetId];
        NSArray *resultList = [[RCDUserInfoManager shareInstance] getFriendInfoList:groupList];
        groupList = [[NSMutableArray alloc] initWithArray:resultList];
        for (RCUserInfo *user in groupList) {
            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
        }
    });
    
}

/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param imageMessageContent 图片消息内容
 */
- (void)presentImagePreviewController:(RCMessageModel *)model {
    RCImageSlideController *previewController = [[RCImageSlideController alloc] init];
    previewController.messageModel = model;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:previewController];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage {
    //保存图片
    UIImage *image = newImage;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
}



#pragma mark


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
