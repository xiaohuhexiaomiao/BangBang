//
//  ChatListViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/7/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface RCMChatViewController : RCConversationViewController

@property(nonatomic, copy) NSString *groupName;
/**
 *  会话数据模型
 */
@property(strong, nonatomic) RCConversationModel *conversation;

@property BOOL needPopToRootView;
- (UIView *)loadEmoticonView:(NSString *)identify index:(int)index;

@end
