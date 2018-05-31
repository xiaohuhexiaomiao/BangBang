//
//  SetPositionViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/18.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SetPositionViewController.h"
#import "CXZ.h"

#import "DepartmentTableViewCell.h"

#import "WorkerListViewController.h"
#import "ManagerViewController.h"

#import "PositionModel.h"
#import "PersonelModel.h"

@interface SetPositionViewController ()<UITableViewDelegate,UITableViewDataSource,AdressBookDelegate,DepartmentCellDelegate,WorkerListControllerDelegate>
{
    NSInteger selectedSection;
}
@property(nonatomic ,strong)UITableView *tableview;

@property(nonatomic ,strong)NSMutableDictionary *personDict;

@property(nonatomic ,strong)NSMutableArray *alreadySelectedPersonArray;

@property(nonatomic ,strong)NSMutableDictionary *allDict;

@end

@implementation SetPositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitleWithString:@"创建公司-添加部门人员" withColor:[UIColor whiteColor]];
    [self setupBackw];
    
    _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.height = self.view.frame.size.height-104;
    [self.view addSubview:_tableview];
    
    UIButton *lastBtn =[CustomView customButtonWithContentView:self.view image:nil title:@"上一步"];
    [lastBtn setTitleColor:TOP_GREEN forState:UIControlStateNormal];
    lastBtn.frame = CGRectMake(0, _tableview.bottom, SCREEN_WIDTH/2, 40);
    [lastBtn addTarget:self action:@selector(clickLastButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextBtn =[CustomView customButtonWithContentView:self.view image:nil title:@"下一步"];
     [nextBtn setTitleColor:TOP_GREEN forState:UIControlStateNormal];
    nextBtn.frame = CGRectMake(SCREEN_WIDTH/2, _tableview.bottom, SCREEN_WIDTH/2, 40);
    [nextBtn addTarget:self action:@selector(clickNextButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark Private Method

-(void)clickLastButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickNextButton
{
    
    NSMutableArray *paramArray = [NSMutableArray array];
    NSArray *keyArray = [self.allDict allKeys];
    for (int i = 0; i < keyArray.count; i++) {
        NSMutableArray *valueArray = [self.allDict objectForKey:keyArray[i]];
        if (valueArray.count >0) {
            NSDictionary *dict = @{@"name":keyArray[i],@"positions":valueArray};
            [paramArray addObject:dict];
        }
    }
    if (paramArray.count == 0) {
        [MBProgressHUD showError:@"请为部门添加人员" toView:self.view];
        return;
    }

    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                @"company_id":self.compony_id,
                                @"big_json":[NSString dictionaryToJson:paramArray]
                                };
    [[NetworkSingletion sharedManager]lastAddPersonToCompany:paramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"**ok*%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            ManagerViewController *managevc = [[ManagerViewController alloc]init];
            managevc.compony_id = self.compony_id;
            managevc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:managevc animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        
    }];
}

-(void)addPersonToPostion:(UIButton*)button
{
    selectedSection = button.tag;
    WorkerListViewController *nearbyController = [[WorkerListViewController alloc] init];
    nearbyController.delegate = self;
    nearbyController.alreadySelectedArray = self.alreadySelectedPersonArray;
    nearbyController.hidesBottomBarWhenPushed = YES;
    //    bookVC.areadySelectArray = self.alreadySelectedPersonArray;
    nearbyController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nearbyController animated:YES];
    self.hidesBottomBarWhenPushed = YES;

}

#pragma mark Controller Delegate

-(void)didSelsectWorker:(NSMutableArray *)selectedArray
{
    
//     NSLog(@"*we*we**%@",selectedArray);
    [self.alreadySelectedPersonArray addObjectsFromArray:selectedArray];
    
    PositionModel *posion = self.positionArray[selectedSection];
    NSMutableArray *array = [self.personDict objectForKey:posion.position_name];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    
    NSMutableArray *departArray = [self.allDict objectForKey:posion.depart_name];
    if (!departArray) {
        departArray = [NSMutableArray array];
    }
    if (array) {
        [dict setObject:array forKey:@"persons"];
        [dict setObject:posion.position_name forKey:@"name"];
        [dict setObject:@(array.count) forKey:@"personCount"];
        [departArray removeObject:dict];
    }
    
    NSMutableArray *personArray = [NSMutableArray array];
    [personArray addObjectsFromArray:array];
    [personArray addObjectsFromArray:selectedArray];
//    NSLog(@"*we***%@",personArray);
    [dict setObject:posion.position_name forKey:@"name"];
    [dict setObject:personArray forKey:@"persons"];
    [dict setObject:@(personArray.count) forKey:@"personCount"];
    
    [self.personDict setObject:personArray forKey:posion.position_name];
    NSIndexSet *indextset = [NSIndexSet indexSetWithIndex:selectedSection];
    [self.tableview reloadSections:indextset withRowAnimation:UITableViewRowAnimationNone];
    
    
    [departArray addObject:dict];
    [self.allDict setObject:departArray forKey:posion.depart_name];
}

-(void)clickDeleteButton:(NSInteger)tag
{
    NSInteger section = tag/100;
    NSInteger row = tag%100;
    
     PositionModel *posion = self.positionArray[section];
     NSMutableArray *personArray = [self.personDict objectForKey:posion.position_name];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:personArray forKey:@"persons"];
    [dict setObject:posion.position_name forKey:@"name"];
    [dict setObject:@(personArray.count) forKey:@"personCount"];
    
    NSMutableArray *departArray = [self.allDict objectForKey:posion.depart_name];
    [departArray removeObject:dict];
    [self.allDict setObject:departArray forKey:posion.depart_name];
   
    [self.alreadySelectedPersonArray removeObject:personArray[row]];
    [personArray removeObjectAtIndex:row];
    if (personArray.count > 0) {
        [dict setObject:personArray forKey:@"persons"];
        [dict setObject:posion.position_name forKey:@"name"];
        [dict setObject:@(personArray.count) forKey:@"personCount"];
        [departArray addObject:dict];
        [self.allDict setObject:departArray forKey:posion.depart_name];
    }
    [self.personDict setObject:personArray forKey:posion.position_name];
    [self.tableview reloadData];
    
}

#pragma mark UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    NSLog(@"***%li",self.positionArray.count);
    
    return self.positionArray.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PositionModel *posion = self.positionArray[section];
    NSArray *personArray = [self.personDict objectForKey:posion.position_name];
    return personArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  PositionModel *posion = self.positionArray[indexPath.section];
    NSArray *personArray = [self.personDict objectForKey:posion.position_name];
    DepartmentTableViewCell *cell = (DepartmentTableViewCell*)[tableView dequeueReusableCellWithIdentifier: @"DepartmentTableViewCell"];
    if (!cell) {
        cell = [[DepartmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DepartmentTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.deleteButton.hidden = NO;
    cell.tag = indexPath.section*100+indexPath.row;
    if (personArray.count > 0) {
        PersonelModel *person = [PersonelModel objectWithKeyValues:personArray[indexPath.row]];

      [cell setMangerDataWith:person];
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
    return 35;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    //    view.backgroundColor = [UIColor whiteColor];
     PositionModel *posion = self.positionArray[section];
    UILabel *label = [CustomView customTitleUILableWithContentView:view title:[NSString stringWithFormat:@"%@-%@",posion.depart_name,posion.position_name]];
    label.frame = CGRectMake(8, 8, SCREEN_WIDTH-36, 20);
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    
    UIButton *button = [CustomView customButtonWithContentView:view image:@"add" title:nil];
    button.frame = CGRectMake(SCREEN_WIDTH-36, 2, 30, 30);
    button.tag = section;
    [button addTarget:self action:@selector(addPersonToPostion:) forControlEvents:UIControlEventTouchUpInside];
    return view;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


#pragma mark get/set

-(NSMutableDictionary*)personDict
{
    if (!_personDict) {
        _personDict = [NSMutableDictionary dictionary];
    }
    return _personDict;
}
-(NSMutableDictionary*)allDict
{
    if (!_allDict) {
        _allDict = [NSMutableDictionary dictionary];
    }
    return _allDict;
}
-(NSMutableArray*)alreadySelectedPersonArray
{
    if (!_alreadySelectedPersonArray) {
        _alreadySelectedPersonArray = [NSMutableArray array];
        
    }
    return _alreadySelectedPersonArray;
}


@end
