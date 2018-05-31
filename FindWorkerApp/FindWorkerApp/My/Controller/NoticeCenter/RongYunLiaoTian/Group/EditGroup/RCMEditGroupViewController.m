//
//  RCMEditGroupViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/5/11.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "RCMEditGroupViewController.h"
#import "CXZ.h"
#import "SWWorkerData.h"
#import "RCDataBaseManager.h"
#import "RCDGroupInfo.h"

#import "RCMAddGroupMemberViewController.h"
#import "RCMShowGroupMemberViewController.h"

@interface RCMEditGroupViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,UITextFieldDelegate,RCMAddMemberControllerDelegate>

@property(nonatomic, strong) UIImageView *GroupPortrait;

@property(nonatomic, strong) UITextField *GroupName;

@property(nonatomic, strong) UITextView *GroupMark;

@property(nonatomic, strong) UIButton *addBtn;//添加群成员

@property(nonatomic, strong) UIButton *dissolveBtn;//解散

@property(nonatomic, strong) UIButton *seeBtn;//查看群成员

@property(nonatomic, strong) UIButton *quitBtn;//退出

@property(nonatomic, strong) UIButton *editBtn;//编辑

@property(nonatomic, strong) NSMutableArray *groupMemberIdList;

@property(nonatomic, assign) BOOL is_manager;//是否是群主

@property(nonatomic, assign) BOOL is_update_logo;//是否换logo

@property(nonatomic, copy) NSString* oldHashString;//qun logo qi niu 地址

@property(nonatomic, copy) NSString* neHashString;//qun logo qi niu 地址

@end

@implementation RCMEditGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"群信息" withColor:[UIColor whiteColor]];
    
    _dissolveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _dissolveBtn.frame = CGRectMake(0, 0, 50, 20);
    [_dissolveBtn setTitle:@"解散" forState:UIControlStateNormal];
    [_dissolveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_dissolveBtn addTarget:self action:@selector(dissolveGroup) forControlEvents:UIControlEventTouchUpInside];
    _dissolveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _dissolveBtn.hidden = YES;
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:_dissolveBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self removeTapGestureRecognizer];
    [self initSubViews];
    [self loadGroupInfo];
}

#pragma mark Private method

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
    
    
    self.editBtn = [CustomView customButtonWithContentView:self.view image:@"pencil" title:@"编辑"];
    [self.editBtn addTarget:self action:@selector(editGroupInfo) forControlEvents:UIControlEventTouchUpInside];
    self.editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [ self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.mas_equalTo(self.GroupPortrait.mas_right).mas_offset(8);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];

    
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
    self.GroupName.userInteractionEnabled = NO;
    self.GroupName.delegate = self;
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
    self.GroupMark.userInteractionEnabled = NO;
    self.GroupMark.delegate = self;
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
    
    self.seeBtn = [CustomView customButtonWithContentView:self.view image:nil title:@"查看群成员"];
    [self.seeBtn addTarget:self action:@selector(seeGroupMember) forControlEvents:UIControlEventTouchUpInside];
    self.seeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [ self.seeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom);
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(40);
    }];
    
    UIView *line2 = [CustomView customLineView:self.view];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.seeBtn.mas_bottom);
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];

    
    self.addBtn = [CustomView customButtonWithContentView:self.view image:@"add" title:@"邀请成员"];
    [self.addBtn addTarget:self action:@selector(addGroupMember) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [ self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom);
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(30);
    }];
    self.addBtn.hidden = YES;
    
    
    CGFloat doneHeight = 30;
    CGFloat doneWidth = 100;
    CGFloat doneX = SCREEN_WIDTH/2-doneWidth/2;
    self.quitBtn = [CustomView customButtonWithContentView:self.view image:nil title:@"退出群"];
    [self.quitBtn addTarget:self action:@selector(quiteGroup) forControlEvents:UIControlEventTouchUpInside];
    self.quitBtn.layer.cornerRadius = doneHeight/2;
    self.quitBtn.layer.borderColor = LINE_GRAY.CGColor;
    self.quitBtn.layer.borderWidth = 0.8;
    [self.quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addBtn.mas_bottom).mas_offset(50);
        make.left.mas_equalTo(doneX);
        make.width.mas_equalTo(doneWidth);
        make.height.mas_equalTo(doneHeight);
    }];
    
}

-(void)loadGroupInfo
{
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[NetworkSingletion sharedManager]getGroupInfoByID:@{@"group_id":self.groupID} onSucceed:^(NSDictionary *dict) {
//        NSLog(@"groupinf %@",dict);
        RCDGroupInfo *group;
        if ([dict[@"codel"] integerValue] == 0) {
            NSString *imgUrl = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,[dict[@"data"] objectForKey:@"avatar"]];
            self.oldHashString = [dict[@"data"] objectForKey:@"avatar"];
            group = [[RCDGroupInfo alloc]init];
            group.portraitUri = imgUrl;
            group.groupName = [dict[@"data"] objectForKey:@"name"];
            group.groupId = self.groupID;
            group.introduce = [dict[@"data"] objectForKey:@"notice"];
            group.creatorId = [dict[@"data"] objectForKey:@"manager_uid"];
            if ([userid isEqualToString:group.creatorId]) {
                self.is_manager = YES;
                self.addBtn.hidden = NO;
                self.dissolveBtn.hidden = NO;
                self.quitBtn.hidden  = YES;
            }
        }else{
            group = [[RCDataBaseManager shareInstance] getGroupByGroupId:self.groupID];
            
        }
        [self.GroupPortrait sd_setImageWithURL:[NSURL URLWithString:group.portraitUri] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        if (![NSString isBlankString:group.groupName]) {
            self.GroupName.text = group.groupName;
        }
        if (![NSString isBlankString:group.introduce]) {
            self.GroupMark.text = group.introduce;
        }
        
    } OnError:^(NSString *error) {
        RCDGroupInfo *group = [[RCDataBaseManager shareInstance] getGroupByGroupId:self.groupID];
        [self.GroupPortrait sd_setImageWithURL:[NSURL URLWithString:group.portraitUri] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        if (![NSString isBlankString:group.groupName]) {
            self.GroupName.text = group.groupName;
        }
        if (![NSString isBlankString:group.introduce]) {
            self.GroupMark.text = group.introduce;
        }
    }];
}

#pragma mark IBAction
//解散
-(void)dissolveGroup
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要解散群么？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *dict = @{@"group_id":self.groupID};
        [[NetworkSingletion sharedManager]dissolveGroup:dict onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue]==0) {
                [self.navigationController popViewControllerAnimated:YES];
                [[RCDataBaseManager shareInstance] deleteGroupToDB:self.groupID];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_GROUP_NEW_INFO" object:nil];
            }
        } OnError:^(NSString *error) {
            
        }];
        
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
}

//退出群组
-(void)quiteGroup
{
    NSDictionary *dict = @{@"group_id":self.groupID};
    [[NetworkSingletion sharedManager]quiteGroup:dict onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            [self.navigationController popViewControllerAnimated:YES];
            [[RCDataBaseManager shareInstance] deleteGroupToDB:self.groupID];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_GROUP_NEW_INFO" object:nil];
        }
    } OnError:^(NSString *error) {
        
    }];
}

//查看群成员
-(void)seeGroupMember
{
    RCMShowGroupMemberViewController *memberVC = [[RCMShowGroupMemberViewController alloc]init];
    memberVC.groupID = self.groupID;
    memberVC.is_manager = self.is_manager;
    memberVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:memberVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

//邀请群成员
-(void)addGroupMember
{
    RCMAddGroupMemberViewController *addVC = [[RCMAddGroupMemberViewController alloc]init];
    addVC.delegate = self;
    addVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

//编辑群
-(void)editGroupInfo
{
    if (self.is_manager) {
        self.addBtn.hidden = NO;
        self.dissolveBtn.hidden = NO;
        NSString *title = [self.editBtn titleForState:UIControlStateNormal];
        if ([title isEqualToString:@"编辑"]) {
            [UIView animateWithDuration:0.1 animations:^{
                self.GroupPortrait.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chosePortrait)];
                [self.GroupPortrait addGestureRecognizer:singleClick];
                self.GroupMark.userInteractionEnabled = YES;
                self.GroupName.userInteractionEnabled = YES;
               
            }];
        }else{
            NSString *hashString;
            if (self.is_update_logo) {
                if ([NSString isBlankString:self.neHashString]) {
                    [WFHudView showMsg:@"图片正在上传中.." inView:self.view];
                    return;
                }else{
                    hashString = self.neHashString;
                }
            }else{
                hashString = self.oldHashString;
            }
            NSDictionary *dict = @{@"name":self.GroupName.text,@"notice":self.GroupMark.text,@"avatar":hashString,@"group_id":self.groupID};
            [[NetworkSingletion sharedManager]editGroupInfoByID:dict onSucceed:^(NSDictionary *dict) {
                if ([dict[@"code"] integerValue]==0) {
                    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
                    RCDGroupInfo *groupInfo = [RCDGroupInfo new];
                    groupInfo.portraitUri =  [NSString stringWithFormat:@"%@%@",IMAGE_HOST,hashString];;
                    groupInfo.groupId = self.groupID;
                    groupInfo.groupName = self.GroupName.text;
                    groupInfo.introduce = self.GroupMark.text;
                    groupInfo.creatorId = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
                    [[RCDataBaseManager shareInstance] insertGroupToDB:groupInfo];
                    [MBProgressHUD showSuccess:@"编辑成功" toView:self.view];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_GROUP_NEW_INFO" object:nil];
                }
            } OnError:^(NSString *error) {
                
            }];
            
        }
        
    }
}
#pragma mark RCMAddMemberControllerDelegate

-(void)selectedMember:(NSMutableArray *)memberArray
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor colorWithHexString:@"343637"];
    hud.labelText = @"添加中...";
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES whileExecutingBlock:^{
        for (SWWorkerData *worker in memberArray) {
            [self.groupMemberIdList addObject:worker.uid];
        }
        
        NSDictionary *paramDict = @{@"uids":[NSString dictionaryToJson:self.groupMemberIdList],@"group_id":self.groupID};
        [[NetworkSingletion sharedManager]addGroupMember:paramDict onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue]==0) {
                
                [self.addBtn setTitle:[NSString stringWithFormat:@"邀请成员（已成功邀请%li人）",self.groupMemberIdList.count] forState:UIControlStateNormal];
                [self.groupMemberIdList removeAllObjects];
            }
            
        } OnError:^(NSString *error) {
            
        }];

    } completionBlock:^{
         hud.labelText = @"添加成功";
        [hud hide:YES afterDelay:1];
    }];
    
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
    [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.is_update_logo = YES;
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
    NSData *data;
    UIImage *image;
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
//                NSLog(@"info ===== %@", info);
//                NSLog(@"resp ===== %@", resp);
        
        self.neHashString =[resp objectForKey:@"hash"];
        
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

#pragma mark UITextfield Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
    return YES;
}

#pragma mark UITextView Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
    return YES;
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
