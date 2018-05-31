//
//  ApprovalFileViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/7/6.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ApprovalFileViewController.h"
#import "CXZ.h"
#import "SelectedDepartmentViewController.h"
#import "AdressBookViewController.h"

#import "ApprovalContentView.h"
#import "ApprovalFileModel.h"
#import "FilesModel.h"
#import "ApprovalResultModel.h"
#import "ApprovalTableView.h"


@interface ApprovalFileViewController ()<UITextFieldDelegate,UITextViewDelegate,UIDocumentInteractionControllerDelegate,UIActionSheetDelegate,SelectedDepartmentDelegate,ZLPhotoPickerBrowserViewControllerDelegate,AdressBookDelegate,RCIMUserInfoDataSource,CopyDelegate>

@property(nonatomic, strong)UIScrollView *scrollView;

@property(nonatomic, strong)UIButton *selectedDepartment;

@property(nonatomic, strong)UITextField *codeTxt;

@property(nonatomic, strong)UITextField *titleTxt;

@property(nonatomic ,strong) UIButton *projectButton;//部门经理

@property(nonatomic, strong)UITextView *contentTextview;

@property(nonatomic, strong)UILabel *contentLabel;

@property(nonatomic ,strong)UILabel *approvalLabel;

@property(nonatomic, strong)UIImageView *wasteImageview;//作废标识

@property(nonatomic , strong) DealWithApprovalView *dealView;

@property(nonatomic ,strong) UIButton *submitbButton;

@property(nonatomic ,strong)UILabel *sponsorLabel;//发起人

@property(nonatomic , strong) MoreFilesView *fileView;

@property(nonatomic ,strong)ShowFilesView *showFielsView;

@property(nonatomic ,strong)UIView *listView;

@property(nonatomic, strong)UIView *lastView;

@property(nonatomic ,copy) NSString *departmentStr;

@property(nonatomic, strong)NSMutableArray *imgArray;

@property (nonatomic , strong) NSMutableArray *assets;

@property (nonatomic , strong) NSMutableArray *photos;

@property (nonatomic ,copy) NSString *ennexID;

@property (nonatomic ,assign) NSUInteger ennexType;

@property(nonatomic , assign) NSInteger isDownload;

@property(nonatomic , strong) ApprovalFileModel *approvalModel;

@property(nonatomic ,copy)NSString *projectManagerStr;//部门经理

@property(nonatomic ,strong)NSDictionary *chatDict;

@property(nonatomic ,copy)NSString *participation_id;//


@end

@implementation ApprovalFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self  setupBackw];
    [self setupTitleWithString:@"呈批件" withColor:[UIColor whiteColor]];
     [self setupNextWithString:@"去复制" withColor:[UIColor whiteColor]];
    [self config];
    self.projectManagerStr = @"";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark 数据相关

-(void)submitApprovalFile
{
    if (self.form_type == 0) {
        if ([NSString isBlankString:self.departmentStr]) {
            [WFHudView showMsg:@"请选择部门" inView:self.view];
            return;
        }
        if ([NSString isBlankString:self.titleTxt.text]) {
            [WFHudView showMsg:@"请输入标题" inView:self.view];
            return;
        }
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
            self.ennexID = [dict[@"data"] objectForKey:@"enclosure_id"];
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
    [SVProgressHUD show];
    NSMutableArray *enclosureArray = [NSMutableArray array];
    if (self.fileView.file_id_array.count > 0) {
        [enclosureArray addObjectsFromArray:self.fileView.file_id_array];
    }
    if (![NSString isBlankString:self.ennexID]) {
        NSDictionary *dict = @{@"contract_id":self.ennexID,@"type":@(3),@"name":@"图片"};
        [enclosureArray addObject:dict];
    }

    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                @"content":self.contentTextview.text,
                                @"chengpi_num":self.codeTxt.text,
                                @"title":self.titleTxt.text,
                             };
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:paramDict];
    if (enclosureArray.count > 0) {
        NSString *many_enclosure = [NSString dictionaryToJson:enclosureArray];
        [param setObject:many_enclosure forKey:@"many_enclosure"];
    }
    if (![NSString isBlankString:self.projectManagerStr]) {
        [param setObject:self.projectManagerStr forKey:@"project_manager"];
    }
    if (![NSString isBlankString:self.departmentStr]) {
        [param setObject:self.departmentStr forKey:@"department_id"];
    }
    if (![NSString isBlankString:self.companyID]) {
        [param setObject:self.companyID forKey:@"company_id"];
    }
    self.submitbButton.userInteractionEnabled = NO;
    if (self.form_type == 1) {
         [param setObject:self.worker_user_id forKey:@"handler_uid"];
        [[NetworkSingletion sharedManager]sendPersonalFileForm:param onSucceed:^(NSDictionary *dict) {
//                    NSLog(@"file %@",dict);
            [SVProgressHUD dismiss];
            if ([dict[@"code"] integerValue]== 0) {
                [self.fileView removeObserver:self forKeyPath:@"height"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                self.submitbButton.userInteractionEnabled = YES;
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            self.submitbButton.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
            [MBProgressHUD showError:error toView:self.view];
        }];
    }else{
        [[NetworkSingletion sharedManager]addApprovalFile:param onSucceed:^(NSDictionary *dict) {
            //        NSLog(@"file %@",dict);
            [SVProgressHUD dismiss];
            if ([dict[@"code"] integerValue]== 0) {
                [self.fileView removeObserver:self forKeyPath:@"height"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                self.submitbButton.userInteractionEnabled = YES;
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            self.submitbButton.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
            [MBProgressHUD showError:error toView:self.view];
        }];
    }
    
    
}



#pragma mark 点击事件

-(void)clickProjectManager
{
    AdressBookViewController *bookVC = [[AdressBookViewController alloc]init];
    bookVC.isSelectedManager = YES;
    bookVC.companyid = self.companyID;
    bookVC.delegate = self;
    bookVC.loadDataType = 2;
    [self.navigationController pushViewController:bookVC animated:YES];
}

//选择部门
-(void)clickSelectDepartment:(UIButton*)button
{
    SelectedDepartmentViewController *selectedVC = [[SelectedDepartmentViewController alloc]init];
    selectedVC.isShow = YES;
    selectedVC.companyid = self.companyID;
    selectedVC.delegate = self;
    [self.navigationController pushViewController:selectedVC animated:YES];
}

-(void)onNext
{
    
    if (self.form_type == 0) {
        CopyViewController *copyVC = [[CopyViewController alloc]init];
        copyVC.companyID = self.companyID;
        copyVC.type = 6;
        copyVC.delegate = self;
        [self.navigationController pushViewController:copyVC animated:YES];
    }else{
        CopyViewController *copyVC = [[CopyViewController alloc]init];
        copyVC.formType = 3;
        copyVC.type = 1;
        copyVC.delegate = self;
        [self.navigationController pushViewController:copyVC animated:YES];
    }
}

-(void)onBack
{
    [self.fileView removeObserver:self forKeyPath:@"height"];
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark Controller & AprovalView Delegate

-(void)didSelectedDepartment:(NSDictionary *)department
{
    self.departmentStr = department[@"department_id"];
    [self.selectedDepartment setTitle:department[@"department_name"] forState:UIControlStateNormal];
}

-(void)selectedPorjectManager:(NSDictionary *)dict
{
    NSDictionary *dictionay = @{@"uid":dict[@"uid"]};
    self.projectManagerStr = [NSString dictionaryToJson:dictionay];
    if (![NSString isBlankString:dict[@"name"]]) {
        [self.projectButton setTitle:dict[@"name"] forState:UIControlStateNormal];
    }
    
}


-(void)copyAll:(id)model
{
    ApprovalFileModel *fileModel = (ApprovalFileModel*)model;
    if (fileModel.department_name) {
         [self.selectedDepartment setTitle:fileModel.department_name forState:UIControlStateNormal];
         self.departmentStr = fileModel.department_id;
    }
    self.codeTxt.text = fileModel.chengpi_num;
    self.titleTxt.text = fileModel.title;
    self.contentTextview.text = fileModel.content;
   
    if (![NSString isBlankString:fileModel.project_manager_id]) {
        NSDictionary *dictionay = @{@"uid":fileModel.project_manager_id};
        self.projectManagerStr = [NSString dictionaryToJson:dictionay];
        [self.projectButton setTitle:fileModel.project_manager_name[@"name"] forState:UIControlStateNormal];
    }
    
    NSMutableArray *fileArray = [NSMutableArray array];
    if (fileModel.contract_id) {
        [fileArray addObject:fileModel.contract_id];
    }
    if (fileModel.many_enclosure.count > 0) {
        [fileArray addObjectsFromArray:fileModel.many_enclosure];
    }
    [self.fileView setMoreFilesViewWithArray:fileArray];
    
}

#pragma mark 界面

-(void)config
{
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _wasteImageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"feiqi"]];
    _wasteImageview.transform = CGAffineTransformMakeRotation(-M_PI/12);
    _wasteImageview.alpha = 0.6;
    [_scrollView addSubview:_wasteImageview];
    _wasteImageview.hidden = YES;
    _wasteImageview.frame = CGRectMake(SCREEN_WIDTH/2-105, SCREEN_HEIGHT/2-50, 210, 140);
    
    NSString *department = @"部门：";
    CGSize departSize = [department sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    if (self.form_type == 0) {
        UILabel *departLabel = [self customUILabelWithFrame:CGRectMake(8, 0, departSize.width, 30) title:department];
        [_scrollView addSubview:departLabel];
        
        
        _selectedDepartment = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedDepartment.frame = CGRectMake(departLabel.right, departLabel.top, SCREEN_WIDTH-departLabel.right-8, departLabel.height);
        _selectedDepartment.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [_selectedDepartment setTitleColor:[UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1.00] forState:UIControlStateNormal];
        _selectedDepartment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_selectedDepartment addTarget:self action:@selector(clickSelectDepartment:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_selectedDepartment];
        
        UIView *line = [self customLineViewWithFrame:CGRectMake(8, _selectedDepartment.bottom, SCREEN_WIDTH-16, 1)];
        [_scrollView addSubview:line];
        
        UILabel *codeLabel = [self customUILabelWithFrame:CGRectMake(departLabel.left, line.bottom, departLabel.width, departLabel.height) title:@"编号："];
        [_scrollView addSubview:codeLabel];
        
        _codeTxt = [self customTextFieldWithFrame:CGRectMake(codeLabel.right, codeLabel.top, SCREEN_WIDTH-codeLabel.right-8, codeLabel.height)];
        [_scrollView addSubview:_codeTxt];
        
        UIView *line1 = [self customLineViewWithFrame:CGRectMake(line.left, _codeTxt.bottom, line.width, line.height)];
        [_scrollView addSubview:line1];
        
        UILabel *titleLabel = [self customUILabelWithFrame:CGRectMake(codeLabel.left, line1.bottom, codeLabel.width, codeLabel.height) title:@"标题："];
        [_scrollView addSubview:titleLabel];
        
        _titleTxt = [self customTextFieldWithFrame:CGRectMake(titleLabel.right, titleLabel.top, SCREEN_WIDTH-titleLabel.right-8, titleLabel.height)];
        [_scrollView addSubview:_titleTxt];
        
        UIView *line2 = [self customLineViewWithFrame:CGRectMake(line.left, _titleTxt.bottom, line.width, line.height)];
        [_scrollView addSubview:line2];
        _lastView = line2;
        
        NSString *partStr = @"部门（项目）经理：";
        CGSize partSize = [partStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *partLabel = [self customUILabelWithFrame:CGRectMake(_lastView.left, _lastView.bottom, partSize.width, departLabel.height) title:partStr];
        [_scrollView addSubview:partLabel];
        
        _projectButton = [self customButtonWithFrame:CGRectMake(partLabel.right, partLabel.top, SCREEN_WIDTH-partLabel.right-8, partLabel.height) title:@""];
        [_projectButton addTarget:self action:@selector(clickProjectManager) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_projectButton];
        
        UIView *line3 = [self customLineViewWithFrame:CGRectMake(line1.left, _projectButton.bottom, line1.width, line1.height)];
        [_scrollView addSubview:line3];
        _lastView = line3;
    }else if(self.form_type == 1){
        UILabel *codeLabel = [self customUILabelWithFrame:CGRectMake(8, 0, departSize.width, 30) title:@"编号："];
        [_scrollView addSubview:codeLabel];
        
        _codeTxt = [self customTextFieldWithFrame:CGRectMake(codeLabel.right, codeLabel.top, SCREEN_WIDTH-codeLabel.right-8, codeLabel.height)];
        [_scrollView addSubview:_codeTxt];
        
        UIView *line1 = [self customLineViewWithFrame:CGRectMake(8, _codeTxt.bottom,  SCREEN_WIDTH-16, 1)];
        [_scrollView addSubview:line1];
        
        UILabel *titleLabel = [self customUILabelWithFrame:CGRectMake(codeLabel.left, line1.bottom, codeLabel.width, codeLabel.height) title:@"标题："];
        [_scrollView addSubview:titleLabel];
        
        _titleTxt = [self customTextFieldWithFrame:CGRectMake(titleLabel.right, titleLabel.top, SCREEN_WIDTH-titleLabel.right-8, titleLabel.height)];
        [_scrollView addSubview:_titleTxt];
        
        UIView *line2 = [self customLineViewWithFrame:CGRectMake(line1.left, _titleTxt.bottom, line1.width, line1.height)];
        [_scrollView addSubview:line2];
        _lastView = line2;
    }
    

    _fileView = [[MoreFilesView alloc]initWithFrame:CGRectMake(8, _lastView.bottom, SCREEN_WIDTH-16, 30)];
    [_scrollView addSubview:_fileView];
    [_fileView addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    
    _listView = [[UIView alloc]initWithFrame:CGRectMake(0, _fileView.bottom, SCREEN_WIDTH, 126)];
    [_scrollView addSubview:_listView];
    
    UIView *line4 = [self customLineViewWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-16, 1)];
    [_listView addSubview:line4];
    
    UILabel *contentLabel = [self customUILabelWithFrame:CGRectMake(line4.left, line4.bottom, departSize.width, 25) title:@"内容："];
    [_listView addSubview:contentLabel];
    
    _contentTextview = [[UITextView alloc]initWithFrame:CGRectMake(contentLabel.right, contentLabel.top, SCREEN_WIDTH-contentLabel.right-8, 100)];
    _contentTextview.delegate = self;
    _contentTextview.returnKeyType = UIReturnKeyDone;
    [_listView addSubview:_contentTextview];
    
    _submitbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitbButton.frame = CGRectMake(8, _listView.bottom+10, SCREEN_WIDTH-16, 40);
    _submitbButton.backgroundColor = TOP_GREEN;
    _submitbButton.layer.cornerRadius = 5;
    [_submitbButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitbButton setTitle:@"提交" forState:UIControlStateNormal];
    _submitbButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:0.8];
    [_submitbButton addTarget:self action:@selector(submitApprovalFile) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_submitbButton];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"height"] ) {
        CGFloat newHeight = [change[@"new"] floatValue];
        CGRect frame = self.fileView.frame;
        frame.size.height = newHeight;
        self.fileView.frame = frame;
        self.listView.top = self.fileView.bottom;
        self.submitbButton.top = self.listView.bottom+40;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.submitbButton.bottom+100);
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}




#pragma mark 自定义控件

-(UITextField*)customTextFieldWithFrame:(CGRect)frame
{
    UITextField *textfield = [[UITextField alloc]initWithFrame:frame];
    textfield.delegate = self;
    textfield.font = [UIFont systemFontOfSize:FONT_SIZE];
    textfield.returnKeyType = UIReturnKeyDone;
    textfield.textColor = FORMTITLECOLOR;
    return textfield;
}

-(UILabel*)customUILabelWithFrame:(CGRect)frame title:(NSString*)title
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = FORMLABELTITLECOLOR;
    label.font = [UIFont systemFontOfSize:FONT_SIZE];
    label.text = title;
    return label;
}

-(UIView*)customLineViewWithFrame:(CGRect)frame
{
    UIView *line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = UIColorFromRGB(224, 223, 226);
    return line;
}

-(UIButton*)customButtonWithFrame:(CGRect)frame title:(NSString*)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE ];
    [button setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
    if (title.length > 0) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    return button;
}

#pragma mark UITextfield Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    //    if ([text isEqualToString:@"\n"]) {
    //        [textView resignFirstResponder];
    //        return NO;
    //    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    
    CGFloat width = CGRectGetWidth(textView.frame);
    CGFloat height = CGRectGetHeight(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
    textView.frame= newFrame;
    
    CGRect frame = self.listView.frame;
    frame.size.height = fmax(height, newSize.height)+1;
    self.listView.frame= frame;
    _submitbButton.top= self.listView.bottom+40;
}

#pragma mark SET/GET

-(NSMutableArray*)imgArray
{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
        
    }
    return _imgArray;
}

-(NSMutableArray*)photos
{
    if (!_photos) {
        _photos = [NSMutableArray array];
        UIImage *img = [UIImage imageNamed:@"上传照片.jpg"];
        [_photos addObject:img];
    }
    return _photos;
}
-(NSMutableArray*)assets
{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}



@end
