//
//  CallbackDef.h
//  EighteenPalm
//
//  Created by 卢明渊 on 15/5/7.
//  Copyright (c) 2015年 18zhang. All rights reserved.
//

#ifndef CXZ_CallbackDef_h
#define CXZ_CallbackDef_h


typedef void (^OperatorCallback)(int code, NSString* msg); //操作返回回调 成功code＝0 其他失败
typedef void (^DataCallback)(id data); // 数据返回回调 成功不为nil

#endif
