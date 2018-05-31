//
//  PostContractViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/1.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "PostContractViewController.h"
#import "CXZ.h"
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "SWMyLocationController.h"
#import "SignNameViewController.h"

@interface PostContractViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,MyLocationControllerDelegate>

{
    UIDatePicker *datePicker;
    UIView *dateBackgroundView;
    NSInteger tag;
    UIButton *lastSelectedView;
}


@property (nonatomic, strong) UIWindow *selectWindow;

@property (nonatomic, strong) UITableView *selectTableview;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITextField *payField; //付款比例

@property (nonatomic, strong) UILabel *startTimeLbl;

@property (nonatomic, strong) UILabel *finishedTimeLbl;

@property (nonatomic, strong) UITextField *addressTF;

@property (nonatomic, strong) UITextField *yifangTxtfield;

@property (nonatomic, strong) UITextField *totalPriceTF;//合同总价

@property (nonatomic, strong) UITextField *contractTitleTextfield;//合同名称

@property (nonatomic, strong) UIView *lastView;

@property (nonatomic, strong) NSArray *contractTypeArray;

@property (nonatomic, strong) NSArray *descripArray;

@property (nonatomic, strong) NSMutableArray *paramArray;

@end

@implementation PostContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    if (!self.is_save) {
        if (self.isBack == YES) {
            [self setupTitleWithString:@"修改合同" withColor:[UIColor whiteColor]];
            [self loadContractDescription];
        }else{
            [self setupTitleWithString:@"填写合同" withColor:[UIColor whiteColor]];
            [self loadContractType];
        }
        
    }else{
        [self setupTitleWithString:@"编辑合同" withColor:[UIColor whiteColor]];
        [self loadContractDescription];
    }
    [self config];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma  mark Private Method

-(void)config
{
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _scrollView.height -= 104;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    UIButton *previewBtn = [[UIButton alloc] init];
    previewBtn.frame     = CGRectMake(0, SCREEN_HEIGHT-104, SCREEN_WIDTH/2, 40);
    [previewBtn setTitle:@"预览" forState:UIControlStateNormal];
    [previewBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [previewBtn addTarget:self action:@selector(previewContact) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previewBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame     = CGRectMake(previewBtn.right, previewBtn.top, previewBtn.width, previewBtn.height);
    sureBtn.backgroundColor = GREEN_COLOR;
    if (self.is_save) {
        [previewBtn setTitle:@"保存" forState:UIControlStateNormal];
        [sureBtn setTitle:@"保存并分享" forState:UIControlStateNormal];
    }else{
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(confirmContact) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    if (self.isBack == NO) {
        _selectWindow = [[UIWindow alloc]initWithFrame:self.view.bounds];
        _selectWindow.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _selectWindow.windowLevel = UIWindowLevelNormal;
        
        _selectTableview = [[UITableView alloc]initWithFrame:CGRectMake(100, 20, SCREEN_WIDTH-40, 300) style:UITableViewStyleGrouped] ;
        _selectTableview.center = self.selectWindow.center;
        _selectTableview.delegate = self;
        _selectTableview.dataSource = self;
        _selectTableview.tableFooterView = [UIView new];
        [_selectWindow addSubview:_selectTableview];
        
        [self.view addSubview:_selectWindow];
        [_selectWindow makeKeyWindow];
        _selectWindow.hidden = NO;
    }
    
    //日期选择框
    dateBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, self.view.frame.size.width, 260)];
    dateBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dateBackgroundView];
    
    dateBackgroundView.layer.zPosition = 1000;
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelkClick) forControlEvents:UIControlEventTouchUpInside];
    [dateBackgroundView addSubview:cancelBtn];
    
    UIButton *comfirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(dateBackgroundView.frame.size.width - 50, 0, 50, 44)];
    [comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [comfirmBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [comfirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    comfirmBtn.titleLabel.font = cancelBtn.titleLabel.font;
    [comfirmBtn addTarget:self action:@selector(comfirmClick) forControlEvents:UIControlEventTouchUpInside];
    [dateBackgroundView addSubview:comfirmBtn];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, comfirmBtn.bottom, dateBackgroundView.frame.size.width, dateBackgroundView.height - comfirmBtn.bottom - 44)];
    datePicker.hidden = YES;
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.minimumDate = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    [components setMonth:01];
    [components setDay:01];
    [dateBackgroundView addSubview:datePicker];
    
}

-(void)setContractDescriptionView
{
    NSString *titleStr = @"合同名称";
    CGSize titleSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    UILabel *contractTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, titleSize.width, 20)];
    contractTitleLabel.text = titleStr;
    contractTitleLabel.font = [UIFont systemFontOfSize:12];
    contractTitleLabel.textColor = [UIColor blackColor];
    [self.scrollView addSubview:contractTitleLabel];
    
    _contractTitleTextfield = [[UITextField alloc]initWithFrame:CGRectMake(contractTitleLabel.right+5, contractTitleLabel.top, SCREEN_WIDTH-contractTitleLabel.right-10, contractTitleLabel.height)];
    _contractTitleTextfield.returnKeyType = UIReturnKeyDone;
    _contractTitleTextfield.font = [UIFont systemFontOfSize:12];
    _contractTitleTextfield.backgroundColor = [UIColor whiteColor];
    if (self.detailDict) {
        _contractTitleTextfield.text = self.detailDict[@"contract_name"];
    }
    _lastView = _contractTitleTextfield;
    [self.scrollView addSubview:_contractTitleTextfield];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, _contractTitleTextfield.bottom, 40, 20)];
    nameLabel.text = @"乙方：";
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textColor = [UIColor blackColor];
    [self.scrollView addSubview:nameLabel];
    
    _yifangTxtfield = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right+5, nameLabel.top, SCREEN_WIDTH-nameLabel.right-10, 20)];
    _yifangTxtfield.returnKeyType = UIReturnKeyDone;
    _yifangTxtfield.font = [UIFont systemFontOfSize:12];
    _yifangTxtfield.backgroundColor = [UIColor whiteColor];
    if (self.detailDict) {
        _yifangTxtfield.text = self.detailDict[@"contract_name"];
    }
    _lastView = _yifangTxtfield;
    [self.scrollView addSubview:_yifangTxtfield];
    
    NSString *revenueStr = @"是否含税";
    CGSize revenueSize = [revenueStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *revenueLbl = [[UILabel alloc] init];
    revenueLbl.frame    = CGRectMake(contractTitleLabel.left, _lastView.bottom+5, revenueSize.width, revenueSize.height);
    revenueLbl.font     = [UIFont systemFontOfSize:12];
    revenueLbl.text     = revenueStr;
    revenueLbl.textColor = [UIColor blackColor];
    [self.scrollView addSubview:revenueLbl];
    
    UIButton *yesBtn = [[UIButton alloc] init];
    [yesBtn setImage:[UIImage imageNamed:@"dow_unselect"] forState:UIControlStateNormal];
    [yesBtn setImage:[UIImage imageNamed:@"dow_select"] forState:UIControlStateSelected];
    [yesBtn setTitle:@"是" forState:UIControlStateNormal];
    [yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [yesBtn setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    [yesBtn addTarget:self action:@selector(selectYes:) forControlEvents:UIControlEventTouchUpInside];
    [yesBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    yesBtn.tag = 1;
    [yesBtn sizeToFit];
    yesBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    CGFloat yesBtnW = yesBtn.bounds.size.width;
    CGFloat yesBtnH = yesBtn.bounds.size.height;
    CGFloat yesBtnX = CGRectGetMaxX(revenueLbl.frame) + 5;
    CGFloat yesBtnY = revenueLbl.frame.origin.y - 3;
    
    yesBtn.frame = CGRectMake(yesBtnX, yesBtnY, yesBtnW, yesBtnH);
    _lastView = yesBtn;
    [self.scrollView addSubview:yesBtn];
    
    UIButton *noBtn = [[UIButton alloc] init];
    [noBtn setImage:[UIImage imageNamed:@"dow_unselect"] forState:UIControlStateNormal];
    [noBtn setImage:[UIImage imageNamed:@"dow_select"] forState:UIControlStateSelected];
    [noBtn setTitle:@"否" forState:UIControlStateNormal];
    [noBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [noBtn setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    [noBtn addTarget:self action:@selector(selectNo:) forControlEvents:UIControlEventTouchUpInside];
    [noBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [noBtn sizeToFit];
    noBtn.tag = 2;
    noBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    CGFloat noBtnW = yesBtn.bounds.size.width;
    CGFloat noBtnH = yesBtn.bounds.size.height;
    CGFloat noBtnX = CGRectGetMaxX(yesBtn.frame) + 10;
    CGFloat noBtnY = revenueLbl.frame.origin.y - 3;
    
    noBtn.frame = CGRectMake(noBtnX, noBtnY, noBtnW, noBtnH);
    [self.scrollView addSubview:noBtn];
    
    if (self.detailDict) {
        NSInteger is_tax = [self.detailDict[@"is_tax"] integerValue ];
        if (is_tax == 1) {
            yesBtn.selected = YES;
        }else{
            noBtn.selected = YES;
        }
    }
    
    
    NSString *starTime = @"开始时间";
    CGSize starSize = [starTime sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *startLable = [[UILabel alloc] init];
    startLable.frame    = CGRectMake(contractTitleLabel.left, _lastView.bottom+5, starSize.width, contractTitleLabel.height);
    startLable.font     = [UIFont systemFontOfSize:12];
    startLable.text     = starTime;
    startLable.textColor = [UIColor blackColor];
    [self.scrollView addSubview:startLable];
    
    _startTimeLbl = [[UILabel alloc]initWithFrame:CGRectMake(startLable.right+5, startLable.top, SCREEN_WIDTH-startLable.right-10, contractTitleLabel.height)];
    _startTimeLbl.font = [UIFont systemFontOfSize:12];
    _startTimeLbl.backgroundColor = [UIColor whiteColor];
    _startTimeLbl.tag = 10;
    _startTimeLbl.layer.cornerRadius = 6;
    _lastView = _startTimeLbl;
    if (self.detailDict) {
        _startTimeLbl.text = self.detailDict[@"contract_begin_time"];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDate:)];
    _startTimeLbl.userInteractionEnabled = YES;
    [_startTimeLbl addGestureRecognizer:tap];
    [self.scrollView addSubview:_startTimeLbl];
    
    
    NSString *finishTime = @"结束时间";
    CGSize finishSize = [finishTime sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *finishLable = [[UILabel alloc] init];
    finishLable.frame    = CGRectMake(contractTitleLabel.left, _lastView.bottom+5, finishSize.width, contractTitleLabel.height);
    finishLable.font     = [UIFont systemFontOfSize:12];
    finishLable.text     = finishTime;
    finishLable.textColor = [UIColor blackColor];
    [self.scrollView addSubview:finishLable];
    
    _finishedTimeLbl = [[UILabel alloc]initWithFrame:CGRectMake(finishLable.right+5, finishLable.top, _startTimeLbl.width, _startTimeLbl.height)];
    _finishedTimeLbl.font = [UIFont systemFontOfSize:12];
    _finishedTimeLbl.backgroundColor = [UIColor whiteColor];
    _finishedTimeLbl.tag = 20;
    _finishedTimeLbl.layer.cornerRadius = 6;
    _lastView = _finishedTimeLbl;
    if (self.detailDict) {
        _finishedTimeLbl.text = self.detailDict[@"contract_end_time"];
    }
    UITapGestureRecognizer *finishTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDate:)];
    _finishedTimeLbl.userInteractionEnabled = YES;
    [_finishedTimeLbl addGestureRecognizer:finishTap];
    [self.scrollView addSubview:_finishedTimeLbl];
    
    NSString *address = @"工程地址";
    CGSize addressSize = [address sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *addressLable = [[UILabel alloc] init];
    addressLable.frame    = CGRectMake(contractTitleLabel.left, _lastView.bottom+5, addressSize.width, _startTimeLbl.height);
    addressLable.font     = [UIFont systemFontOfSize:12];
    addressLable.text     = address;
    addressLable.textColor = [UIColor blackColor];
    [self.scrollView addSubview:addressLable];
    
    _addressTF = [[UITextField alloc]initWithFrame:CGRectMake(addressLable.right+5, addressLable.top, SCREEN_WIDTH-addressLable.right-10-30, _startTimeLbl.height)];
    _addressTF.font = [UIFont systemFontOfSize:12];
    _addressTF.returnKeyType = UIReturnKeyDone;
    _addressTF.backgroundColor = [UIColor whiteColor];
    _lastView = _addressTF;
    if (self.detailDict) {
        _addressTF.text = self.detailDict[@"contract_address"];
    }
    [self.scrollView addSubview:_addressTF];
    
    UIImage *positionImg = [UIImage imageNamed:@"blue_position"];
    UIButton *positionBtn = [[UIButton alloc] init];
    [positionBtn setImage:positionImg forState:UIControlStateNormal];
    positionBtn.frame = CGRectMake(SCREEN_WIDTH-30,  _finishedTimeLbl.bottom, 30, 30);
    positionBtn.imageEdgeInsets = UIEdgeInsetsMake(5, -5, -5, 5);
    [positionBtn addTarget:self action:@selector(chooseLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:positionBtn];
    
    
    
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.frame    = CGRectMake(contractTitleLabel.left, _lastView.bottom+5, contractTitleLabel.width ,contractTitleLabel.height);
    totalLabel.font     = [UIFont systemFontOfSize:12];
    totalLabel.textColor = [UIColor blackColor];
    totalLabel.text     = @"合同总价";
    [self.scrollView addSubview:totalLabel];
    
    _totalPriceTF = [[UITextField alloc]initWithFrame:CGRectMake(totalLabel.right+5, totalLabel.top, 60, totalLabel.height)];
    _totalPriceTF.font = [UIFont systemFontOfSize:12];
    _totalPriceTF.backgroundColor = [UIColor whiteColor];
    _totalPriceTF.keyboardAppearance = UIKeyboardTypeNumberPad;
    _totalPriceTF.returnKeyType = UIReturnKeyDone;
    _lastView = _totalPriceTF;
    if (self.detailDict) {
        _totalPriceTF.text = self.detailDict[@"subtotal"];
    }
    [self.scrollView addSubview:_totalPriceTF];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_totalPriceTF.right+3, _totalPriceTF.top, 20, _totalPriceTF.height)];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"元";
    [self.scrollView addSubview:label];
    
    NSDictionary *infoArray;
    if (self.detailDict) {
        infoArray = [NSString dictionaryWithJsonString:self.detailDict[@"info"]];
    }
    
    for (int i = 0; i < self.descripArray.count; i++) {
        NSString *typeStr = [self.descripArray[i] objectForKey:@"type"];
        NSString *titleStr = [self.descripArray[i] objectForKey:@"title"];
        NSString *formID = [self.descripArray[i] objectForKey:@"form_element_id"];
        NSString *meta = [self.descripArray[i] objectForKey:@"meta_data"];
        if (![NSString isBlankString:meta]) {
            NSDictionary *respond = [NSString dictionaryWithJsonString: meta];
            CGSize titleSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, _lastView.bottom+5, titleSize.width, 20)];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.text = titleStr;
            [self.scrollView addSubview:titleLabel];
            
            static NSString *result;
            NSArray *resultArray;
            if (infoArray.count >0) {
                for (NSDictionary *dict in infoArray) {
                    if ([dict[@"form_element_id"] isEqualToString:formID]) {
                        if ([dict[@"result"] isKindOfClass:[NSString class]]) {
                            result = dict[@"result"];
                        }else{
                            resultArray =dict[@"result"];
                        }
                        
                    }
                }
            }
            
            
            if ([typeStr isEqualToString:@"input_text"]) {
                if ([respond[@"max_lines"] integerValue] >1) {
                    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(titleLabel.right+5, titleLabel.top, SCREEN_WIDTH-titleLabel.right-10, 80)];
                    textView.font = [UIFont systemFontOfSize:11];
                    textView.tag = 100+i;
                    textView.text = result;
                    [self.scrollView addSubview:textView];
                    _lastView = textView;
                    
                }else{
                    UITextField *textFld = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right+5, titleLabel.top, SCREEN_WIDTH-titleLabel.right-10, titleLabel.height)];
                    textFld.delegate = self;
                    textFld.returnKeyType = UIReturnKeyDone;
//                    textFld.placeholder = [respond objectForKey:@"hint"];
                    textFld.font = [UIFont systemFontOfSize:11];
                    textFld.tag = 100+i;
                    textFld.text = result;
                    [self.scrollView addSubview:textFld];
                    _lastView = textFld;
                }
                
            }
            if ([typeStr isEqualToString:@"date_select"]) {
                UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, SCREEN_WIDTH-titleLabel.right-5, titleLabel.height)];
                textLable.text = [respond objectForKey:@"time"];
                textLable.font = [UIFont systemFontOfSize:12];
                textLable.tag = 100+i;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseDate:)];
                textLable.userInteractionEnabled = YES;
                [textLable addGestureRecognizer:tap];
                [self.scrollView addSubview:textLable];
                textLable.text = result;
                _lastView = textLable;
            }
            
            if ([typeStr isEqualToString:@"single_choice"]) {
                NSArray *optionsArray = [respond objectForKey:@"options"];
                for (int j = 0; j < optionsArray.count; j++) {
                    UIButton *singleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    singleBtn.frame = CGRectMake(titleLabel.right+3, _lastView.bottom+5, 16, 16);
                    [singleBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
                    [singleBtn addTarget:self action:@selector(clickSingleChooseButton:) forControlEvents:UIControlEventTouchUpInside];
                    singleBtn.tag = i*1000+j;
                    [self.scrollView addSubview:singleBtn];
                    if (result && [result integerValue] == j) {
                        [singleBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
                    }
                    
                    NSString *content = [optionsArray[j] objectForKey:@"choice_title"];
                    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(singleBtn.right+2, singleBtn.top+2, SCREEN_WIDTH-singleBtn.right-7, 0)];
                    contentLabel.font = [UIFont systemFontOfSize:12];
                    contentLabel.numberOfLines = 0;
                    contentLabel.text = content;
                    [contentLabel sizeToFit];
                    [self.scrollView addSubview:contentLabel];
                    _lastView = contentLabel;
                }
            }
            
            if ([typeStr isEqualToString:@"multi_choice"]) {
                NSArray *optionsArray = [respond objectForKey:@"options"];
                for (int j = 0; j < optionsArray.count; j++) {
                    UIButton *singleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    singleBtn.frame = CGRectMake(titleLabel.right+3, _lastView.bottom+5, 16, 16);
                    [singleBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
                    [singleBtn addTarget:self action:@selector(clickMultipleChooseButton:) forControlEvents:UIControlEventTouchUpInside];
                    singleBtn.tag = i*1000+j;
                    [self.scrollView addSubview:singleBtn];
                    
                    
                    NSString *content = [optionsArray[j] objectForKey:@"choice_title"];
                    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(singleBtn.right+2, singleBtn.top+2, SCREEN_WIDTH-singleBtn.right-7, 0)];
                    contentLabel.font = [UIFont systemFontOfSize:12];
                    contentLabel.numberOfLines = 0;
                    contentLabel.text = content;
                    [contentLabel sizeToFit];
                    [self.scrollView addSubview:contentLabel];
                    _lastView = contentLabel;
                }
            }
        }
        
        
        
        
    }
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _lastView.bottom+60);
}
//选择地址
- (void)chooseLocation {
    
    SWMyLocationController *myLocationController = [[SWMyLocationController alloc] init];
    myLocationController.delegate = self;
    [self.navigationController pushViewController:myLocationController animated:YES];
    
}

-(void)clickMyLocation:(NSString *)addressString
{
    self.addressTF.text = addressString;
}


//选择日期
-(void)clickDate:(UITapGestureRecognizer*)tap
{
    [self.payField resignFirstResponder];
    tag = ((UILabel*)tap.view).tag;
    [UIView beginAnimations:nil context:Nil];
    dateBackgroundView.top = SCREEN_HEIGHT - dateBackgroundView.height;
    datePicker.hidden = NO;
    [UIView commitAnimations];
}
//是否含税
- (void)selectYes:(UIButton *)sender {
    
    UIButton *noBtn = [self.scrollView viewWithTag:2];
    
    sender.selected = !sender.isSelected;
    
    if(sender.isSelected) {
        
        noBtn.selected = NO;
        
    }
}
- (void)selectNo:(UIButton *)sender {
    
    UIButton *yesBtn = [self.scrollView viewWithTag:1];
    
    sender.selected = !sender.isSelected;
    
    if(sender.isSelected) {
        
        yesBtn.selected = NO;
        
    }
    
}


//预览
-(void)previewContact
{
    if (self.is_save) {
         [self savaDrafts:NO];
    }else{
        UIButton *yesBtn = [self.scrollView viewWithTag:1];
        UIButton *noBtn = [self.scrollView viewWithTag:2];
        static NSInteger is_tax;
        is_tax = 0;
        if(yesBtn.isSelected) {
            
            is_tax = 1;
            
        }
        if(noBtn.isSelected) {
            
            is_tax = 2;
            
        }
        if ([NSString isBlankString:self.contractTitleTextfield.text]) {
            [WFHudView showMsg:@"请输入合同名称" inView:self.scrollView];
            return;
        }
        if ([NSString isBlankString:self.startTimeLbl.text]) {
            [WFHudView showMsg:@"请选择开始时间" inView:self.scrollView];
            return;
        }
        if ([NSString isBlankString:self.finishedTimeLbl.text]) {
            [WFHudView showMsg:@"请选择结束时间" inView:self.scrollView];
            return;
        }
        if ([NSString isBlankString:self.addressTF.text]) {
            [WFHudView showMsg:@"请输入工程地址" inView:self.scrollView];
            return;
        }
        if ([NSString isBlankString:self.totalPriceTF.text]) {
            [WFHudView showMsg:@"请输入合同总价" inView:self.scrollView];
            return;
        }
        NSDictionary *paramdict = @{@"is_tax":@(is_tax),
                                    @"subtotal":self.totalPriceTF.text,
                                    @"info":self.paramArray,
                                    @"type_id":self.contractTypeID,
                                    @"develop_start_time":self.startTimeLbl.text,
                                    @"develop_end_time":self.finishedTimeLbl.text,
                                    @"information_address":self.addressTF.text};
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"app_token"];
        NSString *uid =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
        NSString *urlString = [NSString stringWithFormat:@"%@/index.php/Mobile/Find/show_form?skey=%@&skey_uid=%@&is_tax=%li&subtotal=%@&info=%@&type_id=%@&develop_start_time=%@&develop_end_time=%@&information_address=%@",API_HOST,token,uid,is_tax,self.totalPriceTF.text,[NSString dictionaryToJson:self.paramArray],self.contractTypeID,self.startTimeLbl.text,self.finishedTimeLbl.text,self.addressTF.text];
        
        WebViewController *web = [WebViewController new];
        web.urlStr = urlString;
        web.title = @"合同详情";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
    
    
    
}

#pragma mark 提交

-(void)uploadContract
{
    for (int i = 0; i < self.descripArray.count; i++) {
        NSString *typeStr = [self.descripArray[i] objectForKey:@"type"];
        NSString *titleStr = [self.descripArray[i] objectForKey:@"title"];
        NSDictionary *respond = [NSString dictionaryWithJsonString:[self.descripArray[i] objectForKey:@"meta_data"]];
        static NSString *inputStr ;
        if ([typeStr isEqualToString:@"input_text"]) {
            if ([respond[@"max_lines"] integerValue] >1) {
                UITextView *textview = (UITextView*)[self.scrollView viewWithTag:i];
                inputStr = textview.text;
            }else{
                UITextField *textField = (UITextField*)[self.scrollView viewWithTag:100+i];
                inputStr = textField.text;
            }
            if (inputStr.length == 0) {
                [WFHudView showMsg:[NSString stringWithFormat:@"请输入%@",titleStr] inView:self.scrollView];
                return;
            }
            [_paramArray addObject:@{@"form_element_id":[self.descripArray[i] objectForKey:@"form_element_id"],@"result":inputStr}];
        }
        if ([typeStr isEqualToString:@"date_select"]) {
            UILabel *dateLabel = (UILabel *)[self.scrollView viewWithTag:100+i];
            inputStr = dateLabel.text;
            if (inputStr.length == 0) {
                [WFHudView showMsg:[NSString stringWithFormat:@"请输入%@",titleStr] inView:self.scrollView];
                return;
            }
            [_paramArray addObject:@{@"form_element_id":[self.descripArray[i] objectForKey:@"form_element_id"],@"result":inputStr}];
        }
        
        if ([typeStr isEqualToString:@"single_choice"]) {
            NSArray *optionsArray = [respond objectForKey:@"options"];
            for (int j = 0; j < optionsArray.count; j++) {
                UIButton *selectButn = [self.scrollView viewWithTag:i*1000+j];
                UIImage *tempImage = [UIImage imageNamed:@"select"];
                NSData *tempData = UIImagePNGRepresentation(tempImage);
                UIImage *image = [selectButn imageForState:UIControlStateNormal];
                NSData *imageData = UIImagePNGRepresentation(image);
                if ([tempData isEqual:imageData]) {
                    [_paramArray addObject:@{@"form_element_id":[self.descripArray[i] objectForKey:@"form_element_id"],@"result":@(j)}];
                }
            }
        }
        
        if ([typeStr isEqualToString:@"multi_choice"]) {
            NSArray *optionsArray = [respond objectForKey:@"options"];
            NSMutableArray *resultArray = [NSMutableArray array];
            for (int j = 0; j < optionsArray.count; j++) {
                UIButton *selectButn = [self.scrollView viewWithTag:i*1000+j];
                UIImage *tempImage = [UIImage imageNamed:@"select"];
                NSData *tempData = UIImagePNGRepresentation(tempImage);
                UIImage *image = [selectButn imageForState:UIControlStateNormal];
                NSData *imageData = UIImagePNGRepresentation(image);
                if ([tempData isEqual:imageData]) {
                    [resultArray addObject:@(j)];
                }
            }
            if (resultArray.count == 0) {
                [WFHudView showMsg:[NSString stringWithFormat:@"请选择%@",titleStr] inView:self.scrollView];
                return;
            }
            [_paramArray addObject:@{@"form_element_id":[self.descripArray[i] objectForKey:@"form_element_id"],@"result":resultArray}];
        }
    }
    
    UIButton *yesBtn = [self.scrollView viewWithTag:1];
    UIButton *noBtn = [self.scrollView viewWithTag:2];
    NSInteger is_tax = 0;
    if(yesBtn.isSelected) {
        
        is_tax = 1;
        
    }
    if(noBtn.isSelected) {
        
        is_tax = 2;
    }
    
    if ([NSString isBlankString:self.contractTitleTextfield.text]) {
        [WFHudView showMsg:@"请输入合同名称" inView:self.scrollView];
        return;
    }
    if ([NSString isBlankString:self.startTimeLbl.text]) {
        [WFHudView showMsg:@"请选择开始时间" inView:self.scrollView];
        return;
    }
    if ([NSString isBlankString:self.finishedTimeLbl.text]) {
        [WFHudView showMsg:@"请选择结束时间" inView:self.scrollView];
        return;
    }
    if ([NSString isBlankString:self.addressTF.text]) {
        [WFHudView showMsg:@"请输入工程地址" inView:self.scrollView];
        return;
    }
    if ([NSString isBlankString:self.totalPriceTF.text]) {
        [WFHudView showMsg:@"请输入合同总价" inView:self.scrollView];
        return;
    }
    if (self.isCompany == YES) {
        
        NSDictionary *paramdict = @{@"uid":self.uid,
                                    @"worker_id":self.workID,
                                    @"company_id":self.company,
                                    @"is_tax":@(is_tax),
                                    @"subtotal":self.totalPriceTF.text,
                                    @"info":[NSString dictionaryToJson:self.paramArray],
                                    @"contract_id":self.contractTypeID,
                                    @"contract_name":self.contractTitleTextfield.text,
                                    @"contract_begin_time":self.startTimeLbl.text,
                                    @"contract_end_time":self.finishedTimeLbl.text,
                                    @"contract_address":self.addressTF.text};
        SignNameViewController *signVC = [[SignNameViewController alloc]init];
        signVC.paraDict = paramdict;
        signVC.isWorker = NO;
        signVC.isCompany = YES;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: signVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else{
        if (self.isBack == YES) {
            NSDictionary *paramdict = @{@"uid":self.uid,
                                        @"company_id":self.company,
                                        @"worker_id":self.workID,
                                        @"is_tax":@(is_tax),
                                        @"subtotal":self.totalPriceTF.text,
                                        @"info":[NSString dictionaryToJson:self.paramArray],
                                        @"contract_id":self.contractID,
                                        @"contract_name":self.contractTitleTextfield.text,
                                        @"contract_begin_time":self.startTimeLbl.text,
                                        @"contract_end_time":self.finishedTimeLbl.text,
                                        @"contract_address":self.addressTF.text};
            if (self.isCompany == YES) {
                [[NetworkSingletion sharedManager]updateCompanyContract:paramdict onSucceed:^(NSDictionary *dict) {
                    //            NSLog(@"****%@",dict);
                    if ([dict[@"code"] integerValue ] == 0) {
                        [MBProgressHUD showSuccess:@"修改成功" toView:self.scrollView];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [MBProgressHUD showError:dict[@"message"] toView:self.scrollView];
                    }
                } OnError:^(NSString *error) {
                    [MBProgressHUD showError:error toView:self.scrollView];
                }];
            }else{
                [[NetworkSingletion sharedManager]getModifyConstract:paramdict onSucceed:^(NSDictionary *dict) {
                    //            NSLog(@"****%@",dict);
                    if ([dict[@"code"] integerValue ] == 0) {
                        [MBProgressHUD showSuccess:@"修改成功" toView:self.scrollView];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [MBProgressHUD showError:dict[@"message"] toView:self.scrollView];
                    }
                } OnError:^(NSString *error) {
                    [MBProgressHUD showError:error toView:self.scrollView];
                }];
            }
            
            
        }else{
            NSDictionary *paramdict = @{@"uid":self.uid,
                                        @"worker_id":self.workID,
                                        @"is_tax":@(is_tax),
                                        @"subtotal":self.totalPriceTF.text,
                                        @"info":[NSString dictionaryToJson:self.paramArray],
                                        @"type_id":self.contractTypeID,
                                        @"information_id":self.information_id,
                                        @"contract_name":self.contractTitleTextfield.text,
                                        @"contract_begin_time":self.startTimeLbl.text,
                                        @"contract_end_time":self.finishedTimeLbl.text,
                                        @"contract_address":self.addressTF.text,
                                        };
            SignNameViewController *signVC = [[SignNameViewController alloc]init];
            signVC.paraDict = paramdict;
            signVC.isWorker = NO;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: signVC animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }
    }
    
}

-(void)savaDrafts:(BOOL)isShare;
{
    for (int i = 0; i < self.descripArray.count; i++) {
        NSString *typeStr = [self.descripArray[i] objectForKey:@"type"];
        NSString *titleStr = [self.descripArray[i] objectForKey:@"title"];
         NSString *meta = [self.descripArray[i] objectForKey:@"meta_data"];
        if (![NSString isBlankString:meta]) {
            NSDictionary *respond = [NSString dictionaryWithJsonString:meta];
            static NSString *inputStr ;
            if ([typeStr isEqualToString:@"input_text"]) {
                if ([respond[@"max_lines"] integerValue] >1) {
                    UITextView *textview = (UITextView*)[self.scrollView viewWithTag:i];
                    inputStr = textview.text;
                }else{
                    UITextField *textField = (UITextField*)[self.scrollView viewWithTag:100+i];
                    inputStr = textField.text;
                }
                if (inputStr.length == 0) {
                    [WFHudView showMsg:[NSString stringWithFormat:@"请输入%@",titleStr] inView:self.scrollView];
                    return;
                }
                [_paramArray addObject:@{@"form_element_id":[self.descripArray[i] objectForKey:@"form_element_id"],@"result":inputStr}];
            }
            if ([typeStr isEqualToString:@"date_select"]) {
                UILabel *dateLabel = (UILabel *)[self.scrollView viewWithTag:100+i];
                inputStr = dateLabel.text;
                if (inputStr.length == 0) {
                    [WFHudView showMsg:[NSString stringWithFormat:@"请输入%@",titleStr] inView:self.scrollView];
                    return;
                }
                [_paramArray addObject:@{@"form_element_id":[self.descripArray[i] objectForKey:@"form_element_id"],@"result":inputStr}];
            }
            
            if ([typeStr isEqualToString:@"single_choice"]) {
                NSArray *optionsArray = [respond objectForKey:@"options"];
                for (int j = 0; j < optionsArray.count; j++) {
                    UIButton *selectButn = [self.scrollView viewWithTag:i*1000+j];
                    UIImage *tempImage = [UIImage imageNamed:@"select"];
                    NSData *tempData = UIImagePNGRepresentation(tempImage);
                    UIImage *image = [selectButn imageForState:UIControlStateNormal];
                    NSData *imageData = UIImagePNGRepresentation(image);
                    if ([tempData isEqual:imageData]) {
                        [_paramArray addObject:@{@"form_element_id":[self.descripArray[i] objectForKey:@"form_element_id"],@"result":@(j)}];
                    }
                }
            }
            
            if ([typeStr isEqualToString:@"multi_choice"]) {
                NSArray *optionsArray = [respond objectForKey:@"options"];
                NSMutableArray *resultArray = [NSMutableArray array];
                for (int j = 0; j < optionsArray.count; j++) {
                    UIButton *selectButn = [self.scrollView viewWithTag:i*1000+j];
                    UIImage *tempImage = [UIImage imageNamed:@"select"];
                    NSData *tempData = UIImagePNGRepresentation(tempImage);
                    UIImage *image = [selectButn imageForState:UIControlStateNormal];
                    NSData *imageData = UIImagePNGRepresentation(image);
                    if ([tempData isEqual:imageData]) {
                        [resultArray addObject:@(j)];
                    }
                }
                if (resultArray.count == 0) {
                    [WFHudView showMsg:[NSString stringWithFormat:@"请选择%@",titleStr] inView:self.scrollView];
                    return;
                }
                [_paramArray addObject:@{@"form_element_id":[self.descripArray[i] objectForKey:@"form_element_id"],@"result":resultArray}];
            }
        }
        
    }
    
    UIButton *yesBtn = [self.scrollView viewWithTag:1];
    UIButton *noBtn = [self.scrollView viewWithTag:2];
    NSInteger is_tax = 0;
    if(yesBtn.isSelected) {
        
        is_tax = 1;
        
    }
    if(noBtn.isSelected) {
        
        is_tax = 2;
    }
    
    if ([NSString isBlankString:self.contractTitleTextfield.text]) {
        [WFHudView showMsg:@"请输入合同名称" inView:self.scrollView];
        return;
    }
    if ([NSString isBlankString:self.yifangTxtfield.text]) {
        [WFHudView showMsg:@"请输入乙方姓名" inView:self.scrollView];
        return;
    }
    if ([NSString isBlankString:self.startTimeLbl.text]) {
        [WFHudView showMsg:@"请选择开始时间" inView:self.scrollView];
        return;
    }
    if ([NSString isBlankString:self.finishedTimeLbl.text]) {
        [WFHudView showMsg:@"请选择结束时间" inView:self.scrollView];
        return;
    }
    if ([NSString isBlankString:self.addressTF.text]) {
        [WFHudView showMsg:@"请输入工程地址" inView:self.scrollView];
        return;
    }
    if ([NSString isBlankString:self.totalPriceTF.text]) {
        [WFHudView showMsg:@"请输入合同总价" inView:self.scrollView];
        return;
    }
    NSDictionary *paramdict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                @"is_tax":@(is_tax),
                                @"subtotal":self.totalPriceTF.text,
                                @"info":[NSString dictionaryToJson:self.paramArray],
                                @"contract_name":self.contractTitleTextfield.text,
                                @"contract_begin_time":self.startTimeLbl.text,
                                @"contract_end_time":self.finishedTimeLbl.text,
                                @"contract_address":self.addressTF.text,
                                @"type_id":self.contractTypeID,
                                @"b_name":self.yifangTxtfield.text,
                            };
    
    [[NetworkSingletion sharedManager]saveContractToDrafts:paramdict onSucceed:^(NSDictionary *dict) {
//                    NSLog(@"****%@",dict);
        if ([dict[@"code"] integerValue ] == 0) {
            if (isShare) {
                NSString *urlStr = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_draft?id=%li",API_HOST,[dict[@"data"] integerValue]];
                [self shareWithInfo:urlStr];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.scrollView];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.scrollView];
    }];
    
}

-(void)shareWithInfo:(NSString*)urlStr
{
    NSString *text = self.self.contractTitleTextfield.text;
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:[UIImage imageNamed:@"旭邦装饰名片 - 副本"]
                                        url:[NSURL URLWithString:urlStr]
                                      title:@"合同"
                                       type:SSDKContentTypeAuto];
    NSArray *shareList = @[@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeWechatSession)];
    //、分享（可以弹出我们的分享菜单和编辑界面）
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                                                     items:shareList
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           
                                                           switch (state) {
                                                               case SSDKResponseStateSuccess:
                                                               {
                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                                                       message:nil
                                                                                                                      delegate:nil
                                                                                                             cancelButtonTitle:@"确定"
                                                                                                             otherButtonTitles:nil];
                                                                   [alertView show];
                                                                   break;
                                                               }
                                                               case SSDKResponseStateFail:
                                                               {
                                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                                                  delegate:nil
                                                                                                         cancelButtonTitle:@"OK"
                                                                                                         otherButtonTitles:nil, nil];
                                                                   [alert show];
                                                                   break;
                                                               }
                                                               default:
                                                                   break;
                                                           }
                                                       }
                                             ];
    
    
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    
}

//确定
-(void)confirmContact
{
    if (self.is_save) {
         [self savaDrafts:YES];
    }else{
        [self uploadContract];
    }
}

#pragma mark 单选

-(void)clickSingleChooseButton:(UIButton*)button
{
    if (lastSelectedView) {
        [lastSelectedView setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    }
    [button setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    lastSelectedView = button;
}

#pragma mark 多选

-(void)clickMultipleChooseButton:(UIButton*)button
{
    UIImage *tempImage = [UIImage imageNamed:@"select"];
    NSData *tempData = UIImagePNGRepresentation(tempImage);
    UIImage *image = [button imageForState:UIControlStateNormal];
    NSData *imageData = UIImagePNGRepresentation(image);
    if ([tempData isEqual:imageData]) {
        [button setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    }
}

#pragma mark 选择日期

-(void)chooseDate:(UITapGestureRecognizer*)tap
{
    tag = tap.view.tag;
    [UIView beginAnimations:nil context:Nil];
    dateBackgroundView.top = SCREEN_HEIGHT - dateBackgroundView.height;
    datePicker.hidden = NO;
    [UIView commitAnimations];
}

- (void)cancelkClick
{
    [UIView beginAnimations:nil context:Nil];
    dateBackgroundView.top = SCREEN_HEIGHT;
    [UIView commitAnimations];
}

- (void)comfirmClick
{
    [UIView beginAnimations:nil context:Nil];
    
    dateBackgroundView.top = SCREEN_HEIGHT;
    
    [UIView commitAnimations];
    
    NSCalendar *calendar = datePicker.calendar;
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear |
    
    NSCalendarUnitMonth |
    
    NSCalendarUnitDay;
    
    comps = [calendar components:unitFlags fromDate:datePicker.date];
    
    NSInteger year = [comps year];
    
    NSInteger month = [comps month];
    
    NSInteger day = [comps day];
    
    NSString *datestr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day];
    //    NSLog(@"****%@",datestr);
    if (tag == 10) {
        self.startTimeLbl.text = datestr;
    }else if (tag ==20){
        self.finishedTimeLbl.text = datestr;
    }else{
        UILabel *textLabel = (UILabel*)[self.scrollView viewWithTag:tag];
        textLabel.text = datestr;
    }
    
}




#pragma  mark Data

-(void)loadContractType
{
    if (self.isCompany == YES) {
        [[NetworkSingletion sharedManager]getCompanyContractTypeList:nil onSucceed:^(NSDictionary *dict) {
//            NSLog(@"****%@",dict);
            if ([dict[@"code"] integerValue]==0) {
                self.contractTypeArray = [dict objectForKey:@"data"];
                [self.selectTableview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.selectWindow];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.selectWindow];
        }];
    }else{
        [[NetworkSingletion sharedManager]getConstractType:nil onSucceed:^(NSDictionary *dict) {

            if ([dict[@"code"] integerValue]==0) {
                self.contractTypeArray = [dict objectForKey:@"data"];
                [self.selectTableview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.selectWindow];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.selectWindow];
        }];
    }
    
}

//获取合同规范描述
-(void)loadContractDescription
{
    //    NSLog(@"***%@",self.contractTypeID);
    [[NetworkSingletion sharedManager]getConstractDescription:@{@"id":self.contractTypeID} onSucceed:^(NSDictionary *dict) {
        
        NSLog(@"***description**%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            self.descripArray = [dict objectForKey:@"data"];
            [self setContractDescriptionView];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.selectWindow];
        }
        
        
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
    
}


#pragma  mark UITableView Delegate & DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contractTypeArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.contractTypeArray.count > 0) {
        cell.textLabel.text = [self.contractTypeArray[indexPath.row] objectForKey:@"contract_name"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = @"请选择合同类型";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    return titleLabel;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.contractTypeArray.count > 0) {
        NSDictionary *dict = self.contractTypeArray[indexPath.row];
        if (self.isCompany) {
            self.contractTypeID = dict[@"contract_type_id"];
            [self.selectWindow resignKeyWindow];
            self.selectWindow.hidden = YES;
            [self loadContractDescription];
        }else{
            self.contractTypeID = dict[@"contract_type_id"];
            [self.selectWindow resignKeyWindow];
            self.selectWindow.hidden = YES;
            [self loadContractDescription];
        }

    }
    
}

#pragma mark UITextfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark get/set
-(NSMutableArray*)paramArray
{
    if (!_paramArray) {
        _paramArray = [NSMutableArray array];
    }
    return _paramArray;
}

@end
