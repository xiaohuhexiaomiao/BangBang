//
//  RecommendFriendViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/3/23.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "RecommendFriendViewController.h"

#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

#import "PermissionUpdateViewController.h"
#import "RecommendFriendCell.h"
#import "CXZ.h"

@interface RecommendFriendViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,ABPersonViewControllerDelegate>
{
    NSInteger page;
    
    NSInteger selectedRow;
    NSArray *typeArray;
    UIView *dateBackgroundView;
    UIPickerView *personalDataPickerView;
}
@property(nonatomic ,strong)UITableView *tableview;

@property(nonatomic ,strong)UILabel *numberLabel;

@property(nonatomic ,strong)UIWindow *addWindow;

@property(nonatomic ,strong)UIView *clickView;

@property(nonatomic ,strong)UIView *bagView;

@property(nonatomic ,strong)UITextField *nameTxtfield;

@property(nonatomic ,strong)UITextField *phoneTxtfield;

@property(nonatomic ,strong)UILabel *workerTypeLabel;

@property(nonatomic ,strong)NSMutableArray *dataArray;

@end

@implementation RecommendFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"推荐好友" withColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRightButton)];
    self.navigationItem.rightBarButtonItem = barItem;
    
    _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-16, 30)];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    _numberLabel.font = [UIFont systemFontOfSize:10];
    _numberLabel.textColor = GREEN_COLOR;
    [self.view addSubview:_numberLabel];
    
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableview.top = _numberLabel.bottom;
    _tableview.height = self.view.bounds.size.height - 30;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirstPageData)];
    [_tableview.mj_header beginRefreshing];
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.view addSubview:_tableview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark Private Method

-(void)clickRightButton
{
    [self loadWorkerType];
    [self configAddView];
    [self initWithPickView];
//    PermissionUpdateViewController *vc = [PermissionUpdateViewController new];
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    
}
-(void)configAddView
{
    if (!_addWindow) {
        _addWindow = [[UIWindow alloc] initWithFrame:self.view.bounds];
        _addWindow.windowLevel = UIWindowLevelNormal;
        _addWindow.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        
        _clickView = [[UIView alloc] initWithFrame:self.view.bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCancelBtn)];
        [_clickView addGestureRecognizer:tap];
        [_addWindow addSubview:_clickView];
        
        _bagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, 200)];
        _bagView.center = _clickView.center;
        _bagView.top = 100;
        _bagView.backgroundColor = [UIColor whiteColor];
        _bagView.layer.cornerRadius = 5;
        _bagView.layer.masksToBounds = YES;
        [_addWindow addSubview:_bagView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, _bagView.width, 20)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = TITLECOLOR;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"推荐好友";
        [_bagView addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom+10, _bagView.width, 1)];
        lineView.backgroundColor = GREEN_COLOR;
        [_bagView addSubview:lineView];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, lineView.bottom+10, 50, 20)];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.text = @"姓    名:";
        nameLabel.textColor = TITLECOLOR;
        [_bagView addSubview:nameLabel];
        
        _nameTxtfield = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right+3, nameLabel.top-2, _bagView.width-nameLabel.right-19, 25)];
        _nameTxtfield.placeholder = @"请输入姓名";
        _nameTxtfield.font = [UIFont systemFontOfSize:12];
        _nameTxtfield.textColor = SUBTITLECOLOR;
        _nameTxtfield.layer.borderColor = UIColorFromRGB(233, 233, 233).CGColor;
        _nameTxtfield.layer.borderWidth = 0.5;
        _nameTxtfield.layer.cornerRadius = 5;
        [_bagView addSubview:_nameTxtfield];
        
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, _nameTxtfield.bottom+10, 50, 20)];
        typeLabel.text = @"工    种:";
        typeLabel.font = [UIFont systemFontOfSize:14];
        typeLabel.textColor = TITLECOLOR;
        [_bagView addSubview:typeLabel];
        
        
        _workerTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeLabel.right+3, _nameTxtfield.bottom+8, _nameTxtfield.width, _nameTxtfield.height)];
        _workerTypeLabel.font = [UIFont systemFontOfSize:12];
        _workerTypeLabel.textColor = UIColorFromRGB(206, 206, 211);
        _workerTypeLabel.text = @"请选择工种";
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseWorkerType)];
        _workerTypeLabel.userInteractionEnabled = YES;
        [_workerTypeLabel addGestureRecognizer:tap1];
        _workerTypeLabel.layer.borderColor = UIColorFromRGB(233, 233, 233).CGColor;
        _workerTypeLabel.layer.borderWidth = 0.5;
        _workerTypeLabel.layer.cornerRadius = 5;
        [_bagView addSubview:_workerTypeLabel];
        
        
        UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, _workerTypeLabel.bottom+10, 50, 20)];
        phoneLabel.font = [UIFont systemFontOfSize:14];
        phoneLabel.text = @"手机号:";
        phoneLabel.textColor = TITLECOLOR;
        [_bagView addSubview:phoneLabel];
        
        _phoneTxtfield = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right+3, _workerTypeLabel.bottom+8, _nameTxtfield.width-40, _nameTxtfield.height)];
        _phoneTxtfield.placeholder = @"请输入手机号";
        _phoneTxtfield.textColor = SUBTITLECOLOR;
        _phoneTxtfield.font = [UIFont systemFontOfSize:12];
        _phoneTxtfield.keyboardType = UIKeyboardTypePhonePad;
        _phoneTxtfield.layer.borderColor = UIColorFromRGB(233, 233, 233).CGColor;
        _phoneTxtfield.layer.borderWidth = 0.5;
        _phoneTxtfield.layer.cornerRadius = 5;
        [_bagView addSubview:_phoneTxtfield];
        
        UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        phoneBtn.frame = CGRectMake(_phoneTxtfield.right, _phoneTxtfield.top-8, 40, 40);
        phoneBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [phoneBtn setImage:[UIImage imageNamed:@"phone_address"] forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(visitPhoneAddress) forControlEvents:UIControlEventTouchUpInside];
        [_bagView addSubview:phoneBtn];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(8, _phoneTxtfield.bottom+20, 80, 30);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [_bagView addSubview:cancelBtn];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(_bagView.width-88, cancelBtn.top,cancelBtn.width, 30);
        [confirmBtn setTitle:@"下一个" forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [confirmBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        [_bagView addSubview:confirmBtn];
        
        [self.view addSubview:_addWindow];
        
    }
    
    [_addWindow makeKeyWindow];
    _addWindow.hidden = NO;
    
}


-(void)clickCancelBtn
{
    [_addWindow resignKeyWindow];
    _addWindow.hidden = YES;
}

-(void)clickConfirmBtn
{
    [self addFriend];
}

-(void)chooseWorkerType
{
    [self.nameTxtfield resignFirstResponder];
    [personalDataPickerView reloadAllComponents];
//    [personalDataPickerView selectRow:0 inComponent:0 animated:YES];
    [UIView animateWithDuration:0.1 animations:^{
        dateBackgroundView.top = SCREEN_HEIGHT- dateBackgroundView.height;
    }];
    
}

-(void)visitPhoneAddress
{
    ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
    nav.peoplePickerDelegate = self;
    if(IOS8){
        nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)addFriend
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if (self.nameTxtfield.text.length == 0) {
        [MBProgressHUD showError:@"请输入姓名" toView:self.view];
        return;
    }
    if (self.phoneTxtfield.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
        return;
    }
    if ([self.workerTypeLabel.text isEqualToString:@"请选择工种"]) {
        [MBProgressHUD showError:@"请选择工种" toView:self.view];
        return;
    }
    NSDictionary *paramDict = @{@"uid":uid,@"name":self.nameTxtfield.text,@"mobile":self.phoneTxtfield.text,@"type":[typeArray[selectedRow] objectForKey:@"wid"]};
    [[NetworkSingletion sharedManager]addFriend:paramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"****%@",dict);
        if ([dict[@"code"] integerValue]==0) {
//            [MBProgressHUD showSuccess:@"添加成功" toView:self.view];
            self.workerTypeLabel.text = @"";
            self.nameTxtfield.text = @"";
            self.phoneTxtfield.text = @"";
            NSDictionary *dict = @{@"name":self.nameTxtfield.text,@"mobile":self.phoneTxtfield.text,@"status":@"0"};
            [self.dataArray insertObject:dict atIndex:0];
            [self.tableview reloadData ];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
    self.phoneTxtfield.text = phoneNO;
//    if (phone && [ZXValidateHelper checkTel:phoneNO]) {
//        phoneNum = phoneNO;
//        [self.tableView reloadData];
//        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
//        return;
//    }
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark PickView

-(void)initWithPickView
{
    if (!dateBackgroundView) {
        dateBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, self.view.frame.size.width, 300)];
        dateBackgroundView.backgroundColor = [UIColor whiteColor];
        [self.addWindow addSubview:dateBackgroundView];
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
    self.workerTypeLabel.text = [typeArray[selectedRow] objectForKey:@"type_name"];
    self.workerTypeLabel.textColor = TITLECOLOR;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return typeArray.count;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [typeArray[row] objectForKey:@"type_name"];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedRow = row;
}


#pragma mark 加载数据

-(void)loadWorkerType
{
    __weak typeof(self) weakself = self;
    [[NetworkSingletion sharedManager]getWorkerType:nil onSucceed:^(NSDictionary *dict) {
        //        NSLog(@"**23*%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            typeArray = dict[@"data"];
            [personalDataPickerView reloadAllComponents];
        }else{
            [weakself loadWorkerType];
        }
    } OnError:^(NSString *error) {
        [weakself loadWorkerType];
    }];
}

-(void)loadFirstPageData
{
    page = 1;
    [self.dataArray removeAllObjects];
    [self loadData];
}

-(void)loadMoreData
{
    page++;
    [self loadData];
}

-(void)loadData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSDictionary *paramDict = @{@"uid":uid,@"p":@(page),@"each":@"12"};
    [[NetworkSingletion sharedManager]friendList:paramDict onSucceed:^(NSDictionary *dict) {
        NSLog(@"****%@",dict);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if ([dict[@"code"]integerValue]==0) {
            [self.dataArray addObjectsFromArray:[dict[@"data"] objectForKey:@"list"]];
            self.numberLabel.text = [NSString stringWithFormat:@"已注册：%@/%@",[dict[@"data"] objectForKey:@"regCount"],[dict[@"data"] objectForKey:@"requestCount"]];
        }else{
           [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
        [self.tableview reloadData];
    } OnError:^(NSString *error) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [MBProgressHUD showError:error toView:self.view];
    }];
}

#pragma mark UITableviewDelegate & datasource 

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"recommend";
    RecommendFriendCell *cell = (RecommendFriendCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[RecommendFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count > 0) {
         [cell setRecommendCell:self.dataArray[indexPath.row]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}



@end
