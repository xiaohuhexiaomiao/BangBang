//
//  SWCompleteInfoController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWCompleteInfoController.h"

#import "CXZ.h"

#import "WorkerTypeViewController.h"

#import "WokerTypeModel.h"

#import "SWFindWorkerUtils.h"

#import "SWUploadCmd.h"

#import "SWUserData.h"


#define padding 10

@interface SWCompleteInfoController ()<DDChoosePhotoDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,WorkerTypeControllerDelegate>
{
    UIScrollView *scrollView;
    UIView *dateBackgroundView;
    UIPickerView *personalDataPickerView;
    
    NSDictionary *dataDict;
    NSArray *provinceArray;
    NSArray *typeArray;
    NSArray *yearArray;
    NSInteger TapSection;
    NSInteger selectedRow;
}
@property (nonatomic, retain) UIView *IDCardView;

@property (nonatomic, retain) UIImageView *chooseBtn; //选择图片Btn

@property (nonatomic, assign) BOOL isIDSelect; //是不是身份证上传

@property (nonatomic, retain) UIImageView *selectIDCard;

@property (nonatomic, retain) NSString *iconName;

@property (nonatomic, retain) NSString *IconPath; //头像路径

@property (nonatomic, retain) NSString *frontPath; //正面身份证路径

@property (nonatomic, retain) NSString *backPath; //反面身份证路径

@property (nonatomic, retain) UIScrollView *contentView;

@property (nonatomic, assign) CGFloat replyViewDraw;

@property (nonatomic, assign) CGPoint origpoint;

@property (nonatomic, assign) BOOL isShow; //判断键盘是不是显示

@property (nonatomic, retain) UITextField *nameField;

@property (nonatomic, retain) UITextField *IDCardField;

@property (nonatomic, retain) UITextField *QQField;

@property (nonatomic, retain) UITextField *WeChatField;

@property (nonatomic, retain) UITextField *alipayField;

@property (nonatomic, retain) UITextField *BankField;

@property (nonatomic, retain) UITextField *bankNameField;

@property (nonatomic, retain) UITextField *bankAddressField;

@property (nonatomic, retain) UITextField *addressField;

@property (nonatomic, retain) UITextField *salaryField;

@property (nonatomic, strong) UITextField *workerTypeField;

@property (nonatomic, strong) UITextField *yearTxtfld;

@property (nonatomic, strong) UITextField *provinceTxtfld;

@property (nonatomic, retain) UITextView *selfEvaluateView;

@property (nonatomic, strong) UIView *workTypeView;

@property (nonatomic, strong) UIView *provinceView;

@property (nonatomic, strong) UIView *yearView;

@property (nonatomic, copy) NSString *workerTypeID;

@end

@implementation SWCompleteInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupBackw];
    provinceArray = @[@"北京市",@"天津市",@"上海市",@"重庆市",@"黑龙江省",@"吉林省",@"辽宁省",@"江苏省",@"山东省",@"安徽省",@"河北省",@"河南省",@"湖北省",@"湖南省",@"江西省",@"陕西省",@"山西省",@"四川省",@"青海省",@"海南省",@"广东省",@"贵州省",@"浙江省",@"福建省",@"甘肃省",@"云南省",@"内蒙古自治区",@"宁夏回族自治区",@"新疆维吾尔自治区",@"西藏自治区",@"广西壮族自治区",@"台湾",@"香港",@"澳门"];
    yearArray = @[@"1年",@"2年",@"3年",@"4年",@"5年",@"6年",@"7年",@"8年",@"9年",@"10年",@"10年以上"];
    
    [self reloadData];
  
    [self setupTitleWithString:@"编辑个人资料" withColor:[UIColor whiteColor]];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyHidden) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyShow) name:UIKeyboardWillShowNotification object:nil];
    
}



- (void)reloadData
{
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    [[NetworkSingletion sharedManager]getInfoDetailList:@{@"phone":phone} onSucceed:^(NSDictionary *dict) {
//                        NSLog(@"***%@*≥***%@",dict,dict[@"name"]);
      
        if ([dict[@"code"] integerValue]==0) {
            dataDict = dict[@"data"];
            self.IconPath = dataDict[@"avatar"];
            self.backPath = dataDict[@"trp_pic"];
            self.frontPath = dataDict[@"idcard_p"];
            self.selfEvaluateView.text = dataDict[@"self_evaluation"];
            dataDict = dict[@"data"];
            
        }
        [self initWithView];
    } OnError:^(NSString *error) {
       
    }];
}

- (void)onNext
{
    [SWFindWorkerUtils jumpMain];
}
- (void)keyShow {
    
    _isShow = YES;
    
}

- (void)keyHidden {
    
    _isShow = NO;
    
}

- (void)showKeyboard:(NSNotification *)notif {
    
    if(_isShow) {
        
        NSDictionary *dic = notif.userInfo;
        CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
        
        if(keyboardRect.size.height > 250) {
            
            
        }
        
    }
}


//初始化界面
- (void)initWithView {
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.frame         = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:scrollView];
    _contentView = scrollView;
    
    CGFloat maxY = [self createIconView];

    NSArray *dataArr;
    
    NSArray *titleArr = @[@"*真实姓名",@"*身份证",@"*期望薪资",@"*工种",@"*籍贯",@"*工龄",@"QQ",@"微信",@"支付宝",@"银行卡",@"开户银行",@"开户银行地址",@"暂住地址"];
    NSArray *placeArr = @[@"请输入真实姓名",@"请输入身份证号",@"例如：300元/天",@"请选择工种",@"请选择籍贯",@"请选择工龄",@"请填写QQ号",@"请填写微信",@"请填写支付宝账号",@"请填写您常用的银行卡",@"请填写开户银行",@"请填写开户银行地址",@"请填写您最近住的地方"];
    if (dataDict) {
        NSArray *array = dataDict[@"work_type"];
        static NSString *work_type;
        if (array.count > 0) {
            work_type = array[0];
        }else{
            work_type = @"";
        }
        dataArr = @[dataDict[@"name"],dataDict[@"idcard"],dataDict[@"salary"],work_type,dataDict[@"hometown"],dataDict[@"work_years"],dataDict[@"qq"],dataDict[@"wechat"],dataDict[@"clipay"],dataDict[@"bank_card"],dataDict[@"bank_name"],dataDict[@"bank_address"],dataDict[@"address"]];
    }
    
    CGFloat maxHeight = 0;
    
    for (int i = 0; i < titleArr.count; i++) {
        
        CGFloat viewH = 50;
        CGFloat viewX = 0;
        CGFloat viewY = i * 50  + maxY;
        CGFloat viewW = SCREEN_WIDTH;
        UIView *inputView = [self setUpInputView:CGRectMake(viewX, viewY, viewW, viewH) title:titleArr[i] placeholder:placeArr[i] content:dataArr[i]];
        
        maxHeight = CGRectGetMaxY(inputView.frame);
    }
    
    
    CGFloat nextY = 0;
    
    maxHeight = [self creatmyIntroduce:maxHeight];
    
    [self pickPhotoByIDCardView:maxHeight];
    nextY = CGRectGetMaxY(_IDCardView.frame) + 6 * padding;
    
    CGFloat nextX = 40;
    
    CGFloat nextW = SCREEN_WIDTH - 2 * nextX;
    CGFloat nextH = 40;
    
    UIButton *nextBtn = [[UIButton alloc] init];
    nextBtn.frame     = CGRectMake(nextX, nextY, nextW, nextH);
    nextBtn.layer.cornerRadius = 5;
    nextBtn.layer.masksToBounds = YES;
    nextBtn.backgroundColor = [UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1.00];
    [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_contentView addSubview:nextBtn];
    
    _contentView.contentSize = CGSizeMake(0, CGRectGetMaxY(nextBtn.frame) + padding);
    
}



/**
 创建个人评价view
 
 @return 高度
 */
- (CGFloat)creatmyIntroduce:(CGFloat)y {
    
    CGFloat height = 0;
    
    UIView *introduceView = [[UIView alloc] init];
    introduceView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:introduceView];
    
    NSString *title = @"个人评价";
    
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *introduceLbl = [[UILabel alloc] init];
    introduceLbl.frame    = CGRectMake(padding, padding, titleSize.width, titleSize.height);
    introduceLbl.text = title;
    introduceLbl.textColor = [UIColor blackColor];
    introduceLbl.font = [UIFont systemFontOfSize:12];
    [introduceView addSubview:introduceLbl];
    
    UITextView *introduceInputView = [[UITextView alloc] init];
    introduceInputView.frame       = CGRectMake(padding, CGRectGetMaxY(introduceLbl.frame) + padding, SCREEN_WIDTH - 2 * padding, 100);
    introduceInputView.delegate    = self;
    introduceInputView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    [introduceView addSubview:introduceInputView];
    
    if (![NSString isBlankString:dataDict[@"self_evaluation"]] ) {
                introduceInputView.text = dataDict[@"self_evaluation"];
    }
    _selfEvaluateView = introduceInputView;
    
    introduceView.frame = CGRectMake(0, y, SCREEN_WIDTH, introduceInputView.frame.size.height + introduceLbl.frame.size.height + padding);
    
    height = CGRectGetMaxY(introduceView.frame);
    
    return height;
    
}

- (CGFloat)createIconView {
    
    CGFloat rowHeight = 0;
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    inputView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:inputView];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont systemFontOfSize:12];
    titleLbl.textColor = [UIColor colorWithRed:0.31 green:0.32 blue:0.32 alpha:1.00];
    titleLbl.text = @"*上传头像";
    [titleLbl sizeToFit];
    titleLbl.frame = CGRectMake(padding, (49 - titleLbl.bounds.size.height) / 2, titleLbl.bounds.size.width, titleLbl.bounds.size.height);
    [inputView addSubview:titleLbl];
    
    UIImageView *iconBtn = [[UIImageView alloc] init];
    NSURL *urlStr = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,dataDict[@"avatar"]]];
    [iconBtn sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"header_icon"]];
    
    //    [iconBtn sizeToFit];
    
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    CGFloat iconX = SCREEN_WIDTH - padding - iconW;
    CGFloat iconY = (49 - iconH) / 2;
    iconBtn.frame = CGRectMake(iconX , iconY, iconW, iconH);
    iconBtn.layer.cornerRadius = iconBtn.frame.size.height / 2;
    iconBtn.layer.masksToBounds = YES;
    //    [iconBtn addTarget:self action:@selector(selectIconClick:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectIconClick:)];
    iconBtn.userInteractionEnabled = YES;
    [iconBtn addGestureRecognizer:tap];
    [inputView addSubview:iconBtn];
    _chooseBtn = iconBtn;
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, CGRectGetMaxY(titleLbl.frame) + (49 - titleLbl.bounds.size.height) / 2, SCREEN_WIDTH, 1);
    line.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [inputView addSubview:line];
    
    rowHeight = CGRectGetMaxY(line.frame);
    
    return rowHeight;
    
}

//选择头像
- (void)selectIconClick:(UIButton *)sender {
    
    _isIDSelect = NO;
    
    //用户头像
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传图片"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    //判断相机是否可用
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册中选择"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          //从相册里选择
                                                          [self imagePickerOrTake:UIImagePickerControllerSourceTypePhotoLibrary];
                                                          
                                                      }];
        [alert addAction:photo];
        
        UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              //从相册里选择
                                                              [self imagePickerOrTake:UIImagePickerControllerSourceTypeCamera];
                                                          }];
        [alert addAction:takePhoto];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action) {
                                                           
                                                       }];
        [alert addAction:cancel];
        
    }else {
        
        UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册中选择"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [self imagePickerOrTake:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                                                      }];
        [alert addAction:photo];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action) {
                                                           
                                                       }];
        [alert addAction:cancel];
        
    }
    
    
    
    [self presentViewController:alert animated:true completion:nil];
    
}

//拍照或者选择相册
- (void)imagePickerOrTake:(UIImagePickerControllerSourceType)source {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = source;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info{
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* image2 = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *image = [self imageCompressForWidth:image2 targetWidth:SCREEN_WIDTH];
    
    if(!_isIDSelect) {
        
        _iconName = @"avatar";
        [_chooseBtn setImage:image];
//        [_chooseBtn setImage:image forState:UIControlStateNormal];
        
    }else {
        
        _selectIDCard.image = image;
        
        if(_selectIDCard.tag == 1) {
            
            _iconName = @"idcard_p";
            
        }else {
            
            _iconName = @"trp_pic";
            
        }
        
        for (UIView *view in _selectIDCard.subviews) {
            
            view.hidden = YES;
            
        }
        
    }
    [[NetworkSingletion sharedManager]getQiNiuToken:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            NSString *imageToken = [dict objectForKey:@"data"];
            [self uploadImageToQNFilePath:image token:imageToken name:_iconName];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
        
    } OnError:^(NSString *error) {
       
        [MBProgressHUD showError:error toView:self.view];
    }];
    
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


//指定宽度按比例缩放
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}



- (void)nextClick:(UIButton *)sender {
   
    if(IS_EMPTY(self.IconPath)) {
        
        [MBProgressHUD showError:@"请上传头像" toView:self.view];
        return;
    }
    if ([NSString isBlankString:self.frontPath]) {
        self.frontPath = @"";
    }
    if ([NSString isBlankString:self.backPath]) {
        self.backPath = @"";
    }
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];

    [parameter setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] forKey:@"uid"];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_token"];
    [parameter setValue:token forKey:@"app_token"];
    
    //角色
    NSString *roles = [[NSUserDefaults standardUserDefaults] objectForKey:@"roles"];
    //雇主完善信息
    if(![CXZStringUtil validateIdentityCard:_IDCardField.text]){
        [MBProgressHUD showError:@"请输入正确的身份证号" toView:self.view];
        [_IDCardField becomeFirstResponder];
        return;
    }
    if([NSString isBlankString:self.nameField.text]){
        [MBProgressHUD showError:@"请输入真实姓名" toView:self.view];
        return;
    }
    if([NSString isBlankString:self.salaryField.text]){
        [MBProgressHUD showError:@"请输入期望薪资" toView:self.view];
        return;
    }
    if([NSString isBlankString:self.workerTypeField.text]){
        [MBProgressHUD showError:@"请选择工种" toView:self.view];
        return;
    }
    if([NSString isBlankString:self.provinceTxtfld.text]){
        [MBProgressHUD showError:@"请选择籍贯" toView:self.view];
        return;
    }
    
    if([NSString isBlankString:self.WeChatField.text]&& [NSString isBlankString:self.alipayField.text] &&[NSString isBlankString:self.BankField.text]){
        [MBProgressHUD showError:@"请输入微信、支付宝、银行卡号其中任意一个" toView:self.view];
        return;
    }
    
    [parameter setValue:_nameField.text forKey:@"name"];
    [parameter setValue:_IDCardField.text forKey:@"idcard"];
    [parameter setValue:_QQField.text forKey:@"qq"];
    [parameter setValue:_WeChatField.text forKey:@"wechat"];
    [parameter setValue:_alipayField.text forKey:@"clipay"];
    [parameter setValue:_BankField.text forKey:@"bank_card"];
    [parameter setValue:_addressField.text forKey:@"address"];
    [parameter setValue:_salaryField.text forKey:@"salary"];
    [parameter setValue:_selfEvaluateView.text forKey:@"self_evaluation"];
    [parameter setValue:_bankNameField.text forKey:@"bank_name"];
    [parameter setValue:_bankAddressField.text forKey:@"bank_address"];
    [parameter setValue:_provinceTxtfld.text forKey:@"hometown"];
    [parameter setValue:_yearTxtfld.text forKey:@"work_years"];
    [parameter setValue:self.workerTypeID forKey:@"work_type"];
    [parameter setValue:self.IconPath forKey:@"avatar"];
    [parameter setValue:self.frontPath forKey:@"idcard_p"];
    [parameter setValue:self.backPath forKey:@"idcard_n"];
    sender.userInteractionEnabled = NO;
    [sender setTitle:@"上传中..." forState:UIControlStateNormal];
    
    [[NetworkSingletion sharedManager]updateMyInfo:parameter onSucceed:^(NSDictionary *dict) {
//        NSLog(@"****%@",dict);
        if([dict[@"code"]integerValue]==0){
            [[NSUserDefaults standardUserDefaults] setObject:self.IconPath forKey:@"avatar"];
            [[NSUserDefaults standardUserDefaults] setObject:_nameField.text forKey:@"realname"];
            //角色
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
            
        }
        sender.userInteractionEnabled = YES;
        [sender setTitle:@"提交" forState:UIControlStateNormal];
    } OnError:^(NSString *error) {
         [MBProgressHUD showError:error toView:self.view];
        sender.userInteractionEnabled = YES;
        [sender setTitle:@"提交" forState:UIControlStateNormal];
    }];
    
    
}


//添加身份证的view
- (void)pickPhotoByIDCardView:(CGFloat)maxHeight {
    
    UIView *IDCardView = [[UIView alloc] init];
    IDCardView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:IDCardView];
    
    NSString *plusStr = @"身份证正面照";
    
    CGSize plusSize = [plusStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    CGFloat plusX = padding;
    CGFloat plusY = padding;
    CGFloat plusW = plusSize.width;
    CGFloat plusH = plusSize.height;
    
    UILabel *plusLbl = [[UILabel alloc] init];
    plusLbl.frame    = CGRectMake(plusX, plusY, plusW, plusH);
    plusLbl.font = [UIFont systemFontOfSize:12];
    plusLbl.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.35 alpha:1.00];
    plusLbl.text = plusStr;
    [IDCardView addSubview:plusLbl];
    
    NSString *frontStr = @"暂住证照片";
    
    CGSize frontSize = [frontStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    CGFloat frontX = (SCREEN_WIDTH - 3 * padding) / 2 + 2 * padding;
    CGFloat frontY = plusY;
    CGFloat frontW = frontSize.width;
    CGFloat frontH = frontSize.height;
    
    UILabel *frontLbl = [[UILabel alloc] init];
    frontLbl.frame    = CGRectMake(frontX, frontY, frontW, frontH);
    frontLbl.font     = [UIFont systemFontOfSize:12];
    frontLbl.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.35 alpha:1.00];
    frontLbl.text = frontStr;
    [IDCardView addSubview:frontLbl];
    
    CGRect frontFrame = CGRectMake(padding, CGRectGetMaxY(plusLbl.frame) + padding, (SCREEN_WIDTH - 3 * padding) / 2, 80);
    
    static NSString *frontUrlStr ;
    static NSString *temporaryUrlStr ;
    if (dataDict) {
        frontUrlStr = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,dataDict[@"idcard_p"]];
        temporaryUrlStr = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,dataDict[@"trp_pic"]];
    }
    UIView *frontView = [self createIDView:@"IDCard_front" title:@"上传身份证正面照" frame:frontFrame parentView:IDCardView tag:1 placeHoder:frontUrlStr];
    
    CGRect beyondFrame = CGRectMake(frontX, CGRectGetMaxY(plusLbl.frame) + padding, (SCREEN_WIDTH - 3 * padding) / 2, 80);
    
    UIView *beyondView = [self createIDView:@"IDCard_beyond" title:@"上传暂住证照" frame:beyondFrame parentView:IDCardView tag:2  placeHoder:temporaryUrlStr];
    
    IDCardView.frame = CGRectMake(0, maxHeight, SCREEN_WIDTH, CGRectGetMaxY(beyondView.frame) + padding);
    
    _IDCardView = IDCardView;
    
}

//创建身份证View
- (UIView *)createIDView:(NSString *)imageName title:(NSString *)title frame:(CGRect)frame parentView:(UIView *)parentView tag:(NSInteger)tag placeHoder:(NSString*)placeHoder
{
    
    UIImageView *IDView = [[UIImageView alloc] init];
    IDView.backgroundColor = [UIColor colorWithRed:0.87 green:0.89 blue:0.91 alpha:1.00];
    IDView.layer.cornerRadius = 5;
    IDView.tag = tag;
    IDView.layer.masksToBounds = YES;
    IDView.frame   = frame;
    IDView.userInteractionEnabled = YES;
    [parentView addSubview:IDView];
    
    UITapGestureRecognizer *selectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)];
    [IDView addGestureRecognizer:selectGesture];
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    CGFloat imageX = (frame.size.width - imageW) / 2;
    CGFloat imageY = frame.size.height / 4;
    
    UIImageView *IDImageView = [[UIImageView alloc] init];
    IDImageView.frame        = CGRectMake(imageX, imageY, imageW, imageH);
    [IDImageView sd_setImageWithURL:[NSURL URLWithString:placeHoder] placeholderImage:image];
    [IDView addSubview:IDImageView];
    
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:10] width:SCREEN_WIDTH];
    
    CGFloat titleW = titleSize.width;
    CGFloat titleH = titleSize.height;
    CGFloat titleX = (frame.size.width - titleW) / 2;
    CGFloat titleY = CGRectGetMaxY(IDImageView.frame) + padding;
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.frame    = CGRectMake(titleX, titleY, titleW, titleH);
    titleLbl.font     = [UIFont systemFontOfSize:10];
    titleLbl.text     = title;
    titleLbl.textColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.58 alpha:1.00];
    [IDView addSubview:titleLbl];
    
    return IDView;
    
}

- (void)selectImage:(UITapGestureRecognizer *)tapGesture {
    
    _isIDSelect = YES;
    
    _selectIDCard = (UIImageView *)tapGesture.view;
    
    //用户头像
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传图片"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    //判断相机是否可用
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册中选择"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          //从相册里选择
                                                          [self imagePickerOrTake:UIImagePickerControllerSourceTypePhotoLibrary];
                                                          
                                                      }];
        [alert addAction:photo];
        
        UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              //从相册里选择
                                                              [self imagePickerOrTake:UIImagePickerControllerSourceTypeCamera];
                                                          }];
        [alert addAction:takePhoto];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action) {
                                                           
                                                       }];
        [alert addAction:cancel];
        
    }else {
        
        UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册中选择"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [self imagePickerOrTake:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                                                      }];
        [alert addAction:photo];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action) {
                                                           
                                                       }];
        [alert addAction:cancel];
        
    }
    
    
    
    [self presentViewController:alert animated:true completion:nil];
    
}

//设置输入界面
- (UIView *)setUpInputView:(CGRect)frame title:(NSString *)title placeholder:(NSString *)placeholder content:(NSString*)contentStr{
    
    UIView *inputView = [[UIView alloc] initWithFrame:frame];
    inputView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:inputView];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont systemFontOfSize:12];
    titleLbl.textColor = [UIColor colorWithRed:0.31 green:0.32 blue:0.32 alpha:1.00];
    titleLbl.text = title;
    [titleLbl sizeToFit];
    titleLbl.frame = CGRectMake(padding, (49 - titleLbl.bounds.size.height) / 2, titleLbl.bounds.size.width, titleLbl.bounds.size.height);
    [inputView addSubview:titleLbl];
    
    UITextField *inputField = [[UITextField alloc] init];
    inputField.placeholder = placeholder;
    inputField.returnKeyType = UIReturnKeyDone;
    if (![NSString isBlankString:contentStr] ) {
        inputField.text = contentStr;
    }
    inputField.frame = CGRectMake(CGRectGetMaxX(titleLbl.frame) + padding, titleLbl.frame.origin.y + 2, SCREEN_WIDTH - CGRectGetMaxX(titleLbl.frame) - 2 * padding, 14);
    inputField.textAlignment = NSTextAlignmentRight;
    inputField.delegate = self;
    inputField.font = [UIFont systemFontOfSize:13];
    [inputView addSubview:inputField];
    
    if([title isEqualToString:@"*真实姓名"]) {
        
        _nameField = inputField;
        
    }else if([title isEqualToString:@"*身份证"]) {
        
        _IDCardField = inputField;
        
    }else if([title isEqualToString:@"*期望薪资"]) {
        
        //        inputField.keyboardType = UIKeyboardTypeNumberPad;
        _salaryField = inputField;
        
        
    }
    else if([title isEqualToString:@"*工种"]) {
        _workerTypeField = inputField;
        _workerTypeField.userInteractionEnabled = NO;
        _workTypeView = [[UIView alloc]initWithFrame:_workerTypeField.frame];
        _workTypeView.userInteractionEnabled = YES;
        [inputView addSubview:_workTypeView];
        [inputView bringSubviewToFront:_workTypeView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPickView:)];
        _workTypeView.tag = 1;
        [_workTypeView addGestureRecognizer:tap];
        
    }
    else if([title isEqualToString:@"*籍贯"]) {
        _provinceTxtfld = inputField;
        _provinceTxtfld.userInteractionEnabled = NO;
        _provinceView = [[UIView alloc]initWithFrame:_provinceTxtfld.frame];
        //        _provinceView.userInteractionEnabled = YES;
        [inputView addSubview:_provinceView];
        [inputView bringSubviewToFront:_provinceView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPickView:)];
        _provinceView.tag = 2;
        [_provinceView addGestureRecognizer:tap];
        
    }else if([title isEqualToString:@"*工龄"]) {
        _yearTxtfld = inputField;
        _yearTxtfld.userInteractionEnabled = NO;
        _yearView = [[UIView alloc]initWithFrame:_yearTxtfld.frame];

        [inputView addSubview:_yearView];
        [inputView bringSubviewToFront:_yearView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPickView:)];
        _yearView.tag = 3;
        [_yearView addGestureRecognizer:tap];
        
    }else if([title isEqualToString:@"QQ"]) {
        
        inputField.keyboardType = UIKeyboardTypeNumberPad;
        _QQField = inputField;
        
    }else if([title isEqualToString:@"微信"]) {
        
        _WeChatField = inputField;
        
    }else if([title isEqualToString:@"支付宝"]) {
        
        _alipayField = inputField;
        
    }else if([title isEqualToString:@"银行卡"]) {
        
        inputField.keyboardType = UIKeyboardTypeNumberPad;
        _BankField = inputField;
        
    }else if([title isEqualToString:@"开户银行"]) {
        
        _bankNameField = inputField;
        
    }else if([title isEqualToString:@"开户银行地址"]) {
        
        _bankAddressField = inputField;
        
    }else if([title isEqualToString:@"暂住地址"]) {
        
        _addressField = inputField;
        
    }
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, CGRectGetMaxY(titleLbl.frame) + (49 - titleLbl.bounds.size.height) / 2, SCREEN_WIDTH, 1);
    line.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [inputView addSubview:line];
    
    return inputView;
    
}
-(void)showPickView:(UITapGestureRecognizer*)tap
{
    [self.provinceTxtfld resignFirstResponder];
    [self.workerTypeField resignFirstResponder];
    [self.yearTxtfld resignFirstResponder];
    [self.salaryField resignFirstResponder];
    TapSection = tap.view.tag;
    if (TapSection == 1) {
        WorkerTypeViewController *wokerVC = [[WorkerTypeViewController alloc]init];
        wokerVC.delegate = self;
        wokerVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wokerVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else{
        [self initWithPickView];
        if(TapSection == 2){
            [personalDataPickerView reloadAllComponents];
        }else{
            [personalDataPickerView reloadAllComponents];
        }
        selectedRow = 0;
        [personalDataPickerView selectRow:0 inComponent:0 animated:YES];
        [UIView animateWithDuration:0.1 animations:^{
            dateBackgroundView.top = SCREEN_HEIGHT- dateBackgroundView.height;
        }];
    }
    
    
}

-(void)selectedWorkerType:(WokerTypeModel *)wokerTypeModle
{
    self.workerTypeField.text = wokerTypeModle.type_name;
    self.workerTypeID = wokerTypeModle.wid;
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
        NSString *hash = [resp objectForKey:@"hash"];
        if([fileName isEqualToString:@"avatar"]){
            
            _IconPath = hash;
            
        }else if([fileName isEqualToString:@"idcard_p"]){
            
            _frontPath = hash;
            
        }else if([fileName isEqualToString:@"trp_pic"]){
            
            _backPath = hash;
            
        }
        
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


#pragma mark PickView


-(void)initWithPickView
{
    if (!dateBackgroundView) {
        dateBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, self.view.frame.size.width, 300)];
        dateBackgroundView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:dateBackgroundView];
        dateBackgroundView.layer.zPosition = 1000;
    }
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [dateBackgroundView addSubview:cancelBtn];
    
    UIButton *comfirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(dateBackgroundView.frame.size.width - 50, 0, 50, 44)];
    [comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [comfirmBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [comfirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    comfirmBtn.titleLabel.font = cancelBtn.titleLabel.font;
    [comfirmBtn addTarget:self action:@selector(comfirmClick) forControlEvents:UIControlEventTouchUpInside];
    [dateBackgroundView addSubview:comfirmBtn];
    
    // UIPickerView
    if (!personalDataPickerView) {
        personalDataPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, comfirmBtn.bottom, dateBackgroundView.frame.size.width, dateBackgroundView.height - comfirmBtn.bottom - 44)];
        personalDataPickerView.delegate = self;
        personalDataPickerView.dataSource = self;
        [dateBackgroundView addSubview:personalDataPickerView];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dateBackgroundView.width, 0.5)];
    line.backgroundColor = GREEN_COLOR;
    [dateBackgroundView addSubview:line];
}
-(void)cancelClick
{
    [UIView beginAnimations:nil context:Nil];
    dateBackgroundView.top = SCREEN_HEIGHT;
    [UIView commitAnimations];
}

-(void)comfirmClick
{
    [UIView beginAnimations:nil context:Nil];
    dateBackgroundView.top = SCREEN_HEIGHT;
    [UIView commitAnimations];
    if (TapSection == 1) {
        self.workerTypeField.text = [typeArray[selectedRow] objectForKey:@"type_name"];
        self.workerTypeID = [typeArray[selectedRow] objectForKey:@"wid"];
    }else if (TapSection == 2){
        self.provinceTxtfld.text = provinceArray[selectedRow];
    }else{
        self.yearTxtfld.text = yearArray[selectedRow];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (TapSection == 1) {
        return typeArray.count;
    }else if (TapSection == 2){
        return provinceArray.count;
    }else{
        return yearArray.count;
    }
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (TapSection == 1) {
        return [typeArray[row] objectForKey:@"type_name"];
    }else if (TapSection == 2){
        return provinceArray[row];
    }else{
        return yearArray[row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedRow = row;
}

#pragma mark TextField Delegate Method

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    UIView *inputView = (UIView *)textField.superview;
    
    _origpoint = _contentView.contentOffset;
    
    //    self.replyViewDraw = [inputView convertRect:inputView.bounds toView:self.view.window].origin.y + inputView.frame.size.height;
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    UIView *inputView = (UIView *)textView.superview;
    
    _origpoint = _contentView.contentOffset;
    
    //    self.replyViewDraw = [inputView convertRect:inputView.bounds toView:self.view.window].origin.y + inputView.frame.size.height + padding;
    
    return YES;
    
}



@end
