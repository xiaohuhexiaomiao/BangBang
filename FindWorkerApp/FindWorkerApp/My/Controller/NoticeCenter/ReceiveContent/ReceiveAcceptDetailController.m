//
//  AcceptDetailController.m
//  BangBangGongRen
//
//  Created by cxz on 2018/3/20.
//  Copyright © 2018年 cxz. All rights reserved.
//

#import "ReceiveAcceptDetailController.h"
#import "CXZ.h"
#import "ReceiveAcceptDetailCell.h"
#import "AcceptInfoModel.h"
#import "ApplyInfoModel.h"

@interface ReceiveAcceptDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic , strong)UITableView *tabelView;

@property(nonatomic , strong)NSArray *titleArray;

@property(nonatomic , strong)AcceptInfoModel *acceptInfoModel;

@property(nonatomic , strong)UIButton *submitButton;

@property (nonatomic, assign) NSInteger cell_type;

@end

@implementation ReceiveAcceptDetailController

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
    [_tabelView.mj_header beginRefreshing];
    
    if (self.operation_type == 0) {
        
        self.cell_type= 2;
    }else{
        self.cell_type = 3;
    }
    _submitButton = [CustomView customButtonWithContentView:self.view image:nil title:@"提交"];
    _submitButton.frame = CGRectMake(16, SCREEN_HEIGHT-144, SCREEN_WIDTH-32, 40);
    _submitButton.backgroundColor = ORANGE_COLOR;
    _submitButton.layer.cornerRadius = 5.0;
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(clickSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"SENDACCEPTSUCCESS" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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

-(void)onBack
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"inspection_id"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"settlement_id"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickSubmitButton
{
    if (self.operation_type == 0) {
//        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:2];
//        ReceiveAcceptDetailCell *cell = (ReceiveAcceptDetailCell*)[self.tabelView cellForRowAtIndexPath:indexpath];
//        if ([cell.inputMoneyTextfield.text floatValue]==0.0) {
//            [WFHudView showMsg:@"请输入金额" inView:self.view];
//            return;
//        }
       
        NSDictionary *dict = @{@"contract_id":@(self.contract_id),
                               @"inspection_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"inspection_id"],
                               @"settlement_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"settlement_id"]};
        [[NetworkSingletion sharedManager]submitBigAcceptForm:dict onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue]==0) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"inspection_id"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"settlement_id"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }else{
//        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:2];
//        ReceiveAcceptDetailCell *cell = (ReceiveAcceptDetailCell*)[self.tabelView cellForRowAtIndexPath:indexpath];
        NSString *insepction = [[NSUserDefaults standardUserDefaults]objectForKey:@"inspection_id"];
        NSString *settlement = [[NSUserDefaults standardUserDefaults]objectForKey:@"settlement_id"];
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
//        [paramDict setObject:cell.inputMoneyTextfield.text forKey:@"money"];
        [paramDict setObject:self.apply_id forKey:@"apply_id"];
        if (![NSString isBlankString:insepction]) {
            [paramDict setObject:insepction forKey:@"inspection_id"];
        }
        if (![NSString isBlankString:settlement]) {
            [paramDict setObject:settlement forKey:@"settlement_id"];
        }
        
        [[NetworkSingletion sharedManager]modifyApplyAccept:paramDict onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue]==0) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"inspection_id"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"settlement_id"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
//            NSLog(@"***%@",error);
            [MBProgressHUD showError:error toView:self.view];
        }];
        
    }
   
}

-(void)reloadData
{
//    NSDictionary *sDict = [[NSDictionary alloc] init];
//    sDict = noti.userInfo;
//    if ([sDict[@"type"] isEqualToString:@"inspection"]) {
//        self.acceptInfoModel.apply_content.inspection_id = sDict[@"result"];
//        NSLog(@"***%@",self.acceptInfoModel.apply_content.inspection_id);
//    }else{
//        self.acceptInfoModel.apply_content.settlement_id = sDict[@"result"];
//    }
    if (self.operation_type == 0) {
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:2];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:2];
        self.cell_type = 4;
        [self.tabelView reloadRowsAtIndexPaths:@[indexPath1,indexPath2] withRowAnimation:UITableViewRowAnimationNone];
    }
    
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
    ReceiveAcceptDetailCell *cell = (ReceiveAcceptDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"ReceiveAcceptDetailCell"];
    if (!cell) {
        cell = [[ReceiveAcceptDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReceiveAcceptDetailCell"];
    }
    
    cell.cellType = self.cell_type;
    cell.tag = indexPath.row;
    [cell configAcceptCell];
    [cell setInfoModel:self.acceptInfoModel];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.cell_type == 2) {
        cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
    }else{
        cell.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        cell.titleLabel.text = [NSString stringWithFormat:@"<font name=Helvetica-Bold size=13 color=\"#0000ff\"><a href=@""><bi>%@</bi></a></font>",self.titleArray[indexPath.section][indexPath.row]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cell_type == 3 && indexPath.section == 2) {
        ReceiveAcceptDetailCell *cell = (ReceiveAcceptDetailCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;;
    }
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
