//
//  InputTextView.m
//  FindWorkerApp
//
//  Created by cxz on 2018/4/10.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "InputTextView.h"
#import "CXZ.h"
#import "DiaryFileView.h"
@interface InputTextView()<UITextViewDelegate>

@property(nonatomic ,strong)UIView* bgView;

@property(nonatomic ,strong)UILabel* placeHolderLabel;

@property(nonatomic ,strong)DiaryFileView *fileView;


@end

@implementation InputTextView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBackgroudView:)];
        [self addGestureRecognizer:tap];
        
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-300, SCREEN_WIDTH, 300)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        _textView = [CustomView customUITextViewWithContetnView:_bgView placeHolder:nil];
        _textView.frame =CGRectMake(10, 8, SCREEN_WIDTH-66, 84);
        _textView.layer.borderColor = LINE_GRAY.CGColor;
        _textView.layer.borderWidth = 0.8;
        _textView.delegate = self;
        
        _placeHolderLabel = [CustomView customContentUILableWithContentView:_bgView title:@"回复："];
        _placeHolderLabel.frame = CGRectMake(12, 9, 80, 20);
        _placeHolderLabel.textColor = [UIColor grayColor];
        _placeHolderLabel.hidden = NO;
        
        UIButton *sendButton = [CustomView customButtonWithContentView:_bgView image:nil title:@"发送"];
        sendButton.frame = CGRectMake(_textView.right, 70, 50, 30);
        sendButton.titleLabel.font = [UIFont systemFontOfSize:13];
//        [sendButton setTitleColor:ORANGE_COLOR forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(clickSendButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        _fileView = [[DiaryFileView alloc]initWithFrame:CGRectMake(8, _textView.bottom+10, SCREEN_WIDTH-16, 30)];
        [_bgView addSubview:_fileView];
        [_fileView addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
    
    
    }
    return self;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"height"] ) {
        CGFloat newHeight = [change[@"new"] floatValue];
        CGRect fileFrame = self.fileView.frame;
        fileFrame.size.height = newHeight;
        self.fileView.frame = fileFrame;
        if (newHeight > 200) {
            CGRect bgFrame = self.bgView.frame;
            bgFrame = CGRectMake(0, self.frame.size.height-100-newHeight, SCREEN_WIDTH, 100+newHeight);
            self.bgView.frame = bgFrame;
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)clickSendButton
{
    if ([NSString isBlankString:self.textView.text]) {
        [WFHudView showMsg:@"请输入回复内容" inView:self];
        return;
    }
    [self.textView resignFirstResponder];
    NSMutableArray *hushArray = [NSMutableArray array];
    if (self.fileView.imgArray.count > 0) {
        for (int i = 0; i < self.fileView.imgArray.count; i++) {
            UploadImageModel *imgView = self.fileView.imgArray[i];
            if ([NSString isBlankString:imgView.hashString]) {
                [WFHudView showMsg:@"图片正在上传中，请稍后提交.." inView:self];
                return;
            }
            [hushArray addObject:imgView.hashString];
            
        }
        [self uploadPhotos:hushArray];
    }else{
        [self uploadReplyContent:nil];
    }
    
    
}

-(void)clickBackgroudView:(UITapGestureRecognizer*)tap
{
    [self.fileView removeObserver:self forKeyPath:@"height"];
    [self removeFromSuperview];
    self.hidden = YES;
}

#pragma mark upload Data

-(void)uploadReplyContent:(NSString*)pictureString
{
    NSMutableArray *enclosureArray = [NSMutableArray array];
    if (self.fileView.file_id_array.count > 0) {
        [enclosureArray addObjectsFromArray:self.fileView.file_id_array];
    }
    if (![NSString isBlankString:pictureString]) {
        NSDictionary *dict = @{@"contract_id":pictureString,@"type":@(3),@"name":@"图片"};
        [enclosureArray addObject:dict];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSDictionary *pdict = @{@"reply_content":self.textView.text,
                                @"participation_id":self.participation_id,
                                @"approval_id":self.approval_id,
                                @"other_uid":self.other_uid};
    [paramDict addEntriesFromDictionary:pdict];
    if (enclosureArray.count > 0) {
        [paramDict setObject:[NSString dictionaryToJson:enclosureArray] forKey:@"many_enclosure"];
    }
    [[NetworkSingletion sharedManager]replyApprovalForm:paramDict onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            [self.fileView removeObserver:self forKeyPath:@"height"];
            self.placeHolderLabel.hidden = NO;
            self.textView.text = @"";
            [self.delegate didLoadNewData];
            [self removeFromSuperview];
            self.hidden = YES;
            
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self];
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
            [self uploadReplyContent:[NSString stringWithFormat:@"%li",enclosureId]];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self];
        }
    } OnError:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
    
}


#pragma mark UITextView Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeHolderLabel.hidden = YES;
}



@end
