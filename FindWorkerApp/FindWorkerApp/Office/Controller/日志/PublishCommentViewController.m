//
//  PublishCommentViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/15.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "PublishCommentViewController.h"
#import "CXZ.h"
#import "DiaryFileView.h"
@interface PublishCommentViewController ()

@property(nonatomic ,strong)UITextView *contentTextView;

@property(nonatomic , strong) UIView *starView;

@property(nonatomic , strong) UILabel *starLabel;

@property(nonatomic , strong) DiaryFileView *fileView;

@property(nonatomic , strong) NSArray *commentArray;

@property(nonatomic , strong) NSMutableArray *starArray;

@property(nonatomic , assign) NSInteger score;


@end

@implementation PublishCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"回复" withColor:[UIColor whiteColor]];
    [self setupNextWithString:@"发布" withColor:[UIColor whiteColor]];
    [self config];
    self.view.backgroundColor = [UIColor whiteColor];
    self.score = 3;
    self.commentArray = @[@"严重批评",@"不 合 格",@"符合要求",@"超过预期",@"非常满意"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Public Method

-(void)onBack
{
    [self.fileView removeObserver:self forKeyPath:@"height"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNext
{
    if (self.comment_type == 1) {
        if ([NSString isBlankString:self.contentTextView.text]) {
            [WFHudView showMsg:@"请输入回复内容" inView:self.view];
            return;
        }
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
            [self publishCommentWithEnclosure:nil];
        }
    }else{
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
            [self publishReviewWithEnclosure:nil];
        }
    }
}

#pragma mark Private Method

-(void)publishCommentWithEnclosure:(NSString *)enclosureid
{
    NSMutableArray *enclosureArray = [NSMutableArray array];
    if (self.fileView.file_id_array.count > 0) {
        [enclosureArray addObjectsFromArray:self.fileView.file_id_array];
    }
    if (![NSString isBlankString:enclosureid]) {
        NSDictionary *dict = @{@"contract_id":enclosureid,@"type":@(3),@"name":@"图片"};
        [enclosureArray addObject:dict];
    }
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    NSDictionary *dict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"publish_id":self.publish_id,
                           @"content":self.contentTextView.text};
    [paraDict addEntriesFromDictionary:dict];
    if (enclosureArray.count > 0) {
        [paraDict setObject:[NSString dictionaryToJson:enclosureArray] forKey:@"enclosure"];
    }
    if (![NSString isBlankString:self.parent_id]) {
        [paraDict setObject:self.parent_id forKey:@"parent_id"];
    }
    [[NetworkSingletion sharedManager]clickDiaryCommentsButton:paraDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"coment %@",dict);
        if ([dict[@"code"] integerValue]==0) {
            [self.fileView removeObserver:self forKeyPath:@"height"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        
    }];
}

-(void)publishReviewWithEnclosure:(NSString *)enclosureid
{
    NSMutableArray *enclosureArray = [NSMutableArray array];
    if (self.fileView.file_id_array.count > 0) {
        [enclosureArray addObjectsFromArray:self.fileView.file_id_array];
    }
    if (![NSString isBlankString:enclosureid]) {
        NSDictionary *dict = @{@"contract_id":enclosureid,@"type":@(3),@"name":@"图片"};
        [enclosureArray addObject:dict];
    }
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    NSDictionary *dict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"log_id":self.log_id,
                           @"reviewer_fraction":@(self.score)};
    [paraDict addEntriesFromDictionary:dict];
    if (enclosureArray.count > 0) {
        [paraDict setObject:[NSString dictionaryToJson:enclosureArray] forKey:@"enclosure"];
    }
    NSString *remark;
    if ([NSString isBlankString:self.contentTextView.text]) {
        remark = self.commentArray[self.score-1];
    }else{
        remark = self.contentTextView.text;
    }
    [paraDict setObject:remark forKey:@"remarks"];
    [[NetworkSingletion sharedManager]clickDiaryReviewsButton:paraDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"coment %@",dict);
        if ([dict[@"code"] integerValue]==0) {
            [self.fileView removeObserver:self forKeyPath:@"height"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        
    }];

}

//上传附件
-(void)uploadPhotos:(NSMutableArray*)hashArray
{
    NSString *hashStr = [NSString dictionaryToJson:hashArray];
    [[NetworkSingletion sharedManager]updateReviewAnnexNew:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"picture":hashStr} onSucceed:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        if ([dict[@"code"] integerValue]==0) {
            NSInteger enclosureId = [[dict[@"data"] objectForKey:@"enclosure_id"] integerValue];
            if (self.comment_type == 1) {
                [self publishCommentWithEnclosure:[NSString stringWithFormat:@"%li",enclosureId]];
            }else{
                [self publishReviewWithEnclosure:[NSString stringWithFormat:@"%li",enclosureId]];
            }
            
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self.view];
        }
    } OnError:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
    
}



-(void)clickStarButton:(UIButton*)button
{
    
    NSInteger tag = button.tag;
    self.score = tag+1;
    self.starLabel.text = self.commentArray[tag];
    for (int i = 0; i < 5; i++) {
        UIButton *starButton = (UIButton*)self.starArray[i];
        if (i < (tag+1)) {
            [starButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        }else{
            [starButton setImage:[UIImage imageNamed:@"nostar"] forState:UIControlStateNormal];
        }
    }
    
}

#pragma mark 界面

-(void)config
{
    UIView *lastView;
    _contentTextView = [CustomView customUITextViewWithContetnView:self.view placeHolder:nil];
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(8);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(80);
    }];
    _contentTextView.backgroundColor = UIColorFromRGB(239, 239, 239);
    lastView = _contentTextView;
    
    if (self.comment_type == 2) {
        _starView = [[UIView alloc]init];
        _starView.layer.cornerRadius = 15;
        _starView.layer.borderColor = TOP_GREEN.CGColor;
        _starView.layer.borderWidth = 0.8;
        [self.view addSubview:_starView];
        [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(lastView.mas_bottom).mas_offset(10);
            make.width.mas_equalTo(180);
            make.height.mas_equalTo(30);
        }];
         lastView = _starView;
        
        UIButton *lastButton ;
        for (int i = 0; i < 5; i++) {
            UIButton *button = [CustomView customButtonWithContentView:_starView image:@"star" title:nil];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(3+23*i);
                make.top.mas_equalTo(5);
                make.width.height.mas_equalTo(20);
            }];
            if (i > 2) {
                [button setImage:[UIImage imageNamed:@"nostar"] forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(clickStarButton:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [self.starArray addObject:button];
            lastButton = button;
        }
        _starLabel = [CustomView customTitleUILableWithContentView:_starView title:@"符合要求"];
        [_starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lastButton.mas_right).mas_offset(3);
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.height.mas_equalTo(20);
        }];
    }
    
    _fileView = [[DiaryFileView alloc]initWithFrame:CGRectMake(8, lastView.bottom, SCREEN_WIDTH-16, 30)];
    [self.view addSubview:_fileView];
    [_fileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(lastView.mas_bottom).mas_offset(10);
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
        CGRect frame = self.fileView.frame;
        frame.size.height = newHeight;
        self.fileView.frame = frame;
       
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark get/set

-(NSMutableArray*)starArray
{
    if (!_starArray) {
        _starArray = [NSMutableArray array];
    }
    return _starArray;
}

@end
