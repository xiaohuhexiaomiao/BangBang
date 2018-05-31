//
//  CompanyPersonManageViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/4/25.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "CompanyPersonManageViewController.h"
#import "CXZ.h"

#import "DepartmentTableViewCell.h"


#import "AddColleagueViewController.h"

@interface CompanyPersonManageViewController ()<UITableViewDelegate,UITableViewDataSource,DepartmentCellDelegate>

@property (nonatomic , strong)UITableView *departmentTableview;

@property (nonatomic , strong) NSMutableArray *departmentArray;//部门

@property (nonatomic , strong) NSMutableDictionary *personnerlDict;//部门员工

@property (nonatomic , strong) NSMutableDictionary *selectSignDict;

@end

@implementation CompanyPersonManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitleWithString:@"公司人员管理" withColor:[UIColor whiteColor]];
    [self setupBackw];
    
    _departmentTableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _departmentTableview.height = self.view.frame.size.height - 64;
    _departmentTableview.delegate = self;
    _departmentTableview.dataSource = self;
    [self.view addSubview:_departmentTableview];
    
    _departmentTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDepartmentManageData];
    }];
    [_departmentTableview.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Private Method
//加载部门信息
-(void)loadDepartmentManageData
{
    [self.departmentArray removeAllObjects];
    [[NetworkSingletion sharedManager]getDepartmentData:@{@"company_id":self.company_id} onSucceed:^(NSDictionary *dict) {
        //        NSLog(@"**department*%@",dict);
        [self.departmentTableview.mj_header endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            NSDictionary *managerDict = @{@"department_describe":@"",@"department_id":@"-1",@"department_name":@"管理员"};
            [self.departmentArray addObjectsFromArray:dict[@"data"]];
            [self.departmentArray insertObject:managerDict atIndex:0];
            [self.departmentTableview reloadData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [self.departmentTableview.mj_header endRefreshing];
        [MBProgressHUD showError:error toView:self.view];
    }];
}
//加载部门人员
-(void)loadDepartmentPersonnerlWith:(NSString*)departmentID
{
    NSDictionary *paramDict = @{@"company_id":self.company_id,@"department_id":departmentID};
    [[NetworkSingletion sharedManager]getDepartmentPersonnerlData:paramDict onSucceed:^(NSDictionary *dict) {
        //        NSLog(@"**sdsdsd**%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            NSArray *persnonnelArray = [PersonelModel objectArrayWithKeyValuesArray:dict[@"data"]];
            PersonelModel *jme = [persnonnelArray objectAtIndex:0];
            [self.personnerlDict setObject:persnonnelArray forKey:departmentID];
            [self.departmentTableview reloadData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
        
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}
-(void)clickDepartmentTitle:(UITapGestureRecognizer*)tap
{
    UIView *view = tap.view;
    NSInteger indext = view.tag-100;
    UIButton *imageBtn = [view viewWithTag:1];
    UIImage *tempImage = [UIImage imageNamed:@"arrow_right"];
    NSData *tempData = UIImagePNGRepresentation(tempImage);
    UIImage *image = [imageBtn imageForState:UIControlStateNormal];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *descrip = [self.departmentArray[indext] objectForKey:@"department_id"];
    if ([imageData isEqual:tempData]) {
        [imageBtn setImage:[UIImage imageNamed:@"arrow_gray"] forState:UIControlStateNormal ];
        
        [self.selectSignDict setObject:@"1" forKey:descrip];
        if ([self.personnerlDict objectForKey:descrip]) {
            [self.departmentTableview reloadData];
        }else{
            [self loadDepartmentPersonnerlWith:descrip];
        }
        
    }else{
        [imageBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [self.selectSignDict setObject:@"0" forKey:descrip];
        [self.departmentTableview reloadData];
    }
}
#pragma mark CellDelegate Method

-(void)clickDeleteButton:(NSInteger)tag
{
    NSInteger section =tag/100;
    NSInteger row = tag %100;
    
    if (section == 0) {//删除管理员
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定要删除此管理员么？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteManager:section row:row];
        }]];
        [self.navigationController presentViewController:alertVC animated:YES completion:nil];
    }else{//删除公司员工
        [self isHaveApproval:section row:row];
    }
    
}
//判断用户是否还有审批
-(void)isHaveApproval:(NSInteger)section row:(NSInteger)row
{
    NSString *descrip = [self.departmentArray[section] objectForKey:@"department_id"];
    NSArray *array = [self.personnerlDict objectForKey:descrip];
    PersonelModel *personelModel = array[row];
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                @"del_uid":personelModel.personnel_id,
                                @"company_id":self.company_id};
    [[NetworkSingletion sharedManager]isHaveApproval:paramDict onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"]integerValue ] == 0) {
            NSInteger ishave = [[dict objectForKey:@"data"] integerValue];
            if (ishave == 0) {
                [self deleteComparnyPersonel:section row:row];
            }else{
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"此员工还有审批未处理，删除后审批将失效，是否继续删除？" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alertVC addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self deleteComparnyPersonel:section row:row];
                }]];
                [self.navigationController presentViewController:alertVC animated:YES completion:nil];
            }
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}


-(void)deleteComparnyPersonel:(NSInteger)section row:(NSInteger)row
{
    NSString *descrip = [self.departmentArray[section] objectForKey:@"department_id"];
    NSArray *array = [self.personnerlDict objectForKey:descrip];
    PersonelModel *personelModel = array[row];
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                @"personnel_id":personelModel.personnel_id,
                                @"company_id":self.company_id};
    [[NetworkSingletion sharedManager]deletePersonel:paramDict onSucceed:^(NSDictionary *dict) {
        //            NSLog(@"delete personnel %@",dict);
        if ([dict[@"code"] integerValue]==0) {
            NSMutableArray *listArray = [NSMutableArray arrayWithArray:array];
            [listArray removeObjectAtIndex:row];
            [self.personnerlDict setObject:listArray forKey:descrip];
            NSIndexSet *indextset = [NSIndexSet indexSetWithIndex:section];
            [self.departmentTableview reloadSections:indextset withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}

-(void)deleteManager:(NSInteger)section row:(NSInteger)row
{
    NSString *descrip = [self.departmentArray[section] objectForKey:@"department_id"];
    NSArray *array = [self.personnerlDict objectForKey:descrip];
    PersonelModel *personelModel = array[row];
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                @"personnel_id":personelModel.personnel_id,
                                @"company_id":self.company_id,
                                @"my_personnel_id":self.personalID};
    [[NetworkSingletion sharedManager]deleteManager:paramDict onSucceed:^(NSDictionary *dict) {
        //            NSLog(@"delete manager %@",dict);
        if ([dict[@"code"] integerValue]==0) {
            NSMutableArray *listArray = [NSMutableArray arrayWithArray:array];
            [listArray removeObjectAtIndex:row];
            [self.personnerlDict setObject:listArray forKey:descrip];
            NSIndexSet *indextset = [NSIndexSet indexSetWithIndex:section];
            [self.departmentTableview reloadSections:indextset withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}

#pragma mark UITabelViewDelegate & DataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.departmentArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.departmentArray.count > 0) {
        NSString *descrip = [self.departmentArray[section] objectForKey:@"department_id"];
        if ([[self.selectSignDict objectForKey:descrip] isEqualToString:@"1"]) {
            NSArray *array = [self.personnerlDict objectForKey:descrip];
            return array.count;
        }else{
            return 0;
        }
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DepartmentTableViewCell *cell = (DepartmentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"DepartmentCell"];
    if (!cell) {
        cell = [[DepartmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DepartmentCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.tag = indexPath.row+indexPath.section*100;
    if (self.departmentArray.count > 0) {
        NSString *descrip = [self.departmentArray[indexPath.section] objectForKey:@"department_id"];
        NSArray *perssonArray = [self.personnerlDict objectForKey:descrip];
        if (perssonArray.count > 0) {
            cell.deleteButton.hidden = NO;
            [cell setMangerDataWith:perssonArray[indexPath.row]];
        }
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.departmentArray.count > 0) {
        NSString *descrip = [self.departmentArray[indexPath.section] objectForKey:@"department_id"];
        NSArray *array = [self.personnerlDict objectForKey:descrip];
        PersonelModel *personelModel = array[indexPath.row];
        AddColleagueViewController *addVC = [[AddColleagueViewController alloc]init];
        addVC.company_id = self.company_id;
        addVC.isUpdate = YES;
        addVC.personal = personelModel;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.tag = 100+section;
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(8, 12, 16, 16);
    imageBtn.tag = 1;
    NSString *descrip = [self.departmentArray[section] objectForKey:@"department_id"];
    [imageBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    if ([self.selectSignDict objectForKey:descrip]) {
        if ([[self.selectSignDict objectForKey:descrip] isEqualToString:@"0"]) {
            [imageBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        }else{
            [imageBtn setImage:[UIImage imageNamed:@"arrow_gray"] forState:UIControlStateNormal];
        }
    }
    
    [view addSubview:imageBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageBtn.right, 10, SCREEN_WIDTH-16, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = TITLECOLOR;
    NSDictionary *descripDict = self.departmentArray[section];
    if ([NSString isBlankString:descripDict[@"department_describe"]]) {
        titleLabel.text = descripDict[@"department_name"];
    }else{
        
        NSString *descripStr = descripDict[@"department_describe"];
        NSString *attributeStr = [NSString stringWithFormat:@"%@（%@）",descripDict[@"department_name"],descripDict[@"department_describe"] ];
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:attributeStr];
        NSRange range = [attributeStr rangeOfString:@"（"];
        [content addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(range.location, descripStr.length+2)];
        [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(range.location, descripStr.length+2)];
        titleLabel.attributedText = content;
    }
    [view addSubview:titleLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDepartmentTitle:)];
    [view addGestureRecognizer:tap];
    return view;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark get/ set

-(NSMutableDictionary*)personnerlDict
{
    if (!_personnerlDict) {
        _personnerlDict = [NSMutableDictionary dictionary];
    }
    return _personnerlDict;
}
-(NSMutableArray*)departmentArray
{
    if (!_departmentArray) {
        _departmentArray = [NSMutableArray array];
    }
    return _departmentArray;
}

-(NSMutableDictionary*)selectSignDict
{
    if (!_selectSignDict) {
        _selectSignDict = [NSMutableDictionary dictionary];
    }
    return _selectSignDict;
}


@end
