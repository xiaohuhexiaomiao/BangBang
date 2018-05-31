//
//  SignNameViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/4/28.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SignNameViewController.h"
#import "CXZ.h"
#import "LCPaintView.h"


@interface SignNameViewController ()

@property (nonatomic, weak) LCPaintView *paintView;


@end

@implementation SignNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupBackw];
    [self setupTitleWithString:@"签名" withColor:[UIColor whiteColor]];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
    tipLabel.text = @"请在下面方框里手写您的姓名";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = TITLECOLOR;
    [self.view addSubview:tipLabel];
    
    LCPaintView *paintView = ({
        LCPaintView *paintView = [[LCPaintView alloc] init];
        paintView.frame = CGRectMake(8, tipLabel.bottom, SCREEN_WIDTH-16, SCREEN_HEIGHT-170);
        paintView.backgroundColor = [UIColor whiteColor];
//        paintView.layer.borderColor = [UIColor blackColor].CGColor;
//        paintView.layer.borderWidth = 0.8;
        
        paintView.lineColor = [UIColor blackColor];
        paintView.lineWidth = 1;
        [self.view insertSubview:paintView atIndex:0];
        self.paintView = paintView;
    });
    
    __weak typeof(paintView) weakPaintView = paintView;
    [NSTimer scheduledTimerWithTimeInterval:5.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
        __strong typeof(weakPaintView) strongPaintView = weakPaintView;
        
        strongPaintView.lineColor = [UIColor blackColor];
        strongPaintView.lineWidth = 1;
    }];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    okBtn.backgroundColor = TOP_GREEN;
    clearBtn.frame = CGRectMake(0, self.view.bounds.size.height-40-64, SCREEN_WIDTH/2, 40);
    [clearBtn setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
    [clearBtn setTitle:@"重写" forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clickClearButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.backgroundColor = TOP_GREEN;
    okBtn.frame = CGRectMake(clearBtn.right, clearBtn.top, SCREEN_WIDTH/2, 40);
//    [okBtn setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
    
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    
}

-(void)clickClearButton
{
    [self.paintView clear];
}

-(void)clickConfirmButton
{
//    [self saveScreen:self.paintView];

    UIImage *signImage = [self saveScreen:self.paintView];
    [[NetworkSingletion sharedManager]getQiNiuToken:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            NSString *imageToken = [dict objectForKey:@"data"];
            [self uploadImageToQNFilePath:@[signImage] token:@[imageToken]];
        }else{
            [SVProgressHUD dismiss];
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
            
            return ;
        }
        
    } OnError:^(NSString *error) {
        [SVProgressHUD dismiss];
        [MBProgressHUD showError:error toView:self.view];
    }];
    
    
}

//发送个人合同
-(void)sendPersonalContractWithSign:(NSString*)signStr
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:self.contentJson forKey:@"content_json"];
    [paramDict setObject:@(self.contranctTypeID) forKey:@"contract_type_id"];
    [paramDict setObject:self.workID forKey:@"worker_id"];
    [paramDict setObject:signStr forKey:@"signatory_a"];
    if (![NSString isBlankString:self.projectID]) {
        [paramDict setObject:self.projectID forKey:@"information_id"];
    }
    [[NetworkSingletion sharedManager]sendContractNew:paramDict onSucceed:^(NSDictionary *dict) {
//         NSLog(@"*****%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            
            [MBProgressHUD showSuccess:@"发送成功" toView:self.view];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1 ] animated:YES];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self.view];
        }
    } OnError:^(NSString *error) {
        [WFHudView showMsg:error inView:self.view];
    }];
}
//修改个人合同
-(void)modifyPersonalContractWithSign:(NSString*)signStr
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:self.contentJson forKey:@"content_json"];
    [paramDict setObject:@(self.contranctTypeID) forKey:@"contract_type_id"];
    [paramDict setObject:self.workID forKey:@"worker_id"];
    [paramDict setObject:signStr forKey:@"signatory_a"];
    [paramDict setObject:@(self.contranctID) forKey:@"contract_id"];
    [[NetworkSingletion sharedManager]getModifyConstract:paramDict onSucceed:^(NSDictionary *dict) {
        //         NSLog(@"*****%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            
            [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1 ] animated:YES];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self.view];
        }
    } OnError:^(NSString *error) {
        [WFHudView showMsg:error inView:self.view];
    }];
}

-(void)dealWithInspectionWithSign:(NSString*)signStr
{
    NSDictionary *paramDict = @{@"contract_id":@(self.contranctID),@"state":@(1),@"apply_id":self.applyid,@"type":@(1),@"signatory":signStr};
    [[NetworkSingletion sharedManager]dealWithAcceptance:paramDict onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            
            [MBProgressHUD showSuccess:@"处理成功" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}

-(void)dealWithSettlmentWithSign:(NSString*)signStr
{
    NSDictionary *paramDict = @{@"contract_id":@(self.contranctID),@"state":@(1),@"apply_id":self.applyid,@"type":@(2),@"signatory":signStr};
    [[NetworkSingletion sharedManager]dealWithAcceptance:paramDict onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            
            [MBProgressHUD showSuccess:@"处理成功" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}

#pragma mark 七牛相关
- (void)uploadImageToQNFilePath:(NSArray *)imageArray token:(NSArray*)imageTokenArray{
    
    NSMutableArray *hashArray = [NSMutableArray array];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue=dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < imageArray.count; i++) {
        
        NSString *filePath = [self getImagePath:imageArray[i] index:i];
        dispatch_group_async(group, queue, ^{
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
                //        NSLog(@"percent == %.2f", percent);
            }
                                                                         params:nil
                                                                       checkCrc:NO
                                                             cancellationSignal:nil];
            [upManager putFile:filePath key:nil token:imageTokenArray[i] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                //        NSLog(@"info ===== %@", info);
                //        NSLog(@"resp ===== %@", resp);
                NSString *hash = [resp objectForKey:@"hash"];
                [hashArray addObject:hash];
                dispatch_semaphore_signal(semaphore);
            }
                        option:uploadOption];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
        
    }
    [SVProgressHUD dismiss];
    dispatch_group_notify(group, queue, ^{
        //所有请求返回数据后执行
        if (self.signType == 0) {
            
        }else if(self.signType == 1){
             [self sendPersonalContractWithSign:hashArray[0]];
        }else if(self.signType == 2){
            [self dealWithInspectionWithSign:hashArray[0]];
        }else if(self.signType == 3){
            [self dealWithSettlmentWithSign:hashArray[0]];
        }else if(self.signType == 4){
            [self modifyPersonalContractWithSign:hashArray[0]];
        }
    });
    
}



//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image index:(NSInteger)index
{
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [NSString stringWithFormat:@"/theImage%li.png",index];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}

- (UIImage *)saveScreen:(UIView*)contentView{
    
    CGSize size = contentView.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGRect rect = contentView.frame;
    
    //  自iOS7开始，UIView类提供了一个方法-drawViewHierarchyInRect:afterScreenUpdates: 它允许你截取一个UIView或者其子类中的内容，并且以位图的形式（bitmap）保存到UIImage中
    [contentView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
  
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
    
//    UIGraphicsEndImageContext();
//   
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
