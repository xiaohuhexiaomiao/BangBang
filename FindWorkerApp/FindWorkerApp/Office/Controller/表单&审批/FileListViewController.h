//
//  FileListViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/10/20.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

#import <QuickLook/QuickLook.h>

@protocol FileViewControllerDelegate <NSObject>

-(void)chooseFiles:(NSMutableArray*)filesArray;

@end

@interface FileListViewController : CXZBaseViewController
//打开word文档需要引入的视图控制器
@property(nonatomic,strong) QLPreviewController *previewController;

@property(nonatomic ,strong)id <FileViewControllerDelegate>delegate;

@end
