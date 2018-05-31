//
//  ToPayViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/1/26.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "ToPayViewController.h"
#import "CXZ.h"
#import "MoreFilesView.h"
#import "SWAlipay.h"
#import "PayRecordsViewController.h"

@interface ToPayViewController ()<UITextViewDelegate>

@property(nonatomic, strong) UIScrollView *bgScrollView;

@property(nonatomic, strong) UITextField *pay_basis_textfield;//付款依据

@property(nonatomic, strong) UITextField *account_name_textfield;//账户名

@property(nonatomic, strong) UITextField *account_number_textfield;//账号

@property(nonatomic, strong) UITextField *account_address_textfield;//开户行

@property(nonatomic, strong) UITextField *alipay_account_textfield;//支付宝账号

@property(nonatomic, strong) UITextField *phone_textfield;//手机号

@property(nonatomic, strong) UITextField *total_money_textfield;//总金额

@property(nonatomic, strong) UITextField *already_pay_textfield;//已付款金额

@property(nonatomic, strong) UITextField *this_time_pay_textfield;//本次付款

@property(nonatomic, strong) UITextView *pay_content_textview;//付款内容

@property(nonatomic, strong) UIButton *more_list_button;//更多记录

@property(nonatomic, strong) UIView *pay_type_view;//付款方式

@property(nonatomic, strong) RTLabel *reality_money_label;//实际付款金额

@property(nonatomic, strong) UIView *lastView;

@property(nonatomic, strong) UIView *line100;

@property(nonatomic, strong) MoreFilesView *moreFilesView;

@property(nonatomic, strong) UIButton *submitButton;//更多记录

@property(nonatomic, assign) NSInteger payType;//100 支付宝 101 其他

@property(nonatomic, copy) NSString* screenboot_image_id;//

@end

@implementation ToPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"发工资" withColor:[UIColor whiteColor]];
    [self setupNextWithString:@"账单" withColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self config];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark Systom Method
-(void)onBack
{
    [self.moreFilesView removeObserver:self forKeyPath:@"height"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onNext
{
    PayRecordsViewController *recordsVC = [[PayRecordsViewController alloc]init];
    recordsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recordsVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}



#pragma mark IBAction

-(void)clickPaymentBasisButton:(UIButton*)button
{
    PayRecordsViewController *recordsVC = [[PayRecordsViewController alloc]init];
    recordsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recordsVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

-(void)clickMoreListButton
{
    
    if (self.phone_textfield.text.length < 1) {
        [WFHudView showMsg:@"请输入对方手机号" inView:self.view];
        return;
    }else{
        PayRecordsViewController *recordsVC = [[PayRecordsViewController alloc]init];
        recordsVC.phone = self.phone_textfield.text;
        recordsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:recordsVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
   
}

-(void)clickPayTypeButton:(UIButton*)button
{
 
    NSInteger tag = button.tag;
   
   
    if (tag == 100) {
        if ([NSString isBlankString:self.this_time_pay_textfield.text]) {
            [WFHudView showMsg:@"请输入本次付款金额" inView:self.view];
            return;
        }else{
             button.selected = !button.isSelected;
            CGFloat money = [self.this_time_pay_textfield.text floatValue];
            NSString *realityMoney = [NSString stringWithFormat:@"%.2f元",(money+money*0.61/100)];
            self.reality_money_label.text = [self.reality_money_label.text stringByAppendingString:realityMoney];
        }
        UIButton *otherBtn = [_bgScrollView viewWithTag:101];
        if(button.isSelected) {
            otherBtn.selected = NO;
        }
        _line100.hidden = NO;
        _reality_money_label.hidden = NO;
        _moreFilesView.hidden = YES;
        [_submitButton setTitle:@"去付款" forState:UIControlStateNormal];
         self.payType = 1;
    }else if (tag == 101){
        button.selected = !button.isSelected;
        UIButton *otherBtn = [_bgScrollView viewWithTag:100];
        if(button.isSelected) {
            otherBtn.selected = NO;
        }
        
        _line100.hidden = NO;
        _reality_money_label.hidden = YES;
        _moreFilesView.hidden = NO;
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        self.payType = 3;
        
    }
}

-(void)clickSubmitButton
{
    if ([NSString isBlankString:self.pay_content_textview.text]) {
        [WFHudView showMsg:@"请输入付款内容" inView:self.view];
        return;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear |
    
    NSCalendarUnitMonth |
    
    NSCalendarUnitDay;
    
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSInteger year = [comps year];
    
    NSInteger month = [comps month];
    
    if (self.payType == 1) {
        
        NSDictionary *paramDict = @{@"alipay_id":self.alipay_account_textfield.text,
                                    @"phone":self.phone_textfield.text,
                                    @"body":self.pay_content_textview.text,
                                    @"money":self.total_money_textfield.text,
                                    @"pay_paid":self.this_time_pay_textfield.text,
                                    @"pay_type":@(self.payType),
                                    @"year":@(year),@"month":@(month)};
        self.submitButton.userInteractionEnabled = NO;
        [[NetworkSingletion sharedManager]toPayAndRecord:paramDict onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue ]== 0) {
                SWAlipay *pay = [SWAlipay new];
                NSString *payStr = dict[@"data"];
                [pay payToStr:payStr];
            }else{
                self.submitButton.userInteractionEnabled = YES;
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            self.submitButton.userInteractionEnabled = YES;
             [MBProgressHUD showError:error toView:self.view];
        }];
    }else if (self.payType == 3){
        NSMutableArray *hushArray = [NSMutableArray array];
        if (self.moreFilesView.imgArray.count > 0) {
            for (int i = 0; i < self.moreFilesView.imgArray.count; i++) {
                UploadImageModel *imgView = self.moreFilesView.imgArray[i];
                if ([NSString isBlankString:imgView.hashString]) {
                    [WFHudView showMsg:@"图片正在上传中，请稍后提交.." inView:self.view];
                    return;
                }
                [hushArray addObject:imgView.hashString];
                
            }
            [self uploadPhotos:hushArray];
        }else{
            [WFHudView showMsg:@"请上传付款截图" inView:self.view];
            return;
        }

    }
    
}

//上传附件
-(void)uploadPhotos:(NSMutableArray*)hashArray
{
    NSString *hashStr = [NSString dictionaryToJson:hashArray];
    [[NetworkSingletion sharedManager]updateReviewAnnexNew:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"picture":hashStr} onSucceed:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        if ([dict[@"code"] integerValue]==0) {
            self.screenboot_image_id = [dict[@"data"] objectForKey:@"enclosure_id"];
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
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear |
    
    NSCalendarUnitMonth |
    
    NSCalendarUnitDay;
    
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSInteger year = [comps year];
    
    NSInteger month = [comps month];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSDictionary *paramDict = @{@"alipay_id":self.alipay_account_textfield.text,
                                @"phone":self.phone_textfield.text,
                                @"body":self.pay_content_textview.text,
                                @"money":self.total_money_textfield.text,
                                @"pay_paid":self.this_time_pay_textfield.text,
                                @"pay_type":@(self.payType),
                                @"year":@(year),@"month":@(month)};
    [param addEntriesFromDictionary:paramDict];
    
    if (![NSString isBlankString:self.screenboot_image_id]) {
        [param setObject:self.screenboot_image_id forKey:@"basis"];
    }
    self.submitButton.userInteractionEnabled = NO;
    [[NetworkSingletion sharedManager]toPayAndRecord:param onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue ]== 0) {
            [self.moreFilesView removeObserver:self forKeyPath:@"height"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            self.submitButton.userInteractionEnabled = YES;
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        self.submitButton.userInteractionEnabled = YES;
        [MBProgressHUD showError:error toView:self.view];
    }];
    
}



#pragma mark Private method

-(void)config
{
    _bgScrollView = [[UIScrollView alloc]init];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_bgScrollView];
    _bgScrollView.bounces = NO;
    [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    
//    //------
//    NSString *title = @"付款依据：";
//    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
//    UILabel *titleLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:title];
//    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(8);
//        make.top.mas_equalTo(0);
//        make.width.mas_equalTo(titleSize.width+1);
//        make.height.mas_equalTo(30);
//    }];
//    _lastView = titleLbl;
//    
//    CGFloat buttonWidth = (SCREEN_WIDTH-titleSize.width-10)/3;
//    NSArray *titleArray = @[@"请款单",@"报销单",@"其他"];
//    for (int i = 0; i < 3; i++) {
//        UIButton *button = [CustomView customButtonWithContentView:_bgScrollView image:@"dow_unselect" title:titleArray[i]];
//        button.tag = i;
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(_lastView.mas_right);
//            make.top.mas_equalTo(_lastView.mas_top);
//            make.width.mas_equalTo(buttonWidth);
//            make.height.mas_equalTo(30);
//        }];
//        [button addTarget:self action:@selector(clickPaymentBasisButton:) forControlEvents:UIControlEventTouchUpInside];
//        _lastView = button;
//    }
//    
//    UIView *line0 = [CustomView customLineView:_bgScrollView];
//    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(8);
//        make.top.mas_equalTo(titleLbl.mas_bottom);
//        make.width.mas_equalTo(SCREEN_WIDTH-9);
//        make.height.mas_equalTo(1);
//    }];
    
//    NSString *name = @"账户名：";
//    CGSize nameSize = [name sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
//    UILabel *nameLabel = [CustomView customTitleUILableWithContentView:_bgScrollView title:name];
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(8);
//        make.top.mas_equalTo(line0.mas_bottom);
//        make.width.mas_equalTo(nameSize.width+1);
//        make.height.mas_equalTo(30);
//    }];
//    
//    _account_name_textfield = [CustomView customUITextFieldWithContetnView:_bgScrollView placeHolder:nil];
//    [_account_name_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(nameLabel.mas_right);
//        make.top.mas_equalTo(nameLabel.mas_top);
//        make.width.mas_equalTo(SCREEN_WIDTH-nameSize.width-9);
//        make.height.mas_equalTo(30);
//    }];
//    _account_name_textfield.textAlignment = NSTextAlignmentLeft;
//    
//    UIView *line1 = [CustomView customLineView:_bgScrollView];
//    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(8);
//        make.top.mas_equalTo(_account_name_textfield.mas_bottom);
//        make.width.mas_equalTo(line0.mas_width);
//        make.height.mas_equalTo(1);
//    }];
//    
//    
//    
//    NSString *number = @"账号：";
//    CGSize numberSize = [number sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
//    UILabel *numberLabel = [CustomView customTitleUILableWithContentView:_bgScrollView title:number];
//    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(8);
//        make.top.mas_equalTo(line1.mas_bottom);
//        make.width.mas_equalTo(numberSize.width+1);
//        make.height.mas_equalTo(30);
//    }];
//    
//    _account_number_textfield = [CustomView customUITextFieldWithContetnView:_bgScrollView placeHolder:nil];
//    [_account_number_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(numberLabel.mas_right);
//        make.top.mas_equalTo(numberLabel.mas_top);
//        make.width.mas_equalTo(SCREEN_WIDTH-numberSize.width-9);
//        make.height.mas_equalTo(30);
//    }];
//    _account_number_textfield.textAlignment = NSTextAlignmentLeft;
//    
//    UIView *line2 = [CustomView customLineView:_bgScrollView];
//    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(8);
//        make.top.mas_equalTo(_account_number_textfield.mas_bottom);
//        make.width.mas_equalTo(line0.mas_width);
//        make.height.mas_equalTo(1);
//    }];
//    
//    
//    
//    NSString *account_address = @"开户行：";
//    CGSize addressSize = [account_address sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
//    UILabel *addressLabel = [CustomView customTitleUILableWithContentView:_bgScrollView title:account_address];
//    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(8);
//        make.top.mas_equalTo(line2.mas_bottom);
//        make.width.mas_equalTo(addressSize.width+1);
//        make.height.mas_equalTo(30);
//    }];
//    
//    _account_address_textfield = [CustomView customUITextFieldWithContetnView:_bgScrollView placeHolder:nil];
//    [_account_address_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(addressLabel.mas_right);
//        make.top.mas_equalTo(addressLabel.mas_top);
//        make.width.mas_equalTo(SCREEN_WIDTH-addressSize.width-9);
//        make.height.mas_equalTo(30);
//    }];
//    _account_address_textfield.textAlignment = NSTextAlignmentLeft;
//    
//    UIView *line3 = [CustomView customLineView:_bgScrollView];
//    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(8);
//        make.top.mas_equalTo(_account_address_textfield.mas_bottom);
//        make.width.mas_equalTo(line0.mas_width);
//        make.height.mas_equalTo(1);
//    }];
    
    
    NSString *alipay = @"*支付宝账号：";
    CGSize alipaySize = [alipay sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *alipayLabel = [CustomView customTitleUILableWithContentView:_bgScrollView title:alipay];
    [alipayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(alipaySize.width+1);
        make.height.mas_equalTo(30);
    }];
    
    _alipay_account_textfield = [CustomView customUITextFieldWithContetnView:_bgScrollView placeHolder:@"请输入正确的支付宝账号"];
    [_alipay_account_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(alipayLabel.mas_right);
        make.top.mas_equalTo(alipayLabel.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH-alipayLabel.width-9);
        make.height.mas_equalTo(30);
    }];
    _alipay_account_textfield.textAlignment = NSTextAlignmentLeft;
    
    UIView *line0 = [CustomView customLineView:_bgScrollView];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_alipay_account_textfield.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(1);
    }];
    
    
    NSString *phone = @"*手机号码：";
    CGSize phoneSize = [phone sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *phoneLabel = [CustomView customTitleUILableWithContentView:_bgScrollView title:phone];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line0.mas_bottom);
        make.width.mas_equalTo(phoneSize.width+1);
        make.height.mas_equalTo(30);
    }];
    
    _phone_textfield = [CustomView customUITextFieldWithContetnView:_bgScrollView placeHolder:nil];
    [_phone_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLabel.mas_right);
        make.top.mas_equalTo(phoneLabel.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH-phoneSize.width-9);
        make.height.mas_equalTo(30);
    }];
    _phone_textfield.textAlignment = NSTextAlignmentLeft;
    _phone_textfield.keyboardType = UIKeyboardTypePhonePad;
    
    UIView *line4 = [CustomView customLineView:_bgScrollView];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_phone_textfield.mas_bottom);
        make.width.mas_equalTo(line0.mas_width);
        make.height.mas_equalTo(1);
    }];

    NSString *content = @"付款内容：";
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *contentLabel = [CustomView customTitleUILableWithContentView:_bgScrollView title:content];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line4.mas_bottom);
        make.width.mas_equalTo(contentSize.width+1);
        make.height.mas_equalTo(30);
    }];
    
    _pay_content_textview = [CustomView customUITextViewWithContetnView:_bgScrollView placeHolder:nil];
    [_pay_content_textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentLabel.mas_right);
        make.top.mas_equalTo(contentLabel.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH-contentSize.width-9);
        make.height.mas_equalTo(30);
    }];
    _pay_content_textview.delegate = self;
    
    UIView *line5 = [CustomView customLineView:_bgScrollView];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_pay_content_textview.mas_bottom);
        make.width.mas_equalTo(line0.mas_width);
        make.height.mas_equalTo(1);
    }];
    
    
    
    NSString *total = @"总金额：";
    CGSize totalSize = [total sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *totalLabel = [CustomView customTitleUILableWithContentView:_bgScrollView title:total];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line5.mas_bottom);
        make.width.mas_equalTo(totalSize.width+1);
        make.height.mas_equalTo(30);
    }];
    
    _total_money_textfield = [CustomView customUITextFieldWithContetnView:_bgScrollView placeHolder:nil];
    [_total_money_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(totalLabel.mas_right);
        make.top.mas_equalTo(totalLabel.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH-totalSize.width-9);
        make.height.mas_equalTo(30);
    }];
    _total_money_textfield.textAlignment = NSTextAlignmentLeft;
    _total_money_textfield.keyboardType = UIKeyboardTypeDecimalPad;
    
    UIView *line7 = [CustomView customLineView:_bgScrollView];
    [line7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_total_money_textfield.mas_bottom);
        make.width.mas_equalTo(line0.mas_width);
        make.height.mas_equalTo(1);
    }];
    
//    NSString *already = @"已付金额：";
//    CGSize alreadySize = [already sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
//    UILabel *alreadyLabel = [CustomView customTitleUILableWithContentView:_bgScrollView title:already];
//    [alreadyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(8);
//        make.top.mas_equalTo(line7.mas_bottom);
//        make.width.mas_equalTo(alreadySize.width+1);
//        make.height.mas_equalTo(30);
//    }];
//    
//    _already_pay_textfield = [CustomView customUITextFieldWithContetnView:_bgScrollView placeHolder:nil];
//    [_already_pay_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(alreadyLabel.mas_right);
//        make.top.mas_equalTo(alreadyLabel.mas_top);
//        make.width.mas_equalTo(SCREEN_WIDTH-alreadySize.width-9);
//        make.height.mas_equalTo(30);
//    }];
//    _already_pay_textfield.textAlignment = NSTextAlignmentLeft;
//    
//    UIView *line8 = [CustomView customLineView:_bgScrollView];
//    [line8 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(8);
//        make.top.mas_equalTo(_already_pay_textfield.mas_bottom);
//        make.width.mas_equalTo(line0.mas_width);
//        make.height.mas_equalTo(1);
//    }];
    
    NSString *this = @"本次付款金额：";
    CGSize thisSize = [this sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *thisLabel = [CustomView customTitleUILableWithContentView:_bgScrollView title:this];
    [thisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line7.mas_bottom);
        make.width.mas_equalTo(thisSize.width+1);
        make.height.mas_equalTo(30);
    }];
    
    _this_time_pay_textfield = [CustomView customUITextFieldWithContetnView:_bgScrollView placeHolder:nil];
    [_this_time_pay_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(thisLabel.mas_right);
        make.top.mas_equalTo(thisLabel.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH-thisSize.width-9);
        make.height.mas_equalTo(30);
    }];
    _this_time_pay_textfield.keyboardType = UIKeyboardTypeDecimalPad;
    _this_time_pay_textfield.textAlignment = NSTextAlignmentLeft;
    
    UIView *line9 = [CustomView customLineView:_bgScrollView];
    [line9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_this_time_pay_textfield.mas_bottom);
        make.width.mas_equalTo(line0.mas_width);
        make.height.mas_equalTo(1);
    }];
    
    NSString *payType = @"付款方式：";
    CGSize payTypeSize = [payType sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *payTypeLbl = [CustomView customTitleUILableWithContentView:_bgScrollView title:payType];
    [payTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line9.mas_bottom);
        make.width.mas_equalTo(payTypeSize.width+1);
        make.height.mas_equalTo(30);
    }];
    _lastView = payTypeLbl;
    
    CGFloat paybuttonWidth = (SCREEN_WIDTH-payTypeSize.width-10)/2;
    NSArray *payArray = @[@"支付宝",@"其他"];
    for (int i = 0; i < payArray.count; i++) {
        UIButton *button = [CustomView customButtonWithContentView:_bgScrollView image:@"dow_unselect" title:payArray[i]];
        [button setImage:[UIImage imageNamed:@"dow_select"] forState:UIControlStateSelected];
        button.tag = i+100;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_lastView.mas_right);
            make.top.mas_equalTo(_lastView.mas_top);
            make.width.mas_equalTo(paybuttonWidth);
            make.height.mas_equalTo(30);
        }];
        [button setTitleColor:UIColorFromRGB(152, 152, 152) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickPayTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        _lastView = button;
    }
    
    UIView *line6 = [CustomView customLineView:_bgScrollView];
    [line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(payTypeLbl.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-9);
        make.height.mas_equalTo(1);
    }];

    
    _more_list_button = [CustomView customButtonWithContentView:_bgScrollView image:nil title:@"更多记录"];
    [_more_list_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line6.mas_bottom);
        make.width.mas_equalTo(line0.mas_width);
        make.height.mas_equalTo(40);
    }];
//    [_more_list_button setTitleColor:[UIColor colorWithHexString:@"#0000ff"] forState:UIControlStateNormal];
    [_more_list_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _more_list_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_more_list_button addTarget:self action:@selector(clickMoreListButton) forControlEvents:UIControlEventTouchUpInside];
    _lastView = _more_list_button;
    
    
    _line100 = [CustomView customLineView:_bgScrollView];
    _line100.hidden = YES;
    [_line100 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_more_list_button.mas_bottom);
        make.width.mas_equalTo(line0.mas_width);
        make.height.mas_equalTo(1);
    }];
    
   
    _reality_money_label = [CustomView customRTLableWithContentView:_bgScrollView title:nil];
    [_reality_money_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_line100.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(60);
    }];
//    _reality_money_label.textAlignment = NSTextAlignmentRight;
    _reality_money_label.text = @"<font size=12 color=\"#7f7f7f\">支付宝平台将收取0.61%的手续费</font><br><font size=12 color=\"#7f7f7f\">实际付款金额：</font>";
    _reality_money_label.hidden = YES;
    
    _moreFilesView = [[MoreFilesView alloc]initWithFrame:CGRectMake(8, _line100.bottom, SCREEN_WIDTH-16, 30)];
    _moreFilesView.hidden = YES;
    [_bgScrollView addSubview:_moreFilesView];
    [_moreFilesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_line100.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(30);
    }];
    [_moreFilesView addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [_moreFilesView.addButton setTitle:@"上传付款截图" forState:UIControlStateNormal];
    
    
    _submitButton = [CustomView customButtonWithContentView:_bgScrollView image:nil title:@"去付款"];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_more_list_button.mas_bottom).mas_offset(120);
        make.width.mas_equalTo(line0.mas_width);
        make.height.mas_equalTo(40);
    }];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.backgroundColor = TOP_GREEN;
    _submitButton.layer.cornerRadius = 3;
    [_submitButton addTarget:self action:@selector(clickSubmitButton) forControlEvents:UIControlEventTouchUpInside];
   
 
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"height"] ) {
        CGFloat newHeight = [change[@"new"] floatValue];
        //        CGFloat oldMoney = [change[@"old"] floatValue];
        //        NSLog(@"**height*%lf",newHeight);
        CGRect frame = self.moreFilesView.frame;
        frame.size.height = newHeight;
        self.moreFilesView.frame = frame;
        [self.moreFilesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(newHeight);
        }];
       
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark UITextView Delegate

-(void)textViewDidChange:(UITextView *)textView
{
    NSString *content = @"付款内容：";
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    CGSize constraintSize = CGSizeMake(SCREEN_WIDTH-contentSize.width-1, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    CGFloat textHeight = size.height > 80 ? 80 :size.height;
    [textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textHeight);
    }];
}

@end
