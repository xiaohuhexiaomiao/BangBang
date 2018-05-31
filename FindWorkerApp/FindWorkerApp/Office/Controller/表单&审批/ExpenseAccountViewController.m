//
//  ExpenseAccountViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/1/5.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "ExpenseAccountViewController.h"
#import "CXZ.h"

#import "AdressBookViewController.h"
#import "CopyViewController.h"

#import "ExpenseAccountView.h"
#import "ExpenseAccountModel.h"

@interface ExpenseAccountViewController ()<AdressBookDelegate,ExpenseAccountViewDelegate,CopyDelegate>
{
    NSInteger expenseViewTag;
}
@property(nonatomic , strong) UITextView *titleTextView;

@property(nonatomic , strong) UIScrollView *bgScrollview;

@property(nonatomic , strong) UIButton *projectButton;

@property(nonatomic , strong) UIView *listView;

@property(nonatomic , strong)UIButton *addListButton;//添加按钮

@property(nonatomic , strong)UILabel *totalMoneyLabel;//总金额

@property(nonatomic , strong)UILabel *totalMoneyWordsLabel;//大写总金额

@property(nonatomic , strong) UIView *lastView;

@property(nonatomic , strong) MoreFilesView *fileView;

@property(nonatomic , strong) ExpenseAccountView *expenseView;

@property(nonatomic , strong) UIButton *submitbButton;

@property(nonatomic , strong) NSString *totalMoney;

@property(nonatomic , copy) NSString *projectManagerStr;

@property(nonatomic , copy) NSString *enclosure_id;

@property(nonatomic , strong) NSMutableArray *expenseViewArray;

@end

@implementation ExpenseAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackw];
    [self setupTitleWithString:@"报销单" withColor:[UIColor whiteColor]];
    [self setupNextWithString:@"去复制" withColor:[UIColor whiteColor]];
    [self config];
    expenseViewTag = 101;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



#pragma mark Public Method

-(void)onNext
{
    
    if (self.form_type == 0) {
        CopyViewController *copyVC = [[CopyViewController alloc]init];
        copyVC.companyID = self.companyID;
        copyVC.type = 11;
        copyVC.delegate = self;
        [self.navigationController pushViewController:copyVC animated:YES];
    }else{
        CopyViewController *copyVC = [[CopyViewController alloc]init];
        copyVC.formType = 4;
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

#pragma mark Private Method

-(void)clickProjectManager
{
    AdressBookViewController *bookVC = [[AdressBookViewController alloc]init];
    bookVC.isSelectedManager = YES;
    bookVC.companyid = self.companyID;
    bookVC.delegate = self;
    bookVC.loadDataType = 2;
    [self.navigationController pushViewController:bookVC animated:YES];
}

-(void)addExpenseAccountList
{
    CGRect frame = self.listView.frame;
    CGFloat height= frame.size.height;
    height += 140;
    frame.size.height = height;
    self.listView.frame = frame;
    [self.listView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    
    ExpenseAccountView *expenseView = [[ExpenseAccountView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 140)];
    expenseView.tag = expenseViewTag;
    expenseView.delegate = self;
    expenseView.deleteButton.hidden = NO;
    [self.listView addSubview:expenseView];
    [expenseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_lastView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(140);
    }];
    _lastView = expenseView;
    expenseViewTag++;
    [self.expenseViewArray addObject:expenseView];
    
    _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, self.listView.bottom+200);
}

#pragma mark 提交

-(void)submitExpenseAccountForm
{
    if ([NSString isBlankString:self.titleTextView.text]) {
        [WFHudView showMsg:@"请输入标题" inView:self.view];
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
        [WFHudView showMsg:@"请上传附件" inView:self.view];
        return;
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
    
    NSMutableArray *array = [NSMutableArray array];
    CGFloat total = 0;
    for (int i = 0; i < self.expenseViewArray.count; i++) {
        ExpenseAccountView *expenseView = (ExpenseAccountView*)self.expenseViewArray[i];
        NSString *timeStr = [expenseView.dayButton titleForState:UIControlStateNormal];
        if ([NSString isBlankString:timeStr] &&[NSString isBlankString:expenseView.contentTextView.text]&&[NSString isBlankString:expenseView.numberTextfield.text] &&[NSString isBlankString:expenseView.moneyTextfield.text] &&[NSString isBlankString:expenseView.markTextView.text] ) {
            
        }else{
            if ([NSString isBlankString:timeStr]) {
                [WFHudView showMsg:@"请选择发生时间" inView:self.view];
                return;
            }
            if ([NSString isBlankString:expenseView.contentTextView.text]) {
                [WFHudView showMsg:@"请输入报销内容" inView:self.view];
                return;
            }
            if ([NSString isBlankString:expenseView.moneyTextfield.text]) {
                [WFHudView showMsg:@"请输入报销金额" inView:self.view];
                return;
            }
            NSDictionary *dict = @{@"month_day":timeStr,@"content":expenseView.contentTextView.text,@"price":expenseView.moneyTextfield.text,@"amount":expenseView.numberTextfield.text,@"remarks":expenseView.markTextView.text,@"big_price":expenseView.moneyWordsLabel.text};
            [array addObject:dict];
            total += [expenseView.moneyTextfield.text doubleValue];
        }
    }
    
    if (array.count == 0 ) {
        [WFHudView showMsg:@"请添加报销清单" inView:self.view];
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
    if ([self.totalMoney doubleValue] == 0.0) {
        self.totalMoney = [NSString stringWithFormat:@"%lf",total];
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSDictionary *paramDict = @{
                                @"content":[NSString dictionaryToJson:array],
                                @"money":self.totalMoney,
                                @"big_money":[NSString digitUppercase:self.totalMoney],
                                @"title":self.titleTextView.text
                                };
    [param addEntriesFromDictionary:paramDict];
    if (enclosureArray.count > 0) {
        NSString *many_enclosure = [NSString dictionaryToJson:enclosureArray];
        [param setObject:many_enclosure forKey:@"many_enclosure"];
    }
    if (![NSString isBlankString:self.projectManagerStr]) {
        [param setObject:self.projectManagerStr forKey:@"project_manager"];
    }
    if (![NSString isBlankString:self.companyID]) {
        [param setObject:self.companyID forKey:@"company_id"];
    }
    if (self.form_type == 1) {
        [param setObject:self.worker_user_id forKey:@"handler_uid"];
        [[NetworkSingletion sharedManager]sendPersonalExpenseForm:param onSucceed:^(NSDictionary *dict) {
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
    }else{
        [[NetworkSingletion sharedManager]publishExpenseAccountForm:param onSucceed:^(NSDictionary *dict) {
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
    
    
    
}

#pragma mark CopyViewControllerDelegate

-(void)copyAll:(id)model
{
    ExpenseAccountModel *detailModel = (ExpenseAccountModel*)model;
    self.titleTextView.text = detailModel.title;
    self.totalMoney = [NSString stringWithFormat:@"%f",detailModel.money];
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"总金额：%.2f元",detailModel.money];
    self.totalMoneyWordsLabel.text = [NSString stringWithFormat:@"总金额（大写）:%@",[NSString digitUppercase:self.totalMoney]];

    if (![NSString isBlankString:detailModel.project_manager_id]) {
        NSDictionary *dictionay = @{@"uid":detailModel.project_manager_id};
        self.projectManagerStr = [NSString dictionaryToJson:dictionay];
        [self.projectButton setTitle:detailModel.project_manager_name[@"name"] forState:UIControlStateNormal];
    }
  
    if (detailModel.many_enclosure.count > 0) {
         [self.fileView setMoreFilesViewWithArray:detailModel.many_enclosure];
    }
    
    if (detailModel.content.count > 0) {
        
        [self.expenseViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.expenseViewArray removeAllObjects];
        
        CGRect frame = self.listView.frame;
        CGFloat height= frame.size.height;
        height = 140 * detailModel.content.count+50;
        frame.size.height = height;
        self.listView.frame = frame;
        [self.listView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];

       
        CGRect expenseframe = self.expenseView.frame;
        expenseframe = CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 140);
        self.expenseView.frame = expenseframe;
        [self.listView addSubview:self.expenseView];
        [self.expenseViewArray addObject:self.expenseView];
        [self.expenseView showCopyExpenseViewWithDict:detailModel.content[0]];
        [self.expenseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_totalMoneyWordsLabel.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(140);
        }];
         _lastView = self.expenseView;
        for (int i = 1; i < detailModel.content.count; i++) {
            NSDictionary *dict = detailModel.content[i];
            ExpenseAccountView *expenseView = [[ExpenseAccountView alloc]initWithFrame:CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 140)];
            [expenseView showCopyExpenseViewWithDict:dict];
            expenseView.tag = expenseViewTag;
            expenseView.delegate = self;
            [self.listView addSubview:expenseView];
            [expenseView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(_lastView.mas_bottom);
                make.width.mas_equalTo(SCREEN_WIDTH);
                make.height.mas_equalTo(140);
            }];
            _lastView = expenseView;
            expenseViewTag++;
//            [expenseView.moneyTextfield addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
            [self.expenseViewArray addObject:expenseView];
            
           

        }
    }
    
    self.submitbButton.top = self.listView.bottom+40;
    _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, self.listView.bottom+200);
    
    
}


#pragma mark ExpenseAccountViewDelegate

-(void)deleteExpenseAccountView:(NSInteger)tag
{
    //        NSLog(@"*delegre  %li",tag);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        ExpenseAccountView *view =(ExpenseAccountView*) [self.listView viewWithTag:tag];
        CGFloat money = [view.moneyTextfield.text doubleValue];
        CGFloat total = [self.totalMoney doubleValue];
        total -= money;
        self.totalMoney = [NSString stringWithFormat:@"%.2lf",total];
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"总金额：%.2f元",total];
        self.totalMoneyWordsLabel.text = [NSString stringWithFormat:@"总金额（大写）:%@",[NSString digitUppercase:self.totalMoney]];
//        [view.moneyTextfield removeObserver:self forKeyPath:@"text"];
        [view removeFromSuperview];
        [self.expenseViewArray removeObject:view];
        
        _lastView = _totalMoneyWordsLabel;
        [self.expenseViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (int i = 0; i < self.expenseViewArray.count; i++) {
            ExpenseAccountView *view =(ExpenseAccountView*) self.expenseViewArray[i];
            CGRect frame = view.frame;
            frame = CGRectMake(0, _lastView.bottom, SCREEN_WIDTH, 140);
            view.frame = frame;
            [self.listView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(8);
                make.top.mas_equalTo(_lastView.mas_bottom);
                make.width.mas_equalTo(SCREEN_WIDTH);
                make.height.mas_equalTo(140);
            }];
            _lastView = view;
        }
        

        CGRect frame = self.listView.frame;
        CGFloat height= frame.size.height;
        height = self.expenseViewArray.count*140+50;
        frame.size.height = height;
        self.listView.frame = frame;
        [self.listView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        
    }) ;
    [self.submitbButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.listView.mas_bottom).mas_offset(40);
    }];
    _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, self.listView.bottom+200);
}

-(void)editMoneyDone
{
    CGFloat total = 0.0;
    
    for (int i = 0; i < self.expenseViewArray.count; i++) {
        ExpenseAccountView *expenseView = (ExpenseAccountView*)self.expenseViewArray[i];
        CGFloat money = [expenseView.moneyTextfield.text doubleValue];
        total +=  money;
        
    }
    self.totalMoney = [NSString stringWithFormat:@"%.2lf",total];
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"总金额：%@元",self.totalMoney];
    self.totalMoneyWordsLabel.text = [NSString stringWithFormat:@"总金额（大写）:%@",[NSString digitUppercase:self.totalMoney]];
  
}

#pragma mark AdressBookControllerDelegate

-(void)selectedPorjectManager:(NSDictionary *)dict
{
    NSDictionary *dictionay = @{@"uid":dict[@"uid"]};
    self.projectManagerStr = [NSString dictionaryToJson:dictionay];
    if (![NSString isBlankString:dict[@"name"]]) {
         [self.projectButton setTitle:dict[@"name"] forState:UIControlStateNormal];
    }
   
}



#pragma mark J界面相关

-(void)config
{
    _bgScrollview = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _bgScrollview.showsVerticalScrollIndicator = YES;
    _bgScrollview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bgScrollview];
    [_bgScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(0);
    }];
    
    NSString *titleStr = @"标题：";
    CGSize titleSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    UILabel *titleLabel = [CustomView customTitleUILableWithContentView:_bgScrollview title:titleStr];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(titleSize.width+1);
        make.height.mas_equalTo(30);
    }];
    
    _titleTextView = [CustomView customUITextViewWithContetnView:_bgScrollview placeHolder:nil];
    [_titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right);
        make.top.mas_equalTo(titleLabel.mas_top);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line0 = [CustomView customLineView:_bgScrollview];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_titleTextView.mas_bottom);
       make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(1);
    }];
    _lastView = line0;
    
    if (self.form_type == 0) {
        NSString *managerStr = @"项目（部门）经理：";
        CGSize projectManagerSize = [managerStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *projectManagerLabel = [CustomView customTitleUILableWithContentView:_bgScrollview title:managerStr];
        [projectManagerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_lastView.mas_bottom);
            make.width.mas_equalTo(projectManagerSize.width+1);
            make.height.mas_equalTo(30);
        }];
        
        _projectButton = [CustomView customButtonWithContentView:_bgScrollview image:nil title:nil];
        [_projectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(projectManagerLabel.mas_right);
            make.top.mas_equalTo(projectManagerLabel.mas_top);
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
            make.height.mas_equalTo(30);
        }];
        [_projectButton addTarget:self action:@selector(clickProjectManager) forControlEvents:UIControlEventTouchUpInside];
        _projectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        
        UIView *line1 = [CustomView customLineView:_bgScrollview];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_projectButton.mas_bottom);
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
            make.height.mas_equalTo(1);
        }];
        _lastView = line1;
    }
    
    
    _fileView = [[MoreFilesView alloc]initWithFrame:CGRectMake(8, _lastView.bottom, SCREEN_WIDTH-16, 40)];
    [_bgScrollview addSubview:_fileView];
    [_fileView addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [_fileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_lastView.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(40);
    }];

    UIView *line2 = [CustomView customLineView:_bgScrollview];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_fileView.mas_bottom);
       make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(1);
    }];
    
    
    _listView = [[UIView alloc]initWithFrame:CGRectMake(0, line2.bottom, SCREEN_WIDTH, 190)];
    [_bgScrollview addSubview:_listView];
    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(line2.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(190);
    }];

    _addListButton = [CustomView customButtonWithContentView:_listView image:nil title:@"＋添加报销清单"];
    _addListButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_addListButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH/2-8);
        make.height.mas_equalTo(30);
    }];
    [_addListButton addTarget:self action:@selector(addExpenseAccountList) forControlEvents:UIControlEventTouchUpInside];
    
    _totalMoneyLabel = [CustomView customContentUILableWithContentView:_listView title:nil];
    [_totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_addListButton.mas_right);
        make.top.mas_equalTo(_addListButton.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(30);
    }];
    _totalMoneyLabel.font = [UIFont systemFontOfSize:12 weight:0.8];
    _totalMoneyLabel.textColor = DARK_RED_COLOR;
    _totalMoneyLabel.textAlignment = NSTextAlignmentRight;
    
    _totalMoneyWordsLabel = [CustomView customContentUILableWithContentView:_listView title:nil];
    [_totalMoneyWordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(_totalMoneyLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(20);
    }];
    _totalMoneyWordsLabel.font = [UIFont systemFontOfSize:12 weight:0.8];
    _totalMoneyWordsLabel.textColor = DARK_RED_COLOR;
//    _totalMoneyWordsLabel.textAlignment = NSTextAlignmentRight;
    

    _expenseView = [[ExpenseAccountView alloc]initWithFrame:CGRectMake(0, _totalMoneyWordsLabel.bottom, SCREEN_WIDTH, 140)];
    _expenseView.tag = 100;
    _expenseView.delegate = self;
    _expenseView.deleteButton.hidden = YES;
    [_listView addSubview:_expenseView];
    [_expenseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_totalMoneyWordsLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(140);
    }];
    _lastView = _expenseView;
    [self.expenseViewArray addObject:_expenseView];
    
    _submitbButton = [CustomView customButtonWithContentView:_bgScrollview image:nil title:@"提交"];
    _submitbButton.backgroundColor = TOP_GREEN;
    _submitbButton.layer.cornerRadius = 5;
    [_submitbButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitbButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:0.8];
    [_submitbButton addTarget:self action:@selector(submitExpenseAccountForm) forControlEvents:UIControlEventTouchUpInside];
    [_submitbButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_listView.mas_bottom).mas_offset(40);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(40);
    }];
//
    _bgScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, _submitbButton.bottom+40);
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"text"] ) {
        CGFloat newMoney = [change[@"new"] doubleValue];
        CGFloat oldMoney = [change[@"old"] doubleValue];
        CGFloat toatl = [self.totalMoney doubleValue];
        toatl += newMoney;
        toatl -= oldMoney;
        self.totalMoney = [NSString stringWithFormat:@"%.2lf",toatl];
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"总金额：%.2f元",toatl];
        self.totalMoneyWordsLabel.text = [NSString stringWithFormat:@"总金额（大写）:%@",[NSString digitUppercase:self.totalMoney]];
    }else if ([keyPath isEqualToString:@"height"] ) {
        CGFloat newHeight = [change[@"new"] floatValue];
        CGRect frame = self.fileView.frame;
        frame.size.height = newHeight;
        self.fileView.frame = frame;
        [_fileView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(newHeight);
        }];
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark get/set

-(NSMutableArray*)expenseViewArray
{
    if (!_expenseViewArray) {
        _expenseViewArray = [NSMutableArray array];
    }
    return _expenseViewArray;
}

@end
