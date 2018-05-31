//
//  RightsManagementViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/13.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "RightsManagementViewController.h"
#import "CXZ.h"
#import "AdressBookViewController.h"
#import "PerssonalTableViewCell.h"

@interface RightsManagementViewController ()<UITableViewDelegate,UITableViewDataSource,UpdateApprovalList,AdressBookDelegate>

@property (nonatomic, strong)UITableView *perTableview;

@property (nonatomic ,strong)NSMutableDictionary *deleteSignDict;

@property (nonatomic ,strong)NSMutableDictionary *listDict;

@property (nonatomic , assign)NSInteger editIndex;

@end

@implementation RightsManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"设置审批权限" withColor:[UIColor whiteColor]];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 5, SCREEN_WIDTH-16, 30)];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.numberOfLines = 2;
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.text = @"注意：审批顺序从左到右依次为低级到高级，点击编辑按钮，长按头像移动可改变审批顺序...";
    [self.view addSubview:tipLabel];
    
    _perTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, tipLabel.bottom+5, SCREEN_WIDTH, SCREEN_HEIGHT-40-100) style:UITableViewStyleGrouped];
    _perTableview.delegate =self;
    _perTableview.dataSource = self;
    _perTableview.backgroundColor = [UIColor whiteColor];
    _perTableview.separatorColor = [UIColor clearColor];
    [self.view addSubview:_perTableview];
    
    [self loadApprovalList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark Private Method

-(void)clickSetBtn:(UIButton*)setBtn
{
//    NSLog(@"**tag**%li",setBtn.tag);
    self.editIndex = setBtn.tag;
    [self.deleteSignDict setObject:@"1" forKey:@(setBtn.tag)];
    [self.perTableview reloadSections:[NSIndexSet indexSetWithIndex:setBtn.tag] withRowAnimation:UITableViewRowAnimationNone];
   
}

-(void)clickSaveButton:(UIButton*)saveButton
{
//     NSLog(@"**save**%li",saveButton.tag);
    
    static NSString *type;
    NSString *index = [NSString stringWithFormat:@"%li",saveButton.tag-100];
    NSArray *selectArray = [self.listDict objectForKey:index];
    [self.deleteSignDict setObject:@"0" forKey:@(saveButton.tag-100)];
    if (saveButton.tag-100 == 0) {
        
        NSMutableArray *paramArray = [NSMutableArray array];
        for (int i = 0; i <selectArray.count; i++) {
            NSString *uid = [selectArray[i] objectForKey:@"uid"];
            [paramArray addObject:uid];
        }
        NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                    @"company_id":self.company_ID,
                                    @"boss":[NSString dictionaryToJson:paramArray]
                                    };
        [[NetworkSingletion sharedManager]setSpecailApproval:paramDict onSucceed:^(NSDictionary *dict) {
//                    NSLog(@"**set**%@",dict);
            if ([dict[@"code"] integerValue]==0) {
                [MBProgressHUD showSuccess:@"保存成功" toView:self.view];
                [self.perTableview reloadSections:[NSIndexSet indexSetWithIndex:saveButton.tag-100] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }else{
       
        switch (saveButton.tag-100) {
            case 1:type = @"2";break;
            case 2:type =  @"1";break;
            case 3:type = @"0";break;
            case 4:type = @"8";break;
                case 5:type = @"9";break;
                case 6:type = @"3";break;
                case 7:type = @"7";break;
                 case 8:type = @"10";break;
                case 9:type = @"5";break;
                case 10:type = @"6";break;
            default:
                break;
        }
        NSMutableArray *paramArray = [NSMutableArray array];
        for (int i = 0; i <selectArray.count; i++) {
            NSString *uid = [selectArray[i] objectForKey:@"uid"];
            [paramArray addObject:@{@"uid":uid}];
        }
//            NSLog(@"**add*%li",paramArray.count);
        NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                    @"company_id":self.company_ID,
                                    @"type":type,
                                    @"sequence":[NSString dictionaryToJson:paramArray]
                                    };
        [[NetworkSingletion sharedManager]setApprovalList:paramDict onSucceed:^(NSDictionary *dict) {
//                    NSLog(@"**set**%@***%@",dict,dict[@"message"]);
            if ([dict[@"code"] integerValue]==0) {
                [MBProgressHUD showSuccess:@"保存成功" toView:self.view];
                [self.perTableview reloadSections:[NSIndexSet indexSetWithIndex:saveButton.tag-100] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }
    
    
}

-(void)loadApprovalList
{
     NSArray *titleArray = @[@"特权设置（可越级审批）",@"合同评审表（家装）",@"合同评审表（公装）",@"请款单（家装）",@"请款单（公装）",@"请款单（其他）",@"请购单（家装）",@"请购单（公装）",@"请购单（其他）",@"印章申请",@"呈批件"];
    self.listDict = [NSMutableDictionary dictionary];
    NSLog(@"***%@",self.company_ID);
    [[NetworkSingletion sharedManager]getApprovalList:@{@"company_id":self.company_ID} onSucceed:^(NSDictionary *dict) {
//        NSLog(@"***sd*%@",dict);
        if ([dict[@"code"]integerValue] == 0) {
            for (NSDictionary *dictionary in [dict[@"data"] objectForKey:@"approval"]) {
                NSInteger type = [dictionary[@"type"] integerValue];
                switch (type) {
                    case 0:
                        [self.listDict setObject:dictionary[@"list"] forKey:@"3"];
                        break;
                    case 1:[self.listDict setObject:dictionary[@"list"] forKey:@"2"];break;
                    case 2:[self.listDict setObject:dictionary[@"list"] forKey:@"1"];break;
                    case 3:[self.listDict setObject:dictionary[@"list"] forKey:@"6"];break;
                    case 5:[self.listDict setObject:dictionary[@"list"] forKey:@"9"];break;
                    case 6:[self.listDict setObject:dictionary[@"list"] forKey:@"10"];break;
                    case 7:[self.listDict setObject:dictionary[@"list"] forKey:@"7"];break;
                    case 8:[self.listDict setObject:dictionary[@"list"] forKey:@"4"];break;
                    case 9:[self.listDict setObject:dictionary[@"list"] forKey:@"5"];break;
                    case 10:[self.listDict setObject:dictionary[@"list"] forKey:@"8"];break;
                    default:
                        break;
                }
            }
        
            [self.perTableview reloadData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}
#pragma mark  Delegate

-(void)updateApprovalList:(NSMutableArray *)listarray
{
//    NSLog(@"change");
    NSString *index = [NSString stringWithFormat:@"%li",self.editIndex];
    [self.listDict setObject:listarray forKey:index];
}
//点击添加
-(void)clickAddBtn:(NSMutableArray *)listarray index:(NSInteger)index
{
//    NSLog(@"**add*%li",index);
    self.editIndex = index;
    AdressBookViewController *bookVC = [[AdressBookViewController alloc]init];
    bookVC.companyid = self.company_ID;
    bookVC.areadySelectArray = listarray;
    bookVC.isSelect = YES;
    bookVC.delegate = self;
    bookVC.loadDataType = 2;
    bookVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bookVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

-(void)saveAdressBook:(NSMutableArray *)selectedArray
{
//    NSLog(@"*count**%li",self.editIndex);
    NSString *index = [NSString stringWithFormat:@"%li",self.editIndex];
    [self.listDict setObject:selectedArray forKey:index];
    [self.perTableview reloadSections:[NSIndexSet indexSetWithIndex:self.editIndex] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark  UITableview Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 11;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PerssonalTableViewCell *cell = (PerssonalTableViewCell*)[tableView  dequeueReusableCellWithIdentifier:@"PerssonalCell"];
    if (!cell) {
        cell = [[PerssonalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PerssonalCell"];
    }
//    PerssonalTableViewCell *cell = [[PerssonalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PerssonalCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.index = indexPath.section;
    NSString *delete = [self.deleteSignDict objectForKey:@(indexPath.section)];
    if (delete && [delete isEqualToString:@"1"]) {
         cell.isDelete = YES;
    }else{
        cell.isDelete = NO;
    }
    if (self.listDict.count > 0) {
        NSString *index = [NSString stringWithFormat:@"%li",indexPath.section];
        [cell setPerssonalCell:[self.listDict objectForKey:index]];
    }
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *titleArray = @[@"特权设置（可越级审批）",@"合同评审表（家装）",@"合同评审表（公装）",@"请款单（家装）",@"请款单（公装）",@"请款单（其他）",@"请购单（家装）",@"请购单（公装）",@"请购单（其他）",@"印章申请",@"呈批件"];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-78, 30)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = TITLECOLOR;
    titleLabel.text = titleArray[section];
    [headView addSubview:titleLabel];
    
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.frame = CGRectMake(titleLabel.right, 0, 30, 30);
    [headBtn setTitle:@"编辑" forState:UIControlStateNormal];
//    [headBtn setTitle:@"保存" forState:UIControlStateSelected];
    headBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [headBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    headBtn.tag = section;
    [headBtn addTarget:self action:@selector(clickSetBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:headBtn];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(headBtn.right, 0, 40, 30);
    [saveBtn setTitle:@"| 保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    saveBtn.tag = section+100;
    [saveBtn addTarget:self action:@selector(clickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:saveBtn];
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

#pragma mark GET / SET
-(NSMutableDictionary*)deleteSignDict
{
    if (!_deleteSignDict) {
        _deleteSignDict = [NSMutableDictionary dictionary];
    }
    return _deleteSignDict;
}




@end
