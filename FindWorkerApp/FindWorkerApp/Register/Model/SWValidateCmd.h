//
//  SWValidateCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/29.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@class SWNodeData;

@interface SWValidateCmd : BaseCommand

@property (nonatomic, retain) NSString *sender; //发送的手机

@property (nonatomic, retain) NSString *code; //收到的验证码

@property (nonatomic, retain) NSString *validate_code;//获取验证码时的信息

@end
