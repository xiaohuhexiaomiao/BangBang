//
//  LAN.h
//  dongman
//
//  Created by 蓝布鲁 on 16/7/30.
//  Copyright (c) 2016 cxz. All rights reserved.
//

#ifndef LAN_h
#define LAN_h

typedef void (^AfterHttp)();
typedef void (^AfterArr)(NSArray *array);
typedef void (^After)(float diamond);
typedef void (^LableTapped)(CGFloat bottom);
typedef void(^AfterExec)();
typedef CGFloat (^bottomBtn)(float maxY);

//包括状态栏的屏幕尺寸
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//判断是否版本超过7.0
#define IOS7 ([[UIDevice currentDevice].systemVersion doubleValue]>=7.0)
//判断是否版本超过8.0
#define IOS8 ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0)

//适配的导航栏高度
#define TITLE_BAR_HEIGHT (IOS7?64:44)
#endif /* LAN_h */
