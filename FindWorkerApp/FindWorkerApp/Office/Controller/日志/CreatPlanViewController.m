//
//  CreatPlanViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CreatPlanViewController.h"
#import "CXZ.h"

#import "GFCalendar.h"

#import "DiaryFileView.h"
#import "DiarySendRangeView.h"

#import "DatePickerView.h"

@interface CreatPlanViewController ()<UITextViewDelegate,UIPickerViewDelegate>

@property(nonatomic , strong) UIScrollView *bgScrollView;

@property(nonatomic , strong) RTLabel *calendarLabel;

@property(nonatomic , strong) UIView *line;

@property(nonatomic , strong) DiaryFileView *fileView;

@property(nonatomic , strong) DiarySendRangeView *rangeView;

@property(nonatomic , strong) UIView *calendarView;

@property(nonatomic , strong) NSMutableArray *textViewArray;

@property(nonatomic , copy) NSString *signDay;//记录日期 作计算用

@end

@implementation CreatPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackw];
    if (self.type == 1) {
        [self setupTitleWithString:@"日计划" withColor:[UIColor whiteColor]];
    }else if (self.type == 2){
        [self setupTitleWithString:@"周计划" withColor:[UIColor whiteColor]];
    }else if (self.type == 3){
       [self setupTitleWithString:@"月计划" withColor:[UIColor whiteColor]];
    }
    
    [self setupNextWithString:@"发送" withColor:[UIColor whiteColor]];
    [self config];
    [self loadDiaryType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma  mark Data Method
-(void)loadDiaryType
{
    [[NetworkSingletion sharedManager]getDiaryRegulation:@{@"log_type_id":@(self.form_id)} onSucceed:^(NSDictionary *dict) {
//        NSLog(@"haha %@",dict);
        [self.bgScrollView.mj_header endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            NSArray *array = dict[@"data"];
            [self configDynamicView:array];
        }
        
    } OnError:^(NSString *error) {
        
    }];
}

#pragma mark Public Method

-(void)onBack
{
    [self.fileView removeObserver:self forKeyPath:@"height"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNext
{
    if ([NSString isBlankString:self.rangeView.reviewer_id]) {
        [WFHudView showMsg:@"请选择点评人" inView:self.view];
        return;
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
        [self publishDayPlanWithImageId:nil];
    }

}


#pragma mark Private Method
//发布

-(void)publishDayPlanWithImageId:(NSString*)imageId
{
    NSMutableArray *enclosureArray = [NSMutableArray array];
    if (self.fileView.file_id_array.count > 0) {
        [enclosureArray addObjectsFromArray:self.fileView.file_id_array];
    }
    if (![NSString isBlankString:imageId]) {
        NSDictionary *dict = @{@"contract_id":imageId,@"type":@(3),@"name":@"图片"};
        [enclosureArray addObject:dict];
    }
    NSMutableArray *formArray = [NSMutableArray array];
    for (int i = 0; i < self.textViewArray.count; i++) {
        UITextView *textView = (UITextView*)self.textViewArray[i];
        NSDictionary *resultDict = @{@"form_element_id":@(textView.tag),@"result":textView.text};
        [formArray addObject:resultDict];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSDictionary *dict = @{@"company_id":self.company_id,
                           @"reviewer":self.rangeView.reviewer_id,
                           @"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"log_type":@(self.type),
                           @"user_save_time":@([NSString toTimeIntervalWithDateString:self.signDay]),
                           @"custom_form_type":@(self.form_id),
                           @"custom_form_result":[NSString dictionaryToJson:formArray],
                           };
    [paramDict addEntriesFromDictionary:dict];
    if (enclosureArray.count > 0) {
        [paramDict setObject:[NSString dictionaryToJson:enclosureArray] forKey:@"enclosure"];
    }
    if (self.rangeView.rangeArray.count > 0) {
        [paramDict setObject:[NSString dictionaryToJson:self.rangeView.rangeArray] forKey:@"json"];
    }
    [[NetworkSingletion sharedManager]publishOnePlan:paramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"publish %@",dict);
        if ([dict[@"code"] integerValue]==0) {
            [self.fileView removeObserver:self forKeyPath:@"height"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        
    }];
    
}



//上传附件
-(void)uploadPhotos:(NSMutableArray*)hashArray
{
    NSString *hashStr = [NSString dictionaryToJson:hashArray];
    [[NetworkSingletion sharedManager]updateReviewAnnexNew:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"picture":hashStr} onSucceed:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        if ([dict[@"code"] integerValue]==0) {
            NSInteger enclosureId = [[dict[@"data"] objectForKey:@"enclosure_id"] integerValue];
            [self publishDayPlanWithImageId:[NSString stringWithFormat:@"%li",enclosureId]];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self.view];
        }
    } OnError:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
    
}


//点击向左button
-(void)clickPreviousDay
{
    if (self.type == 1) {
         self.calendarLabel.text = [NSString toDateBeforOrAfterOfDays:-1 withDate:self.signDay];
        self.signDay = self.calendarLabel.text;
    }else if (self.type == 2){
        self.signDay = [NSString toDateBeforOrAfterOfDays:-7 withDate:self.signDay];
        NSString *mandy = [NSString toMondyWithDateString:self.signDay];
        NSString *sundy = [NSString toSundyWithDateString:self.signDay];
        self.calendarLabel.text = [NSString stringWithFormat:@"%@~%@",mandy,sundy];
    }else if (self.type == 3){
        self.signDay = [NSString toDateBeforOrAfterOfDays:-30 withDate:self.signDay];
        self.calendarLabel.text = [self.signDay substringWithRange:NSMakeRange(0, 8)];
    }

}
//点击向右button
-(void)clickNextDay
{
    if (self.type == 1) {
        self.calendarLabel.text = [NSString toDateBeforOrAfterOfDays:1 withDate:self.signDay];
        self.signDay = self.calendarLabel.text;
    }else if (self.type == 2){
        self.signDay = [NSString toDateBeforOrAfterOfDays:7 withDate:self.signDay];
        NSString *mandy = [NSString toMondyWithDateString:self.signDay];
        NSString *sundy = [NSString toSundyWithDateString:self.signDay];
        self.calendarLabel.text = [NSString stringWithFormat:@"%@~%@",mandy,sundy];
    }else if (self.type == 3){
        self.signDay = [NSString toDateBeforOrAfterOfDays:30 withDate:self.signDay];
         self.calendarLabel.text = [self.signDay substringWithRange:NSMakeRange(0, 8)];
    }

}
//点击日历
-(void)clickCalendarButton
{
    if (self.type == 1|| self.type == 2) {
        [self showCalendar];
    }else{
        [self selectMonth];
    }
}
//选择月份
-(void)selectMonth
{

    DatePickerView *picker = [[DatePickerView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 200)];
    picker.datePickerType = 0;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择月份\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        self.calendarLabel.text = [NSString stringWithFormat:@"%@%@",picker.yearString,picker.monthString];
        self.signDay = [NSString stringWithFormat:@"%@%@08日",picker.yearString,picker.monthString];
    }];
    [alertController.view addSubview:picker];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
//日历view
-(void)showCalendar
{
    NSDate * currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *currentDay = [formatter stringFromDate:currentDate];
    
    __weak typeof(self) weakself = self;
    
    if (!_calendarView) {
        
        _calendarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _calendarView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        CGFloat width = self.view.bounds.size.width - 60.0;
        CGPoint origin = CGPointMake(30.0, 64.0 + 70.0);
        GFCalendarView *calendar = [[GFCalendarView  alloc] initWithFrameOrigin:origin width:width];
        //    calendar.calendarBasicColor = [UIColor cyanColor]; // 更改颜色
        calendar.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day) {
            NSString *title;
            NSString *dayStr = [NSString stringWithFormat:@"%ld年%ld月%ld日", year, month, day];
            self.signDay = dayStr;
            if (weakself.type == 1) {
                if ([dayStr isEqualToString:currentDay]) {
                    title = dayStr;
                }else{
                    title = [NSString stringWithFormat:@"%@补交",dayStr];
                }
                weakself.calendarLabel.text = title;
            }else if(weakself.type == 2){
                NSString *mandy = [NSString toMondyWithDateString:dayStr];
                NSString *sundy = [NSString toSundyWithDateString:dayStr];
                self.calendarLabel.text = [NSString stringWithFormat:@"%@~%@",mandy,sundy];
            }
            [weakself.calendarView removeFromSuperview];
            weakself.calendarView.hidden = YES;
        };
        [calendar setIs_rounded_Corner:YES];
        [_calendarView addSubview:calendar];
        _calendarView.hidden = YES;
    }
    
    UIWindow *bgWindow =  [[UIApplication sharedApplication] keyWindow];
    
    [UIView animateWithDuration:0.1 animations:^{
        weakself.calendarView.hidden = NO;
        [bgWindow addSubview:_calendarView];
    }];

}

#pragma mark 界面 相关

-(void)configDynamicView:(NSArray*)formArray
{
    [self.fileView removeObserver:self forKeyPath:@"height"];
    [self.textViewArray removeAllObjects];
    UIView *lastView = self.line;
    for (int i = 0; i < formArray.count; i++) {
        NSString *typeStr = [formArray[i] objectForKey:@"type"];
        NSString *titleStr =[NSString stringWithFormat:@"%@：",[formArray[i] objectForKey:@"title"]] ;
        NSString *formID = [formArray[i] objectForKey:@"form_element_id"];
        NSString *meta = [formArray[i] objectForKey:@"meta_data"];
        if (![NSString isBlankString:meta]) {
//            NSDictionary *respond = [NSString dictionaryWithJsonString: meta];
            if ([typeStr isEqualToString:@"input_text"]) {
                CGSize titleSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
                CGFloat lableWidth = titleSize.width > 90.0 ? 90.0 :titleSize.width;
                UILabel *lable = [CustomView customTitleUILableWithContentView:self.bgScrollView title:titleStr];
                [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.line.mas_left);
                    make.top.mas_equalTo(lastView.mas_bottom);
                    make.width.mas_equalTo(lableWidth+2);
                    make.height.mas_equalTo(30);
                }];
                if (titleSize.width >90.0) {
                    lable.textAlignment = 2;
                }
                
                UITextView *textView = [CustomView customUITextViewWithContetnView:self.bgScrollView placeHolder:nil];
                textView.delegate = self;
                textView.tag = [formID integerValue];
                [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lable.mas_right);
                    make.top.mas_equalTo(lastView.mas_bottom);
                    make.right.mas_equalTo(self.line.mas_right);
                    make.height.mas_equalTo(30);
                }];
                [self.textViewArray addObject:textView];
                
                UIView *line0 = [CustomView customLineView:self.bgScrollView];
                [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.line.mas_left);
                    make.top.mas_equalTo(textView.mas_bottom);
                    make.width.mas_equalTo(self.line.mas_width);
                    make.height.mas_equalTo(1);
                }];
                lastView = line0;
            }
        }
    }
    
    _fileView = [[DiaryFileView alloc]initWithFrame:CGRectMake(8, lastView.bottom, SCREEN_WIDTH-16, 30)];
    [_bgScrollView addSubview:_fileView];
    [_fileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(lastView.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(30);
    }];
    [_fileView addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    
    _rangeView = [[DiarySendRangeView alloc]initWithFrame:CGRectMake(0, _fileView.bottom, SCREEN_WIDTH, 25)];
    _rangeView.company_id = self.company_id;
    [_bgScrollView addSubview:_rangeView];
    [_rangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_fileView.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(25);
    }];
    
    _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.rangeView.bottom+200);

}

-(void)config
{
    
    _bgScrollView = [[UIScrollView alloc]init];
    _bgScrollView.showsVerticalScrollIndicator = YES;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
    [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    
    __weak typeof(self) weakself = self;
    _bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadDiaryType];
    }];
    
    UIButton *leftButton = [CustomView customButtonWithContentView:_bgScrollView image:@"aleft" title:nil];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(7.5);
        make.width.height.mas_equalTo(25);
    }];
    [leftButton addTarget:self action:@selector(clickPreviousDay) forControlEvents:UIControlEventTouchUpInside];
    
    _calendarLabel = [CustomView customRTLableWithContentView:_bgScrollView title:nil];
    _calendarLabel.frame = CGRectMake(SCREEN_WIDTH/2-70, 10, 120, 20);
    [_calendarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(120);
        make.left.mas_equalTo(SCREEN_WIDTH/2-70);
        make.height.mas_equalTo(20);
    }];
    _calendarLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *downButton = [CustomView customButtonWithContentView:_bgScrollView image:@"arrow_gray" title:nil];
    [downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_calendarLabel.mas_right);
        make.top.mas_equalTo(8);
        make.width.height.mas_equalTo(25);
    }];
    [downButton addTarget:self action:@selector(clickCalendarButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightButton = [CustomView customButtonWithContentView:_bgScrollView image:@"right" title:nil];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCREEN_WIDTH-33);
        make.top.mas_equalTo(leftButton.mas_top);
        make.width.mas_equalTo(leftButton.mas_width);
        make.height.mas_equalTo(rightButton.mas_height);
    }];
    [rightButton addTarget: self action:@selector(clickNextDay) forControlEvents:UIControlEventTouchUpInside];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *currentDay = [formatter stringFromDate:[NSDate date]];
    self.signDay = currentDay;
    if (self.type == 1){
        self.calendarLabel.text = currentDay;
    }else if (self.type == 2) {
        self.calendarLabel.font = [UIFont systemFontOfSize:12];
        CGRect frame = self.calendarLabel.frame;
        frame.size.width = 240;
        frame.origin.x = SCREEN_WIDTH/2-140;
        self.calendarLabel.frame = frame;
        [self.calendarLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(240);
            make.left.mas_equalTo(SCREEN_WIDTH/2-140);
        }];
        NSString *mandy = [NSString toMondyWithDateString:currentDay];
        NSString *sundy = [NSString toSundyWithDateString:currentDay];
        self.calendarLabel.text = [NSString stringWithFormat:@"%@~%@",mandy,sundy];
        
    }else if (self.type == 3){
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"yyyy年MM月"];
        NSString *currentMonth = [formatter1 stringFromDate:[NSDate date]];
        self.signDay = [NSString stringWithFormat:@"%@08日",currentMonth];
        self.calendarLabel.text = currentMonth;
        
    }
    
    _line = [CustomView customLineView:_bgScrollView];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.top.mas_equalTo(_calendarLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(1);
    }];
    
}




-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"height"] ) {
        CGFloat newHeight = [change[@"new"] floatValue];
        [self.fileView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(newHeight);
        }];
        _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.rangeView.bottom+200);
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark UITextView Delegate

-(void)textViewDidChange:(UITextView *)textView
{
    CGSize constraintSize = CGSizeMake(SCREEN_WIDTH-16, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    [textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
    }];

     _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.rangeView.bottom+200);
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{

}

#pragma mark get/set

-(NSMutableArray*)textViewArray
{
    if (!_textViewArray) {
        _textViewArray = [NSMutableArray array];
    }
    return _textViewArray;
}



@end
