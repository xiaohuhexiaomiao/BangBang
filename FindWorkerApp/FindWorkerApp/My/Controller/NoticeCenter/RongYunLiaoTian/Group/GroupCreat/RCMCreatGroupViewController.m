//
//  RCMCreatGroupViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/5/10.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "RCMCreatGroupViewController.h"
#import "CXZ.h"
#import "SWWorkerData.h"

#import "RCMAddGroupMemberViewController.h"

@interface RCMCreatGroupViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate,RCMAddMemberControllerDelegate>
{
    NSData *data;
    UIImage *image;
    //    NSMutableArray *memberIdsList;
    MBProgressHUD *hud;
    CGFloat deafultY;
    NSString *hash;
}

@property(nonatomic, strong) UIImageView *GroupPortrait;

@property(nonatomic, strong) UITextField *GroupName;

@property(nonatomic, strong) UITextView *GroupMark;

@property(nonatomic, strong) UIButton *addBtn;

@property(nonatomic, strong) UIButton *doneBtn;

@property(nonatomic, strong) NSMutableArray *groupMemberIdList;


@end

@implementation RCMCreatGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"创建群" withColor:[UIColor whiteColor]];
    //    [self setupNextWithString:@"完成" withColor:[UIColor whiteColor]];
    [self removeTapGestureRecognizer];
    [self initSubViews];
}


- (void)initSubViews {
    //群组头像的UIImageView
    CGFloat groupPortraitWidth = 50;
    CGFloat groupPortraitHeight = groupPortraitWidth;
    CGFloat groupPortraitX = RCDscreenWidth / 2.0 - groupPortraitWidth / 2.0;
    self.GroupPortrait = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"placeholder"]];
    [self.view addSubview:self.GroupPortrait];
    [self.GroupPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(groupPortraitX);
        make.width.mas_equalTo(groupPortraitWidth);
        make.height.mas_equalTo(groupPortraitHeight);
    }];
    self.GroupPortrait.layer.masksToBounds = YES;
    self.GroupPortrait.layer.cornerRadius = 5.f;
    //为头像设置点击事件
    self.GroupPortrait.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chosePortrait)];
    [self.GroupPortrait addGestureRecognizer:singleClick];
    
    //群组名称的UITextField
    CGFloat titleHeight = 30;
    CGFloat titleWidth = 60;
    
    UILabel *nameLabel = [CustomView customTitleUILableWithContentView:self.view title:@"群名称："];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.GroupPortrait.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(titleWidth);
        make.height.mas_equalTo(titleHeight);
    }];
    
    self.GroupName = [CustomView customUITextFieldWithContetnView:self.view placeHolder:@"（2-10个字符）"];
//    self.GroupName.textAlignment = NSTextAlignmentCenter;
    self.GroupName.returnKeyType = UIReturnKeyDone;
    [self.GroupName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_top);
        make.right.mas_equalTo(-8);
        make.left.mas_equalTo(nameLabel.mas_right);
        make.height.mas_equalTo(titleHeight);
    }];
    
    UIView *line = [CustomView customLineView:self.view];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.GroupName.mas_bottom);
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    //底部蓝线
    
    CGFloat blueLineHeight = 40;
    UILabel *introduce = [CustomView customTitleUILableWithContentView:self.view title:@"群简介："];
    [introduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(titleWidth);
        make.height.mas_equalTo(titleHeight);
    }];
    
    self.GroupMark = [CustomView customUITextViewWithContetnView:self.view placeHolder:nil];
    [self.GroupMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(introduce.mas_top);
        make.right.mas_equalTo(-8);
        make.left.mas_equalTo(introduce.mas_right);
        make.height.mas_equalTo(blueLineHeight);
    }];
    
    UIView *line1 = [CustomView customLineView:self.view];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.GroupMark.mas_bottom);
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
    self.addBtn = [CustomView customButtonWithContentView:self.view image:@"add" title:@"邀请成员"];
    [self.addBtn addTarget:self action:@selector(addGroupMember) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [ self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom);
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(30);
    }];
    
    CGFloat doneHeight = 30;
    CGFloat doneWidth = 80;
    CGFloat doneX = SCREEN_WIDTH/2-doneWidth/2;
    self.doneBtn = [CustomView customButtonWithContentView:self.view image:nil title:@"完成"];
    [self.doneBtn addTarget:self action:@selector(clickDoneButton) forControlEvents:UIControlEventTouchUpInside];
    self.doneBtn.layer.cornerRadius = doneHeight/2;
    self.doneBtn.layer.borderColor = LINE_GRAY.CGColor;
    self.doneBtn.layer.borderWidth = 0.8;
    [ self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addBtn.mas_bottom).mas_offset(30);
        make.left.mas_equalTo(doneX);
        make.width.mas_equalTo(doneWidth);
        make.height.mas_equalTo(doneHeight);
    }];
}

-(void)addGroupMember
{
    RCMAddGroupMemberViewController *addVC = [[RCMAddGroupMemberViewController alloc]init];
    addVC.delegate = self;
    addVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
- (void)clickDoneButton
{
    
    //    [_GroupName resignFirstResponder];
    //
    NSString *nameStr = [self.GroupName.text copy];
    nameStr = [nameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([hash length] == 0) {
        [self Alert:@"群头像正在上传中"];
        return;
    }
    if (self.groupMemberIdList.count == 0) {
        [self Alert:@"请添加群成员"];
        return;
    }
    //群组名称需要大于2位
    if ([nameStr length] == 0) {
        [self Alert:@"群组名称不能为空"];
    }
    //群组名称需要大于2个字
    else if ([nameStr length] < 2) {
        [self Alert:@"群组名称过短"];
    }
    //群组名称需要小于10个字
    else if ([nameStr length] > 10) {
        [self Alert:@"群组名称不能超过10个字"];
    } else {
        BOOL isAddedcurrentUserID = false;
        for (NSString *userId in self.groupMemberIdList) {
            if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
                isAddedcurrentUserID = YES;
            } else {
                isAddedcurrentUserID = NO;
            }
        }
        if (isAddedcurrentUserID == NO) {
            [_groupMemberIdList addObject:[RCIM sharedRCIM].currentUserInfo.userId];
        }
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [UIColor colorWithHexString:@"343637"];
        hud.labelText = @"创建中...";
        [hud show:YES];
        
        NSDictionary *dict = @{@"name":nameStr,@"notice":self.GroupMark.text,@"avatar":hash};
        [[RCDHttpTool shareInstance]createGroupWithGroupInfo:dict GroupMemberList:_groupMemberIdList complete:^(NSString *groupId) {
            
            if (groupId) {
                [RCDHTTPTOOL getGroupMembersWithGroupId:groupId
                                                  Block:^(NSMutableArray *result){
                                                      //更新本地数据库中群组成员的信息
                                                      if (hash) {
                                                          RCGroup *groupInfo = [RCGroup new];
                                                          groupInfo.portraitUri = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,hash];
                                                          groupInfo.groupId = groupId;
                                                          groupInfo.groupName = nameStr;
                                                          [[RCIM sharedRCIM]refreshGroupInfoCache:groupInfo withGroupId:groupId];
                                                          
                                                      } else {
//                                                          [self gotoChatView:groupId groupName:nameStr];
                                                          //关闭HUD
                                                          
                                                      }
                                                      [hud hide:YES];
                                                      [self.navigationController popViewControllerAnimated:YES];

                                                  }];
            }
        }];
    }
}


-(void)Alert:(NSString *)alertContent {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:alertContent
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark

-(void)selectedMember:(NSMutableArray *)memberArray
{
    for (SWWorkerData *worker in memberArray) {
        [self.groupMemberIdList addObject:worker.uid];
    }
   
    [self.addBtn setTitle:[NSString stringWithFormat:@"邀请成员（已邀请%li人）",self.groupMemberIdList.count] forState:UIControlStateNormal];
}


#pragma mark 相册
- (void)chosePortrait {
    
    [_GroupName resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"拍照"
                                                    otherButtonTitles:@"我的相册", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                NSLog(@"模拟器无法连接相机");
            }
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqual:@"public.image"]) {
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        CGRect captureRect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
        UIImage *captureImage =
        [self getSubImage:originImage Rect:captureRect imageOrientation:originImage.imageOrientation];
        
        UIImage *scaleImage = [self scaleImage:captureImage toScale:0.8];
        data = UIImageJPEGRepresentation(scaleImage, 0.00001);
    }
    
    image = [UIImage imageWithData:data];
    [self dismissViewControllerAnimated:YES completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.GroupPortrait.image = image;
    });
    
    [[NetworkSingletion sharedManager]getQiNiuToken:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            NSString *imageToken = [dict objectForKey:@"data"];
            [self uploadImageToQNFilePath:image token:imageToken name:@"GroupLogo"];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
        
    } OnError:^(NSString *error) {
        
        [MBProgressHUD showError:error toView:self.view];
    }];
    
}

- (UIImage *)getSubImage:(UIImage *)originImage
                    Rect:(CGRect)rect
        imageOrientation:(UIImageOrientation)imageOrientation {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(originImage.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef scale:1.f orientation:imageOrientation];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}

- (UIImage *)scaleImage:(UIImage *)Image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(Image.size.width * scaleSize, Image.size.height * scaleSize));
    [Image drawInRect:CGRectMake(0, 0, Image.size.width * scaleSize, Image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark 七牛相关
- (void)uploadImageToQNFilePath:(UIImage *)image token:(NSString*)imageToken name:(NSString*)fileName{
    
    NSString *filePath = [self getImagePath:image name:fileName];
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        //        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [upManager putFile:filePath key:nil token:imageToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        //        NSLog(@"info ===== %@", info);
        //        NSLog(@"resp ===== %@", resp);
        hash = [resp objectForKey:@"hash"];
        
        
    }
                option:uploadOption];
}


//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image name:(NSString*)name
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
    NSString *ImagePath = [NSString stringWithFormat:@"/theImage%@.png",name];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}

#pragma mark get/set

-(NSMutableArray*)groupMemberIdList
{
    if (!_groupMemberIdList) {
        _groupMemberIdList = [NSMutableArray array];
    }
    return _groupMemberIdList;
}

#pragma mark warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
