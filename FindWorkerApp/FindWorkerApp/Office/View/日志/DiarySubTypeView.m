//
//  DiarySubTypeView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/12/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "DiarySubTypeView.h"
#import "CXZ.h"

@interface DiarySubTypeView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong)UITableView *tableview;

@property(nonatomic ,strong)NSArray *typeArray;

@end

@implementation DiarySubTypeView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-150, SCREEN_HEIGHT-300) style:UITableViewStyleGrouped];
        _tableview.center =self.center;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.tableFooterView = [UIView new];
        [self addSubview:_tableview];
        
    }
    return self;
}

#pragma mark Data

-(void)loadDiaryType
{

    [[NetworkSingletion sharedManager]getDiarySubTypeList:@{@"type":@(self.diaryType)} onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            self.typeArray = dict[@"data"];
        }
        [self.tableview reloadData];
    } OnError:^(NSString *error) {
        
    }];
}

#pragma mark UITableview Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.typeArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.typeArray.count> 0) {
        cell.textLabel.text = [self.typeArray[indexPath.row] objectForKey:@"log_type_name"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = FORMTITLECOLOR;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.typeArray.count > 0) {
        NSDictionary *dict = self.typeArray[indexPath.row];
        [self.delegate selectedDiarySubType:dict type:self.diaryType];
        [self removeFromSuperview];
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH-150, 40)];
    label.text = @"选择日志类型:";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = FORMLABELTITLECOLOR;
    return label;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
@end
