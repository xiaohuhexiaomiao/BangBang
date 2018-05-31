//
//  CommentsRangeViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/17.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CommentsRangeViewController.h"
#import "CXZ.h"
#import "NormallSelsectedCell.h"
#import "DepartmentTableViewCell.h"
@interface CommentsRangeViewController ()<UITableViewDelegate,UITableViewDataSource,DepartmentCellDelegate,NormallSelsectedCellDelegate>;

@property(nonatomic ,strong)UIButton *latelyButton;

@property(nonatomic ,strong)UIButton *personButton;

@property(nonatomic ,strong)UIButton *departButton;

@property(nonatomic ,strong)UIView *line1;

@property(nonatomic ,strong)UIView *line2;

@property(nonatomic ,strong)UIView *line3;

@property(nonatomic ,strong)UIScrollView *scrollView;

@property(nonatomic ,strong)UITableView *firstTabelView;

@property(nonatomic ,strong)UITableView *secondTabelView;

@property(nonatomic ,strong)UITableView *thirdTabelView;

@property(nonatomic ,strong)UILabel *rangeLabel;

@property(nonatomic ,strong)UIButton *cofirmButton;

@property(nonatomic ,strong)NSArray *departArray;

@property(nonatomic ,strong)NSArray *personArray;

@property(nonatomic ,strong)NSMutableArray *selectArray;

@property(nonatomic ,copy)NSString *descriptionString;//范围描述

@property(nonatomic ,assign)BOOL is_all_selected;//是否全选

@end

@implementation CommentsRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"抄送范围" withColor:[UIColor whiteColor]];
//    [self setupNextWithString:@"全选" withColor:[UIColor whiteColor]];
    [self config];
    [self getCommpanyPerson];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Data

-(void)getDepartmentData
{
    if (self.departArray.count > 0) {
        return;
    }
    [[NetworkSingletion sharedManager]getDepartmentData:@{@"company_id":self.company_id} onSucceed:^(NSDictionary *dict) {
//         NSLog(@"company  %@",dict);
        if ([dict[@"code"] integerValue]==0) {
            self.departArray = [dict objectForKey:@"data"];
            [self.thirdTabelView reloadData];
        }
    } OnError:^(NSString *error) {
        
    }];
}

-(void)getCommpanyPerson
{
    if (self.personArray.count > 0) {
        return;
    }
    [[NetworkSingletion sharedManager]getDepartmentPersonnerlData:@{@"company_id":self.company_id} onSucceed:^(NSDictionary *dict) {
//                NSLog(@"company  %@",dict);
        if ([dict[@"code"] integerValue]==0) {
            NSArray *array = [dict objectForKey:@"data"];
        
            NSArray *pArray = [PersonelModel objectArrayWithKeyValuesArray:array];
            self.personArray = pArray;
            [self.secondTabelView reloadData];
            
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
//        [MBProgressHUD showError:error toView:self.view];
    }];

}

#pragma mark Public Method

-(void)onNext
{
    [self.selectArray removeAllObjects];
    self.is_all_selected = !self.is_all_selected;
    [self.firstTabelView reloadData];
    [self.secondTabelView reloadData];
    if (self.is_all_selected) {
        NSDictionary *dict = @{@"id":self.company_id,@"type":@(3)};
        [self.selectArray addObject:dict];
        self.rangeLabel.text = @"已选择：全公司";
        self.descriptionString = @"全公司";
        
    }else{
         self.rangeLabel.text = @"已选择：";
        self.descriptionString = @"";
    }
   
    
}

#pragma mark PrivateMethod

-(void)clickTypeButton:(UIButton*)button
{
    if (button.tag == 100) {//
        
        [UIView animateWithDuration:0.1 animations:^{
            [self.departButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
            [self.personButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
            [self.latelyButton setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
            self.line1.hidden = NO;
            self.line2.hidden = YES;
            self.line3.hidden = YES;
            [self.scrollView scrollRectToVisible:CGRectMake(0, self.scrollView.top, SCREEN_WIDTH, self.scrollView.bounds.size.height) animated:YES];
            
            
        }];
        
    }else if (button.tag == 101) {//同事button
        
        [UIView animateWithDuration:0.1 animations:^{
            [self.departButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
            [self.personButton setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
            [self.latelyButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
            self.line2.hidden = NO;
            self.line1.hidden = YES;
            self.line3.hidden = YES;
            [self.scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH, self.scrollView.top, SCREEN_WIDTH, self.scrollView.bounds.size.height) animated:YES];
            [self getCommpanyPerson];
            
        }];
        
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            [self.personButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
            [self.departButton setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
            [self.latelyButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
            self.line1.hidden = YES;
            self.line3.hidden = NO;
            self.line2.hidden = YES;
            [self.scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH*2, self.scrollView.top, SCREEN_WIDTH, self.scrollView.bounds.size.height) animated:YES];
            [self getDepartmentData];
        }];
    }
}

-(void)clickConfirmButton:(UIButton*)button
{
    if (self.selectArray.count == 0) {
        [WFHudView showMsg:@"请选择抄送范围" inView:self.view];
        return;
    }
    [self.delegate didSelectedRangeArray:self.selectArray rangeDescription:self.descriptionString];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults]setObject:self.descriptionString forKey:@"RangeDescription"];
//    NSString *rangStr = [NSString dictionaryToJson:self.selectArray];
     [[NSUserDefaults standardUserDefaults]setObject:self.selectArray forKey:self.company_id];
//    NSLog(@"***%@",self.selectArray);
}

#pragma mark Cell Delegate
//选择同事
-(void)clickSeleteButton:(BOOL)isSeleted tag:(NSInteger)tag
{
    self.is_all_selected = NO;
    PersonelModel *person = self.personArray[tag];
    person.is_selected = isSeleted;
    NSDictionary *dict = @{@"id":person.personnel_id,@"type":@(1)};
    if (isSeleted) {

        [self.selectArray addObject:dict];
    }else{
     
        [self.selectArray removeObject:dict];
    }
    [self refreshRangeLabelContent];
}

//选择部门
-(void)selectedCellWith:(BOOL)isSelected Model:(NSDictionary *)model
{
    if (model) {
        NSDictionary *dict = @{@"id":model[@"department_id"],@"type":@(2)};
        if (isSelected) {
            [self.selectArray addObject:dict];
        }else{
            [self.selectArray removeObject:dict];
        }
        [self refreshRangeLabelContent];
    }
}

-(void)selectedCellWith:(BOOL)isSelected index:(NSInteger)index
{
    if (index == 0 ) {
        NSDictionary *dict = @{@"id":self.company_id,@"type":@(3)};
        if (isSelected) {
            [self.selectArray addObject:dict];
        }else{
            [self.selectArray removeObject:dict];
        }
    }
    if (index == 1 ) {
     
        NSArray *rangArray = [[NSUserDefaults standardUserDefaults]objectForKey:self.company_id];
//        NSArray *rangArray = [NSString arrayWithJsonString:rangArrayStr];
        if (isSelected) {
            [self.selectArray addObjectsFromArray:rangArray];
        }else{
            [self.selectArray removeObjectsInArray:rangArray];
        }
    }
    [self refreshRangeLabelContent];
}

-(void)refreshRangeLabelContent
{
    NSString *rangStr = @"";
    NSInteger departCount = 0;
    NSInteger personCount = 0;
    for (NSDictionary *dict in self.selectArray) {
        if ([dict[@"type"] integerValue]==3) {
            rangStr =[rangStr stringByAppendingString:@"全公司"];
        }
        if ([dict[@"type"] integerValue]==2) {
            departCount++;
        }
        if ([dict[@"type"] integerValue]==1) {
            personCount++;
        }
    }
    if (departCount > 0) {
        rangStr =[rangStr stringByAppendingFormat:@"%li个部门",departCount];
    }
    if (personCount > 0) {
        rangStr = [rangStr stringByAppendingFormat:@"%li个同事",personCount];
    }
    self.rangeLabel.text = [NSString stringWithFormat:@"已选择：%@",rangStr];
    self.descriptionString = [NSString stringWithFormat:@"%@",rangStr];
}

#pragma mark 界面

-(void)config
{
    _latelyButton = [CustomView customButtonWithContentView:self.view image:nil title:@"最近"];
    _latelyButton.tag = 100;
    _latelyButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 39);
    [_latelyButton setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [_latelyButton addTarget:self action:@selector(clickTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _personButton = [CustomView customButtonWithContentView:self.view image:nil title:@"同事"];
    _personButton.tag = 101;
    _personButton.frame = CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 39);
    [_personButton addTarget:self action:@selector(clickTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _departButton = [CustomView customButtonWithContentView:self.view image:nil title:@"部门"];
    _departButton.tag = 102;
    _departButton.frame =  CGRectMake(SCREEN_WIDTH/3*2, _personButton.top, SCREEN_WIDTH/3, 39);
    [_departButton addTarget:self action:@selector(clickTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [CustomView customLineView:self.view];
    line.frame = CGRectMake(0, _personButton.bottom, SCREEN_WIDTH, 1);
    
    _line1 = [CustomView customLineView:self.view];
    _line1.frame = CGRectMake(0, _personButton.bottom, SCREEN_WIDTH/3, 1);
    _line1.backgroundColor = GREEN_COLOR;
    
    _line2 = [CustomView customLineView:self.view];
    _line2.frame = CGRectMake(_line1.right, _line1.top,_line1.width, _line1.height);
    _line2.backgroundColor = GREEN_COLOR;
    _line2.hidden = YES;
    
    _line3 = [CustomView customLineView:self.view];
    _line3.frame = CGRectMake(_line2.right, _line1.top,_line1.width, _line1.height);;
    _line3.backgroundColor = GREEN_COLOR;
    _line3.hidden = YES;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, line.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-144)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT-104-40);
    [self.view addSubview:_scrollView];
    
    _firstTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.frame.size.height) style:UITableViewStyleGrouped];
    //    _firstTabelView.top = _scrollView.top;
    _firstTabelView.delegate = self;
    _firstTabelView.dataSource = self;
    _firstTabelView.tableFooterView = [UIView new];
    [_scrollView addSubview:_firstTabelView];
    
    _secondTabelView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _scrollView.frame.size.height) style:UITableViewStyleGrouped];
    _secondTabelView.delegate = self;
    _secondTabelView.dataSource = self;
    _secondTabelView.tableFooterView = [UIView new];
    [_scrollView addSubview:_secondTabelView];
    
    _thirdTabelView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, _scrollView.frame.size.height) style:UITableViewStyleGrouped];
    _thirdTabelView.delegate = self;
    _thirdTabelView.dataSource = self;
    _thirdTabelView.tableFooterView = [UIView new];
    [_scrollView addSubview:_thirdTabelView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _scrollView.bottom, SCREEN_WIDTH, 40)];
    [self.view addSubview:bottomView];
    
    _rangeLabel = [CustomView customTitleUILableWithContentView:bottomView title:@"已选择："];
    _rangeLabel.frame = CGRectMake(8, 0, SCREEN_WIDTH-80, 40);
    
    _cofirmButton = [CustomView customButtonWithContentView:bottomView image:nil title:@"确定"];
    _cofirmButton.backgroundColor = [UIColor orangeColor];
    _cofirmButton.frame = CGRectMake(SCREEN_WIDTH-68, 2, 60, 35);
    _cofirmButton.layer.cornerRadius = 3;
    _cofirmButton.layer.masksToBounds = YES;
    [_cofirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cofirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark UITableView Delegate & DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _firstTabelView) {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _firstTabelView) {
        if (section == 1) {
             NSString *rangStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"RangeDescription"];
            if ([NSString isBlankString:rangStr]) {
                return 0;
            }
        }
        return 1;
        
    }
    if (tableView == _secondTabelView) {
        return self.personArray.count;
    }
    
    return self.departArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _firstTabelView) {
        NormallSelsectedCell *cell = (NormallSelsectedCell*)[tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
        if (!cell) {
            cell = [[NormallSelsectedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
         cell.selectedButton.hidden = NO;
        cell.tag = indexPath.section;
        if (indexPath.section == 0) {
            [cell setNormalCellWithTitleString:@"全公司"];
        }
        if (indexPath.section == 1) {
            
            NSString *rangStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"RangeDescription"];
            [cell setNormalCellWithTitleString:rangStr];
        }
        return cell;

    }
    
    if (tableView == _secondTabelView) {
        DepartmentTableViewCell *cell = (DepartmentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"DepartmentTableViewCell"];
        if (!cell) {
            cell = [[DepartmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DepartmentTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.tag = indexPath.row;
        cell.selectBtn.hidden = NO;
        if (self.personArray.count > 0) {
             PersonelModel *person = self.personArray[indexPath.row];
            [cell setNormalDataWith:person];
            if (person.is_selected) {
                [cell.selectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
            }else{
                [cell.selectBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
                
            }
            
        }
        
       
        return cell;
    }
    
    NormallSelsectedCell *cell = (NormallSelsectedCell*)[tableView dequeueReusableCellWithIdentifier:@"NormallSelsectedCell"];
    if (!cell) {
        cell = [[NormallSelsectedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormallSelsectedCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (self.departArray.count > 0) {
        [cell setNormalCellWithDictionary:self.departArray[indexPath.row]];
        cell.selectedButton.hidden = NO;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _firstTabelView) {
        if (section == 1) {
            return 30;
        }
    }
    return 10.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _firstTabelView) {
        if (section == 1) {
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 5, SCREEN_WIDTH-16, 25)];
            label.font = [UIFont systemFontOfSize:12];
            label.text = @"经常使用";
            label.textColor = FORMTITLECOLOR;
            [view addSubview:label];
            return view;
        }
    }
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark get/set

-(NSMutableArray*)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

@end
