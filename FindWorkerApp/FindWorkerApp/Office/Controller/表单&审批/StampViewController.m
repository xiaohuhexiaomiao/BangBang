//
//  StampViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/29.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "StampViewController.h"
#import "CXZ.h"

#import "StampModel.h"
#import "ApprovalResultModel.h"

#import "StampView.h"
#import "ApprovalContentView.h"

#import "SelectedDepartmentViewController.h"
#import "AdressBookViewController.h"

@interface StampViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate,StampViewDelegate,SelectedDepartmentDelegate,ZLPhotoPickerBrowserViewControllerDelegate,AdressBookDelegate,CopyDelegate>
{
    NSInteger viewTag;
}
@property(nonatomic ,strong) UIScrollView *bgScrollview;

@property(nonatomic ,strong) UIButton *departmentBtn;

@property(nonatomic ,strong) UITextField *applyNameTxt;

@property(nonatomic ,strong) UIButton *addListBtn;

@property(nonatomic ,strong) UIButton *projectButton;//部门经理

@property(nonatomic ,strong)UILabel *approvalLabel;//审批人员展示

@property(nonatomic, strong)UIImageView *wasteImageview;//作废标识

@property(nonatomic , strong) DealWithApprovalView *dealView;

@property(nonatomic ,strong) UIButton *submitbButton;

@property(nonatomic ,strong)UILabel *sponsorLabel;//发起人

@property(nonatomic , strong) MoreFilesView *fileView;

@property(nonatomic ,strong)ShowFilesView *showFielsView;//

@property(nonatomic ,strong)UIView *listView;

@property(nonatomic ,strong) UIView *lastView;

@property(nonatomic , strong)StampModel *stampModel;

@property(nonatomic ,copy)NSString *departmentStr;

@property(nonatomic ,copy) NSString *contractID;//附件id

@property(nonatomic ,strong) NSMutableArray *stampViewArray;

@property(nonatomic, strong)NSMutableArray *imgArray;

@property (nonatomic , strong) NSMutableArray *assets;

@property (nonatomic , strong) NSMutableArray *photos;

@property(nonatomic , assign) NSInteger isDownload;

@property(nonatomic ,copy)NSString *projectManagerStr;//部门经理

@end

@implementation StampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setupBackw];
    [self setupTitleWithString:@"印章申请" withColor:[UIColor whiteColor]];
    [self setupNextWithString:@"去复制" withColor:[UIColor whiteColor]];
    [self config];
    viewTag = 100;
    self.projectManagerStr = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark 点击事件

-(void)clickAddList
{
   
    StampView *stampView = [[StampView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 125)];
    stampView.tag = viewTag;
    stampView.delegate = self;
    [self.listView addSubview:stampView];
    _lastView = stampView;
    viewTag++;
    [self.stampViewArray addObject:stampView];
    
    CGRect frame = self.listView.frame;
    CGFloat height= frame.size.height;
    height += 125;
    frame.size.height = height;
    self.listView.frame = frame;
    self.submitbButton.top = self.listView.bottom+40;
    _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, self.submitbButton.bottom+100);
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
    CopyViewController *copyVC = [[CopyViewController alloc]init];
    copyVC.companyID = self.companyID;
    copyVC.type = 5;
    copyVC.delegate = self;
    [self.navigationController pushViewController:copyVC animated:YES];
    
}

-(void)onBack
{
    [self.fileView removeObserver:self forKeyPath:@"height"];
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark ViewDelegate

-(void)deleteStampView:(NSInteger)tag
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        StampView *view =(StampView*) [self.listView viewWithTag:tag];
        
        [view removeFromSuperview];
        [self.stampViewArray removeObject:view];
        [self refreshWorkerListUI];
    }) ;
}

//刷新UI
-(void)refreshWorkerListUI
{
    _lastView = _addListBtn;
    [self.stampViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.stampViewArray.count; i++) {
        StampView *view =(StampView*) self.stampViewArray[i];
        view.frame = CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 125);
        [self.listView addSubview:view];
        _lastView = view;
    }
    CGRect frame = self.listView.frame;
    CGFloat height= frame.size.height;
    height = self.stampViewArray.count*125+30;
    frame.size.height = height;
    self.listView.frame = frame;
    self.submitbButton.top = self.listView.bottom+40;
    
}

#pragma mark ViewController Delegate

-(void)selectedPorjectManager:(NSDictionary *)dict
{
    NSDictionary *dictionay = @{@"uid":dict[@"uid"]};
    self.projectManagerStr = [NSString dictionaryToJson:dictionay];
    if (![NSString isBlankString:dict[@"name"]]) {
        [self.projectButton setTitle:dict[@"name"] forState:UIControlStateNormal];
    }
   
}


-(void)didSelectedDepartment:(NSDictionary *)department
{
    self.departmentStr = department[@"department_id"];
    [self.departmentBtn setTitle:department[@"department_name"] forState:UIControlStateNormal];
}

-(void)copyAll:(id)model
{
    StampModel *stampModel = (StampModel*)model;
    
    [self.departmentBtn setTitle:stampModel.department_name forState:UIControlStateNormal];
    self.departmentStr = stampModel.department_id;
    self.applyNameTxt.text = stampModel.user_name;
    if (![NSString isBlankString:stampModel.project_manager_id]) {
        NSDictionary *dictionay = @{@"uid":stampModel.project_manager_id};
        self.projectManagerStr = [NSString dictionaryToJson:dictionay];
        [self.projectButton setTitle:stampModel.project_manager_name[@"name"] forState:UIControlStateNormal];
    }
    
    NSMutableArray *fileArray = [NSMutableArray array];
    if (stampModel.contract_id) {
        [fileArray addObject:stampModel.contract_id];
    }
    if (stampModel.many_enclosure.count > 0) {
        [fileArray addObjectsFromArray:stampModel.many_enclosure];
    }
    [self.fileView setMoreFilesViewWithArray:fileArray];
    
    if (stampModel.info.count > 0) {
        for (int i = 0; i < stampModel.info.count; i++) {
            StampView *stampView = [[StampView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 125)];
            stampView.tag = viewTag;
            stampView.delegate = self;
            [self.listView addSubview:stampView];
            _lastView = stampView;
            viewTag++;
            [stampView showCopyStampViewData:stampModel.info[i]];
            [self.stampViewArray addObject:stampView];
            
            CGRect frame = self.listView.frame;
            CGFloat height= frame.size.height;
            height += 125;
            frame.size.height = height;
            self.listView.frame = frame;
        
        }
    }
    self.submitbButton.top =  self.listView.bottom+40;
    _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, self.submitbButton.bottom+125);
}



#pragma mark 界面相关

-(void)config
{
    _bgScrollview = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _bgScrollview.showsVerticalScrollIndicator = YES;
    _bgScrollview.showsHorizontalScrollIndicator = NO;
    _bgScrollview.delegate = self;
    [self.view addSubview:_bgScrollview];
    
    
    _wasteImageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"feiqi"]];
    _wasteImageview.transform = CGAffineTransformMakeRotation(-M_PI/12);
    _wasteImageview.alpha = 0.6;
    [_bgScrollview addSubview:_wasteImageview];
    _wasteImageview.hidden = YES;
    _wasteImageview.frame = CGRectMake(SCREEN_WIDTH/2-105, SCREEN_HEIGHT/2-50, 210, 140);
//    [_wasteImageview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(SCREEN_WIDTH/2-105);
//        make.top.mas_equalTo(SCREEN_HEIGHT/2-50);
//        make.width.mas_equalTo(210);
//        make.height.mas_equalTo(140);
//    }];
    
    NSString *depart = @"部门：";
    CGSize departSize = [depart sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *departLabel = [self customUILabelWithFrame:CGRectMake(8, 0, departSize.width, 30) title:depart];
    [_bgScrollview addSubview:departLabel];
    
    _departmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _departmentBtn.frame = CGRectMake(departLabel.right, departLabel.top, SCREEN_WIDTH-departLabel.right-8, departLabel.height);
    _departmentBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [_departmentBtn setTitleColor:[UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1.00] forState:UIControlStateNormal];
    [_departmentBtn addTarget:self action:@selector(clickSelectDepartment:) forControlEvents:UIControlEventTouchUpInside];
    _departmentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_bgScrollview addSubview:_departmentBtn];
    
    UIView *line1 = [self customLineViewWithFrame:CGRectMake(departLabel.left, _departmentBtn.bottom, SCREEN_WIDTH-16, 1)];
    [_bgScrollview addSubview:line1];
    
    NSString *apply = @"申请人：";
    CGSize applySize = [apply sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *applyLabel = [self customUILabelWithFrame:CGRectMake(departLabel.left, line1.bottom, applySize.width, departLabel.height) title:apply];
    [_bgScrollview addSubview:applyLabel];
    
    _applyNameTxt = [self customTextFieldWithFrame:CGRectMake(applyLabel.right, applyLabel.top, SCREEN_WIDTH-applyLabel.right-8, applyLabel.height)];
    [_bgScrollview addSubview:_applyNameTxt];
    
    UIView *line2 = [self customLineViewWithFrame:CGRectMake(line1.left, applyLabel.bottom, line1.width, line1.height)];
    [_bgScrollview addSubview:line2];
    
    NSString *partStr = @"部门经理：";
    CGSize partSize = [partStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *partLabel = [self customUILabelWithFrame:CGRectMake(line2.left, line2.bottom, partSize.width, departLabel.height) title:partStr];
    [_bgScrollview addSubview:partLabel];
    
    _projectButton = [self customButtonWithFrame:CGRectMake(partLabel.right, partLabel.top, SCREEN_WIDTH-partLabel.right-8, partLabel.height) title:@""];
    [_projectButton addTarget:self action:@selector(clickProjectManager) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollview addSubview:_projectButton];
    
    UIView *line3 = [self customLineViewWithFrame:CGRectMake(line1.left, _projectButton.bottom, line1.width, line1.height)];
    [_bgScrollview addSubview:line3];
    _lastView = line3;
    
    _fileView = [[MoreFilesView alloc]initWithFrame:CGRectMake(8, _lastView.bottom, SCREEN_WIDTH-16, 30)];
    [_bgScrollview addSubview:_fileView];
    [_fileView addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    _listView = [[UIView alloc]initWithFrame:CGRectMake(0, _fileView.bottom, SCREEN_WIDTH, 30)];
    [_bgScrollview addSubview:_listView];
    
    UIView *line4 = [self customLineViewWithFrame:CGRectMake(line1.left, 0, line1.width, line1.height)];
    [_listView addSubview:line4];
    
    _addListBtn = [self customButtonWithFrame:CGRectMake(line4.left, line4.bottom, line4.width, applyLabel.height) title:@"＋申请清单"];
    _addListBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE weight:0.8];
    [_addListBtn addTarget:self action:@selector(clickAddList) forControlEvents:UIControlEventTouchUpInside];
    [_addListBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_listView addSubview:_addListBtn];
    _lastView = _addListBtn;
    
    _submitbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitbButton.frame = CGRectMake(8, _listView.bottom+125, SCREEN_WIDTH-16, 40);
    _submitbButton.backgroundColor = TOP_GREEN;
    _submitbButton.layer.cornerRadius = 5;
    [_submitbButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitbButton setTitle:@"提交" forState:UIControlStateNormal];
    _submitbButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:0.8];
    [_submitbButton addTarget:self action:@selector(submitApprovalFile) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollview addSubview:_submitbButton];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"height"] ) {
        CGFloat newHeight = [change[@"new"] floatValue];
        CGRect frame = self.fileView.frame;
        frame.size.height = newHeight;
        self.fileView.frame = frame;
        self.listView.top = self.fileView.bottom;
        self.submitbButton.top = self.listView.bottom+40;
        _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, self.submitbButton.bottom+125);
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}




#pragma mark 数据处理



-(void)clickProjectManager
{
    AdressBookViewController *bookVC = [[AdressBookViewController alloc]init];
    bookVC.is_single_selected = YES;
    bookVC.companyid = self.companyID;
    bookVC.delegate = self;
    bookVC.loadDataType = 2;
    [self.navigationController pushViewController:bookVC animated:YES];
}

-(void)submitApprovalFile
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
            self.contractID = [dict[@"data"] objectForKey:@"enclosure_id"];
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
    if ([NSString isBlankString:self.departmentStr]) {
        [WFHudView showMsg:@"请选择部门" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.applyNameTxt.text]) {
        [WFHudView showMsg:@"请输入申请人" inView:self.view];
        return;
    }
    if (self.stampViewArray.count == 0) {
        [WFHudView showMsg:@"请添加申请清单" inView:self.view];
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.stampViewArray.count; i++) {
        StampView *stampView = (StampView*)self.stampViewArray[i];
        if ([NSString isBlankString:stampView.fileNameTxt.text]) {
            [WFHudView showMsg:@"请输入资料名称" inView:self.view];
            return;
        }
        if ([NSString isBlankString:stampView.stampType]) {
            [WFHudView showMsg:@"请选择印章类别" inView:self.view];
            return;
        }
        if ([NSString isBlankString:stampView.selectedCompanyButton.text]) {
            [WFHudView showMsg:@"请输入公司名称" inView:self.view];
            return;
        }
        
        NSDictionary *dict = @{@"reason":stampView.reasonTxt.text,@"contract_name":stampView.fileNameTxt.text,@"num":stampView.numTxt.text,
                               @"remarks":stampView.remarkTxt.text,@"name_company":stampView.selectedCompanyButton.text,@"seal_type":stampView.stampType};
        [array addObject:dict];
    }
    self.submitbButton.userInteractionEnabled = NO;
    NSMutableArray *enclosureArray = [NSMutableArray array];
    if (self.fileView.file_id_array.count > 0) {
        [enclosureArray addObjectsFromArray:self.fileView.file_id_array];
    }
    if (![NSString isBlankString:self.contractID]) {
        NSDictionary *dict = @{@"contract_id":self.contractID,@"type":@(3),@"name":@"图片"};
        [enclosureArray addObject:dict];
    }

    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"departmental":self.departmentStr,
                                @"user_name":self.applyNameTxt.text,
                                @"info":[NSString dictionaryToJson:array],
                                @"company_id":self.companyID,
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
    
    [[NetworkSingletion sharedManager]addStampForm:param onSucceed:^(NSDictionary *dict) {
//                        NSLog(@"**purchase*%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            [self.fileView removeObserver:self forKeyPath:@"height"];
            [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            self.submitbButton.userInteractionEnabled = YES;
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
       self.submitbButton.userInteractionEnabled = YES;
        [MBProgressHUD showError:error toView:self.view];
    }];
    
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
    button.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
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

#pragma mark GET / SET

-(NSMutableArray*)stampViewArray
{
    if (!_stampViewArray) {
        _stampViewArray = [NSMutableArray array];
    }
    return _stampViewArray;
}

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
