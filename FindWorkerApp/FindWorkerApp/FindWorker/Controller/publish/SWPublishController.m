//
//  SWPublishController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/18.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWPublishController.h"

#import "CXZ.h"
#import "JXPopoverView.h"

#import "SWItemSelectView.h"

#import "SWPublishSuccessController.h"
#import "SignNameViewController.h"

#import "SWMyLocationController.h"

#import "SWWorkerTypeCmd.h"
#import "SWWorkerTypeInfo.h"
#import "SWWorkerTypeData.h"
#import "ComporationModel.h"

#import "SWWantWorker.h"


#define padding 10

@interface SWPublishController ()<UITextViewDelegate,SWItemSeleceDelegate>

@property (nonatomic, assign) BOOL isOtherViewInput; // 判断是不是其他备注输入

@property (nonatomic, assign) CGFloat otherViewY; //备注的Y

@property (nonatomic, assign) CGPoint origPoint;

@property (nonatomic, assign) BOOL isShow; //判断键盘是不是显示

@property (nonatomic, retain) UIScrollView *contentView;

@property (nonatomic, retain) UITextField *positionField;

@property (nonatomic, retain) UITextField *titleField;

@property (nonatomic, retain) UIButton *faceMoney;

@property (nonatomic, retain) UIButton *startTimeBtn;

@property (nonatomic, retain) UIButton *limitTimeBtn;

@property (nonatomic, retain) UITextView *otherView;

@property (nonatomic, retain) NSArray *workArr; //总共有多少工种

@property (nonatomic, retain) NSMutableArray *selectWorkerArr;

@property (nonatomic, retain) UITextField *moneyField;

@property (nonatomic, strong) UIButton *selectedCompanyButton;

@property (nonatomic, strong) RTLabel *tipLabel;

@property (nonatomic, strong) NSArray *companyArray;

@property (nonatomic, copy) NSString *companyID;

@end

@implementation SWPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    _selectWorkerArr = [NSMutableArray array];
    
    [self setupTitleWithString:@"发布工程" withColor:[UIColor whiteColor]];
    
    [self setupBackw];
    
    NSString *tip = @"需要加入/创建一个公司，才能发布工程哦~<br>加入公司：办公->申请加入<br>创建公司：办公->创建公司";
    _tipLabel = [CustomView customRTLableWithContentView:self.view title:tip];
    _tipLabel.frame = CGRectMake(0, 100, SCREEN_WIDTH, 200);
    _tipLabel.textAlignment =RTTextAlignmentCenter;
    [self.view addSubview:_tipLabel];
    _tipLabel.hidden = YES;;
    
    
    [self loadCompanyInfo];
//    [self setUpView];
    
    //添加键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyHidden) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyShow) name:UIKeyboardWillShowNotification object:nil];
    
}

-(void)loadCompanyInfo
{
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[NetworkSingletion sharedManager]getAllCorporationByUserID:@{@"uid":userid} onSucceed:^(NSDictionary *dict) {
//                NSLog(@"**all Company***%@",dict);
       
        if ([dict[@"code"]integerValue]==0) {
            _tipLabel.hidden = YES;
            NSArray *array = dict[@"data"];
            if (array.count > 0) {
                self.companyArray = [ComporationModel objectArrayWithKeyValuesArray:dict[@"data"]];
                [self loadData];
            }
           
        }else if([dict[@"code"]integerValue]==250){
            _tipLabel.hidden = NO;
            self.contentView.hidden = YES;
            [self.view bringSubviewToFront:_tipLabel];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];

}

//加载工种的信息
- (void)loadData {
    
    SWWorkerTypeCmd *typeCmd = [[SWWorkerTypeCmd alloc] init];
    typeCmd.type = 2;
    [[HttpNetwork getInstance] requestPOST:typeCmd success:^(BaseRespond *respond) {
        
        SWWorkerTypeInfo *typeInfo = [[SWWorkerTypeInfo alloc] initWithDictionary:respond.data];
        
        _workArr = [NSMutableArray arrayWithArray:typeInfo.data];
        self.contentView.hidden = NO;
        [self setUpView];
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        
        
    }];
    
}

- (void)keyShow {
    
    _isShow = YES;
    
}

- (void)keyHidden {
    
    _isShow = NO;
    
}

- (void)showKeyboard:(NSNotification *)notif {
    
    if(_isOtherViewInput) {
        if(_isShow) {
            
            NSDictionary *dic = notif.userInfo;
            CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
            
            if(keyboardRect.size.height > 250) {
                
                [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
                    
                    [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
                    
                    CGPoint offsetPoint = _origPoint;
                    offsetPoint.y -= (keyboardRect.origin.y - self.otherViewY);
                    self.contentView.contentOffset = offsetPoint;
                    
                    
                }];
                
            }
            
        }
        
    }
    
    
    
}

-(void)clickSelectedCompany
{
    if (self.companyArray.count>0) {
        JXPopoverView *popoverView = [JXPopoverView popoverView];
        popoverView.style = PopoverViewStyleDark;
        NSMutableArray *actionArray = [NSMutableArray array];
        
        for (int i = 0 ; i < self.companyArray.count; i++) {
            ComporationModel *company = self.companyArray[i];
            JXPopoverAction *action1 = [JXPopoverAction actionWithTitle:company.company_big_name handler:^(JXPopoverAction *action) {
                self.companyID = company.company_big_id;
                [self.selectedCompanyButton setTitle:[NSString stringWithFormat:@"公司：%@",company.company_big_name] forState:UIControlStateNormal];
            }];
            
            [actionArray addObject:action1];
        }
        [popoverView showToView:self.selectedCompanyButton withActions:actionArray];
    }

}

//设置界面
- (void)setUpView {
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame         = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    _contentView = contentView;
    
    //发布按钮
    UIButton *publishBtn = [[UIButton alloc] init];
    publishBtn.frame     = CGRectMake(0, SCREEN_HEIGHT - 40 - 64, SCREEN_WIDTH, 40);
    publishBtn.backgroundColor = [UIColor colorWithRed:0.50 green:0.75 blue:0.75 alpha:1.00];
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishClick:) forControlEvents:UIControlEventTouchUpInside];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:publishBtn];
    
     _selectedCompanyButton  = [CustomView customButtonWithContentView:contentView image:nil title:@"请选择公司"];
    _selectedCompanyButton.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, 40);
    _selectedCompanyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_selectedCompanyButton addTarget:self action:@selector(clickSelectedCompany) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(0, _selectedCompanyButton.bottom, SCREEN_WIDTH, 1.0)];
    line0.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [contentView addSubview:line0];
    
    //标题
    NSString *title = @"标题";
    
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, line0.bottom+10, titleSize.width, titleSize.height)];
    titleLbl.font     = [UIFont systemFontOfSize:12];
    titleLbl.textColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.21 alpha:1.00];
    titleLbl.text      = title;
    [contentView addSubview:titleLbl];
    
    
    UITextField *titleField  = [[UITextField alloc] init];
    titleField.frame         = CGRectMake(CGRectGetMaxX(titleLbl.frame) + 10, titleLbl.frame.origin.y, SCREEN_WIDTH - CGRectGetMaxX(titleLbl.frame) - 20, 15);
    titleField.font          = [UIFont systemFontOfSize:12];
    titleField.textAlignment = NSTextAlignmentRight;
    titleField.placeholder   = @"请输入标题";
    [contentView addSubview:titleField];
    _titleField = titleField;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _titleField.bottom+10, SCREEN_WIDTH, 1.0)];
    line.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [contentView addSubview:line];
    
    //工种
    NSString *job = @"工种选择";
    
    CGSize jobSize = [job sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *jobLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(line.frame) + (49 - jobSize.height) / 2, jobSize.width, jobSize.height)];
    jobLbl.font     = [UIFont systemFontOfSize:12];
    jobLbl.textColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.21 alpha:1.00];
    jobLbl.text      = job;
    [contentView addSubview:jobLbl];
    
//    NSArray *itemArr = @[@"水电工",@"水泥工",@"地暖工",@"油漆工",@"木    工",@"小      工"];
    
    //初始位置
    CGFloat x = 16;
    CGFloat y = CGRectGetMaxY(jobLbl.frame) + (49 - jobSize.height) / 2 - 10;
    CGFloat least_width = SCREEN_WIDTH; //剩余宽度
    CGFloat maxY = 0;
    
    for (SWWorkerTypeData *data in _workArr) {
        
        if(least_width == 0) {
        
            x = 16;
            y += 45;
            
        }
        
        SWItemSelectView *selectView = [[SWItemSelectView alloc] init];
        selectView.frame             = CGRectMake(x, y, 10, 40);
        selectView.selectViewDelegate = self;
        CGFloat width = [selectView showView:data];
        
        least_width = least_width - width;
        if(least_width <= 0) {
            
            x = 16;
            y += 45;
            
        }
        
        selectView.frame             = CGRectMake(x, y, width, 40);
        [contentView addSubview:selectView];
        
        x = CGRectGetMaxX(selectView.frame) + 10;
        
        least_width = SCREEN_WIDTH - CGRectGetMaxX(selectView.frame) - 16;
        maxY = CGRectGetMaxY(selectView.frame);
        
    }
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, maxY + (49 - titleSize.height) / 2, SCREEN_WIDTH, 1.0)];
    line1.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [contentView addSubview:line1];
    
    
    //预算
    //标题
    NSString *money = @"预算";
    
    CGSize moneySize = [money sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line1.frame) + (49 - moneySize.height) / 2, moneySize.width, moneySize.height)];
    moneyLbl.font     = [UIFont systemFontOfSize:12];
    moneyLbl.textColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.21 alpha:1.00];
    moneyLbl.text      = money;
    [contentView addSubview:moneyLbl];
    
    UIImage *dowImg = [UIImage imageNamed:@"dow_unselect"];
    UIButton *faceMoney = [[UIButton alloc] init];
    faceMoney.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    [faceMoney setImage:dowImg forState:UIControlStateNormal];
    [faceMoney setImage:[UIImage imageNamed:@"dow_select"] forState:UIControlStateSelected];
    [faceMoney setTitle:@"面议" forState:UIControlStateNormal];
    faceMoney.titleLabel.font = [UIFont systemFontOfSize:12];
    [faceMoney setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [faceMoney addTarget:self action:@selector(faceClick:) forControlEvents:UIControlEventTouchUpInside];
    [faceMoney sizeToFit];
    
    UITextField *moneyField  = [[UITextField alloc] init];
    moneyField.frame         = CGRectMake(CGRectGetMaxX(titleLbl.frame) + 10, moneyLbl.frame.origin.y, SCREEN_WIDTH - CGRectGetMaxX(moneyLbl.frame) - 20 - faceMoney.frame.size.width, 15);
    moneyField.font          = [UIFont systemFontOfSize:12];
    moneyField.textAlignment = NSTextAlignmentRight;
    moneyField.placeholder   = @"请输入预算";
    [contentView addSubview:moneyField];
    _moneyField = moneyField;
    
    faceMoney.frame = CGRectMake(CGRectGetMaxX(moneyField.frame) + 5, CGRectGetMaxY(line1.frame) + (49 - 12) / 2 - 2, 10, 10);
    [faceMoney sizeToFit];
    [contentView addSubview:faceMoney];
    _faceMoney = faceMoney;
    
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyField.frame) + (49 - moneySize.height) / 2, SCREEN_WIDTH, 1.0)];
    line3.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [contentView addSubview:line3];
    
    //地点
    NSString *address = @"地点";
    
    CGSize addressSize = [address sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line3.frame) + (49 - addressSize.height) / 2, addressSize.width, addressSize.height)];
    addressLbl.font     = [UIFont systemFontOfSize:12];
    addressLbl.textColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.21 alpha:1.00];
    addressLbl.text      = address;
    [contentView addSubview:addressLbl];
    
    UIImage *positionImg = [UIImage imageNamed:@"blue_position"];
    UIButton *positionBtn = [[UIButton alloc] init];
    [positionBtn setImage:positionImg forState:UIControlStateNormal];
    [positionBtn sizeToFit];
    
    UITextField *positionField  = [[UITextField alloc] init];
    positionField.frame         = CGRectMake(CGRectGetMaxX(titleLbl.frame) + 10, addressLbl.frame.origin.y, SCREEN_WIDTH - CGRectGetMaxX(addressLbl.frame) - 25 - positionBtn.frame.size.width, 15);
    positionField.font          = [UIFont systemFontOfSize:12];
    positionField.textAlignment = NSTextAlignmentRight;
    _positionField = positionField;
//    positionField.placeholder   = @"请输入预算";
    [contentView addSubview:positionField];
    
    positionBtn.frame = CGRectMake(CGRectGetMaxX(positionField.frame) + 5, CGRectGetMaxY(line3.frame) + (49 - 12) / 2 - 2, 10, 10);
    [positionBtn sizeToFit];
    [positionBtn addTarget:self action:@selector(chooseLocation) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:positionBtn];
    
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(positionField.frame) + (49 - moneySize.height) / 2, SCREEN_WIDTH, 1.0)];
    line4.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [contentView addSubview:line4];
    
    //开始时间
    NSString *startTime = @"开始时间";
    
    CGSize startTimeSize = [startTime sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *startTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line4.frame) + (49 - startTimeSize.height) / 2, startTimeSize.width, startTimeSize.height)];
    startTimeLbl.font     = [UIFont systemFontOfSize:12];
    startTimeLbl.textColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.21 alpha:1.00];
    startTimeLbl.text      = startTime;
    [contentView addSubview:startTimeLbl];
    
    NSString *temp1 = @"请选择时间";
    CGSize temp1Size = [temp1 sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UIButton *startTimeBtn = [[UIButton alloc] init];
    [startTimeBtn setTitle:@"请选择时间" forState:UIControlStateNormal];
    startTimeBtn.frame = CGRectMake(SCREEN_WIDTH - temp1Size.width - 10, CGRectGetMaxY(line4.frame) + (49 - 12) / 2 - 2, temp1Size.width, temp1Size.height);
    startTimeBtn.tag = 1;
    [startTimeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    startTimeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [startTimeBtn setTitleColor:[UIColor colorWithRed:0.59 green:0.59 blue:0.60 alpha:1.00] forState:UIControlStateNormal];
    [contentView addSubview:startTimeBtn];
    _startTimeBtn = startTimeBtn;
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(startTimeBtn.frame) + (49 - startTimeSize.height) / 2, SCREEN_WIDTH, 1.0)];
    line5.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [contentView addSubview:line5];
    
    //有效时间
    NSString *limitTime = @"有效期";
    
    CGSize limitTimeSize = [limitTime sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *limitTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line5.frame) + (49 - limitTimeSize.height) / 2, limitTimeSize.width, limitTimeSize.height)];
    limitTimeLbl.font     = [UIFont systemFontOfSize:12];
    limitTimeLbl.textColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.21 alpha:1.00];
    limitTimeLbl.text      = limitTime;
    [contentView addSubview:limitTimeLbl];
    
    NSString *temp2 = @"请选择时间";
    CGSize temp2Size = [temp2 sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UIButton *limitTimeBtn = [[UIButton alloc] init];
    [limitTimeBtn setTitle:@"请选择时间" forState:UIControlStateNormal];
    limitTimeBtn.frame = CGRectMake(SCREEN_WIDTH - temp2Size.width - 10, CGRectGetMaxY(line5.frame) + (49 - 12) / 2 - 2, temp2Size.width, temp2Size.height);
    limitTimeBtn.tag = 2;
    limitTimeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [limitTimeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    [limitTimeBtn setTitleColor:[UIColor colorWithRed:0.59 green:0.59 blue:0.60 alpha:1.00] forState:UIControlStateNormal];
    [contentView addSubview:limitTimeBtn];
    _limitTimeBtn = limitTimeBtn;
    
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(limitTimeBtn.frame) + (49 - limitTimeSize.height) / 2, SCREEN_WIDTH, 1.0)];
    line6.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [contentView addSubview:line6];
    
    //备注
    NSString *other = @"备注";
    
    CGSize otherSize = [other sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *otherLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line6.frame) + (49 - otherSize.height) / 2, otherSize.width, otherSize.height)];
    otherLbl.font     = [UIFont systemFontOfSize:12];
    otherLbl.textColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.21 alpha:1.00];
    otherLbl.text      = other;
    [contentView addSubview:otherLbl];
    
    UITextView *otherView = [[UITextView alloc] init];
    otherView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    otherView.layer.cornerRadius = 5;
    otherView.layer.masksToBounds = YES;
    otherView.delegate    = self;
    otherView.tag         = 5;
    otherView.frame       = CGRectMake(10, CGRectGetMaxY(otherLbl.frame) + 10, SCREEN_WIDTH - 20, 100);
    [contentView addSubview:otherView];
    _otherView = otherView;
    
    contentView.contentSize = CGSizeMake(0, CGRectGetMaxY(otherView.frame) + 10 + 60);
    
}

#pragma mark --------- UITextViewDelegate start ----------------

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if(textView.tag == 5) {
    
        _isOtherViewInput = YES;
        _otherViewY = [textView convertRect:textView.bounds toView:self.view.window].origin.y + textView.frame.size.height + padding;
        _origPoint = _contentView.contentOffset;
        
    }else {
    
        
        _isOtherViewInput = NO;
        
    }
    
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    _isOtherViewInput = NO;
    [_contentView setContentOffset:CGPointZero animated:YES];
    
}

#pragma mark --------- UITextViewDelegate end ------------------

- (void)setLocation:(NSString *)location {
    
    _location = location;
    
    _positionField.text = location;
    
}



- (void)selectTime:(UIButton *)sender {
    
    if(sender.tag == 1) {
        
        UIDatePicker *picker = [[UIDatePicker alloc]init];
        picker.datePickerMode = UIDatePickerModeDate;
        picker.minimumDate = [NSDate date];
        picker.frame = CGRectMake(0, 40, 320, 200);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择开始时间\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSDate *date = picker.date;
            
            [sender setTitle: [date stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
            NSString *temp2 = [date stringWithFormat:@"yyyy-MM-dd"];
            CGSize temp2Size = [temp2 sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
            
            sender.frame = CGRectMake(SCREEN_WIDTH - temp2Size.width - 10, sender.frame.origin.y, temp2Size.width, temp2Size.height);
            
            
        }];
        [alertController.view addSubview:picker];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else {
    
        UIDatePicker *picker = [[UIDatePicker alloc]init];
        picker.datePickerMode = UIDatePickerModeDate;
        picker.minimumDate = [NSDate date];
        picker.frame = CGRectMake(0, 40, 320, 200);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择有效期\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSDate *date = picker.date;
            
            [sender setTitle: [date stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
            NSString *temp2 = [date stringWithFormat:@"yyyy-MM-dd"];
            CGSize temp2Size = [temp2 sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
            
            sender.frame = CGRectMake(SCREEN_WIDTH - temp2Size.width - 10, sender.frame.origin.y, temp2Size.width, temp2Size.height);
            
            
        }];
        [alertController.view addSubview:picker];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    
    
}

#pragma mark ----------- SWItemSeleceDelegate start --------------------

- (void)selectItem:(SWItemSelectView *)itemView {
    
//    NSLog(@"se12lect:%@:%ld",itemView.workerName,(long)itemView.workerNum);
    
    BOOL isFind = NO;
    
    SWWorkerTypeData *workerType = itemView.workerName;
    
    for (int i = 0; i < _selectWorkerArr.count; i++) {
        
        SWWantWorker *wantWorker = _selectWorkerArr[i];
        
        if(wantWorker.type == [workerType.wid integerValue]) {
            
            isFind = YES;
            wantWorker.num = itemView.workerNum;
            break;
            
        }
        
    }
    
    if(!isFind) {
        
        SWWantWorker *wantWorker = [[SWWantWorker alloc] init];
        wantWorker.type = [workerType.wid integerValue];
        wantWorker.num = itemView.workerNum;
        [_selectWorkerArr addObject:wantWorker];
        
    }
    
    
}

- (void)deselectItem:(SWItemSelectView *)itemView {
    
//    NSLog(@"deselect:%@:%ld",itemView.workerName,(long)itemView.workerNum);
    
    SWWorkerTypeData *workerType = itemView.workerName;
    
    int i = 0;
    
    for (; i < _selectWorkerArr.count; i++) {
        
        SWWantWorker *wantWorker = _selectWorkerArr[i];
        
        if(wantWorker.type == [workerType.wid integerValue]) {
            
            break;
            
        }
        
    }
    
    [_selectWorkerArr removeObjectAtIndex:i];
    
}

#pragma mark ----------- SWItemSeleceDelegate end --------------------

//是否面议点击事件
- (void)faceClick:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    
    if(sender.isSelected) {
        
        _moneyField.placeholder = @"面议";
        [_moneyField setEnabled:NO];
        
    }else {
        _moneyField.placeholder   = @"请输入预算";
        [_moneyField setEnabled:YES];
        
    }
    
}


- (void)chooseLocation {
    
    SWMyLocationController *myLocationController = [[SWMyLocationController alloc] init];
    [self.navigationController pushViewController:myLocationController animated:YES];
    
}

- (void)publishClick:(UIButton *)sender {
    
//    [self showContractView];
    
    SWPublishWorkCmd *publishCmd = [[SWPublishWorkCmd alloc] init];
    
    publishCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
  
    if(IS_EMPTY(_titleField.text)) {
        
        [MBProgressHUD showError:@"请填写标题" toView:self.view];
        return;
    }
    if(_selectWorkerArr.count == 0) {
        [MBProgressHUD showError:@"请选择工人类型和工人数量" toView:self.view];
        return;
    }
    
    if(!_faceMoney.isSelected) {
        
        if(IS_EMPTY(_moneyField.text)) {
        
            [MBProgressHUD showError:@"请填写预算，或选择面议" toView:self.view];
            return;
            
        }
        
    }
    
    if(IS_EMPTY(_positionField.text)) {
        
        [MBProgressHUD showError:@"请填写地址" toView:self.view];
        return;
        
    }
    
    if([_startTimeBtn.currentTitle isEqualToString:@"请选择时间"]) {
        
        [MBProgressHUD showError:@"请选择开始时间" toView:self.view];
        return;
        
    }
    
    if([_limitTimeBtn.currentTitle isEqualToString:@"请选择时间"]) {
        
        [MBProgressHUD showError:@"请选择有效期" toView:self.view];
        return;
        
    }
    
    NSInteger day = [self calculateDay];
    
    if(day < 0) {
    
        [MBProgressHUD showError:@"有效期不能小于发布时间" toView:self.view];
        
        return;
        
    }
    
    
    
    
    publishCmd.title = _titleField.text;
//
    NSMutableString *typeStr = [NSMutableString string];
    NSMutableString *numStr = [NSMutableString string];
//    
    for (SWWantWorker *wantWork in _selectWorkerArr) {
        
        [typeStr appendString:[NSString stringWithFormat:@"%ld,",wantWork.type]];
        [numStr appendString:[NSString stringWithFormat:@"%ld,",wantWork.num]];
        
    }
    
    publishCmd.isface = [NSString stringWithFormat:@"%d",_faceMoney.isSelected];
    if(!_faceMoney.isSelected) {
        
        publishCmd.budget = _moneyField.text;
        
    }
    publishCmd.address = _positionField.text;
    publishCmd.start_time = _startTimeBtn.currentTitle;
    publishCmd.end_time = _limitTimeBtn.currentTitle;
    publishCmd.remark = _otherView.text;
    publishCmd.typeId = typeStr;
    publishCmd.typenum = numStr;
    publishCmd.company_id = self.companyID;
    
    SWPublishSuccessController *successController = [[SWPublishSuccessController alloc] init];
    successController.workArr = _workArr;
    successController.publishWorkCmd = publishCmd;
    [self.navigationController pushViewController:successController animated:YES];
    
}

//计算两个日期相差
- (NSInteger)calculateDay {
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd";
    
    // 截止时间字符串格式
    NSString *expireDateStr = _limitTimeBtn.currentTitle;
    // 当前时间字符串格式
    NSString *nowDateStr = _startTimeBtn.currentTitle;
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    // 当前时间data格式
    NSDate *nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    
    return dateCom.day;
    
}



@end
