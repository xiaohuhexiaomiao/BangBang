//
//  SWChooseView.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/18.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWChooseView.h"

#import "SWChooseItem.h"

#import "CXZ.h"

#import "SWWorkerTypeCmd.h"
#import "SWWorkerTypeInfo.h"
#import "SWWorkerTypeData.h"

#import "SWWorkerArea.h"

@interface SWChooseView ()<UITableViewDelegate,UITableViewDataSource,SWChooseItemDelegate>

@property (nonatomic, retain) NSMutableArray *workArr;

@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic, strong) NSArray *areaArr;

@end

@implementation SWChooseView
{
    NSInteger selectTag;
    SWChooseItem *_item1;
    SWChooseItem *_item2;
    SWChooseItem *_item3;
    UIView *_contentView;
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.areaArr = @[@"北京市",@"天津市",@"上海市",@"重庆市",@"黑龙江省",@"吉林省",@"辽宁省",@"江苏省",@"山东省",@"安徽省",@"河北省",@"河南省",@"湖北省",@"湖南省",@"江西省",@"陕西省",@"山西省",@"四川省",@"青海省",@"海南省",@"广东省",@"贵州省",@"浙江省",@"福建省",@"甘肃省",@"云南省",@"内蒙古自治区",@"宁夏回族自治区",@"新疆维吾尔自治区",@"西藏自治区",@"广西壮族自治区",@"台湾",@"香港",@"澳门"];
        //设置界面
        [self setUpView];
        
    }
    
    return self;
    
}

//设置界面
- (void)setUpView {
    
    CGFloat width = SCREEN_WIDTH / 3;
    CGFloat height = self.frame.size.height;
    
    SWChooseItem *item1 = [[SWChooseItem alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    item1.title         = @"工种";
    item1.Choosedelegate = self;
    [self addSubview:item1];
    _item1 = item1;
    
    SWChooseItem *item2 = [[SWChooseItem alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    item2.title         = @"地区";
    item2.Choosedelegate = self;
    [self addSubview:item2];
    _item2 = item2;
    
    SWChooseItem *item3 = [[SWChooseItem alloc] initWithFrame:CGRectMake(width * 2, 0, width, height)];
    item3.title         = @"排序";
    item3.Choosedelegate = self;
    item3.itemArr       = @[@"距离",@"好评率",@"雇佣次数"];
    [self addSubview:item3];
    _item3 = item3;
    
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
    [_item3 setSelect:NO];
    
    _contentView.hidden = YES;
    _tableview.hidden = YES;
}

//加载工种的信息
- (void)loadWotkTypeData {
    
    __weak typeof(self) weakself = self;
    [[NetworkSingletion sharedManager]getWorkerType:nil onSucceed:^(NSDictionary *dict) {
        //        NSLog(@"**23*%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            SWWorkerTypeInfo *typeInfo = [[SWWorkerTypeInfo alloc] initWithDictionary:dict];
            
            _workArr = [NSMutableArray arrayWithArray:typeInfo.data];
            SWWorkerTypeData *type = [[SWWorkerTypeData alloc]initWithDictionary:@{@"type_name":@"全部",@"wid":@"0"}];
            [_workArr insertObject:type atIndex:0];
            _item1.typeArr = _workArr;
            [self.tableview reloadData];
        }
    } OnError:^(NSString *error) {
        
    }];
    
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
        [_item3 setSelect:NO];
    }else if([item.title isEqualToString:@"地区"]){
        [_item1 setSelect:NO];
        [_item3 setSelect:NO];
         selectTag = 2;
    }else if([item.title isEqualToString:@"排序"]){
        [_item1 setSelect:NO];
        [_item2 setSelect:NO];
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
    }else if (selectTag == 2){
        return self.areaArr.count;
    }else if (selectTag == 3){
        return _item3.itemArr.count;
    }
    return 0;
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
    }else if (selectTag == 2){
        cell.textLabel.text = self.areaArr[indexPath.row];
    }else if (selectTag == 3){
        cell.textLabel.text = _item3.itemArr[indexPath.row];
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
    }else if (selectTag == 2){
        [self.itemDelegate selectAddressItem:self.areaArr[indexPath.row]];
    }else{
        [self.itemDelegate selectItem:_item3.itemArr[indexPath.row]];
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
