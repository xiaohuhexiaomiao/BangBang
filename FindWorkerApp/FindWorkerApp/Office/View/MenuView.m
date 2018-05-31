//
//  MenuView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/4.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "MenuView.h"
#import "CXZ.h"
@interface MenuView() <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *selectedTbleview;

@property (nonatomic , strong)NSMutableArray *dataArray;

@property (nonatomic , assign) BOOL is_selected_depart;
@end

@implementation MenuView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [NSMutableArray array];
        _selectedTbleview = [[UITableView alloc]init];
        [self addSubview:_selectedTbleview];
        [_selectedTbleview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
        _selectedTbleview.delegate =self;
        _selectedTbleview.dataSource = self;
        _selectedTbleview.tableFooterView = [UIView new];
    }
    return self;
}

-(void)setTableviewFrame
{
    _dataArray = [NSMutableArray array];
    _selectedTbleview = [[UITableView alloc]init];
    [self addSubview:_selectedTbleview];
    [_selectedTbleview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    _selectedTbleview.delegate =self;
    _selectedTbleview.dataSource = self;
    _selectedTbleview.tableFooterView = [UIView new];
}

-(void)loadMenuData
{
    self.is_selected_depart = YES;
    [self.dataArray removeAllObjects];
    //加载部门信息
    [[NetworkSingletion sharedManager]getDepartmentData:@{@"company_id":self.companyID} onSucceed:^(NSDictionary *dict) {
//                        NSLog(@"**department*%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            [self.dataArray addObjectsFromArray:dict[@"data"]];
            [self.selectedTbleview reloadData];
        }
    } OnError:^(NSString *error) {
        
    }];
}

-(void)loadJobData:(NSArray*)jobArray
{
    self.is_selected_depart = NO;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:jobArray];
    [self.selectedTbleview reloadData];
}


#pragma mark UITableview Delegate & Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    if (self.dataArray.count > 0) {
        NSDictionary *dataDict = self.dataArray[indexPath.row];
        if (self.is_selected_depart) {
            cell.textLabel.text = dataDict[@"department_name"];
        }else{
            cell.textLabel.text = dataDict[@"job_name"];
        }
    }
    cell.textLabel.textColor = FORMLABELTITLECOLOR;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        self.hidden = YES;
        [self.delegate selectedDepartment:self.dataArray[indexPath.row] is_department:self.is_selected_depart];
    }
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 30.0f;
}




@end
