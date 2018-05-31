//
//  SWFinishedView.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWFinishedView.h"

#import "CXZ.h"

#import "SWFinishedCell.h"

#import "SWMyTaskCmd.h"
#import "SWMyTaskInfo.h"
#import "SWMyTaskData.h"
#import "SWTools.h"
#import "SWFinishedController.h"
#import "SWJobDetailController.h"

@interface SWFinishedView ()<UITableViewDelegate,UITableViewDataSource,SWFinishedCellDelegate>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSArray *dataSource;

@end


@implementation SWFinishedView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        //初始化界面
        [self initWithView];
        
        [self loadData];
        
    }
    
    return self;
    
}

- (void)loadData {
    
    SWMyTaskCmd *taskCmd = [[SWMyTaskCmd alloc] init];
    taskCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    taskCmd.build_status = 4;
    
    [[HttpNetwork getInstance] requestPOST:taskCmd success:^(BaseRespond *respond) {
        
        SWMyTaskInfo *taskInfo = [[SWMyTaskInfo alloc] initWithDictionary:respond.data];
        
        _dataSource = taskInfo.data;
        
        [_tableView reloadData];
        
        [_tableView.mj_header endRefreshing];
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        [_tableView.mj_header endRefreshing];
        
        [MBProgressHUD showError:@"加载数据失败" toView:self];
        
    }];
    
}


//初始化界面
- (void)initWithView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    tableView.tableFooterView = [UIView new];
    [self addSubview:tableView];
    _tableView = tableView;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        [self loadData];
        
    }];
    
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    
    _tableView.mj_header = header;
    
}
#pragma mark 点击申请付款

-(void)clickApplyPayBtn:(NSInteger)tag
{
    SWMyTaskData *taskData = _dataSource[tag];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请输入申请金额" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入金额";
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
 
    }];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *txField = alertVC.textFields[0];
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        NSDictionary *dict = @{@"wid":uid,
                               @"apply_amount":txField.text,
                               @"contract_id":taskData.information_id};
        [self applyPayment:dict];
    }]];
    SWFinishedController *finishVC = (SWFinishedController*)[self viewController];
    [finishVC presentViewController:alertVC animated:YES completion:nil];
    
}

-(void)applyPayment:(NSDictionary*)paramDict
{
    [[NetworkSingletion sharedManager]applyPayment:paramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"****%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            [WFHudView showMsg:@"申请成功" inView:self];
        }else{
            [WFHudView showMsg:dict[@"message"] inView:self];
        }
    } OnError:^(NSString *error) {
         [WFHudView showMsg:error inView:self];
    }];
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
#pragma mark ------------ tableView delegate & dataSource start ------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataSource.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 49.0f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    return view;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SWFinishedCell *waitingCell = [SWFinishedCell initWithTableViewCell:tableView];
    waitingCell.tag = indexPath.row;
    waitingCell.delegate = self;
    SWMyTaskData *taskData = _dataSource[indexPath.section];
    
    [waitingCell showData:[SWTools dateFormate:taskData.add_time formate:@"yyyy-MM-dd"] content:taskData.title];
    
    return waitingCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataSource.count > 0) {
        SWJobDetailController *jobController = [[SWJobDetailController alloc] init];
        SWMyTaskData *taskData = _dataSource[indexPath.section];
        jobController.iid = taskData.information_id;
        jobController.type = 4;
        [self.viewController.navigationController pushViewController:jobController animated:YES];
    }
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark ------------ tableView delegate & dataSource end ------------------

@end
