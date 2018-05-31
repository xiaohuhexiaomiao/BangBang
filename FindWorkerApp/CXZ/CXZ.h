//
//  CXZ.h
//  ImHere
//
//  Created by 卢明渊 on 15-3-13.
//  Copyright (c) 2015年 我在这. All rights reserved.
//

#ifndef CXZ_h
#define CXZ_h

#import "AppDelegate.h"
#import "CXZImageUtil.h"
#import "CXZFileUtil.h"
#import "ConfigUtil.h"
#import "CXZTimeUtil.h"
#import "HttpNetwork.h"
#import "NSGCDThread.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"

#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
#import "ZLCameraViewController.h"

#import "NSDate+Category.h"
#import "NSString+Category.h"
#import "MBProgressHUD+Add.h"
#import "UIView+Category.h"

#import "CALayer+Transition.h"
#import "CALayer+Anim.h"
#import "UITableView+NoneData.h"
#import "UIImage+Resize.h"
#import "NSObject+Ext.h"
#import "UIView+LAN.h"
#import "NSString+Extras.h"
#import "NSDate+Helper.h"
#import "UIColor+ColorChange.h"
#import "UILabel+Copy.h"
#import "UIViewExt.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

#import "CXZStringUtil.h"
#import "KaimaiDef.h"

#import "NetworkSingletion.h"
#import "WFHudView.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "WebViewController.h"
#import "SingleComponentDelegate.h"
#import "EditWebViewController.h"
#import "DataBase.h"
#import "RTLabel.h"

#import <QuickLook/QuickLook.h>
#import <MapKit/MapKit.h>
#import <Qiniu/QiniuSDK.h>
#import "Masonry.h"

#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RCConversationViewController.h>
#import "RCDataBaseManager.h"
#import "RCDHttpTool.h"

#import "CopyViewController.h"
#import "InputReasonViewController.h"

#import "DealWithApprovalView.h"
#import "AdressBookButton.h"
#import "CustomView.h"
#import "MoreFilesView.h"
#import "ShowFilesView.h"
#import "UploadImageModel.h"
#import "CashierReplyContentView.h"

#import "FileModel.h"
#import "PersonelModel.h"
#import "FormElementsModel.h"
#import "PersonalApprovalResultModel.h"

//app名称配置
#define APP_NAME @"dongman"
//底部按钮高度
#define DEFAULT_TABBAR_HEIGHT 49

//适配的导航栏高度
#define TITLE_BAR_HEIGHT (IOS7?64:44)

//导航栏颜色
#define NAV_BAR_COLOR HexRGB(0x252525)

//程序中默认字体
#define DEFAULT_FONT @"Helvetica"

#define FONT_SIZE 14

//本地数据库名称
#define LOCAL_DB_NAME @"dongman.db"

//本地文件保存目录（一般不删除）
#define LOCAL_FILE_PATH [NSString stringWithFormat:@"%@Local", APP_NAME]

//聊天阅后即焚
#define FIRE_FLAG @"fire"
#define FIRE_VALUE @"aijiaFire"

//更新原创下载状态
#define UPDATE_FANMADE_DOWNLOAD @"update_fanMade_DownloadState"
//更新cell
#define UPDATE_CELL @"updateCell"
//检查
#define CHECK_WIFI @"CHECK_IS_WIFI"

//获取RGB实现
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define UIColorFromRGB(rValue,gValue,bValue) [UIColor colorWithRed:rValue / 255.0 green:gValue / 255.0 blue:bValue / 255.0 alpha:1]

#define TINTCOLOR HexRGB(0x252525)

#define TITLECOLOR [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00];

#define SUBTITLECOLOR [UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1.00];

#define FORMTITLECOLOR [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1.00];//表单文本颜色

#define FORMLABELTITLECOLOR [UIColor colorWithRed:152/255 green:152/255 blue:152/255 alpha:1.00] ;//表单标题颜色

#define FONTBACKGROUNDCOLOR  UIColorFromRGB(248, 249, 248) //字体背景色
//橘色
#define ORANGE_COLOR RGBA(255, 122, 76, 1.0)
//深红色
#define LIGHT_RED_COLOR RGBA(255, 116, 116, 1.0)
//暗红色
#define DARK_RED_COLOR RGBA(255, 116, 142, 1.0)
//绿色
#define GREEN_COLOR RGBA(88, 196, 196, 1.0)
//线灰
#define LINE_GRAY [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.00]
//顶部绿
#define TOP_GREEN [UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1.00]

//判断是否版本超过7.0
#define IOS7 ([[UIDevice currentDevice].systemVersion doubleValue]>=7.0)

//判断是否版本超过8.0
#define IOS8 ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0)

//判断是否版本超过8.0
#define IOS11 ([[UIDevice currentDevice].systemVersion doubleValue]>=11.0)

#define NAVIGATION_BAR_HEIGHT ([[UIDevice currentDevice].systemVersion doubleValue]>=11.0?88:64)

//导航栏状态栏高度
#define TITLE_HEIGHT_WITH_BAR (STATUS_BAR_HEIGHT+44)
//包括状态栏的屏幕尺寸
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//不包括状态栏的屏幕尺寸
#define FRAME_WIDTH ([UIScreen mainScreen].applicationFrame.size.width)
#define FRAME_HEIGHT ([UIScreen mainScreen].applicationFrame.size.height)

//状态栏尺寸,不包含热点时的多出尺寸
#define STATUS_BAR_WIDTH ([[UIApplication sharedApplication] statusBarFrame].size.width)
#define STATUS_BAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)

//判断字符串是否为空
#define IS_EMPTY(str) (str == nil || [str length] == 0)

//验证码重复操作时间
#define CODE_SEND_TIME 60

//图片最大宽高
#define IMAGE_MAX_WH 300

// 关于我们地址
#define ABUOTUS_HOST @"https://bbsf.hzxb.net/index.php/Mobile/aboutme/about_page"


// 弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//AppId
#define APP_ID @"951723151"

//sessionKey
#define Session_Key @"SDFASDDF"


// 上线
//#define RONGYUN_KEY @"qf3d5gbjqeg0h"//融云
//#define API_HOST @"https://bbsf.hzxb.net"// 服务器接口根地址
//#define IMAGE_HOST @"http://bbsf-file.hzxb.net/"   //查看图片-七牛-上线

//测试
#define RONGYUN_KEY @"kj7swf8okyfh2"//融云
#define API_HOST @"http://192.168.1.250:80/fw"//测试服
#define IMAGE_HOST @"http://bbsf-test-file.hzxb.net/"//查看图片-七牛-测试服


// 上传文件接口
//#define UPLOAD_HOST @"http://115.29.203.21:10006/index.php/Mobile/App/upload"
//#define UPLOAD_HOST @"http://118.178.94.235/index.php/Mobile/App/upload"
//#define UPLOAD_HOST @"http://bbsf.hzxb.net/index.php/Mobile/App/upload"

#define IMAGE_URL(substr) [NSString stringWithFormat:@"%@%@", IMAGE_HOST, substr
//#define RES_URL(substr) [NSString stringWithFormat:@"http://115.29.203.21:10006/index.php%@", substr]
#define RES_URL(substr) [NSString stringWithFormat:@"http://bbsf.hzxb.net/index.php%@", substr]


//融云
#define DEFAULTS [NSUserDefaults standardUserDefaults]
#define ShareApplicationDelegate [[UIApplication sharedApplication] delegate]
#define HEXCOLOR(rgbValue)                                                                                             \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                                               \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                                                  \
blue:((float)(rgbValue & 0xFF)) / 255.0                                                           \
alpha:1.0]
#define IOS_FSystenVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define RCDDebugTestFunction 0

#define RCDPrivateCloudManualMode 0

#define RCDscreenWidth [UIScreen mainScreen].bounds.size.width
#define RCDscreenHeight [UIScreen mainScreen].bounds.size.height

#define RCD_IS_IPHONEX (RCDscreenWidth>=375.0f && RCDscreenHeight>=812.0f)
#define RCDExtraBottomHeight (RCD_IS_IPHONEX ? 34 : 0)
#define RCDExtraTopHeight (RCD_IS_IPHONEX ? 24 : 0)


#endif
