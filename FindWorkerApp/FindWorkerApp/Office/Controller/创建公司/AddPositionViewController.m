//
//  AddPositionViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "AddPositionViewController.h"
#import "CXZ.h"
#import "SelectedDepartCell.h"
#import "SetPositionViewController.h"
#import "DepartmentModel.h"
#import "PositionModel.h"

@interface AddPositionViewController ()<UITableViewDelegate,UITableViewDataSource,SelectedDepartCellDelegate>
{
    NSInteger selectedSection;
    NSInteger addType;//1添加部门 0添加职位
}
@property(nonatomic ,strong)UITableView *tableview;

@property(nonatomic ,strong)UIWindow *bgWindow;

@property(nonatomic ,strong)UITextField *nameTxt;

@property (nonatomic , strong)NSMutableArray *departArray;

@property(nonatomic ,strong)NSMutableArray *positionArray;

@property(nonatomic ,strong)NSMutableArray *selectedArray;

@end

@implementation AddPositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitleWithString:@"创建公司-部门架构" withColor:[UIColor whiteColor]];
    [self setupBackw];
    
    _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.height = self.view.frame.size.height-104;
    [self.view addSubview:_tableview];
    
     [self loadDepartData];
    
  
    UIButton *nextBtn =[CustomView customButtonWithContentView:self.view image:nil title:@"下一步"];
    nextBtn.frame = CGRectMake(0, _tableview.bottom, SCREEN_WIDTH, 40);
    [nextBtn setTitleColor:TOP_GREEN forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickNextButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark Private Method

-(void)loadDepartData
{
    [[NetworkSingletion sharedManager]presetDepartmentOfCompany:nil onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            NSArray *array = [DepartmentModel objectArrayWithKeyValuesArray:dict[@"data"]];
            [self.departArray addObjectsFromArray:array];
            [self.tableview reloadData];
        }
    } OnError:^(NSString *error) {
        
    }];
}

-(void)clickLastButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickNextButton
{
    if (self.positionArray.count == 0) {
        [WFHudView showMsg:@"请选择职位" inView:self.view];
        return;
    }
    SetPositionViewController *setVC = [[SetPositionViewController alloc]init];
    setVC.positionArray = self.positionArray;
    setVC.compony_id = self.compony_id;
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

-(void)clickCancelButton:(UIButton*)bton
{
    _bgWindow.hidden = YES;
    [_bgWindow resignKeyWindow];
}

-(void)clickAddPerSonalButton:(UIButton*)bton
{
    if (addType == 1) {
        if (![NSString isBlankString:self.nameTxt.text]) {
            DepartmentModel *depart = [[DepartmentModel alloc]init];
            depart.name = self.nameTxt.text;
            [self.departArray addObject:depart];
            [self.tableview reloadData];
            
        }else{
            [WFHudView showMsg:@"请输入部门名称" inView:self.view];
        }
    }else{
        DepartmentModel *depart = self.departArray[selectedSection];
        if (self.nameTxt.text.length > 0) {
            NSMutableArray *jobArray = [NSMutableArray array];
            [jobArray addObjectsFromArray:depart.job];
            [jobArray addObject:self.nameTxt.text];
            depart.job = jobArray;
            [self.tableview reloadData];
        }else{
            [WFHudView showMsg:@"请输入职位名称" inView:self.view];
        }
    }
    
   
}

-(void)clickAddDepartmentButton:(UITapGestureRecognizer*)tap
{
    UILabel *label = (UILabel*)tap.view;
    if ([label.text isEqualToString:@"自定义部门"]) {
        addType = 1;
        [self setAddDepartmentView];
    }
}


-(void)setAddDepartmentView
{
    if (!_bgWindow) {
        _bgWindow = [[UIWindow alloc]initWithFrame:self.view.bounds];
        _bgWindow.windowLevel = UIWindowLevelNormal;
        _bgWindow.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH-70, 151)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.center = _bgWindow.center;
        bgView.top = 80;
        bgView.layer.cornerRadius = 3;
        [_bgWindow addSubview:bgView];
        
        NSString *title;
        if (addType == 1) {
            title = @"自定义部门";
        }else{
            title = @"自定义职位";
        }
        UILabel *titleLabel = [CustomView customTitleUILableWithContentView:bgView title:title];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(0, 0, bgView.width, 30);
        
        UIView *line = [CustomView customLineView:bgView];
        line.frame = CGRectMake(0, titleLabel.bottom, bgView.width, 1);
        
        NSString *placeHoder ;
        if (addType == 1) {
            placeHoder = @"请输入部门名称";
        }else{
             placeHoder = @"请输入职位名称";
        }
        _nameTxt = [CustomView customUITextFieldWithContetnView:bgView placeHolder:placeHoder];
        _nameTxt.textAlignment = NSTextAlignmentCenter;
        _nameTxt.frame = CGRectMake(5, line.bottom+20, bgView.width-10, 40);
        
        UIButton *canCelBtn = [CustomView customButtonWithContentView:bgView image:nil title:@"取消"];
        [canCelBtn addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        canCelBtn.frame = CGRectMake(0, _nameTxt.bottom+20, bgView.width/2, 40);
        
        UIButton *confirmBtn = [CustomView customButtonWithContentView:bgView image:nil title:@"添加"];
        [confirmBtn addTarget:self action:@selector(clickAddPerSonalButton:) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.frame = CGRectMake(canCelBtn.right,canCelBtn.top, canCelBtn.width, canCelBtn.height);
        [self.view addSubview:_bgWindow];
    }
    _bgWindow.hidden = NO;
    [_bgWindow makeKeyWindow];
}


#pragma mark Cell Delegate

-(void)clickSelectedButton:(NSInteger)index isSelect:(BOOL)selected
{
    NSInteger section = index/100;
    NSInteger row = index%100;
//    NSLog(@"row %li row %li",section,row);
    DepartmentModel *depart = self.departArray[section];
    PositionModel *position = [[PositionModel alloc]init];
    position.depart_name = depart.name;
    position.position_name = depart.job[row];
    if (selected) {
        [self.positionArray addObject:position];
        [self.selectedArray addObject:@(index)];
    }else{
        [self.positionArray removeObject:position];
        [self.selectedArray removeObject:@(index)];
    }
    
}

#pragma mark UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"***%li",self.positionArray.count);
    return self.departArray.count+1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.departArray.count) {
        return 0;
    }
    DepartmentModel *depart = self.departArray[section];
    return depart.job.count+1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DepartmentModel *depart = self.departArray[indexPath.section];
    if (indexPath.row == depart.job.count) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"];
        cell.textLabel.text = @"自定义职位";
        cell.textLabel.font = [UIFont systemFontOfSize:13];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    SelectedDepartCell *cell = (SelectedDepartCell*)[tableView dequeueReusableCellWithIdentifier:@"SelectedDepartCell"];
    if (!cell) {
        cell = [[SelectedDepartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectedDepartCell"];
        
    }
    cell.delegate = self;
    cell.tag = indexPath.section*100+indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.departArray.count > 0) {
        DepartmentModel *depart = self.departArray[indexPath.section];
        if (depart.job.count>0) {
            BOOL is_select = false;
            if ([self.selectedArray containsObject:@(indexPath.section*100+indexPath.row)]) {
                is_select = YES;
            }
            [cell setDepartCell:depart.job[indexPath.row] is_selected:is_select];
        }
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
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
    if (self.departArray.count > 0) {
        NSString *title ;
        if (section == self.departArray.count) {
            title = @"自定义部门";
        }else{
            DepartmentModel *depart = self.departArray[section];
            title = depart.name;
        }
        
        UILabel *label = [CustomView customTitleUILableWithContentView:view title:title];
        label.frame = CGRectMake(8, 8, SCREEN_WIDTH-16, 20);
        label.font = [UIFont systemFontOfSize:14];
        if (section == self.departArray.count) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAddDepartmentButton:)];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:tap];
        }
        label.textColor = [UIColor blackColor];
        
    }
    
    return view;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.departArray.count > 0) {
        DepartmentModel *depart = self.departArray[indexPath.section];
        if (indexPath.row == depart.job.count) {
            addType = 0;
            selectedSection = indexPath.section;
            [self setAddDepartmentView];
        }
    }
    
}

#pragma mark get/set

-(NSMutableArray*)positionArray
{
    if (!_positionArray) {
        _positionArray = [NSMutableArray array];
        
    }
    return _positionArray;
}

-(NSMutableArray*)departArray
{
    if (!_departArray) {
        _departArray = [NSMutableArray array];
    }
    return _departArray;
}

-(NSMutableArray*)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

@end
