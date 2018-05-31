//
//  SetManagerViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/21.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SetManagerViewController.h"
#import "CXZ.h"
#import "DepartmentTableViewCell.h"

#import "AdressBookViewController.h"
#import "SelectedDepartmentViewController.h"

#import "CompanyDepartmentModel.h"
#import "PersonelModel.h"

@interface SetManagerViewController ()<UITableViewDelegate,UITableViewDataSource,DepartmentCellDelegate,AdressBookDelegate,SelectedDepartmentDelegate>
{
    NSInteger sectionCount;
    
    NSInteger selectedSection;
}
@property (nonatomic , strong)UITableView *tableview;

@property (nonatomic , strong)NSMutableDictionary *personDict;

@property (nonatomic , strong)NSMutableDictionary *departDict;

//@property (nonatomic , strong)NSMutableArray *cashierArray;

@end

@implementation SetManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitleWithString:@"设置权限" withColor:[UIColor whiteColor]];
    [self setupBackw];
    [self setupNextWithString:@"添加" withColor:[UIColor whiteColor]];
    
    _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    
    sectionCount = self.personDict.count > 0 ? self.personDict.count :5;
    _tableview.height = self.view.frame.size.height - 104;
    
    UIButton *nextBtn =[CustomView customButtonWithContentView:self.view image:nil title:@"提交"];
    nextBtn.frame = CGRectMake(0, _tableview.bottom, SCREEN_WIDTH, 40);
    [nextBtn addTarget:self action:@selector(clickNextButton) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = TOP_GREEN;
    nextBtn.layer.cornerRadius = 3;
    
    [self loadApprovalData];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark Data Method

-(void)loadApprovalData
{
    NSDictionary *paramDict = @{@"company_id":self.compony_id,@"type":@(self.form_type)};
    [[NetworkSingletion sharedManager]getFormApprovalPerson:paramDict onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            NSArray *dataArray = dict[@"data"];
            if (dataArray.count > 0) {
                NSArray *personArray = [PersonelModel objectArrayWithKeyValuesArray:dataArray];
                NSString *lastDepartment;
                NSInteger key = 0;
                for (int i = 0; i < personArray.count; i ++) {
                    PersonelModel *person = personArray[i];
                    
                    if ([person.department_name isEqualToString:lastDepartment]) {
                        
                    }else{
                        key ++;
                    }
                    
                    NSMutableArray *array = [self.personDict objectForKey:[NSString stringWithFormat:@"%li",key-1]];
                    if (!array) {
                        array = [NSMutableArray array];
                    }
                    [array addObject:person];
                    [self.personDict setObject:array forKey:[NSString stringWithFormat:@"%li",key-1]];
                    CompanyDepartmentModel *model = [[CompanyDepartmentModel alloc]init];
                    model.department_name = person.department_name;
                    model.department_id = [person.department_id integerValue];
                    [self.departDict setObject:model forKey:[NSString stringWithFormat:@"%li",key-1]];
                    lastDepartment = person.department_name;
                }
            }
            sectionCount = self.personDict.count > 0 ? self.personDict.count :5;
            [self.tableview reloadData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        
    }];
}

#pragma mark Systom Mehod

-(void)onNext
{
    sectionCount ++;
    [self.tableview reloadData];
    
}


#pragma mark Private Method

-(void)clickNextButton
{
    NSMutableArray *personArray = [NSMutableArray array];
    NSMutableArray *paramArray = [NSMutableArray array];
    NSArray *valueArray = [self.personDict allValues];
    if (valueArray.count == 0) {
        [MBProgressHUD showError:@"您还未设置审批人员" toView:self.view];
    }
    for (NSArray *array in valueArray) {
        [personArray addObjectsFromArray:array];
    }
    for (PersonelModel *person in personArray) {
        [paramArray addObject:@{@"uid":person.uid}];
    }
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                @"company_id":self.compony_id,
                                @"type":@(self.form_type),
                                @"sequence":[NSString dictionaryToJson:paramArray]
                                };
    [[NetworkSingletion sharedManager]setApprovalList:paramDict onSucceed:^(NSDictionary *dict) {
        //                    NSLog(@"**set**%@***%@",dict,dict[@"message"]);
        if ([dict[@"code"] integerValue]==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}

-(void)addPersonToPostion:(UIButton*)button
{
    selectedSection = button.tag;
    CompanyDepartmentModel *model = [self.departDict objectForKey:[NSString stringWithFormat:@"%li",selectedSection]];
    AdressBookViewController *bookVC = [[AdressBookViewController alloc]init];
    bookVC.companyid = self.compony_id;
    bookVC.departid = model.department_id;
    bookVC.isSelect = YES;
    bookVC.delegate = self;
    bookVC.loadDataType = 1;
    bookVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bookVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}


-(void)addDepartment:(UITapGestureRecognizer*)tap
{
    selectedSection = ((UILabel*)tap.view).tag-100;
    SelectedDepartmentViewController *departVC = [[SelectedDepartmentViewController alloc]init];
    departVC.companyid = self.compony_id;
    departVC.isShow = YES;
    departVC.delegate = self;
    departVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: departVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark 财务回执——相关接口

//-(void)loadCashierData
//{
//    NSDictionary *paramDict = @{@"company_id":self.compony_id,@"department_id":@(-2)};
//    [[NetworkSingletion sharedManager]getDepartmentPersonnerlData:paramDict onSucceed:^(NSDictionary *dict) {
////                NSLog(@"**sdsdsd**%@",dict);
//        if ([dict[@"code"] integerValue]==0) {
//            NSArray *persnonnelArray = [PersonelModel objectArrayWithKeyValuesArray:dict[@"data"]];
//            [self.cashierArray addObjectsFromArray:persnonnelArray];
//            [self.tableview reloadData];
//        }else{
//            [MBProgressHUD showError:dict[@"message"] toView:self.view];
//        }
//        
//    } OnError:^(NSString *error) {
//        [MBProgressHUD showError:error toView:self.view];
//    }];
//}

//-(void)setCashierWithArray:(NSArray*)personArray
//{
//    NSMutableArray *array = [NSMutableArray array];
//    [personArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        PersonelModel *person = (PersonelModel*)obj;
//        [array addObject:person.personnel_id];
//    }];
//    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
//                                @"personnel_id":[NSString dictionaryToJson:array],
//                                @"company_id":self.compony_id
//                                };
//    [[NetworkSingletion sharedManager]setCashier:paramDict onSucceed:^(NSDictionary *dict) {
////        NSLog(@"**sdsdsd**%@",dict);
//        if ([dict[@"code"] integerValue] != 0) {
//            [MBProgressHUD showError:dict[@"message"] toView:self.view];
//        }
//    } OnError:^(NSString *error) {
//        
//    }];
//}

//-(void)deleteCashier:(PersonelModel *)person;
//{
//    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
//                                @"personnel_id":person.personnel_id,
//                                @"company_id":self.compony_id,
//                                @"my_personnel_id":self.person_id
//                                };
//    [[NetworkSingletion sharedManager]deleteCashier:paramDict onSucceed:^(NSDictionary *dict) {
////        NSLog(@"****%@,%@",dict,dict[@"message"]);
//        if ([dict[@"code"] integerValue] == 0) {
//        
//            [self.tableview reloadData];
//        }else{
//            [MBProgressHUD showError:dict[@"message"] toView:self.view];
//        }
//    } OnError:^(NSString *error) {
//        
//    }];
//}

#pragma mark Delegate Method

-(void)didSelectedDepartment:(NSDictionary *)department
{
    CompanyDepartmentModel *model = [CompanyDepartmentModel objectWithKeyValues:department];
    [self.departDict setObject:model forKey:[NSString stringWithFormat:@"%li",selectedSection]];
    [self.tableview reloadData];
}

-(void)saveAdressBook:(NSMutableArray*)selectedArray
{
  
    NSMutableArray *personArray = [self.personDict objectForKey:[NSString stringWithFormat:@"%li",selectedSection]];
    if (!personArray) {
        personArray = [NSMutableArray array];
    }
    NSArray *array = [PersonelModel objectArrayWithKeyValuesArray:selectedArray];
    [personArray addObjectsFromArray:array];
    [self.personDict setObject:personArray forKey:[NSString stringWithFormat:@"%li",selectedSection]];
    NSIndexSet *indextset = [NSIndexSet indexSetWithIndex:selectedSection];
    [self.tableview reloadSections:indextset withRowAnimation:UITableViewRowAnimationNone];
}


-(void)clickDeleteButton:(NSInteger)tag
{
    NSInteger section = tag/1000;
    NSInteger row = tag%1000;
    NSMutableArray *personArray = [self.personDict objectForKey:[NSString stringWithFormat:@"%li",section]];
    [personArray removeObjectAtIndex:row];
    [self.personDict setObject:personArray forKey:[NSString stringWithFormat:@"%li",section]];
    NSIndexSet *indextset = [NSIndexSet indexSetWithIndex:section];
    [self.tableview reloadSections:indextset withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionCount;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    NSMutableArray *personArray = [self.personDict objectForKey:[NSString stringWithFormat:@"%li",section]];
    return personArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DepartmentTableViewCell *cell = (DepartmentTableViewCell*)[tableView dequeueReusableCellWithIdentifier: @"DepartmentTableViewCell"];
    if (!cell) {
        cell = [[DepartmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DepartmentTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.deleteButton.hidden = NO;
    cell.tag = indexPath.section*1000+indexPath.row;
    NSMutableArray *personArray =[self.personDict objectForKey:[NSString stringWithFormat:@"%li",indexPath.section]];
    if (personArray.count > 0) {
        [cell setMangerDataWith:personArray[indexPath.row]];
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    //    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [CustomView customButtonWithContentView:view image:@"add" title:nil];
    button.frame = CGRectMake(SCREEN_WIDTH-36, 2, 30, 30);
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    button.tag = section;
    [button addTarget:self action:@selector(addPersonToPostion:) forControlEvents:UIControlEventTouchUpInside];
    
    CompanyDepartmentModel *model = [self.departDict objectForKey:[NSString stringWithFormat:@"%li",section]];
    NSString *title;
    if (model) {
        button.hidden = NO;
        title = model.department_name;
    }else{
        
        NSString *str = [NSString translationArabicNum:section+1];
        title = [NSString stringWithFormat:@"第%@级",str];
        button.hidden = YES;
        if (section == sectionCount-2 ) {
            title = @"....";
        }else if (section == sectionCount-1){
            title = @"最高级";
        }
    }
    UILabel *label = [CustomView customTitleUILableWithContentView:view title:title];
    label.frame = CGRectMake(8, 8, SCREEN_WIDTH-36, 20);
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addDepartment:)];
    label.userInteractionEnabled = YES;
    label.tag = section+100;
    [label addGestureRecognizer:tap];
    
    return view;
}




#pragma mark get/set







-(NSMutableDictionary*)personDict
{
    if (!_personDict) {
        _personDict = [NSMutableDictionary dictionary];
    }
    return _personDict;
}

-(NSMutableDictionary*)departDict
{
    if (!_departDict) {
        _departDict = [NSMutableDictionary dictionary];
    }
    return _departDict;
}



@end
