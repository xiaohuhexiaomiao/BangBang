//
//  AppDelegate.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/14.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>
#import "SWFindWorkerUtils.h"
#import "SWNavController.h"
#import "SWTabController.h"
#import "SWLoginController.h"
#import "SWFindWorkerController.h" //找工人
#import "SWFindJobsController.h" //找活干
#import "SWMyController.h" //我的
#import "SWJobDetailController.h"
#import "SWMyContractController.h"
#import "SWMyJobController.h"
#import "SWMyPublishDetailController.h"
#import "MyWorkersViewController.h"
#import "TransactionLogViewController.h"
#import "SWDailyOfficeViewController.h"
#import "ConstructionRecordsViewController.h"
#import "DiaryRemindViewController.h"
#import "NoticeCenterViewController.h"

//ShareSDK分享的头文件
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"

//融云
#import "RCDRCIMDataSource.h"

//导入百度地图头文件
#import <BaiduMapAPI_Base/BMKMapManager.h>

// 引入JPush功能所需头文件
#import "JPUSHService.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#import <UserNotifications/UserNotifications.h>

#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import <iflyMSC/iflyMSC.h>
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"

#import "BDSSpeechSynthesizer.h"




@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate,IFlySpeechSynthesizerDelegate,BDSSpeechSynthesizerDelegate,RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate>

@end

@implementation AppDelegate {
    
    BMKMapManager *_mapManager;
    IFlySpeechSynthesizer *_iFlySpeechSynthesizer;
    AVSpeechSynthesizer *_synthesizer;
    AVSpeechSynthesisVoice *_voice;
    AVAudioPlayer *_player;
    AVAudioSession *session;
    BOOL _played;
    UIBackgroundTaskIdentifier _bgTaskId;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //ShareSDK分享的代码
    [ShareSDK registerApp:@"1a638606d486e"
          activePlatforms:@[@(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeSMS)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                     
                 } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                     
                     switch (platformType)
                     {
                             
                         case SSDKPlatformTypeWechat:
                             [appInfo SSDKSetupWeChatByAppId:@"wx2c13ee133f20d636"
                                                   appSecret:@"c6450250e2aa05ffae0facc9bcf4954c"];
                             break;
                         case SSDKPlatformTypeQQ:
                             [appInfo SSDKSetupQQByAppId:@"1105940042"
                                                  appKey:@"nwUY9S10o7kBq6w9"
                                                authType:SSDKAuthTypeBoth];
                             break;
                         default:
                             break;
                     }
                 }];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    NSString *log = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOG"];
    if ([log integerValue]==0) {
        
        SWLoginController *log = [SWLoginController new];
        log.type = 1;
        SWNavController *navController = [[SWNavController alloc] initWithRootViewController:log];
        navController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00];
        self.window.rootViewController = navController;
        
        [self.window makeKeyAndVisible];
        
    }else{
        
        SWTabController *tabBarController = [[SWTabController alloc] init];
        tabBarController.selectedIndex = 1;
        self.window.rootViewController = tabBarController;
        [self.window makeKeyAndVisible];
        //设置消息数量
        NSInteger num = application.applicationIconBadgeNumber;
        SWMyController *myController = (SWMyController*)tabBarController.viewControllers[2];
        NSString *unreadStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"UNREAD"];
        if ([unreadStr integerValue] > 0) {
            myController.tabBarItem.badgeValue = unreadStr;
            
        }else{
            myController.tabBarItem.badgeValue = nil;
        }
        [[NSUserDefaults standardUserDefaults]setObject:@(num) forKey:@"NoticeNumber"];
    }
    
    //集成极光推送api
    [self addJpushApi:launchOptions];
    
    //集成百度地图api
    [self addBaiduMapApi];
    
    //集成微信api
    [self addWXApi];
    
    //集成讯飞语音api
    [self addiFlySpeechApi];
    
    [self playbackgroud];
    
    //集成融云
    [self addRongYun];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    
    _played = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
   
    
    return YES;
}

-(void)handleInterreption:(NSNotification *)sender
{
    if(_played)
    {
        [_player pause];
        _played=NO;
    }
    else
    {
        [_player play];
        _played=YES;
    }
    //    NSLog(@"***us3e**");
}
/**
 集成融云
 */
-(void)addRongYun
{
    // 融云
    [[RCIM sharedRCIM] initWithAppKey:RONGYUN_KEY];
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    
    //开启用户信息和群组信息的持久化
    //    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    //  设置头像为圆形
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    //设置用户信息源和群组信息源
    [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"RongYunToken"];
    if (![NSString isBlankString:token]) {
        [[RCIM sharedRCIM] connectWithToken:token  success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            NSString *nickname = [[NSUserDefaults standardUserDefaults]objectForKey:@"realname"];
            NSString *avatar = [[NSUserDefaults standardUserDefaults]objectForKey:@"avatar"];
            
            RCUserInfo *user =[[RCUserInfo alloc] initWithUserId:user_id name:nickname portrait:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,avatar]];
            [[RCDataBaseManager shareInstance] insertUserToDB:user];
            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
            [RCIM sharedRCIM].currentUserInfo = user;
            [DEFAULTS setObject:user.portraitUri forKey:@"userPortraitUri"];
            [DEFAULTS setObject:user.name forKey:@"userNickName"];
            [DEFAULTS synchronize];
            
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", status);
        } tokenIncorrect:^{
            
            NSLog(@"token错误");
        }];

    }    
}

/**
 集成讯飞语音合成
 */
- (void)addiFlySpeechApi {
    
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"586506ec"];
    [IFlySpeechUtility createUtility:initString];
    
}

/**
 *  结束回调
 *  当整个合成结束之后会回调此函数
 *
 *  @param error 错误码
 */
- (void) onCompleted:(IFlySpeechError*) error {
    
    NSLog(@"error ===== %d",error.errorCode);
    
}


/**
 说话
 
 @param content 说话内容
 */
- (void)speechWord:(NSString *)content {
    
    NSString *voice = [[NSUserDefaults standardUserDefaults]objectForKey:@"XUNFEIVOICE"];
    // 创建合成对象，为单例模式
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    //设置代理
    _iFlySpeechSynthesizer.delegate = self;
    //设置语音合成的参数
    //语速,取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
    //音量;取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"100" forKey: [IFlySpeechConstant VOLUME]];
    //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个性化发音人列表
    if ([NSString isBlankString:voice]) {
        [_iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey: [IFlySpeechConstant VOICE_NAME]];
    }else{
        [_iFlySpeechSynthesizer setParameter:voice forKey: [IFlySpeechConstant VOICE_NAME]];
    }
   
    //音频采样率,目前支持的采样率有 16000 和 8000
    [_iFlySpeechSynthesizer setParameter:@"8000" forKey: [IFlySpeechConstant SAMPLE_RATE]];
    //asr_audio_path保存录音文件路径，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iFlySpeechSynthesizer setParameter:@"tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    //启动合成会话
    [_iFlySpeechSynthesizer startSpeaking:content];
    
}

/** 集成微信Api */
- (void)addWXApi {
    
    //向微信注册
    [WXApi registerApp:@"wx644f7114c23e01ba"];
    
}


/** 集成极光推送api */
- (void)addJpushApi:(NSDictionary *)launchOptions {
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    //    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    //    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) // iOS10
    {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }else   {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"66a51161d94d6e6079365120"
                          channel:@"AppStore" apsForProduction:YES];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registerID"];
    }];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
}


- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSLog(@"yuyin %@",userInfo);
    NSString *voice = [[NSUserDefaults standardUserDefaults]objectForKey:@"VoiceState"];
    if ([voice integerValue]== 0) {
        [self speechWord:content];
    }
}



/** 集成百度api */
- (void)addBaiduMapApi {
    
    //要使用百度地图，首先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"PGbb395hLyA2mLjvq89TbdDMkwVMLd5y" generalDelegate:nil];
    //是否成功
    if(!ret) {
        NSLog(@"百度地图启动失败");
        
    }
    
}




- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *str=[url absoluteString];
    NSString *path = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"path%@", path);
    if ([str  hasPrefix:@"wx6c33c97e5e4a9056"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        
        return YES;
        
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options{
    
    NSString *str=[url absoluteString];
  
    if ([str  hasPrefix:@"wx6c33c97e5e4a9056"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else{
  
        NSString *filePath1 = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *fileName = [[filePath1 componentsSeparatedByString:@"/"] lastObject];
       
        NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *filePath = [NSString stringWithFormat:@"%@/Inbox/%@",DocumentsPath,fileName];
        [self uploadFilesWithPath:filePath name:fileName];
        return YES;
    }
}


- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier {
    
    return NO;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    //    [self speechWord:@"邦邦师傅持续为您接单"];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    
    //开启后台处理多媒体事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session=[AVAudioSession sharedInstance];
    
    //后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    //这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放网络歌曲，若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：

    _bgTaskId=[AppDelegate backgroundPlayerID:_bgTaskId];
    
    //其中的_bgTaskId是后台任务UIBackgroundTaskIdentifier _bgTaskId;
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
   
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    //    NSLog(@"**badege*%li",application.applicationIconBadgeNumber);
    NSString *log = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOG"];
    if ([log integerValue]==1) {
        
        NSInteger num = application.applicationIconBadgeNumber;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [JPUSHService setBadge:0];
        
        [[NSUserDefaults standardUserDefaults]setObject:@(num) forKey:@"NoticeNumber"];
        //设置消息数量
        NSString *unreadStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"UNREAD"];
        SWTabController *tabController = (SWTabController*)self.window.rootViewController;
        SWMyController *myController = (SWMyController*)tabController.viewControllers[2];
        if ([unreadStr integerValue] > 0) {
            myController.tabBarItem.badgeValue = unreadStr;
            
        }else{
            myController.tabBarItem.badgeValue = nil;
        }
        
    }
    
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}


#pragma mark 上传七牛文件
-(void)uploadFilesWithPath:(NSString*)filePath name:(NSString*)fileName
{
    [[NetworkSingletion sharedManager]getQiNiuToken:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            NSString *imageToken = [dict objectForKey:@"data"];
            
            [self uploadFileToQiNiuWithPath:filePath token:imageToken name:fileName];
        }
        
    } OnError:^(NSString *error) {
        
    }];
}

-(void)uploadFileToQiNiuWithPath:(NSString*)path token:(NSString*)token name:(NSString*)fileName
{
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [NSString stringWithFormat:@"%@/Inbox/%@",DocumentsPath,fileName];
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
//        NSLog(@"percent == %.2f", percent);
        
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [upManager putFile:path key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {

                NSString *hash = [resp objectForKey:@"hash"];
                NSArray *nameArray = [fileName componentsSeparatedByString:@"."];
//                NSLog(@"resp ===== %@,%@", nameArray[0],nameArray[1]);
                NSDictionary *paraDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                           @"attribute":nameArray[1],
                                           @"attachments":hash,
                                           @"file_name":nameArray[0]};
                [[NetworkSingletion sharedManager]addFiles:paraDict onSucceed:^(NSDictionary *dict) {

                    if ([dict[@"code"] integerValue]==0) {
                        NSInteger ennex = [[dict[@"data"] objectForKey:@"attachments_id"] integerValue];
                        FileModel *file = [[FileModel alloc]init];
                        file.file_all_name = fileName;
                        file.file_id = [NSString stringWithFormat:@"%li",ennex];
                        file.file_type = nameArray[1];
                        file.file_name = nameArray[0];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *time = [dateFormatter stringFromDate:[NSDate date]];
                        file.file_add_time = time;
                        file.file_user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
                        [[DataBase sharedDataBase]addFile:file];
                    }
                } OnError:^(NSString *error) {
                   
                }];
        
    }
                option:uploadOption];
}



#pragma mark 融云
-(BOOL)onRCIMCustomAlertSound:(RCMessage*)message
{
    return NO;
}
-(BOOL)onRCIMCustomLocalNotification:(RCMessage*)message
                      withSenderName:(NSString *)senderName
{
    return NO;
}
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[ @(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE), @(ConversationType_GROUP) ]];
    NSString * unreadNum = [NSString stringWithFormat:@"%d",unreadMsgCount];
    [[NSUserDefaults standardUserDefaults]setObject:unreadNum forKey:@"UNREAD"];
    [self loadTargetData:message.senderUserId];
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)//应用在前台
        
    {
        //修改app消息界面的参数
        NSLog(@"融云前台");
        SWTabController *tabController = (SWTabController*)self.window.rootViewController;
        tabController.selectedIndex = 3;
        SWMyController *myController = (SWMyController*)tabController.viewControllers[2];
        if (unreadMsgCount > 0) {
            myController.tabBarItem.badgeValue = unreadNum;
            
        }else{
            myController.tabBarItem.badgeValue = nil;
        }
    }else{//应用在后台
        NSLog(@"融云后台");
        UIApplication *app = [UIApplication sharedApplication];
        app.applicationIconBadgeNumber = unreadMsgCount;
        SWTabController *tabController = (SWTabController*)self.window.rootViewController;
        tabController.selectedIndex = 3;
        SWMyController *myController = (SWMyController*)tabController.viewControllers[2];
        NoticeCenterViewController *chatVC = [[NoticeCenterViewController alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        UINavigationController * nvc=(UINavigationController *)tabController.selectedViewController;
        [nvc pushViewController:chatVC animated:YES];
        nvc.hidesBottomBarWhenPushed = NO;
        if (unreadMsgCount > 0) {
            myController.tabBarItem.badgeValue = unreadNum;
            
        }else{
            myController.tabBarItem.badgeValue = nil;
        }
    }
}

-(void)loadTargetData:(NSString*)targetID
{
    [[NetworkSingletion sharedManager]getUserInfo:@{@"uid":targetID} onSucceed:^(NSDictionary *dict) {
        
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
            RCUserInfo *user = [[RCUserInfo alloc]initWithUserId:targetID name:name portrait:portraitUrl];
             [[RCDataBaseManager shareInstance] insertUserToDB:user];
            
        }
    } OnError:^(NSString *error) {
    }];

}

#pragma mark 极光

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //    NSLog(@"func ==== %s",__func__);
    /// Required - 注册 DeviceToken
    if (deviceToken)
    {
        NSString *currentDeviceToken = [[[[deviceToken description]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
        NSLog(@"deviceToken:________%@",currentDeviceToken);
    }
    [JPUSHService registerDeviceToken:deviceToken];
//    [[RCIMClient sharedRCIMClient] setDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)playbackgroud
{
    /*
     这里是随便添加得一首音乐。
     真正的工程应该是添加一个尽可能小的音乐。。。
     0～1秒的
     没有声音的。
     循环播放就行。
     这个只是保证后台一直运行该软件。
     使得该软件一直处于活跃状态.
     你想操作的东西该在哪里操作就在哪里操作。
     */
    session = [AVAudioSession sharedInstance];
    /*打开应用会关闭别的播放器音乐*/
    //    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    /*打开应用不影响别的播放器音乐*/
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [session setActive:YES error:nil];
    //设置代理 可以处理电话打进时中断音乐播
    
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"slient" ofType:@"m4a"];
    NSURL *URLPath = [[NSURL alloc] initFileURLWithPath:musicPath];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:URLPath error:nil];
//    [_player prepareToPlay];
//    _player.numberOfLoops = -1;
//    [_player play];

}

+(UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId
{
    //设置并激活音频会话类别
    AVAudioSession *session=[AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    //允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    
    return newTaskId;
}


#pragma mark- JPUSHRegisterDelegate // 2.1.9版新增JPUSHRegisterDelegate,需实现以下两个方法

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center  willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSString *log = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOG"];
    if ([log integerValue]==1) {
        // Required
        NSDictionary * userInfo = notification.request.content.userInfo;
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
        else {
            // 本地通知
        }
        [self setNoticeBadge:userInfo];
//        NSLog(@"收到通知1:%@", [self logDic:userInfo]);
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
        NSString *voice = [[NSUserDefaults standardUserDefaults]objectForKey:@"VoiceState"];
        if ([voice integerValue]== 0) {
//            [self speechWord:userInfo[@"aps"][@"alert"]];
        }
    }
    
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler: (void (^)())completionHandler {
    // Required
    NSString *log = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOG"];
    if ([log integerValue]==1) {
    }
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }else {
        //本地通知
    }
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"];
    [self setNoticeBadge:userInfo];
    [self clickNotice:userInfo];
    
//    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    NSString *voice = [[NSUserDefaults standardUserDefaults]objectForKey:@"VoiceState"];
    if ([voice integerValue]== 0) {
//        [self speechWord:userInfo[@"aps"][@"alert"]];
    }
}

//iOS 7 Remote Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:  (NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"this is iOS7 Remote Notification");
    
//    NSLog(@"收到通知3:%@", [self logDic:userInfo]);
    [self setNoticeBadge:userInfo];
 
    
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
    //集成讯飞语音api
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);  // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    NSString *voice = [[NSUserDefaults standardUserDefaults]objectForKey:@"VoiceState"];
    if ([voice integerValue]== 0) {
//        [self speechWord:userInfo[@"aps"][@"alert"]];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    // 取得Extras字段内容
    NSDictionary *customizeField1 = [userInfo valueForKey:@"extras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field  =[%@]",content,badge,sound,customizeField1);
    
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)speakVoice {
    
    // 设置apiKey和secretKey
    [[BDSSpeechSynthesizer sharedInstance] setApiKey:@"B5t9DnQInuQk0ZR3A81xjSFP" withSecretKey:@"w3taGLHUlhcOZjAgzSNLKrqrFIcPyB3w"];
    // 设置离线引擎
    NSString *ChineseSpeechData = [[NSBundle mainBundle] pathForResource:@"Chinese_Speech_Male" ofType:@"dat"];
    NSString *ChineseTextData = [[NSBundle mainBundle] pathForResource:@"Chinese_Text" ofType:@"dat"];
    //    NSString *EnglishSpeechData = [[NSBundle mainBundle] pathForResource:@"English_Speech_Female" ofType:@"dat"];
    //    NSString *EnglishTextData = [[NSBundle mainBundle] pathForResource:@"English_text" ofType:@"dat"];
    NSString *LicenseData = [[NSBundle mainBundle] pathForResource:@"offline_engine_tmp_license" ofType:@"dat"];
    
    NSError *error = [[BDSSpeechSynthesizer sharedInstance] loadOfflineEngine:ChineseTextData speechDataPath:ChineseSpeechData licenseFilePath:LicenseData withAppCode:nil];
    
    // 获得合成器实例
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerDelegate:self];
    
    // 开始合成并播放
    NSError* speakError = nil;
    if([[BDSSpeechSynthesizer sharedInstance] speakSentence:@"您好" withError:&speakError] == -1){
        // 错误
        NSLog(@"错误: %ld, %@", (long)speakError.code, speakError.localizedDescription);
    }
    
    
}


- (void)remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    
    //    [_player play];
    
}

#pragma mark PrivateMethod
/** 处理推送过来的消息 */
//- (void)handleContent:(NSDictionary *)dict {
//    NSLog(@"func ==== %s",__func__);
//    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//        
//        NSLog(@"前台:%@",dict[@"aps"][@"alert"]);
//        [self speechWord:dict[@"aps"][@"alert"][@"title"]];
//    }else {
//        
//        NSLog(@"后台:%@",dict[@"aps"][@"alert"]);
//        [self speechWord:dict[@"aps"][@"alert"][@"title"]];
//    }
//    
//}

//设置消息角标
-(void)setNoticeBadge:(NSDictionary*)userInfo
{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//小红点清0操作
        NSInteger num = [userInfo[@"aps"][@"badge"] integerValue];
        [[NSUserDefaults standardUserDefaults]setObject:@(num) forKey:@"NoticeNumber"];
        NSString *unreadNum = [[NSUserDefaults standardUserDefaults]objectForKey:@"UNREAD"];
                SWTabController *tabController = (SWTabController*)self.window.rootViewController;
                SWMyController *myController = (SWMyController*)tabController.viewControllers[2];
        
                if ([unreadNum integerValue] > 0) {
                    myController.tabBarItem.badgeValue = unreadNum;
        
                }else{
                    myController.tabBarItem.badgeValue = nil;
                }
    }
    
}

//极光推送跳转不同界面
-(void)clickNotice:(NSDictionary*)dict
{
//    NSLog(@"log  %@",dict);
    SWTabController *tabBarVC = (SWTabController*)self.window.rootViewController;
    UIViewController *vc ;
    if ([dict[@"type"]isEqualToString:@"worker_audit_agree"]) {//主页>找活干
        tabBarVC.selectedIndex = 0;
    }else if ([dict[@"type"]isEqualToString:@"employment_invitation"]) {//我的任务
        tabBarVC.selectedIndex = 3;
        SWMyJobController *jobVC = [[SWMyJobController alloc] init];
        jobVC.hidesBottomBarWhenPushed = YES;
        jobVC.segmentControl.selectIndex = 0;
        UINavigationController * nvc=(UINavigationController *)tabBarVC.selectedViewController;
        [nvc pushViewController:jobVC animated:YES];
        nvc.hidesBottomBarWhenPushed = NO;
    }else if ([dict[@"type"]isEqualToString:@"new_project_informatin"]){//工程详情
        tabBarVC.selectedIndex = 3;
        SWJobDetailController *jobController = [[SWJobDetailController alloc] init];
        jobController.hidesBottomBarWhenPushed = YES;
        jobController.iid = dict[@"iid"];
        UINavigationController * nvc=(UINavigationController *)tabBarVC.selectedViewController;
        [nvc pushViewController:jobController animated:YES];
        nvc.hidesBottomBarWhenPushed = NO;
    }else if ([dict[@"type"]isEqualToString:@"receive_employment_contract"]||[dict[@"type"]isEqualToString:@"contract_modifyed"]||[dict[@"type"]isEqualToString:@"personal_contract_check_over"]){//我的合同-我收到
        tabBarVC.selectedIndex = 3;
        SWMyContractController *contractVC = [[SWMyContractController alloc] init];
        contractVC.hidesBottomBarWhenPushed = YES;
        contractVC.segmentControl.selectIndex = 1;
        UINavigationController * nvc=(UINavigationController *)tabBarVC.selectedViewController;
        [nvc pushViewController:contractVC animated:YES];
        nvc.hidesBottomBarWhenPushed = NO;
    }else if ([dict[@"type"]isEqualToString:@"employment_contract_agree"]||[dict[@"type"]isEqualToString:@"employment_invitation_agree"]||[dict[@"type"]isEqualToString:@"contract_not_agree"]||[dict[@"type"]isEqualToString:@"contract_refuse"]){//我的合同-我发布
        tabBarVC.selectedIndex = 3;
        SWMyContractController *contractVC = [[SWMyContractController alloc] init];
        contractVC.hidesBottomBarWhenPushed = YES;
        contractVC.segmentControl.selectIndex = 0;
        UINavigationController * nvc=(UINavigationController *)tabBarVC.selectedViewController;
        [nvc pushViewController:contractVC animated:YES];
        nvc.hidesBottomBarWhenPushed = NO;
    }else if ([dict[@"type"]isEqualToString:@"project_receive_worker_ask"]||[dict[@"type"]isEqualToString:@"employment_invitation_refuse"]||[dict[@"type"]isEqualToString:@"worker_confirm_over"]){//我发布的-工程详情
        tabBarVC.selectedIndex = 3;
        SWMyPublishDetailController *publishVC = [SWMyPublishDetailController new];
        publishVC.hidesBottomBarWhenPushed = YES;
        publishVC.iid = dict[@"iid"];
        UINavigationController * nvc=(UINavigationController *)tabBarVC.selectedViewController;
        [nvc pushViewController:publishVC animated:YES];
        nvc.hidesBottomBarWhenPushed = NO;
    }else if ([dict[@"type"]isEqualToString:@"employer_pay_subsist"]){//我的任务>待开始
        tabBarVC.selectedIndex = 3;
        SWMyJobController *jobVC = [[SWMyJobController alloc] init];
        jobVC.hidesBottomBarWhenPushed = YES;
        jobVC.segmentControl.selectIndex = 1;
        UINavigationController * nvc=(UINavigationController *)tabBarVC.selectedViewController;
        [nvc pushViewController:jobVC animated:YES];
        nvc.hidesBottomBarWhenPushed = NO;
    }else if ([dict[@"type"]isEqualToString:@"employer_information_begin"]){//我的任务>进行中
        tabBarVC.selectedIndex = 3;
        SWMyJobController *jobVC = [[SWMyJobController alloc] init];
        jobVC.hidesBottomBarWhenPushed = YES;
        jobVC.segmentControl.selectIndex = 2;
        UINavigationController * nvc=(UINavigationController *)tabBarVC.selectedViewController;
        [nvc pushViewController:jobVC animated:YES];
        nvc.hidesBottomBarWhenPushed = NO;
    }else if ([dict[@"type"]isEqualToString:@"employer_confirm_information_over"]){//我的任务>已完成
        tabBarVC.selectedIndex =3;
        SWMyJobController *jobVC = [[SWMyJobController alloc] init];
        jobVC.hidesBottomBarWhenPushed = YES;
        jobVC.segmentControl.selectIndex = 3;
        UINavigationController * nvc=(UINavigationController *)tabBarVC.selectedViewController;
        [nvc pushViewController:jobVC animated:YES];
        nvc.hidesBottomBarWhenPushed = NO;
    }else if ([dict[@"type"]isEqualToString:@"worker_apply_money"]){//我要发工资
        tabBarVC.selectedIndex = 3;
        MyWorkersViewController *workVC = [[MyWorkersViewController alloc] init];
        workVC.hidesBottomBarWhenPushed = YES;
        UINavigationController * nvc=(UINavigationController *)tabBarVC.selectedViewController;
        [nvc pushViewController:workVC animated:YES];
        nvc.hidesBottomBarWhenPushed = NO;
    }else if ([dict[@"type"]isEqualToString:@"employer_pay_money"]){//交易记录
        tabBarVC.selectedIndex = 3;
        TransactionLogViewController *logVC = [[TransactionLogViewController alloc] init];
        logVC.hidesBottomBarWhenPushed = YES;
        UINavigationController * nvc=(UINavigationController *)tabBarVC.selectedViewController;
        [nvc pushViewController:logVC animated:YES];
        nvc.hidesBottomBarWhenPushed = NO;
    }else if ([dict[@"type"]isEqualToString:@"contract_release_construction_log"]||[dict[@"type"]isEqualToString:@"personal_contract_second_ask_check"]){
        tabBarVC.selectedIndex = 3;
        ConstructionRecordsViewController *recordvc =[[ConstructionRecordsViewController alloc]init];
        recordvc.hidesBottomBarWhenPushed = YES;
        UINavigationController * nvc=(UINavigationController *)tabBarVC.selectedViewController;
        [nvc pushViewController:recordvc animated:YES];
        nvc.hidesBottomBarWhenPushed = NO;
    }else if ([dict[@"type"]isEqualToString:@"receive_company_contract"]||[dict[@"type"]isEqualToString:@"company_contract_not_agree"]||[dict[@"type"]isEqualToString:@"company_contract_agree"]||[dict[@"type"]isEqualToString:@"company_contract_refuse"]||[dict[@"type"]isEqualToString:@"company_contract_modifyed"]||[dict[@"type"]isEqualToString:@"company_contract_verify_pass"]||[dict[@"type"]isEqualToString:@"company_contract_verify_refuse"]||[dict[@"type"]isEqualToString:@"receive_new_verify"]||[dict[@"type"]isEqualToString:@"verify_pass"]||[dict[@"type"]isEqualToString:@"verify_refuse"]||[dict[@"type"]isEqualToString:@"approval_detail_visit"]){
        tabBarVC.selectedIndex = 2;
        
    }else if ([dict[@"type"]isEqualToString:@"work_log_detail_visit"]||[dict[@"type"]isEqualToString:@"reply_new_verify_approval"]){
        tabBarVC.selectedIndex = 2;
        if (![NSString isBlankString:[dict[@"iid"] objectForKey:@"company_id"]]) {
            DiaryRemindViewController *recordvc =[[DiaryRemindViewController alloc]init];
//            recordvc.companyID = [dict[@"iid"] objectForKey:@"company_id"];
            recordvc.hidesBottomBarWhenPushed = YES;
            UINavigationController * nvc=(UINavigationController *)tabBarVC.selectedViewController;
            [nvc pushViewController:recordvc animated:YES];
            nvc.hidesBottomBarWhenPushed = NO;
        }
        
    }
    
    
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    //    NSString *str =
    //    [NSPropertyListSerialization propertyListFromData:tempData
    //                                     mutabilityOption:NSPropertyListImmutable
    //                                               format:NULL
    //                                     errorDescription:NULL];
    NSString *str =[NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:nil];
    return str;
}

//- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
//    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
//}

@end
