//
//  WebViewController.h
//  手保
//
//  Created by my-mac on 15/12/10.
//  Copyright © 2015年 my-mac. All rights reserved.
//

#import "CXZBaseViewController.h"
#import "FilesModel.h"
@interface WebViewController : CXZBaseViewController

@property(nonatomic, copy) NSString *urlStr;

@property(nonatomic, copy) NSString *titleString;

@property(nonatomic, copy) NSString *contract_type_id;

@property(nonatomic, strong) FilesModel *filesModel;

@property(nonatomic, assign)BOOL isAboutUs;

@property(nonatomic, assign)BOOL isShare;

@property(nonatomic, assign)BOOL is_Send;


@end
