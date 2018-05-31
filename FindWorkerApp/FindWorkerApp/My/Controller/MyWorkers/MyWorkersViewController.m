//
//  MyWorkersViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2016/12/28.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "MyWorkersViewController.h"

#import "SWWorkerDetailController.h"
#import "ConfirmPayViewController.h"
#import "MyWorkersCell.h"
#import "SearchWorkerCell.h"
#import "CXZ.h"
#import "SearchView.h"


@interface MyWorkersViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate, MyWorkersCellDelegate,SearchViewDelegate>
{
    UIWindow *searchWindow;
    SearchView *searchView;
    UIView *bgView;
}

@property (nonatomic ,strong) UITableView *myWorkersTabview;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *addWorkBtn;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UIButton *payOffBtn;

@property (nonatomic, assign) CGFloat totalMoney;//总金额

@property (nonatomic, assign) NSInteger num;//人数

@property (nonatomic ,assign) NSInteger index;

@property (nonatomic, copy) NSString *moneyStr;

@property (nonatomic, strong) NSMutableDictionary *moneyDict;

@property (nonatomic, strong) NSMutableDictionary *selectDict;//存储index 选中状态

@property (nonatomic, assign)BOOL isSelected;//工人选中状态

@property (nonatomic, strong) NSMutableArray *listArray;//数据

@property (nonatomic, strong) NSMutableDictionary *selectedDict;//选择工人

@property (nonatomic, strong) NSMutableArray *addWorkerArray;//添加工人 假数据
@end

@implementation MyWorkersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackw];
    [self setupTitleWithString:@"我要发工资" withColor:[UIColor whiteColor]];
    [self setupNextWithString:@"添加" withColor:TOP_GREEN];
    [self.view addSubview:self.myWorkersTabview];
    [self creatBottomView];
    [self creatSearchView];
    self.myWorkersTabview.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self reloadData];
    }];
    [self.myWorkersTabview.mj_header beginRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark 重写父类方法
-(void)onNext
{
    bgView.hidden = NO;
}

#pragma mark PrivateMethod
//添加
-(void)clickAddWorkersButton
{
    bgView.hidden = NO;
}

-(void)creatSearchView
{
//    searchWindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    searchWindow.windowLevel = UIWindowLevelNormal;
//    searchWindow.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, -40, SCREEN_WIDTH, SCREEN_HEIGHT+40)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(quitSearch)];
    [view addGestureRecognizer:tap];
    [bgView addSubview:view];
    
    searchView = [[SearchView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/3, SCREEN_WIDTH, SCREEN_HEIGHT/3*2)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.delegate = self;
    [bgView addSubview:searchView];
    [self.view addSubview:bgView];
    bgView.hidden = YES;
    
//    [searchWindow addSubview:searchView];
//    [searchWindow makeKeyWindow];
//    searchWindow.hidden = YES;
}

-(void)quitSearch
{
//    [searchWindow resignKeyWindow];
//    searchWindow.hidden = YES;
    bgView.hidden = YES;
}

-(void)reloadData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    [[NetworkSingletion sharedManager]getMyWorkersData:@{@"uid":uid} onSucceed:^(NSDictionary *dict) {
        [self.myWorkersTabview.mj_header endRefreshing];
//        NSLog(@"*woyaofagongzi**%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            [self.addWorkerArray removeAllObjects];
            [self.listArray removeAllObjects];
            [self.listArray addObjectsFromArray:dict[@"data"]];
        }
        [self.myWorkersTabview reloadData];
        
    } OnError:^(NSString *error) {
        [WFHudView showMsg:error inView:self.navigationController.view];
        [self.myWorkersTabview.mj_header endRefreshing];
    }];
}

//添加工人接口
-(void)addWorkerWithID:(NSInteger)tag
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *objDict = searchView.searchArray[tag];
    [[NetworkSingletion sharedManager]addWorker:@{@"uid":uid,@"wid":objDict[@"uid"]} onSucceed:^(NSDictionary *dict) {
//        NSLog(@"**tianijai*%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            [self.addWorkerArray insertObject:objDict atIndex:0];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
            [self.myWorkersTabview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            [WFHudView showMsg:@"添加成功" inView:searchView];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:searchView];
        }
    } OnError:^(NSString *error) {
        [WFHudView showMsg:error inView:searchView];
    }];
}
//删除工人接口
-(void)deleteWorkerWithID:(NSInteger)tag
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *objDict;
    if (tag >= 10000) {
        objDict = self.addWorkerArray[tag -10000];
    }else{
        objDict = self.listArray[tag];
    }
    [[NetworkSingletion sharedManager]deleteWorker:@{@"uid":uid,@"wid":objDict[@"uid"]} onSucceed:^(NSDictionary *dict) {
        //        NSLog(@"**tianijai*%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            if (tag >= 10000) {
                [self.addWorkerArray removeObject:objDict];
            }else{
                [self.listArray removeObject:objDict];
            }
//            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
//            [self.myWorkersTabview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            [self.myWorkersTabview reloadData];
            [WFHudView showMsg:@"删除成功" inView:searchView];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:searchView];
        }
    } OnError:^(NSString *error) {
        [WFHudView showMsg:error inView:searchView];
    }];
}

-(void)creatBottomView
{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.myWorkersTabview.bottom, SCREEN_WIDTH, 40)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.hidden = NO;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = TOP_GREEN;
    [self.bottomView addSubview:line];
    
    self.addWorkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addWorkBtn.frame = CGRectMake(0, 1, 80, 39);
    [self.addWorkBtn setTitle:@"添加工人" forState:UIControlStateNormal];
    [self.addWorkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addWorkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.addWorkBtn addTarget:self action:@selector(clickAddWorkersButton) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.addWorkBtn];
    
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.addWorkBtn.right+40, self.addWorkBtn.top, self.addWorkBtn.width*2-70, self.addWorkBtn.height)];
    self.numberLabel.font = [UIFont systemFontOfSize:12];
    self.numberLabel.textColor = [UIColor redColor];
    self.numberLabel.attributedText = [self setAttributionWithTitle:@"人数："];
    [self.bottomView addSubview:self.numberLabel];
    
    self.payOffBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payOffBtn.frame = CGRectMake(SCREEN_WIDTH-60, 1, 60, 39) ;
    [self.payOffBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.payOffBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.payOffBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.payOffBtn.backgroundColor = TOP_GREEN;
    [self.payOffBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.payOffBtn];
    
    [self.view addSubview:self.bottomView];
}
//点击确定
-(void)confirm
{
    ConfirmPayViewController *confirmVC = [ConfirmPayViewController new];
    confirmVC.confirmArray = [self.selectedDict allValues];
    confirmVC.moneyDictionay = self.moneyDict;
    confirmVC.totalPay = self.totalMoney;
//    NSLog(@"queding %@",self.moneyDict);
//    NSLog(@"sel %li %li",[self.selectedDict allValues].count,confirmVC.confirmArray.count);
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:confirmVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

-(NSMutableAttributedString*)setAttributionWithTitle:(NSString*)title
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange range = [title rangeOfString:@"："];
    self.numberLabel.textColor = [UIColor redColor];
    [attributedStr addAttribute:NSForegroundColorAttributeName value: [UIColor blackColor] range:NSMakeRange(0, range.location+1)];
    return attributedStr;
}

#pragma mark SearchView Delegate
//搜索 查看详情
-(void )didClickWorker:(NSDictionary *)dict
{
    SWWorkerDetailController *workerDetail = [[SWWorkerDetailController alloc] init];
    workerDetail.hidesBottomBarWhenPushed = YES;
    workerDetail.workerName = dict[@"name"];
    workerDetail.uid = dict[@"uid"];
    workerDetail.is_detail = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:workerDetail animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//搜索 添加工人
-(void)clickedAddWorker:(NSInteger)index
{
//    NSLog(@"sou %li",index);
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"确定要添加此工人么？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addWorkerWithID:index];
    }]];
    [self.navigationController presentViewController:alerVC animated:YES completion:nil];
}


#pragma mark CellDelegate

-(void)setMoney:(NSInteger)index isSelect:(BOOL)selected isPut:(BOOL)put money:(CGFloat)money
{
    NSLog(@"index %li",index);
    self.index = index;
    self.isSelected = selected;
    if (put) {
        self.moneyStr = [NSString stringWithFormat:@"%.2f",money];
        static NSString *workid;
        if (self.index >= 10000) {
            workid = [self.addWorkerArray[self.index-10000] objectForKey:@"uid"];
            
        }else{
            workid = [self.listArray[self.index] objectForKey:@"uid"];
        }
        CGFloat oldMoney = [[self.moneyDict objectForKey:workid] floatValue];
        if (self.index >= 10000) {
            [self.moneyDict setObject:self.moneyStr forKey:workid];
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.index-10000 inSection:0];
//            [self.myWorkersTabview reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self.moneyDict setObject:self.moneyStr forKey:workid];
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.index inSection:1];
//            [self.myWorkersTabview reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        }
        CGFloat money = [self.moneyStr floatValue];
        if (self.isSelected) {
            self.totalMoney += money;
            self.totalMoney -= oldMoney;
//            self.moneyLabel.attributedText = [self setAttributionWithTitle:[NSString stringWithFormat:@"总金额：¥%.2lf",self.totalMoney]];
            if (self.index >= 10000) {
                [self.selectedDict setObject:self.addWorkerArray[self.index-10000] forKey:[NSString stringWithFormat:@"%li",self.index]];
            }else{
                [self.selectedDict setObject:self.listArray[self.index] forKey:[NSString stringWithFormat:@"%li",self.index]];
            }
        }
    }
    static NSString *workid;
    NSDictionary *objDict;
    if (index >= 10000) {
        workid = [self.addWorkerArray[index-10000] objectForKey:@"uid"];
        objDict = self.addWorkerArray[index-10000];
    }else{
        workid = [self.listArray[index] objectForKey:@"uid"];
        objDict = self.listArray[index];
    }
    NSString *moenyStr = [self.moneyDict objectForKey:[NSString stringWithFormat:@"%@",workid]];
    CGFloat money2 = [moenyStr floatValue];
//    NSLog(@"***inde %li, %lf",index,money);
    if (put == NO) {
        if (selected ) {
            self.totalMoney += money2;
            self.num += 1;
            [self.selectDict setObject:@"1" forKey:[NSString stringWithFormat:@"%li",index]];
            [self.selectedDict setObject:objDict forKey:[NSString stringWithFormat:@"%li",index]];
        }else{
            self.totalMoney -= money2;
            self.num -= 1;
            [self.selectDict setObject:@"0" forKey:[NSString stringWithFormat:@"%li",index]];
            [self.selectedDict removeObjectForKey:[NSString stringWithFormat:@"%li",index]];
        }
    }
    self.numberLabel.attributedText = [self setAttributionWithTitle:[NSString stringWithFormat:@"人数：%@",@(self.num)]];
//    self.moneyLabel.attributedText = [self setAttributionWithTitle:[NSString stringWithFormat:@"总金额：¥%.2lf",self.totalMoney]];
    
}




#pragma mark UITableViewDelegate & DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.addWorkerArray.count;
    }
    return self.listArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyWorkersCell";
    MyWorkersCell *cell = (MyWorkersCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MyWorkersCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    cell.type = NormallType;
    static NSString *workid;
    static NSString *indexStr;
    if (indexPath.section == 0) {
        cell.tag = indexPath.row+10000;
        [cell setMyWorkersCell:self.addWorkerArray[indexPath.row]];
        workid = [self.addWorkerArray[indexPath.row] objectForKey:@"uid"];
        indexStr = [NSString stringWithFormat:@"%li",indexPath.row+10000];
    }else{
         cell.tag = indexPath.row;
        [cell setMyWorkersCell:self.listArray[indexPath.row]];
        workid = [self.listArray[indexPath.row] objectForKey:@"uid"];
        indexStr = [NSString stringWithFormat:@"%li",indexPath.row];
    }
//    if (self.moneyDict.count > 0) {
//        [cell setMoney:[self.moneyDict objectForKey:workid]];
//    }
    if (self.selectDict.count > 0) {
        [cell setSelectImage:[self.selectDict objectForKey:indexStr]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 1) {
            NSDictionary *dict = self.listArray[indexPath.row];
            if ([dict[@"contract_price"] floatValue] > 0) {
                UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"您和此工人有合同关系不能删除！" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self.navigationController presentViewController:alerVC animated:YES completion:nil];
                return;
            }
        }
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"确定要删除此工人么？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (indexPath.section == 0) {
                [self deleteWorkerWithID:indexPath.row+10000];
            }else{
                [self deleteWorkerWithID:indexPath.row];
            }
            
        }]];
        [self.navigationController presentViewController:alerVC animated:YES completion:nil];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark GET/SET

-(UITableView*)myWorkersTabview
{
    if (!_myWorkersTabview) {
        _myWorkersTabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40-60) style:UITableViewStyleGrouped];
        _myWorkersTabview.delegate = self;
        _myWorkersTabview.dataSource = self;
        _myWorkersTabview.tableFooterView = [UIView new];
        
    }
    return _myWorkersTabview;
}
-(NSMutableDictionary*)moneyDict
{
    if (!_moneyDict) {
        _moneyDict = [NSMutableDictionary dictionary];
    }
    return _moneyDict;
}

-(NSMutableDictionary*)selectDict
{
    if (!_selectDict) {
        _selectDict = [NSMutableDictionary dictionary];
    }
    return _selectDict;
}
-(NSMutableArray*)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

-(NSMutableDictionary*)selectedDict
{
    if (!_selectedDict) {
        _selectedDict = [NSMutableDictionary dictionary];
    }
    return _selectedDict;
}

-(NSMutableArray*)addWorkerArray
{
    if (!_addWorkerArray) {
        _addWorkerArray = [NSMutableArray array];
    }
    return _addWorkerArray;
}


#pragma mark 设置cell分割线边缘位置
-(void)viewDidLayoutSubviews
{
    if ([self.myWorkersTabview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myWorkersTabview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.myWorkersTabview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myWorkersTabview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



@end
