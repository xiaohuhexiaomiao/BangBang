//
//  SalaryView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/21.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SalaryView.h"
#import "CXZ.h"
@interface SalaryModel : NSObject

@property(nonatomic ,copy)NSString  *name;

@property(nonatomic ,copy)NSString  *bank_card;

@property(nonatomic ,copy)NSString  *subtotal;

@property(nonatomic ,copy)NSString *bank_address;

@end

@implementation SalaryModel : NSObject



@end

@interface SalaryView()<UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic ,strong) UITextField *nameTxf;

@property (nonatomic ,strong) UITextField *moneyTxf;

@property (nonatomic ,strong) UITextField *bankAccountTxf;

@property (nonatomic ,strong) UITextField *bankNameTxf;

@property (nonatomic ,strong) UIButton *addContractButton;

@property (nonatomic ,strong) UIScrollView *imgScrollview;

@property (nonatomic ,strong) UIButton *deleteButton;

@property (nonatomic ,strong) NSDictionary *contentDict;


@end

@implementation SalaryView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dataDict = [NSMutableDictionary dictionary];
        
        CGFloat width = frame.size.width;
        NSString *name = @"姓名：";
        CGSize nameSize =[name sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *nameLabel = [self customUILabelWithFrame:CGRectMake(8, 5, nameSize.width, 20) title:name];
        [self addSubview:nameLabel];
        
        _nameTxf = [self customTextFieldWithFrame:CGRectMake(nameLabel.right, nameLabel.top, width/2-nameLabel.right, nameLabel.height)];
        [self addSubview:_nameTxf];
        
        NSString *money = @"工资：";
        CGSize moneySize = [money sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *moneyLabel = [self customUILabelWithFrame:CGRectMake(_nameTxf.right, _nameTxf.top, moneySize.width, _nameTxf.height) title:money];
        [self addSubview:moneyLabel];
        
        _moneyTxf = [self customTextFieldWithFrame:CGRectMake(moneyLabel.right, moneyLabel.top, width- moneyLabel.right-20, moneyLabel.height)];
        [self addSubview:_moneyTxf];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(width-20, 0, 20, 20);
        [_deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteWorker:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        
        NSString *bankName = @"开户行支行：";
        CGSize bankNameSize = [bankName sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *bankNameLabel = [self customUILabelWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, bankNameSize.width, nameLabel.height) title:bankName];
        [self addSubview:bankNameLabel];
        
        _bankNameTxf = [self customTextFieldWithFrame:CGRectMake(bankNameLabel.right, bankNameLabel.top, width-bankNameLabel.right-8, bankNameLabel.height)];
        [self addSubview:_bankNameTxf];
        
        NSString *bankAccount = @"账号：";
        CGSize bankAccountSize = [bankAccount sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *bankAccountLabel = [self customUILabelWithFrame:CGRectMake(bankNameLabel.left, bankNameLabel.bottom, bankAccountSize.width, bankNameLabel.height) title:bankAccount];
        [self addSubview:bankAccountLabel];
        
        _bankAccountTxf = [self customTextFieldWithFrame:CGRectMake(bankAccountLabel.right, bankAccountLabel.top, SCREEN_WIDTH-bankAccountLabel.right-8, bankAccountLabel.height)];
        [self addSubview:_bankAccountTxf];
        
        _addContractButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addContractButton.frame = CGRectMake(bankAccountLabel.left, bankAccountLabel.bottom, width-16, 30);
        [_addContractButton setTitle:@"＋添加合同附件" forState:UIControlStateNormal];
        [_addContractButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addContractButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_addContractButton addTarget:self action:@selector(addContractEnnex:) forControlEvents:UIControlEventTouchUpInside];
        _addContractButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:_addContractButton];
        
        _imgScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(bankAccountLabel.left, bankAccountLabel.bottom, width-8, 30)];
        _imgScrollview.showsVerticalScrollIndicator = NO;
        _imgScrollview.showsHorizontalScrollIndicator = YES;
        _imgScrollview.hidden = YES;
//        _imgScrollview.delegate = self;
        [self addSubview:_imgScrollview];
        
        
        UIView *line = [self customLineViewWithFrame:CGRectMake(8, frame.size.height-1, frame.size.width-16, 1)];
        [self addSubview:line];
        
    }
    return self;
}

-(void)setSalaryViewWith:(NSMutableArray*)imgArray
{
    [self uploadPhotoWithImage:imgArray];
    self.addContractButton.hidden = YES;
    self.imgScrollview.hidden = NO;
    [_imgScrollview removeAllSubviews];
    for (int i = 0; i < imgArray.count; i++) {
        UIImageView *imgview = [[UIImageView alloc]init];
        imgview.image = imgArray[i];
        imgview.tag = i;
        imgview.contentMode = UIViewContentModeScaleAspectFill;
        imgview.layer.masksToBounds = YES;
        [_imgScrollview addSubview:imgview];
        imgview.frame = CGRectMake(30*i, 0, 30, 30);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotos:)];
        imgview.userInteractionEnabled = YES;
        [imgview addGestureRecognizer:tap];
        
    }
    
    _imgScrollview.contentSize = CGSizeMake(30*imgArray.count, 30);
    
}

-(void)setSalaryViewWithName:(NSDictionary *)dict type:(NSInteger)type
{
    self.imgScrollview.hidden = YES;
    self.addContractButton.hidden = NO;
    NSString *title = [NSString stringWithFormat:@"合同附件：%@",dict[@"title"]];
    [self.addContractButton setTitle:title forState:UIControlStateNormal];
    if (type == 1) {
        [self.dataDict setObject:dict[@"contract_id"] forKey:@"contract_id"];
    }else{
        [self.dataDict setObject:dict[@"contract_company_id"] forKey:@"contract_id"];
    }
    
    [self.dataDict setObject:@(type) forKey:@"type"];
    
}

-(void)showSalaryViewWithDict:(NSDictionary*)dict
{
    self.nameTxf.userInteractionEnabled = NO;
    self.moneyTxf.userInteractionEnabled = NO;
    self.bankNameTxf.userInteractionEnabled = NO;
    self.bankAccountTxf.userInteractionEnabled = NO;
    self.deleteButton.hidden = YES;
    SalaryModel *salaryModel = [SalaryModel objectWithKeyValues:dict];
    self.nameTxf.text = salaryModel.name;
    self.moneyTxf.text = salaryModel.subtotal;
    self.bankNameTxf.text = salaryModel.bank_address;
    self.bankAccountTxf.text = salaryModel.bank_card;
    [self.addContractButton setTitle:@"点击查看合同附件" forState:UIControlStateNormal];
}

-(void)showCopySalaryViewWithDict:(NSDictionary*)dict
{
    SalaryModel *salaryModel = [SalaryModel objectWithKeyValues:dict];
    self.nameTxf.text = salaryModel.name;
    self.moneyTxf.text = salaryModel.subtotal;
    self.bankNameTxf.text = salaryModel.bank_address;
    self.bankAccountTxf.text = salaryModel.bank_card;
    self.imgScrollview.hidden = NO;
    self.addContractButton.hidden = YES;
    if ([dict[@"type"] integerValue]==3) {
        [[NetworkSingletion sharedManager]getReviewAnnexDetail:@{@"enclosure_id":dict[@"contract_id"]} onSucceed:^(NSDictionary *dict) {
            
            if ([dict[@"code"] integerValue]==0) {
                NSArray *imageArray = [dict[@"data"] objectForKey:@"picture"];
                [_imgScrollview removeAllSubviews];
                for (int i = 0; i < imageArray.count; i++) {
                    NSString *pic = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,imageArray[i]];
                    UIImageView *imgview = [[UIImageView alloc]init];
                    [imgview sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:nil];
                    imgview.tag = i;
                    imgview.contentMode = UIViewContentModeScaleAspectFill;
                    imgview.layer.masksToBounds = YES;
                    [_imgScrollview addSubview:imgview];
                    imgview.frame = CGRectMake(30*i, 0, 30, 30);
                }
                
                _imgScrollview.contentSize = CGSizeMake(30*imageArray.count, 30);
            }
        } OnError:^(NSString *error) {
            
        }];
    }
    self.contentDict = @{@"name":self.nameTxf.text,@"subtotal":self.moneyTxf.text,@"bank_address":self.bankNameTxf.text,@"bank_card":self.bankAccountTxf.text};
    [self.dataDict addEntriesFromDictionary:self.contentDict];
    [self.dataDict setObject:dict[@"contract_id"] forKey:@"contract_id"];
    [self.dataDict setObject:@"3" forKey:@"type"];
}

//点击图片
-(void)addPhotos:(UITapGestureRecognizer*)tap
{
  
    UIImageView *imgView = (UIImageView*)tap.view;
    UIImage *tempImg = [UIImage imageNamed:@"上传照片.jpg"];
    NSData *tempData = UIImagePNGRepresentation(tempImg);
    NSData *data = UIImagePNGRepresentation(imgView.image);
    if ( [data isEqualToData:tempData]) {
         [self.delegate addPhoto:self.tag];
    }else{
        
    }
}

//删除工资表
-(void)deleteWorker:(UIButton*)button
{
    [self.delegate clickDeleteWorkerWithTag:self.tag];
}

//添加合同附件
-(void)addContractEnnex:(UIButton*)button
{
    NSString *title = [self.addContractButton titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"点击查看合同附件"]) {
       
        [self.delegate checkContract:self.tag];
    }else{
        if ([NSString isBlankString:self.nameTxf.text]) {
            [WFHudView showMsg:@"请输入姓名" inView:self ];
            return;
        }
        if ([NSString isBlankString:self.moneyTxf.text]) {
            [WFHudView showMsg:@"请输入工资金额" inView:self ];
            return;
        }
       
        self.contentDict = @{@"name":self.nameTxf.text,@"subtotal":self.moneyTxf.text,@"bank_address":self.bankNameTxf.text,@"bank_card":self.bankAccountTxf.text};
        [self.dataDict addEntriesFromDictionary:self.contentDict];
        [self.delegate clickAddWorkerContract:self.tag];
    }
    
}

-(void)uploadPhotoWithImage:(NSMutableArray*)imageArray
{
    NSMutableArray *tokenArray = [NSMutableArray array];
    [SVProgressHUD show];
    dispatch_group_t _group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue=dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    
    for (int i = 0; i <(imageArray.count-1); i++) {
        
        dispatch_group_async(_group, queue, ^{
            
            [[NetworkSingletion sharedManager]getQiNiuToken:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} onSucceed:^(NSDictionary *dict) {
                if ([dict[@"code"] integerValue]==0) {
                    NSString *imageToken = [dict objectForKey:@"data"];
                    [tokenArray addObject:imageToken];
                    
                }else{
                    [SVProgressHUD dismiss];
                    [WFHudView showMsg:dict[@"message"] inView:self];
                    
                }
                dispatch_semaphore_signal(semaphore);// +1
                
            } OnError:^(NSString *error) {
                [SVProgressHUD dismiss];
                [WFHudView showMsg:error inView:self];
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // -1
            
        });
    }
    dispatch_group_notify(_group, queue, ^{
        //所有请求返回数据后执行
        [self uploadImageToQNFilePath:imageArray token:tokenArray];
    });
    
}
#pragma mark 七牛相关
- (void)uploadImageToQNFilePath:(NSArray *)imageArray token:(NSArray*)imageTokenArray{
    
    NSMutableArray *hashArray = [NSMutableArray array];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue=dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < (imageArray.count-1); i++) {
        
        NSString *filePath = [self getImagePath:imageArray[i] index:i];
        //                NSLog(@"percent ==%@", filePath);
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
    
    dispatch_group_notify(group, queue, ^{
        //所有请求返回数据后执行
        NSString *hashStr = [NSString dictionaryToJson:hashArray];
        [[NetworkSingletion sharedManager]updateReviewAnnexNew:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"picture":hashStr} onSucceed:^(NSDictionary *dict) {
            [SVProgressHUD dismiss];
            if ([dict[@"code"] integerValue]==0) {
                NSString *ennex = [dict[@"data"] objectForKey:@"enclosure_id"];
                [self.dataDict setObject:ennex forKey:@"contract_id"];
                [self.dataDict setObject:@"3" forKey:@"type"];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self];
            }
        } OnError:^(NSString *error) {
            [SVProgressHUD dismiss];
        }];
        
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
#pragma mark 自定义控件

-(UITextField*)customTextFieldWithFrame:(CGRect)frame
{
    UITextField *textfield = [[UITextField alloc]initWithFrame:frame];
    textfield.delegate = self;
    textfield.font = [UIFont systemFontOfSize:12];
    textfield.returnKeyType = UIReturnKeyDone;
    textfield.textColor = FORMTITLECOLOR;
    return textfield;
}

-(UILabel*)customUILabelWithFrame:(CGRect)frame title:(NSString*)title
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = FORMLABELTITLECOLOR;
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    return label;
}

-(UIView*)customLineViewWithFrame:(CGRect)frame
{
    UIView *line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = UIColorFromRGB(224, 223, 226);
    return line;
}

#pragma mark UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UITextview Delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
