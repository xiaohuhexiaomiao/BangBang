//
//  UploadPhotoAndTextViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/5/28.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "UploadPhotoAndTextViewController.h"
#import "CXZ.h"
#import "DiaryFileView.h"
#import "PaymentsFormViewController.h"

@interface UploadPhotoAndTextViewController ()

@property(nonatomic ,strong) UITextView *contentView;

@property(nonatomic ,strong) DiaryFileView *fileView;

@property(nonatomic ,copy) NSString *hushString;

@end

@implementation UploadPhotoAndTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"上传呈批件协议" withColor:[UIColor whiteColor]];
    [self setupNextWithString:@"提交" withColor:[UIColor whiteColor]];
    
    [self config];
}

#pragma mark

-(void)onNext
{
    NSMutableArray *hushArray = [NSMutableArray array];
    if (self.fileView.imgArray.count > 0) {
        for (int i = 0; i < self.fileView.imgArray.count; i++) {
            UploadImageModel *imgView = self.fileView.imgArray[i];
            if ([NSString isBlankString:imgView.hashString]) {
                [WFHudView showMsg:@"图片正在上传中，请稍后提交.." inView:self.view];
                return;
            }
            [hushArray addObject:imgView.hashString];
            
        }
        [self uploadPhotos:hushArray];
    }else{
        [self uploadData];
    }
}
//上传附件
-(void)uploadPhotos:(NSMutableArray*)hashArray
{
    NSString *hashStr = [NSString dictionaryToJson:hashArray];
    [[NetworkSingletion sharedManager]updateReviewAnnexNew:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"picture":hashStr} onSucceed:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        if ([dict[@"code"] integerValue]==0) {
            self.hushString = [dict[@"data"] objectForKey:@"enclosure_id"];
            [self uploadData];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self.view];
        }
    } OnError:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
    
}


-(void)uploadData
{
    NSMutableArray *enclosureArray = [NSMutableArray array];
    if (self.fileView.file_id_array.count > 0) {
        [enclosureArray addObjectsFromArray:self.fileView.file_id_array];
    }
    if (![NSString isBlankString:self.hushString]) {
        NSDictionary *dict = @{@"contract_id":self.hushString,@"type":@(3),@"name":@"图片"};
        [enclosureArray addObject:dict];
    }
    if (enclosureArray.count <= 0) {
        [WFHudView showMsg:@"请上传呈批件协议" inView:self.view];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSDictionary *paramDict = @{@"approval_id":self.approval_ID,
                                @"many_enclosure":[NSString dictionaryToJson:enclosureArray]
                                };
    [param addEntriesFromDictionary:paramDict];
    if (![NSString isBlankString:self.contentView.text]) {
        [param setObject:self.contentView.text forKey:@"remarks"];
    }
    
    [[NetworkSingletion sharedManager]uploadPorotocolOfFile:param onSucceed:^(NSDictionary *dict) {
//                                NSLog(@"**purchase*%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            [self.fileView removeObserver:self forKeyPath:@"height"];
            PaymentsFormViewController *payVC = [[PaymentsFormViewController alloc]init];
            payVC.payType = self.payType;
            payVC.formID = self.approval_ID;
            payVC.companyID = self.companyID;
            payVC.contractName = self.title;
            payVC.form_type = 0;
            payVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:payVC animated:YES];
        }else{
            
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        
    }];
    
    
}

#pragma mark 界面

-(void)config
{
    _contentView = [CustomView customUITextViewWithContetnView:self.view placeHolder:nil];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(100);
    }];
    _contentView.layer.cornerRadius = 3;
    _contentView.layer.masksToBounds = YES;
    _contentView.backgroundColor =  UIColorFromRGB(248, 249, 248);
    
    
    
    _fileView = [[DiaryFileView alloc]initWithFrame:CGRectMake(8, _contentView.bottom+10, SCREEN_WIDTH-16, 30)];
    [self.view addSubview:_fileView];
    [_fileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_contentView.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(30);
    }];
    [_fileView addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"height"] ) {
        CGFloat newHeight = [change[@"new"] floatValue];
        //        CGFloat oldMoney = [change[@"old"] floatValue];
        //        NSLog(@"**height*%lf",newHeight);
        [self.fileView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(newHeight);
        }];
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Navigation
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
