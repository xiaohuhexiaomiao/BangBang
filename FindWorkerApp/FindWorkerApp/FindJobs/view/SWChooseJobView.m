//
//  SWChooseJobView.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/6.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWChooseJobView.h"

#import "SWChooseItem.h"

#import "CXZ.h"

#import "SWWorkerTypeCmd.h"
#import "SWWorkerTypeInfo.h"
#import "SWWorkerTypeData.h"

@interface SWChooseJobView ()<SWChooseItemDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *workArr;

@property (nonatomic ,strong)UITableView *tableview;

@end

@implementation SWChooseJobView {
    
    NSInteger selectTag;
    
    SWChooseItem *_item1;
    SWChooseItem *_item2;
    UIView *_contentView;
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        //设置界面
        [self setUpView];
        
    }
    
    return self;
    
}

//设置界面
- (void)setUpView {
    
    CGFloat width = SCREEN_WIDTH / 2;
    CGFloat height = self.frame.size.height;
    
    SWChooseItem *item1 = [[SWChooseItem alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    item1.title         = @"工种";
    item1.Choosedelegate = self;
    [self addSubview:item1];
    _item1 = item1;
    
    SWChooseItem *item2 = [[SWChooseItem alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    item2.title         = @"排序";
    item2.Choosedelegate = self;
    item2.itemArr       = @[@"时间",@"距离",@"工资"];
    [self addSubview:item2];
    _item2 = item2;
    
    
}

//加载工种
//加载工种的信息
- (void)loadWotkTypeData {
    
    __weak typeof(self) weakself = self;
    [[NetworkSingletion sharedManager]getWorkerType:nil onSucceed:^(NSDictionary *dict) {
        //        NSLog(@"**23*%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            SWWorkerTypeInfo *typeInfo = [[SWWorkerTypeInfo alloc] initWithDictionary:dict];
            
            _workArr = [NSMutableArray arrayWithArray:typeInfo.data];
            
            _item1.typeArr = _workArr;
            [self.tableview reloadData];
        }
    } OnError:^(NSString *error) {
        
    }];
    
}

-(void)config
{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:self.viewController.view.frame];
        _contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideMenu)];
        [_contentView addGestureRecognizer:tap];
        [self.viewController.view addSubview:_contentView];
    }
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 240) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [UIView new];
        [self.viewController.view addSubview:_tableview];
    }
}

-(void)hideMenu
{
    [_item1 setSelect:NO];
    [_item2 setSelect:NO];
    
    _contentView.hidden = YES;
    _tableview.hidden = YES;
}



#pragma mark ChooseItem Delegate
- (void)selectItem:(SWChooseItem *)item {
    [self config];
    _contentView.hidden = NO;
    _tableview.hidden = NO;
    self.tableview.height = 240;
    if([item.title isEqualToString:@"工种"]){
        if (_workArr.count == 0) {
            [self loadWotkTypeData];
        }
        selectTag = 1;
        [_item2 setSelect:NO];
        
    }else if([item.title isEqualToString:@"排序"]){
        [_item1 setSelect:NO];
        self.tableview.height = 120;
        selectTag = 3;
    }
    [self.tableview reloadData];
}


#pragma mark UITableview Delegate & Datasource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectTag == 1) {
        return _item1.typeArr.count;
    }else{
        return _item2.itemArr.count;
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (selectTag == 1) {
        SWWorkerTypeData *typeData = _item1.typeArr[indexPath.row];
        cell.textLabel.text =  typeData.type_name;
    }else{
        cell.textLabel.text = _item2.itemArr[indexPath.row];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectTag == 1) {
        SWWorkerTypeData *typeData = _item1.typeArr[indexPath.row];
        [self.itemDelegate selectTypeItem:typeData.wid];
    }else{
        [self.itemDelegate selectItem:_item2.itemArr[indexPath.row]];
    }
    [self hideMenu];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
