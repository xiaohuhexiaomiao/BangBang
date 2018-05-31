//
//  ConfirmPayViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/1/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ConfirmPayViewController.h"
#import "CXZ.h"
#import "SWAlipay.h"
#import "MyWorkersCell.h"
@interface ConfirmPayViewController ()<UITableViewDelegate,UITableViewDataSource,MyWorkersCellDelegate>

@property (nonatomic ,strong) UITableView *confirmTableView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UIButton *payOffBtn;

@property (nonatomic, assign) CGFloat totalMoney;//总金额

@property (nonatomic, assign) NSInteger num;//人数

@property (nonatomic ,assign) NSInteger index;

@property (nonatomic, copy) NSString *moneyStr;

@property (nonatomic, strong) NSMutableDictionary *moneyDict;

@end

@implementation ConfirmPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"确认付款" withColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.confirmTableView];
    [self creatBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark 私有
-(void)payOff
{
    if (self.totalPay <= 0) {
        [WFHudView showMsg:@"请输入金额" inView:self.view];
        return;
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.moneyDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *payinfo = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *paramDict = @{@"uid":uid,
                                @"total_price":@(self.totalPay),
                                @"type":@"1",
                                @"pay_info":payinfo};
    [[NetworkSingletion sharedManager]toPayOff:paramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"***%@",dict);
//        NSLog(@"***%@",dict[@"data"]);
        if ([dict[@"code"] integerValue] == 0) {
            SWAlipay *pay = [SWAlipay new];
            NSString *payStr = dict[@"data"];
            [pay payToStr:payStr];
        }
    } OnError:^(NSString *error) {
        [WFHudView showMsg:error inView:self.navigationController.view];
    }];
}

-(void)creatBottomView
{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.confirmTableView.bottom, SCREEN_WIDTH, 40)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.hidden = NO;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = TOP_GREEN;
    [self.bottomView addSubview:line];
    
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 1, (SCREEN_WIDTH-32)/3, 39)];
    self.numberLabel.font = [UIFont systemFontOfSize:12];
    self.numberLabel.textColor = [UIColor redColor];
    self.numberLabel.attributedText = [self setAttributionWithTitle:[NSString stringWithFormat:@"人数：%li",self.confirmArray.count]];
    [self.bottomView addSubview:self.numberLabel];
    
    self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.numberLabel.right+8, self.numberLabel.top, self.numberLabel.width*2-70, self.numberLabel.height)];
    self.moneyLabel.font = [UIFont systemFontOfSize:12];
    self.moneyLabel.textColor = [UIColor redColor];
    self.moneyLabel.attributedText = [self setAttributionWithTitle:[NSString stringWithFormat:@"总金额：%.2f",self.totalPay]];
    [self.bottomView addSubview:self.moneyLabel];
    
    self.payOffBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payOffBtn.frame = CGRectMake(SCREEN_WIDTH-60, 1, 60, 39) ;
    [self.payOffBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.payOffBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.payOffBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.payOffBtn.backgroundColor = TOP_GREEN;
    [self.payOffBtn addTarget:self action:@selector(payOff) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.payOffBtn];
    
    [self.view addSubview:self.bottomView];
}

-(NSMutableAttributedString*)setAttributionWithTitle:(NSString*)title
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange range = [title rangeOfString:@"："];
    self.moneyLabel.textColor = [UIColor redColor];
    [attributedStr addAttribute:NSForegroundColorAttributeName value: [UIColor blackColor] range:NSMakeRange(0, range.location+1)];
    return attributedStr;
}

#pragma mark UITableViewDelegate & DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.confirmArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"WorkersCell";
    MyWorkersCell *cell = (MyWorkersCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MyWorkersCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    cell.type = SearchType;
    cell.tag = indexPath.row;
    [cell setMyWorkersCell:self.confirmArray[indexPath.row]];
//    if (self.moneyDictionay.count > 0) {
//        NSString *workid = [self.confirmArray[indexPath.row] objectForKey:@"uid"];
//        [cell setMoney:[self.moneyDictionay objectForKey:workid]];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116.0f;
}
#pragma mark cell delegate
#pragma mark CellDelegate

-(void)setMoney:(NSInteger)index isSelect:(BOOL)selected isPut:(BOOL)put money:(CGFloat)money
{
//    NSLog(@"index %li",index);
    self.index = index;
    
    self.moneyStr = [NSString stringWithFormat:@"%.2f",money];
    NSString *workid =[self.confirmArray[self.index] objectForKey:@"uid"];
    
    CGFloat oldMoney = [[self.moneyDict objectForKey:workid] floatValue];
//    NSLog(@"indsdex %f  %@",oldMoney,workid);
    [self.moneyDict setObject:self.moneyStr forKey:workid];

    self.totalMoney += money;
    self.totalMoney -= oldMoney;
    self.moneyLabel.attributedText = [self setAttributionWithTitle:[NSString stringWithFormat:@"总金额：¥%.2lf",self.totalMoney]];
    
}



#pragma mark get/set 方法
-(UITableView*)confirmTableView
{
    if (!_confirmTableView) {
        _confirmTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60-40) style:UITableViewStylePlain];
        _confirmTableView.delegate = self;
        _confirmTableView.dataSource = self;
        _confirmTableView.tableFooterView = [UIView new];
        
    }
    return _confirmTableView;
}
-(NSMutableDictionary*)moneyDict
{
    if (!_moneyDict) {
        _moneyDict = [NSMutableDictionary dictionary];
    }
    return _moneyDict;
}
#pragma mark 设置cell分割线边缘位置
-(void)viewDidLayoutSubviews
{
    if ([self.confirmTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.confirmTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.confirmTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.confirmTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
