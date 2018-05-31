//
//  SWUserData.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/29.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@interface SWUserData : Jastor

@property (nonatomic, retain) NSString *uid;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *idcard;

@property (nonatomic, retain) NSString *idcard_p;

@property (nonatomic, retain) NSString *idcard_n;

@property (nonatomic, retain) NSString *avatar;

@property (nonatomic, retain) NSString *phone;

@property (nonatomic, retain) NSString *bankcard;

@property (nonatomic, retain) NSString *bank;

@property (nonatomic, retain) NSString *birthday;

@property (nonatomic, retain) NSString *type;

@property (nonatomic, retain) NSString *sex;

@property (nonatomic, assign) NSInteger work_status;

@property (nonatomic, retain) NSString *balance;

@property (nonatomic, retain) NSString *longitude;

@property (nonatomic, retain) NSString *latitude;

@property (nonatomic, retain) NSString *location;

@property (nonatomic, retain) NSString *is_marlboro;

@property (nonatomic, retain) NSString *add_time;

@property (nonatomic, retain) NSString *nice;

@property (nonatomic, retain) NSString *work_num;

@property (nonatomic, retain) NSString *user_status;

@property (nonatomic, retain) NSString *admin_id;

@property (nonatomic, retain) NSString *pass_time;

@property (nonatomic, retain) NSString *app_token;

@property (nonatomic , retain)NSString *rong_token;

/** 登录类型 0:雇主 1:工人 */
@property (nonatomic, retain) NSString *roles;

@property (nonatomic, retain) NSString *skey;

@property (nonatomic, retain) NSString *skey_end_time;

@end
