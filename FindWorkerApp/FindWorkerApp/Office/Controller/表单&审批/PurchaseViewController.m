//
//  PurchaseViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/27.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "PurchaseViewController.h"
#import "CXZ.h"
#import "PurchaseModel.h"

#import "PurchaseView.h"
#import "ApprovalContentView.h"
#import "EnclosureView.h"

#import "AdressBookViewController.h"
#import "SelectedDepartmentViewController.h"
#import "AddProjectViewController.h"

@interface PurchaseViewController ()<UITextFieldDelegate,UIScrollViewDelegate,PurchaseViewDelegate,SelectedDepartmentDelegate,AdressBookDelegate,ZLPhotoPickerBrowserViewControllerDelegate,CopyDelegate,ProjectViewControllerDelegate,EnclosureViewDelegate>
{
    NSInteger purchaseTag;
}
@property(nonatomic ,strong)UIScrollView *bgScrollview;

@property(nonatomic ,strong)UIButton *departmentButton;//选择部门

@property(nonatomic ,strong)UITextView *addressTxt;//项目工程名称

@property(nonatomic ,strong)UITextView *contractTitleTxtview;//合同名称

@property(nonatomic ,strong)EnclosureView *enclosureView;

@property(nonatomic ,strong)UITextField *managerTxt;//工程负责人

@property(nonatomic ,strong)UITextField *phoneTxt;//联系方式

@property(nonatomic ,strong)UILabel *timeTxt;//到货时间

@property(nonatomic ,strong)UITextField *buyNameTxt;//caigou

@property(nonatomic ,strong)UITextField *buyPhoneTxt;//联系方式

@property(nonatomic ,strong)UITextField *receiverNameTxt;//收货人姓名

@property(nonatomic ,strong)UITextField *recerverPhoneTxt;//收货人电话

@property(nonatomic ,strong)UITextView *recerverAddressTxtview;//收货地址

@property(nonatomic ,strong)UIButton *projectButton;//项目经理

@property(nonatomic ,strong)UIButton *addContractButton;//添加附件

@property(nonatomic ,strong)UIView *line5;//添加附件

@property(nonatomic ,strong)UIButton *addListButton;//添加请购物品按钮

@property(nonatomic ,strong)UILabel *totalMoneyLabel;//合计总金额

@property(nonatomic ,strong)PurchaseView *firstPurchaseView;

@property(nonatomic , strong) MoreFilesView *fileView;

@property(nonatomic ,strong) UIButton *addBtn;

@property(nonatomic ,strong) UIButton *submitbButton;

@property(nonatomic ,strong)UIView *listView;

@property(nonatomic ,strong)UIView *lastView;

@property(nonatomic ,strong)NSMutableArray *purchaseViewArray;


@property(nonatomic , strong) NSMutableArray *photos;//相册相关

@property(nonatomic , strong) NSMutableArray *contractImgviewArray;//存放附件UIImageView

@property(nonatomic ,copy)NSString *departmentStr;

@property(nonatomic ,copy)NSString *projectManagerStr;

@property(nonatomic ,copy)NSString *buy_person_id;

@property(nonatomic ,copy)NSString *receive_person_id;

@property(nonatomic ,copy)NSString *enclosure_id;//附件ID

@property(nonatomic , assign) CGFloat totalMoney;

@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackw];
    [self setupTitleWithString:@"请购单" withColor:[UIColor whiteColor]];
    [self config];
    purchaseTag = 1000;
    self.projectManagerStr = @"";
    self.totalMoney = 0.0;
    [self setupNextWithString:@"去复制" withColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark 点击事件

-(void)onNext
{
    for (PurchaseView *purchaseView in self.purchaseViewArray) {
//        NSLog(@"***%@",purchaseView.nameTxt.text);
        [purchaseView.totalMoneyTxt removeObserver:self forKeyPath:@"text"];
    }
    
    if (self.form_type == 0) {
        CopyViewController *copyVC = [[CopyViewController alloc]init];
        copyVC.companyID = self.companyID;
        copyVC.type = 1000;
        copyVC.delegate = self;
        [self.navigationController pushViewController:copyVC animated:YES];
    }else{
        CopyViewController *copyVC = [[CopyViewController alloc]init];
        copyVC.formType = 1;
        copyVC.type = 1;
        copyVC.delegate = self;
        [self.navigationController pushViewController:copyVC animated:YES];
    }
}

-(void)onBack
{
    for (PurchaseView *purchaseView in self.purchaseViewArray) {
        [purchaseView.totalMoneyTxt removeObserver:self forKeyPath:@"text"];
    }
    [self.fileView removeObserver:self forKeyPath:@"height"];
    [self.navigationController popViewControllerAnimated:YES];
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


//添加请购列表
-(void)addPurchaseList
{
    PurchaseView *purchaseView = [[PurchaseView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 100)];
    purchaseView.tag = purchaseTag;
    purchaseView.delegate = self;
    [self.listView addSubview:purchaseView];
    _lastView = purchaseView;
    purchaseTag++;
    [self.purchaseViewArray addObject:purchaseView];
    [purchaseView.totalMoneyTxt addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    CGRect frame = self.listView.frame;
    CGFloat height= frame.size.height;
    height += 100;
    frame.size.height = height;
    self.listView.frame = frame;
    
    self.submitbButton.top = self.listView.bottom+40;
    _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, self.listView.bottom+200);
}

-(void)clickProjectManager
{
    AdressBookViewController *bookVC = [[AdressBookViewController alloc]init];
    bookVC.is_single_selected = YES;
    bookVC.companyid = self.companyID;
    bookVC.delegate = self;
    bookVC.loadDataType = 2;
    [self.navigationController pushViewController:bookVC animated:YES];
}



-(void)selectDate:(UITapGestureRecognizer*)tap
{
    
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
//    picker.minimumDate = [NSDate date];
    picker.frame = CGRectMake(0, 40, 320, 200);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择时间\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSDate *date = picker.date;
        self.timeTxt.text = [date stringWithFormat:@"yyyy-MM-dd"];
        
        
    }];
    [alertController.view addSubview:picker];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)clickRightButton:(UIButton*)buton
{
    NSInteger tag = buton.tag;
    if (tag == 1000) {
        AddProjectViewController *addVC = [[AddProjectViewController alloc]init];
        addVC.company_id = self.companyID;
        addVC.delegate = self;
        addVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark ViewDelegate

-(void)deletePurchaseView:(NSInteger)tag
{
//        NSLog(@"*delegre  %li",tag);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        PurchaseView *view =(PurchaseView*) [self.listView viewWithTag:tag];
        CGFloat money = [view.totalMoneyTxt.text floatValue];
        self.totalMoney -= money;
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"合计：%.2f",self.totalMoney];
        [view.totalMoneyTxt removeObserver:self forKeyPath:@"text"];
        [view removeFromSuperview];
        [self.purchaseViewArray removeObject:view];
        
        _lastView = _addListButton;
        [self.purchaseViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (int i = 0; i < self.purchaseViewArray.count; i++) {
            PurchaseView *view =(PurchaseView*) self.purchaseViewArray[i];
            CGRect frame = view.frame;
            frame = CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 100);
            view.frame = frame;
            [self.listView addSubview:view];
            _lastView = view;
        }
        CGRect frame = self.listView.frame;
        CGFloat height= frame.size.height;
        height = self.purchaseViewArray.count*100+30;
        frame.size.height = height;
        self.listView.frame = frame;
        self.submitbButton.top = self.listView.bottom+40;
    }) ;
}

#pragma mark ControllerDelegate

-(void)selectedProject:(NSDictionary *)projectDict
{
    self.addressTxt.text = projectDict[@"project_name"];
}

-(void)didSelectedDepartment:(NSDictionary *)department
{
    self.departmentStr = department[@"department_id"];
    [self.departmentButton setTitle:department[@"department_name"] forState:UIControlStateNormal];
}
-(void)selectedPorjectManager:(NSDictionary *)dict
{
    NSDictionary *dictionay = @{@"uid":dict[@"uid"]};
    self.projectManagerStr = [NSString dictionaryToJson:dictionay];
    [self.projectButton setTitle:dict[@"name"] forState:UIControlStateNormal];
}

-(void)copyAll:(id)model
{
    PurchaseModel *detailModel = (PurchaseModel*)model;
    if (detailModel.department_name) {
        [self.departmentButton setTitle:detailModel.department_name forState:UIControlStateNormal];
       self.departmentStr = detailModel.department_id;
    }
    
    self.addressTxt.text = detailModel.request_contract_address;
    self.contractTitleTxtview.text = detailModel.contract_name_new;
    self.managerTxt.text = detailModel.contract_responsible;
    self.phoneTxt.text = detailModel.responsible_tel;
    self.timeTxt.text = detailModel.arrival_time;
    self.receiverNameTxt.text = detailModel.consignee;
    self.recerverPhoneTxt.text = detailModel.consignee_phone;
    self.recerverAddressTxtview.text = detailModel.receive_address;
    self.totalMoney = detailModel.total;
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"合计：%.2f元",self.totalMoney];
    self.buyNameTxt.text = detailModel.buy_person;
    self.buyPhoneTxt.text = detailModel.buy_person_phone;
    self.buy_person_id = detailModel.buy_person_uid;
    self.receive_person_id  = detailModel.consignee_uid;
    
    if (![NSString isBlankString:detailModel.project_manager_id]) {
        NSDictionary *dictionay = @{@"uid":detailModel.project_manager_id};
        self.projectManagerStr = [NSString dictionaryToJson:dictionay];
        [self.projectButton setTitle:detailModel.project_manager_name[@"name"] forState:UIControlStateNormal];
    }
    
    NSMutableArray *fileArray = [NSMutableArray array];
    if (detailModel.enclosure_id) {
        [fileArray addObject:detailModel.enclosure_id];
    }
    if (detailModel.many_enclosure.count > 0) {
        [fileArray addObjectsFromArray:detailModel.many_enclosure];
    }
   
    [self.fileView setMoreFilesViewWithArray:fileArray];

    
    if (detailModel.content.count > 0) {
        
        [self.purchaseViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.purchaseViewArray removeAllObjects];
        CGRect frame = self.listView.frame;
        CGFloat height= frame.size.height;
        height = detailModel.content.count*100;
        frame.size.height = height;
        self.listView.frame = frame;
        
        [self.firstPurchaseView showCopyPurchaseViewWithDict:detailModel.content[0]];
        [self.firstPurchaseView.totalMoneyTxt addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self.listView addSubview:self.firstPurchaseView];
        [self.purchaseViewArray addObject:self.firstPurchaseView];
        CGRect frame2 = self.firstPurchaseView.frame;
        frame2 = CGRectMake(0, _addListButton.bottom, SCREEN_WIDTH, 100);
        self.firstPurchaseView.frame = frame2;
        _lastView = self.firstPurchaseView;
        
        for (int i = 1; i < detailModel.content.count; i++) {
            NSDictionary *dict = detailModel.content[i];
            PurchaseView *purchaseView = [[PurchaseView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 100)];
            [purchaseView showCopyPurchaseViewWithDict:dict];
            purchaseView.tag = purchaseTag;
            purchaseView.delegate = self;
            [self.listView addSubview:purchaseView];
            _lastView = purchaseView;
            purchaseTag++;
            [purchaseView.totalMoneyTxt addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
            [self.purchaseViewArray addObject:purchaseView];
            
            
        }
    }
    
    self.submitbButton.top = self.listView.bottom+40;
    _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, self.listView.bottom+200);
    
    
}

#pragma mark 界面相关

-(void)config
{
    
    _bgScrollview = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _bgScrollview.delegate = self;
    _bgScrollview.showsVerticalScrollIndicator = YES;
    _bgScrollview.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_bgScrollview];
    
    NSString *address = @"工程名称：";
    CGSize addressSize = [address sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *addressLabel = [self customUILabelWithFrame:CGRectMake(8, 0, addressSize.width, 30) title:address];
    [_bgScrollview addSubview:addressLabel];
    
    _addressTxt = [[UITextView alloc]initWithFrame:CGRectMake(addressLabel.right, addressLabel.top, SCREEN_WIDTH-addressLabel.right-32, 30)];
    _addressTxt.font = [UIFont systemFontOfSize:FONT_SIZE];
    _addressTxt.textColor = FORMTITLECOLOR;
    [_bgScrollview addSubview:_addressTxt];
    
    if (self.form_type == 0) {
        UIButton *rightBtn1 = [CustomView customButtonWithContentView:_bgScrollview image:@"right" title:nil];
        rightBtn1.tag = 1000;
        rightBtn1.frame = CGRectMake(_addressTxt.right, _addressTxt.top, 32, 32);
        rightBtn1.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
        [rightBtn1 addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    
    UIView *line = [self customLineViewWithFrame:CGRectMake(8, _addressTxt.bottom, SCREEN_WIDTH-16, 1)];
    [_bgScrollview addSubview:line];
    
    NSString *contractTitleStr =@"合同名称：";
    CGSize contractTitleSize = [contractTitleStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *contract = [self customUILabelWithFrame:CGRectMake(8, line.bottom, contractTitleSize.width, 35) title:contractTitleStr];
    [_bgScrollview addSubview:contract];
    
    _contractTitleTxtview = [[UITextView alloc]initWithFrame:CGRectMake(contract.right, contract.top, SCREEN_WIDTH-contract.right-8, contract.height)];
    _contractTitleTxtview.font = _addressTxt.font;
    [_bgScrollview addSubview:_contractTitleTxtview];
    
    
    UIView *line99 = [self customLineViewWithFrame:CGRectMake(8, _contractTitleTxtview.bottom, SCREEN_WIDTH-16, 1)];
    [_bgScrollview addSubview:line99];
    _lastView = line99;
    
    
    if (self.form_type == 0) {
        NSString *department = @"请购部门：";
        CGSize departmentSize = [department sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *departmentLabel = [self customUILabelWithFrame:CGRectMake(8, _lastView.bottom, departmentSize.width, 30) title:department];
        [_bgScrollview addSubview:departmentLabel];
        
        _departmentButton = [self customButtonWithFrame:CGRectMake(departmentLabel.right, departmentLabel.top, SCREEN_WIDTH-departmentLabel.right-11, departmentLabel.height) title:@""];
        _departmentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_departmentButton addTarget:self action:@selector(clickSelectDepartment:) forControlEvents:UIControlEventTouchUpInside];
        [_bgScrollview addSubview:_departmentButton];
       
        UIView *line1 = [self customLineViewWithFrame:CGRectMake(line.left, _departmentButton.bottom, line.width, line.height)];
        [_bgScrollview addSubview:line1];
        _lastView = line1;

    }
    
    NSString *manager = @"工程负责人：";
    CGSize managerSize = [manager sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *managerLabel = [self customUILabelWithFrame:CGRectMake(addressLabel.left, _lastView.bottom+2, managerSize.width, 20) title:manager];
    _lastView = managerLabel;
    [_bgScrollview addSubview:managerLabel];
    
    __weak typeof(self) weakSelf = self;
    if (self.form_type == 0) {
        AdressBookButton *managerBtn = [[AdressBookButton alloc]initWithFrame:CGRectMake(managerLabel.right, managerLabel.top, 20, 20)];
        managerBtn.companyID = self.companyID;
        managerBtn.DidSelectObjectBlock = ^(NSDictionary *object) {
            if ([NSString isBlankString:object[@"name"]]) {
                weakSelf.managerTxt.text = @"";
            }else{
                weakSelf.managerTxt.text = object[@"name"];
            }
            //        weakSelf.managerTxt.text = object[@"name"];
            weakSelf.phoneTxt.text = object[@"phone"];
        };
        [_bgScrollview addSubview:managerBtn];
        _lastView = managerBtn;
    }
    
    _managerTxt = [self customTextFieldWithFrame:CGRectMake(_lastView.right, managerLabel.top, 55, managerLabel.height)];
    [_bgScrollview addSubview:_managerTxt];
    
    
    NSString *phone = @"联系方式：";
    CGSize phoneSize = [phone sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *phoneLabel = [self customUILabelWithFrame:CGRectMake(_managerTxt.right, _managerTxt.top, phoneSize.width, managerLabel.height) title:phone];
    [_bgScrollview addSubview:phoneLabel];
    
    _phoneTxt = [self customTextFieldWithFrame:CGRectMake(phoneLabel.right, phoneLabel.top, SCREEN_WIDTH-phoneLabel.right-8, phoneLabel.height)];
    _phoneTxt.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_bgScrollview addSubview:_phoneTxt];
    
    NSString *time = @"要求到货时间：";
    CGSize timeSize = [time sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *timeLabel = [self customUILabelWithFrame:CGRectMake(managerLabel.left, managerLabel.bottom, timeSize.width, managerLabel.height) title:time];
    [_bgScrollview addSubview:timeLabel];
    
    _timeTxt = [self customUILabelWithFrame:CGRectMake(timeLabel.right, timeLabel.top, SCREEN_WIDTH-timeLabel.right-8, timeLabel.height) title:nil];
    _timeTxt.textColor = FORMTITLECOLOR;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDate:)];
    _timeTxt.userInteractionEnabled = YES;
    [_timeTxt addGestureRecognizer:tap];
    [_bgScrollview addSubview:_timeTxt];
    
    UIView *line2 = [self customLineViewWithFrame:CGRectMake(line.left, _timeTxt.bottom+2, line.width, line.height)];
    [_bgScrollview addSubview:line2];
    
    
    NSString *buyName = @"采购执行人：";
    CGSize buyNameSize = [buyName sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *buyNameLabel = [self customUILabelWithFrame:CGRectMake(line2.left, line2.bottom+5, buyNameSize.width, 20) title:buyName];
    _lastView = buyNameLabel;
    [_bgScrollview addSubview:buyNameLabel];
    
    if (self.form_type == 0) {
        AdressBookButton *buyButton = [[AdressBookButton alloc]initWithFrame:CGRectMake(buyNameLabel.right, buyNameLabel.top, 20, 20)];
        buyButton.companyID = self.companyID;
        buyButton.DidSelectObjectBlock = ^(NSDictionary *object) {
            if ([NSString isBlankString:object[@"name"]]) {
                weakSelf.buyNameTxt.text = @"";
            }else{
                weakSelf.buyNameTxt.text = object[@"name"];
            }
            //        weakSelf.buyNameTxt.text = object[@"name"];
            weakSelf.buyPhoneTxt.text = object[@"phone"];
            weakSelf.buy_person_id = object[@"uid"];
        };
        _lastView = buyButton;
        [_bgScrollview addSubview:buyButton];
    }
   
    
    _buyNameTxt = [self customTextFieldWithFrame:CGRectMake(_lastView.right, _lastView.top, 60, buyNameLabel.height)];
    if (self.form_type == 0) {
        _buyNameTxt.userInteractionEnabled = NO;
    }
    [_bgScrollview addSubview:_buyNameTxt];
    
    NSString *buyPhone = @"联系方式：";
    CGSize buyPhoneSize = [buyPhone sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *buyPhoneLabel = [self customUILabelWithFrame:CGRectMake(phoneLabel.left, buyNameLabel.top, buyPhoneSize.width, buyNameLabel.height) title:buyPhone];
    [_bgScrollview addSubview:buyPhoneLabel];
    
    _buyPhoneTxt = [self customTextFieldWithFrame:CGRectMake(buyPhoneLabel.right, buyPhoneLabel.top, SCREEN_WIDTH-buyPhoneLabel.right-8, buyPhoneLabel.height)];
    [_bgScrollview addSubview:_buyPhoneTxt];
    
    UIView *line0 = [self customLineViewWithFrame:CGRectMake(line.left, _buyPhoneTxt.bottom+5, line.width, line.height)];
    [_bgScrollview addSubview:line0];
    
    
    NSString *receiveName = @"收货人：";
    CGSize receiveNameSize = [receiveName sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *receiveLabel = [self customUILabelWithFrame:CGRectMake(line2.left, line0.bottom+2, receiveNameSize.width, timeLabel.height) title:receiveName];
    _lastView = receiveLabel;
    [_bgScrollview addSubview:receiveLabel];
    
    if (self.form_type == 0) {
        AdressBookButton *nameBtn = [[AdressBookButton alloc]initWithFrame:CGRectMake(receiveLabel.right, receiveLabel.top, 20, 20)];
        nameBtn.companyID = self.companyID;
        nameBtn.DidSelectObjectBlock = ^(NSDictionary *object) {
            //                NSLog(@"gaga  %@",object);
            if ([NSString isBlankString:object[@"name"]]) {
                weakSelf.receiverNameTxt.text = @"";
            }else{
                weakSelf.receiverNameTxt.text = object[@"name"];
            }
            weakSelf.recerverPhoneTxt.text = object[@"phone"];
            weakSelf.receive_person_id = object[@"uid"];
        };
        _lastView = nameBtn;
        [_bgScrollview addSubview:nameBtn];
       
    }
    _receiverNameTxt = [self customTextFieldWithFrame:CGRectMake(_lastView.right, _lastView.top, 60, receiveLabel.height)];
    if (self.form_type == 0) {
        _receiverNameTxt.userInteractionEnabled = NO;
    }
    [_bgScrollview addSubview:_receiverNameTxt];
    
    NSString *receivePhone = @"联系方式：";
    CGSize receivePhoneSize = [receivePhone sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *receivePhoneLabel = [self customUILabelWithFrame:CGRectMake(phoneLabel.left, _receiverNameTxt.top, receivePhoneSize.width, receiveLabel.height) title:receivePhone];
    [_bgScrollview addSubview:receivePhoneLabel];
    
    _recerverPhoneTxt = [self customTextFieldWithFrame:CGRectMake(receivePhoneLabel.right, receivePhoneLabel.top, SCREEN_WIDTH-receivePhoneLabel.right-8, receivePhoneLabel.height)];
    _recerverPhoneTxt.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_bgScrollview addSubview:_recerverPhoneTxt];
    
    NSString *receiveAddress = @"收货地址：";
    CGSize receiveAddressSize = [receiveAddress sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *receiveAddressLabel = [self customUILabelWithFrame:CGRectMake(receiveLabel.left, receiveLabel.bottom, receiveAddressSize.width, 30) title:receiveAddress];
    [_bgScrollview addSubview:receiveAddressLabel];
    
    _recerverAddressTxtview = [[UITextView alloc]initWithFrame:CGRectMake(receiveAddressLabel.right, receiveAddressLabel.top, SCREEN_WIDTH-receiveAddressLabel.right-8, 30)];
    _recerverAddressTxtview.font = [UIFont systemFontOfSize:FONT_SIZE];
    _recerverAddressTxtview.textColor = FORMTITLECOLOR;
    [_bgScrollview addSubview:_recerverAddressTxtview];
    
    UIView *line3 = [self customLineViewWithFrame:CGRectMake(line.left, _recerverAddressTxtview.bottom, line.width, line.height)];
    [_bgScrollview addSubview:line3];
    _lastView = line3;
    
    if (self.form_type == 0) {
        NSString *managerStr = @"项目（部门）经理：";
        CGSize projectManagerSize = [managerStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *projectManagerLabel = [self customUILabelWithFrame:CGRectMake(_lastView.left, _lastView.bottom, projectManagerSize.width, 30) title:managerStr];
        [_bgScrollview addSubview:projectManagerLabel];
        
        _projectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _projectButton.frame = CGRectMake(projectManagerLabel.right, projectManagerLabel.top, SCREEN_WIDTH-projectManagerLabel.right-8, projectManagerLabel.height);
        [_projectButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
        _projectButton.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [_projectButton addTarget:self action:@selector(clickProjectManager) forControlEvents:UIControlEventTouchUpInside];
        _projectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_bgScrollview addSubview:_projectButton];
        
        UIView *line4 = [self customLineViewWithFrame:CGRectMake(line.left, _projectButton.bottom, line.width, line.height)];
        [_bgScrollview addSubview:line4];
        _lastView = line4;
    }
    
    
    _fileView = [[MoreFilesView alloc]initWithFrame:CGRectMake(8, _lastView.bottom, SCREEN_WIDTH-16, 30)];
    [_bgScrollview addSubview:_fileView];
    [_fileView addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    _line5 = [self customLineViewWithFrame:CGRectMake(line.left, _fileView.bottom, line.width, line.height)];
    [_bgScrollview addSubview:_line5];
    
    
//    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
//    _addBtn.frame = CGRectMake(SCREEN_WIDTH-35, SCREEN_HEIGHT-150, 30, 30);
//    [_addBtn addTarget:self action:@selector(addPurchaseList) forControlEvents:UIControlEventTouchUpInside];
//    _addBtn.hidden = NO;
//    [self.view addSubview:_addBtn];
    
    
    _listView = [[UIView alloc]initWithFrame:CGRectMake(0, _line5.bottom, SCREEN_WIDTH, 130)];
    [_bgScrollview addSubview:_listView];
    
    _addListButton = [CustomView customButtonWithContentView:_listView image:nil title:@"＋添加请购清单"];
    _addListButton.frame = CGRectMake(8, _listView.bounds.origin.y, SCREEN_WIDTH/2-8, 30);
//    _addListButton.top = 0.0;
    _addListButton.titleLabel.font =[UIFont systemFontOfSize:FONT_SIZE weight:0.8];
    _addListButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_addListButton addTarget:self action:@selector(addPurchaseList) forControlEvents:UIControlEventTouchUpInside];
    
    
    _totalMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, _addListButton.top, SCREEN_WIDTH/2, 30)];
    _totalMoneyLabel.font = [UIFont systemFontOfSize:12 weight:0.8];
    _totalMoneyLabel.textColor = DARK_RED_COLOR;
    _totalMoneyLabel.textAlignment = NSTextAlignmentRight;
    [_listView addSubview:_totalMoneyLabel];
    
    
    _firstPurchaseView = [[PurchaseView alloc]initWithFrame:CGRectMake(0, _addListButton.bottom, SCREEN_WIDTH, 100)];
    _firstPurchaseView.tag = 999;
    _firstPurchaseView.delegate = self;
    _firstPurchaseView.deleteButton.hidden = YES;
    [_listView addSubview:_firstPurchaseView];
    _lastView = _firstPurchaseView;
    [ _firstPurchaseView.totalMoneyTxt addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.purchaseViewArray addObject:_firstPurchaseView];
    
    
    
    _submitbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitbButton.frame = CGRectMake(8, _listView.bottom+40, SCREEN_WIDTH-16, 40);
    _submitbButton.backgroundColor = TOP_GREEN;
    _submitbButton.layer.cornerRadius = 5;
    [_submitbButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitbButton setTitle:@"提交" forState:UIControlStateNormal];
    _submitbButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:0.8];
    [_submitbButton addTarget:self action:@selector(submitPurchaseForm) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollview addSubview:_submitbButton];
    
    _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+200);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"text"] ) {
        CGFloat newMoney = [change[@"new"] floatValue];
        CGFloat oldMoney = [change[@"old"] floatValue];
        self.totalMoney += newMoney;
        self.totalMoney -= oldMoney;
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"合计：%.2f元",self.totalMoney];
    }else if ([keyPath isEqualToString:@"height"] ) {
        CGFloat newHeight = [change[@"new"] floatValue];
        CGRect frame = self.fileView.frame;
        frame.size.height = newHeight;
        self.fileView.frame = frame;
        self.line5.top = self.fileView.bottom;
        self.listView.top = self.line5.bottom;
        self.submitbButton.top = self.listView.bottom+40;
        _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, self.submitbButton.bottom+100);
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



#pragma mark 数据相关
-(void)submitPurchaseForm
{
    if (self.form_type == 0) {
        if ([NSString isBlankString:self.addressTxt.text]) {
            [WFHudView showMsg:@"请输入工程名称" inView:self.view];
            return;
        }
        if ([NSString isBlankString:self.departmentStr]) {
            [WFHudView showMsg:@"请选择部门" inView:self.view];
            return;
        }
        if ([NSString isBlankString:self.buyNameTxt.text]) {
            [WFHudView showMsg:@"请选择采购执行人" inView:self.view];
            return;
        }
        if ([NSString isBlankString:self.buyPhoneTxt.text]) {
            [WFHudView showMsg:@"请输入采购执行人联系方式" inView:self.view];
            return;
        }
        if ([NSString isBlankString:self.managerTxt.text]) {
            [WFHudView showMsg:@"请输入工程负责人姓名" inView:self.view];
            return;
        }
        if ([NSString isBlankString:self.phoneTxt.text]) {
            [WFHudView showMsg:@"请输入工程负责人联系方式" inView:self.view];
            return;
        }
        if ([NSString isBlankString:self.timeTxt.text]) {
            [WFHudView showMsg:@"请选择要求到货时间" inView:self.view];
            return;
        }
        if ([NSString isBlankString:self.receiverNameTxt.text]) {
            [WFHudView showMsg:@"请输入收货人姓名" inView:self.view];
            return;
        }
        if ([NSString isBlankString:self.recerverPhoneTxt.text]) {
            [WFHudView showMsg:@"请输入收货人联系方式" inView:self.view];
            return;
        }
        if ([NSString isBlankString:self.recerverAddressTxtview.text]) {
            [WFHudView showMsg:@"请输入收货地址" inView:self.view];
            return;
        }
        if ([NSString isBlankString:self.buy_person_id]) {
            [WFHudView showMsg:@"请重新选择采购执行人" inView:self.view];
            return;
        }
        if ([NSString isBlankString:self.receive_person_id]) {
            [WFHudView showMsg:@"请重新选择收货人" inView:self.view];
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
            self.enclosure_id = [dict[@"data"] objectForKey:@"enclosure_id"];
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
    NSLog(@"***%lf yuan",self.totalMoney);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.purchaseViewArray.count; i++) {
        PurchaseView *purchaseView = (PurchaseView*)self.purchaseViewArray[i];
        if ([NSString isBlankString:purchaseView.nameTxt.text] &&[NSString isBlankString:purchaseView.typeTxt.text]&&[NSString isBlankString:purchaseView.normsTxt.text] &&[NSString isBlankString:purchaseView.numTxt.text] &&[NSString isBlankString:purchaseView.priceTxt.text] &&[NSString isBlankString:purchaseView.totalMoneyTxt.text] &&[NSString isBlankString:purchaseView.usesTxt.text] &&[NSString isBlankString:purchaseView.markTxt.text] &&[NSString isBlankString:purchaseView.unitTxt.text]) {
            
        }else{
            if ([NSString isBlankString:purchaseView.nameTxt.text]) {
                [WFHudView showMsg:@"请输入请购物品名称" inView:self.view];
                self.submitbButton.userInteractionEnabled = YES;
                return;
            }
            if ([NSString isBlankString:purchaseView.totalMoneyTxt.text]) {
                [WFHudView showMsg:@"请输入请购物品总额" inView:self.view];
                self.submitbButton.userInteractionEnabled = YES;
                return;
            }
            NSDictionary *dict = @{@"name":purchaseView.nameTxt.text,@"spec":purchaseView.typeTxt.text,@"model":purchaseView.normsTxt.text,@"num":purchaseView.numTxt.text,
                                   @"price":purchaseView.priceTxt.text,@"subtotal":purchaseView.totalMoneyTxt.text,@"purpose":purchaseView.usesTxt.text,@"unit":purchaseView.unitTxt.text};
            [array addObject:dict];
        }
    }
    if (array.count == 0 && [NSString isBlankString:self.enclosure_id]) {
        [WFHudView showMsg:@"请添加请购清单或附件" inView:self.view];
        self.submitbButton.userInteractionEnabled = YES;
        return;
    }
    self.submitbButton.userInteractionEnabled = NO;
    
    NSMutableArray *enclosureArray = [NSMutableArray array];
    if (self.fileView.file_id_array.count > 0) {
        [enclosureArray addObjectsFromArray:self.fileView.file_id_array];
    }
    if (![NSString isBlankString:self.enclosure_id]) {
        NSDictionary *dict = @{@"contract_id":self.enclosure_id,@"type":@(3),@"name":@"图片"};
        [enclosureArray addObject:dict];
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"request_contract_address":self.addressTxt.text,
                                @"contract_responsible":self.managerTxt.text,
                                @"responsible_tel":self.phoneTxt.text,
                                @"arrival_time":self.timeTxt.text,
                                @"consignee":self.receiverNameTxt.text,
                                @"consignee_phone":self.recerverPhoneTxt.text,
                                @"total":[NSString stringWithFormat:@"%.2lf",self.totalMoney],
                                @"receive_address":self.recerverAddressTxtview.text,
                                @"buy_person":self.buyNameTxt.text,
                                @"buy_person_phone":self.buyPhoneTxt.text,
                                @"contract_name_new":self.contractTitleTxtview.text
                                };
    [param addEntriesFromDictionary:paramDict];
    if (enclosureArray.count > 0) {
        NSString *many_enclosure = [NSString dictionaryToJson:enclosureArray];
        [param setObject:many_enclosure forKey:@"many_enclosure"];
    }
    if (array.count > 0) {
        NSString *content = [NSString dictionaryToJson:array];
        [param setObject:content forKey:@"content"];
    }
    if (![NSString isBlankString:self.projectManagerStr]) {
        [param setObject:self.projectManagerStr forKey:@"project_manager"];
    }
    if (![NSString isBlankString:self.departmentStr]) {
        [param setObject:self.departmentStr forKey:@"request_buy_department"];
    }
    if (![NSString isBlankString:self.companyID]) {
        [param setObject:self.companyID forKey:@"company_id"];
    }
    if (![NSString isBlankString:self.receive_person_id]) {
        [param setObject:self.receive_person_id forKey:@"consignee_uid"];
    }
    if (![NSString isBlankString:self.buy_person_id]) {
        [param setObject:self.buy_person_id forKey:@"buy_person_uid"];
    }
    
    if (self.form_type == 1) {
        [param setObject:self.worker_user_id forKey:@"handler_uid"];
        [[NetworkSingletion sharedManager]sendPersonalPurchaseForm:param onSucceed:^(NSDictionary *dict) {
//                  NSLog(@"**purchase*%@",dict);
            if ([dict[@"code"] integerValue]==0) {
                [self.fileView removeObserver:self forKeyPath:@"height"];
                for (PurchaseView *purchaseView in self.purchaseViewArray) {
                    [purchaseView.totalMoneyTxt removeObserver:self forKeyPath:@"text"];
                }
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
 
    }else{
        [[NetworkSingletion sharedManager]addPurchaseForm:param onSucceed:^(NSDictionary *dict) {
            //      NSLog(@"**purchase*%@",dict);
            if ([dict[@"code"] integerValue]==0) {
                [self.fileView removeObserver:self forKeyPath:@"height"];
                for (PurchaseView *purchaseView in self.purchaseViewArray) {
                    [purchaseView.totalMoneyTxt removeObserver:self forKeyPath:@"text"];
                }
                [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                self.submitbButton.userInteractionEnabled = YES;
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
//            NSLog(@"***%@",error);
            self.submitbButton.userInteractionEnabled = YES;
            [MBProgressHUD showError:error toView:self.view];
        }];

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
    if (title) {
        label.text = title;
    }
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
    button.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [button setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

#pragma mark UITextfield Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark get/set

-(NSMutableArray*)purchaseViewArray
{
    if (!_purchaseViewArray) {
        _purchaseViewArray = [NSMutableArray array];
    }
    return _purchaseViewArray;
}

-(NSMutableArray*)contractImgviewArray
{
    if (!_contractImgviewArray) {
        _contractImgviewArray = [NSMutableArray array];
    }
    return _contractImgviewArray;
}

@end
