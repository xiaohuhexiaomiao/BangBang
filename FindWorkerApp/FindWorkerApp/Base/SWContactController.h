//
//  SWContactController.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/13.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@protocol ContactDelegate <NSObject>

/** 回调是否同意合同 */
- (void)bactToAgree:(BOOL)isAgree;

@end

@interface SWContactController : CXZBaseViewController

@property (nonatomic, weak) id<ContactDelegate> contactDelegate;

@property (nonatomic, retain) NSString *infomation_id;

@property (nonatomic, retain) NSString *worker_id;

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, copy) NSString *contact_id;

/**
 status 0 我发送的 1 我收到的 2 我同意的 3 需要雇主重新编写的 4 我拒绝的 5工程已完结
 */
@property (nonatomic, assign) NSInteger status;

- (void)showWebView:(NSString *)infomation_id worker_id:(NSString *)worker_id;

@end
