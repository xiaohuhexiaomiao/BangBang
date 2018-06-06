//
//  AdressBookViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "AdressBookViewController.h"
#import "CXZ.h"

#import "DepartmentTableViewCell.h"
#import "PersonelModel.h"

#import "PersonDetailViewController.h"
#import "ListViewController.h"

@interface AdressBookViewController ()<UITableViewDelegate,UITableViewDataSource,DepartmentCellDelegate>

@property(nonatomic , strong)UITableView *adressTableview;

@property(nonatomic , strong)NSMutableArray *selectedArray;

@property(nonatomic , strong)NSMutableDictionary *dataDict;

@property(nonatomic , strong)NSMutableArray *indextArray;

@end

@implementation AdressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupBackw];
    
    [self setupTitleWithString:@"通讯录" withColor:[UIColor whiteColor]];
    if (self.isSelect == YES) {
        [self setupNextWithString:@"确定" withColor:TOP_GREEN];
    }
    if (self.operation_type == 1) {
        [self setupTitleWithString:@"添加管理员" withColor:[UIColor whiteColor]];
    }else if (self.operation_type == 2){
        [self setupTitleWithString:@"设置回执人员" withColor:[UIColor whiteColor]];
        [self setupNextWithString:@"保存" withColor:TOP_GREEN];
    }else if (self.operation_type == 3){
        [self setupTitleWithString:@"选择审批人员" withColor:[UIColor whiteColor]];
        [self setupNextWithString:@"提交" withColor:TOP_GREEN];
    }

    if (self.loadDataType == 3) {
        [self setupTitleWithString:@"抄送范围" withColor:[UIColor whiteColor]];
    }
    _adressTableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _adressTableview.height = self.view.frame.size.height-64;
    _adressTableview.delegate = self;
    _adressTableview.dataSource = self;
    _adressTableview.tableFooterView = [UIView new];
    [self.view addSubview:_adressTableview];
    
    [self loadCompanyPesson];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark Private Method

-(void)loadCompanyPesson
{
    if (self.loadDataType == 1) {//加载部门人员
        NSDictionary *paramDict = @{@"company_id":self.companyid,@"department_id":@(self.departid)};
        [[NetworkSingletion sharedManager]getDepartmentPersonnerlData:paramDict onSucceed:^(NSDictionary *dict) {
            //        NSLog(@"**sdsdsd**%@",dict);
            if ([dict[@"code"] integerValue]==0) {
                NSArray *array = [dict objectForKey:@"data"];
                for (int i = 0; i < array.count; i++) {
                    PersonelModel *perSonnel = [PersonelModel objectWithKeyValues:array[i]];
                    
                    NSString *key;
                    if (![NSString isBlankString:perSonnel.name]) {
                        NSString *name = [perSonnel.name toPinyinWithoutTone];
                        key = [[name substringToIndex:1] uppercaseString];
                    }else{
                        key = @"#";
                    }
                    
                    NSMutableArray *valueArray = [self.dataDict objectForKey:key];
                    if (!valueArray) {
                        valueArray = [NSMutableArray array];
                    }
                    [valueArray addObject:array[i]];
                    
                    [self.dataDict setObject:valueArray forKey:key];
                }
                
                self.indextArray = [NSMutableArray array];
                [self.indextArray addObjectsFromArray:[[self.dataDict allKeys]sortedArrayUsingSelector:@selector(compare:)]];
                [self.adressTableview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
            
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }else if(self.loadDataType == 2){//加载公司人员
        [[NetworkSingletion sharedManager]getDepartmentPersonnerlData:@{@"company_id":self.companyid} onSucceed:^(NSDictionary *dict) {
//                    NSLog(@"company  %@",dict);
            if ([dict[@"code"] integerValue]==0) {
                NSArray *array = [dict objectForKey:@"data"];
                for (int i = 0; i < array.count; i++) {
                    PersonelModel *perSonnel = [PersonelModel objectWithKeyValues:array[i]];
                    
                    NSString *key;
                    if (![NSString isBlankString:perSonnel.name]) {
                        NSString *name = [perSonnel.name toPinyinWithoutTone];
                        key = [[name substringToIndex:1] uppercaseString];
                    }else{
                        key = @"#";
                    }
                    
                    NSMutableArray *valueArray = [self.dataDict objectForKey:key];
                    if (!valueArray) {
                        valueArray = [NSMutableArray array];
                    }
                    [valueArray addObject:array[i]];
                    
                    [self.dataDict setObject:valueArray forKey:key];
                }
                
                self.indextArray = [NSMutableArray array];
                [self.indextArray addObjectsFromArray:[[self.dataDict allKeys]sortedArrayUsingSelector:@selector(compare:)]];
                [self.adressTableview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }else if(self.loadDataType == 3){//加载抄送范围
        [[NetworkSingletion sharedManager]getDiarySendRange:@{@"publish_id":self.publishID} onSucceed:^(NSDictionary *dict) {
//                    NSLog(@"company  %@",dict);
            if ([dict[@"code"] integerValue]==0) {
                NSArray *array = [dict objectForKey:@"data"];
                for (int i = 0; i < array.count; i++) {
                    PersonelModel *perSonnel = [PersonelModel objectWithKeyValues:array[i]];
                    
                    NSString *key;
                    if (![NSString isBlankString:perSonnel.name]) {
                        NSString *name = [perSonnel.name toPinyinWithoutTone];
                        key = [[name substringToIndex:1] uppercaseString];
                    }else{
                        key = @"#";
                    }
                    
                    NSMutableArray *valueArray = [self.dataDict objectForKey:key];
                    if (!valueArray) {
                        valueArray = [NSMutableArray array];
                    }
                    [valueArray addObject:array[i]];
                    
                    [self.dataDict setObject:valueArray forKey:key];
                }
                
                self.indextArray = [NSMutableArray array];
                [self.indextArray addObjectsFromArray:[[self.dataDict allKeys]sortedArrayUsingSelector:@selector(compare:)]];
                [self.adressTableview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }
    
    
}

#pragma mark

-(void)onNext
{
//    NSLog(@"tag %li",self.selectedArray.count);
    if (self.operation_type == 1) {
        NSMutableArray *personnelArray = [NSMutableArray array];
        for (NSDictionary *dict in self.selectedArray) {
            [personnelArray addObject:dict[@"personnel_id"]];
        }
        NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                    @"personnel_id":[NSString dictionaryToJson:personnelArray],
                                    @"company_id":self.companyid};
        [[NetworkSingletion sharedManager]addManager:paramDict onSucceed:^(NSDictionary *dict) {
            //            NSLog(@"addmanage %@",dict);
            if ([dict[@"code"] integerValue]==0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }else if (self.operation_type == 2){
         [self saveReceiptPerson];
    }else if (self.operation_type == 3){
        [self uploadForm];
    }else{
        if (self.selectedArray.count > 0) {
            [self.delegate saveAdressBook:self.selectedArray];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"请选择人员" toView:self.view];
        }
    }
}

-(void)uploadForm
{
    if (self.selectedArray.count > 0) {
        NSMutableArray *array = [NSMutableArray array];
        [self.selectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = (NSDictionary*)obj;
            [array addObject:dict[@"uid"]];
        }];
        NSDictionary *paramDict = @{@"approval_persons":[NSString dictionaryToJson:array],
                                    @"company_id":self.companyid,
                                    @"inspection_type_id":@(self.form_type),
                                    @"content":self.result_json_string};
        [[NetworkSingletion sharedManager]uploadInspection:paramDict onSucceed:^(NSDictionary *dict) {
            //            NSLog(@"****%@",dict);
            if ([dict[@"code"] integerValue]==0) {
                for (ListViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[ListViewController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            
        }];
        
    }else{
        [MBProgressHUD showError:@"您还未选择审批人员" toView:self.view];
    }
}

-(void)saveReceiptPerson
{
    if (self.selectedArray.count > 0) {
        NSMutableArray *array = [NSMutableArray array];
        [self.selectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = (NSDictionary*)obj;
            [array addObject:dict[@"uid"]];
        }];
        NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                    @"company_id":self.companyid,
                                    @"type":@(self.setType),
                                    @"personnel":[NSString dictionaryToJson:array]};
        [[NetworkSingletion sharedManager]setReceiptPerson:paramDict onSucceed:^(NSDictionary *dict) {
//            NSLog(@"****%@",dict);
            if ([dict[@"code"] integerValue]==0) {
                [self.delegate saveAdressBook:self.selectedArray];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                 [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            
        }];
        
    }else{
        [MBProgressHUD showError:@"您还未设置人员" toView:self.view];
    }
}

#pragma mark Cell Delegate

-(void)clickSeleteButton:(BOOL)isSeleted tag:(NSInteger)tag
{
    
    NSInteger section = tag/1000;
    NSInteger row = tag%1000;
    NSString *key = self.indextArray[section];
    NSArray *dataArr = self.dataDict[key];
    if (isSeleted) {
        [self.selectedArray addObject:dataArr[row]];
    }else{
        [self.selectedArray removeObject:dataArr[row]];
    }

}

#pragma mark UITabelview Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.indextArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = self.indextArray[section];
    NSArray *dataArr = self.dataDict[key];
    return dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DepartmentTableViewCell *cell = (DepartmentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"DepartmentCell"];
    if (!cell) {
        cell = [[DepartmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DepartmentCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row+indexPath.section*1000;
    cell.delegate = self;
    
    NSString *key = self.indextArray[indexPath.section];
    NSArray *dataArr = self.dataDict[key];
    PersonelModel *person = [PersonelModel objectWithKeyValues:dataArr[indexPath.row]];
    if (dataArr.count > 0) {
        if (self.isSelect == YES) {
           
            [cell setSelectDeparmentCellWith:person];
            [cell.selectBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
            for (NSDictionary *dict in self.areadySelectArray) {
                if ([dict[@"uid"] isEqualToString:person.uid]) {
                    [cell.selectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
                    [self.selectedArray addObject:dataArr[indexPath.row]];
                    break;
                }
            }
        }else{
            if (self.loadDataType == 3) {
                [cell setNormalDataWith:person];
            }else{
                [cell setDeparmentCellWith:person];
            }
            
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     return 20.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.indextArray[section];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = UIColorFromRGB(148, 148, 153);
    lable.text = [NSString stringWithFormat:@"    %@",self.indextArray[section]];
    return lable;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    return self.indextArray;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.indextArray.count > 0) {
        if (self.is_single_selected) {
            NSString *key = self.indextArray[indexPath.section];
            NSArray *dataArr = self.dataDict[key];
            [self.delegate selectedPorjectManager:dataArr[indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString *key = self.indextArray[indexPath.section];
            NSArray *dataArr = self.dataDict[key];
            PersonelModel *person = [PersonelModel objectWithKeyValues:dataArr[indexPath.row]];
            PersonDetailViewController *personVC = [[PersonDetailViewController alloc]init];
            personVC.look_uid = person.uid;
            personVC.companyID = self.companyid;
            personVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personVC animated:YES];
            
        }

    }
    }



#pragma mark get / set

-(NSMutableArray*)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
//        [_selectedArray addObjectsFromArray:self.areadySelectArray];
    }
    return _selectedArray;
}

-(NSMutableDictionary*)dataDict
{
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}


@end
