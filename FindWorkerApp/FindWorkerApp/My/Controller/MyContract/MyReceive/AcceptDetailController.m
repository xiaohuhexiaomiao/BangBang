//
//  AcceptDetailController.m
//  BangBangGongRen
//
//  Created by cxz on 2018/3/20.
//  Copyright © 2018年 cxz. All rights reserved.
//

#import "AcceptDetailController.h"
#import "CXZ.h"
#import "AcceptDetailCell.h"
#import "AcceptInfoModel.h"
#import "ApplyInfoModel.h"
#import "InputReasonViewController.h"
#import "SWAlipay.h"

@interface AcceptDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic , strong)UITableView *tabelView;

@property(nonatomic , strong)NSArray *titleArray;

@property(nonatomic , strong)UIButton *submitButton;

@property(nonatomic , strong)AcceptInfoModel *acceptInfoModel;

@end

@implementation AcceptDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupNextWithString:@"合同" withColor:[UIColor whiteColor]];
    [self setupTitleWithString:@"验收申请" withColor:[UIColor whiteColor]];
    
    _titleArray = @[@[@"合同总金额",@"开始时间",@"结束时间"],@[@"已付款金额"],@[@"报验单",@"结算单"]];
    _tabelView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    [self.view addSubview:_tabelView];
    
    _tabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    [_tabelView.mj_header beginRefreshing];
    
    if (self.is_to_pay) {
        _submitButton = [CustomView customButtonWithContentView:self.view image:nil title:@"去付款"];
        _submitButton.frame = CGRectMake(16, SCREEN_HEIGHT-144, SCREEN_WIDTH-32, 40);
        _submitButton.backgroundColor = ORANGE_COLOR;
        _submitButton.layer.cornerRadius = 5.0;
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(clickSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tabelView.mj_header beginRefreshing];
}


-(void)onNext
{
    EditWebViewController *web = [[EditWebViewController alloc]init];
    web.titleString = @"合同";
    web.editType = 7;
    web.contractID = self.contract_id;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

-(void)clickSubmitButton
{
    NSDictionary *paramDict = @{@"contract_id":self.acceptInfoModel.contract_id,
                                @"worker_id":self.acceptInfoModel.worker_id,
                                @"type":@(1),
                                @"apply_id":self.acceptInfoModel.apply_content.apply_id};
    [[NetworkSingletion sharedManager]toPayDownPayment:paramDict onSucceed:^(NSDictionary *dict) {
        
        if ([dict[@"code"] integerValue ]== 0) {
            SWAlipay *pay = [SWAlipay new];
            NSString *payStr = dict[@"data"];
            [pay payToStr:payStr];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}



#pragma mark load data

-(void)loadData
{
    [[NetworkSingletion sharedManager]getAcceptanceDetail:@{@"contract_id":@(self.contract_id)} onSucceed:^(NSDictionary *dict) {
        [self.tabelView.mj_header endRefreshing];
        
                NSLog(@"companyre %@",dict);
        
        if ([dict[@"code"] integerValue]==0) {
            AcceptInfoModel *model = [AcceptInfoModel objectWithKeyValues:dict[@"data"]];
            self.acceptInfoModel = model;
            
        }
        [self.tabelView reloadData];
        
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}



#pragma mark UITabelView Delegate & DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray  *array = self.titleArray[section];
    return array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"NormalCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        cell.textLabel.textColor = FORMLABELTITLECOLOR;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        cell.detailTextLabel.textColor = FORMTITLECOLOR;
        cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
        if (self.acceptInfoModel) {
            NSString* beginTime;
            NSString* endTime;
            if ([NSString isBlankString:self.acceptInfoModel.contract_begin_time]) {
                beginTime = @"";
            }else{
                beginTime = self.acceptInfoModel.contract_begin_time;
            }
            if ([NSString isBlankString:self.acceptInfoModel.contract_end_time]) {
                endTime = @"";
            }else{
                endTime = self.acceptInfoModel.contract_end_time;
            }
            
            NSArray *array = @[@[[NSString stringWithFormat:@"%.2lf元",self.acceptInfoModel.subtotal],beginTime,endTime],@[[NSString stringWithFormat:@"%.2lf元",self.acceptInfoModel.amount_received]]];
            cell.detailTextLabel.text = array[indexPath.section][indexPath.row];
        }
        return cell;
    }
    AcceptDetailCell *cell = (AcceptDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"AcceptDetailCell"];
    if (!cell) {
        cell = [[AcceptDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AcceptDetailCell"];
    }
    cell.tag = indexPath.row;
    
    cell.cellType = 1;
    [cell configAcceptCell];
    [cell setInfoModel:self.acceptInfoModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
    }else{
       
        cell.titleLabel.text = [NSString stringWithFormat:@"<font size=13 color=\"#0000ff\"><a href=''><bi>%@</bi></a></font>",self.titleArray[indexPath.section][indexPath.row]];
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
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




@end
