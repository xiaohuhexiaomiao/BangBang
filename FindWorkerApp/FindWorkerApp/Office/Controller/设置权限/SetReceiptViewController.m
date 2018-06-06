//
//  SetReceiptViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/2.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SetReceiptViewController.h"
#import "CXZ.h"

#import "DepartmentTableViewCell.h"

#import "AdressBookViewController.h"

#import "PersonelModel.h"

@interface SetReceiptViewController ()<UITableViewDelegate ,UITableViewDataSource,AdressBookDelegate>
{
    NSInteger selectedTag;
}
@property(nonatomic ,strong) UITableView *setTableview;

@property (nonatomic , strong)NSMutableDictionary *personDict;

@property (nonatomic , strong)NSArray *typeArray;

@end

@implementation SetReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitleWithString:@"设置表单回执人员" withColor:[UIColor whiteColor]];
    [self setupBackw];
    
    _setTableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _setTableview.delegate = self;
    _setTableview.dataSource = self;
    [self.view addSubview:_setTableview];
    
    __weak typeof(self) weakself = self;
    _setTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    [_setTableview.mj_header beginRefreshing];
    
    self.typeArray = @[@"1",@"3",@"7",@"5",@"6",@"11"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark loadData

-(void)loadData
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                @"company_id":self.compony_id};
    [[NetworkSingletion sharedManager]receiptPersonList:paramDict onSucceed:^(NSDictionary *dict) {
        [self.setTableview.mj_header endRefreshing];
        
        if ([dict[@"code"] integerValue]==0) {
            NSArray *dataArray = dict[@"data"];
            for (NSDictionary *dataDict in dataArray) {
                NSString *key = [NSString stringWithFormat:@"%li",[dataDict[@"type"] integerValue]];
                [self.personDict setObject:dataDict[@"list"] forKey:key];
            }
//          NSLog(@"****%@",self.personDict);
            [self.setTableview reloadData];
        }
    } OnError:^(NSString *error) {
        [self.setTableview.mj_header endRefreshing];
    }];
}


#pragma mark Private Method
-(void)addPersonToPostion:(UIButton*)button
{
    selectedTag = button.tag;

    AdressBookViewController *bookVC = [[AdressBookViewController alloc]init];
    bookVC.companyid = self.compony_id;
    bookVC.isSelect = YES;
    bookVC.setType = [self.typeArray[selectedTag] integerValue];
    bookVC.operation_type = 2;
    bookVC.areadySelectArray = [self.personDict objectForKey:self.typeArray[selectedTag]];
    bookVC.delegate = self;
    bookVC.loadDataType = 2;
    bookVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bookVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark BookViewControllerDelegate

-(void)saveAdressBook:(NSMutableArray *)selectedArray
{
//    NSLog(@"****%li",selectedTag);
    [self.personDict setObject:selectedArray forKey:self.typeArray[selectedTag]];
    [self.setTableview reloadData];
}


#pragma mark UITableView Delegate & Datasource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.typeArray.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSMutableArray *personArray = [self.personDict objectForKey:self.typeArray[section]];
    return personArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DepartmentTableViewCell *cell = (DepartmentTableViewCell*)[tableView dequeueReusableCellWithIdentifier: @"DepartmentTableViewCell"];
    if (!cell) {
        cell = [[DepartmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DepartmentTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.deleteButton.hidden = YES;
    cell.tag = indexPath.section*1000+indexPath.row;
    NSMutableArray *personArray =[self.personDict objectForKey:self.typeArray[indexPath.section]];
    if (personArray.count > 0) {
        NSArray *perArray = [PersonelModel objectArrayWithKeyValuesArray:personArray];
        [cell setNormalDataWith:perArray[indexPath.row]];
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
    
    UIButton *button = [CustomView customButtonWithContentView:view image:nil title:@"编辑"];
    button.frame = CGRectMake(SCREEN_WIDTH-56, 2, 50, 30);
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    button.tag = section;
    [button addTarget:self action:@selector(addPersonToPostion:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *titleArray = @[@"合同评审表",@"请购单",@"请款单",@"印章申请",@"呈批件",@"报销单"];
    UILabel *label = [CustomView customTitleUILableWithContentView:view title:titleArray[section]];
    label.frame = CGRectMake(8, 8, SCREEN_WIDTH-70, 20);
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
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






@end
