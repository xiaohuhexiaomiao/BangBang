//
//  CopyViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/8/25.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CopyViewController.h"
#import "CXZ.h"
#import "SponsorTableViewCell.h"

#import "CompanyReviewViewController.h"
#import "ShowPaymentsViewController.h"
#import "StampViewController.h"
#import "ShowFileViewController.h"
#import "SWSearchWorkerViewController.h"
#import "ShowPurchaseViewController.h"
#import "ShowCompanyViewController.h"
#import "PaymentsFormViewController.h"
#import "ShowExpenseAccountViewController.h"
#import "ShowStampViewController.h"
#import "UploadPhotoAndTextViewController.h"

#import "ApprovalFileModel.h"
#import "StampModel.h"
#import "ReviewDetailModel.h"
#import "PaymentModel.h"
#import "PurchaseModel.h"
#import "CompanyContractReviewModel.h"
#import "ExpenseAccountModel.h"

@interface CopyViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,ApprovalFileDelegate,StampViewControllerDelegate,CompanyReviewControllerDelegate,PaymentFormsControllerDelegate,PurchaseViewControllerDelegate,ShowCompanyReviewControllerDelegate,SponsorTableViewCellDelegate,ShowExpenseAccountViewControllerDelegate>
{
    NSInteger page;
}
@property(nonatomic ,strong)UITableView *listTableview;

@property(nonatomic ,strong)UISearchBar *topsearchbar;

@property(nonatomic ,strong)NSMutableArray *listArray;

@property(nonatomic ,strong)ApprovalFileModel *fileModel;

@property(nonatomic ,strong)StampModel *stampModel;

@property(nonatomic ,strong)ReviewDetailModel *reviewModel;

@property(nonatomic ,strong)PaymentModel *payModel;

@property(nonatomic ,strong)PurchaseModel *purchaseModel;

@property(nonatomic ,strong)CompanyContractReviewModel *company_review_model;

@property(nonatomic ,strong)ExpenseAccountModel *expenseModel;

@property(nonatomic ,copy)NSString *keyWords;

@end

@implementation CopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackw];
    if (self.is_selected_form) {
        [self setupTitle];
    }
    _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH , self.view.bounds.size.height-20) style:UITableViewStylePlain];
    _listTableview.delegate = self;
    _listTableview.dataSource = self;
    __weak typeof(self) weakself = self;
    _listTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakself loadFirstData];
    }];
    _listTableview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    [_listTableview.mj_header beginRefreshing];
    [self.view addSubview:_listTableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark Systom Method
-(void) setupTitle
{
    _topsearchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 150, 30)];
    _topsearchbar.delegate = self;
    _topsearchbar.placeholder = @"请输入关键字";
    for (UIView *sv in _topsearchbar.subviews)
    {
        if ([sv isKindOfClass:NSClassFromString(@"UIView")] && sv.subviews.count > 0)
        {
            [sv.subviews.firstObject removeFromSuperview];
            UITextField *textField = sv.subviews.lastObject;
            
            textField.layer.borderColor = TOP_GREEN.CGColor;
            textField.layer.borderWidth = 0.5;
            textField.layer.masksToBounds = YES;
            textField.layer.cornerRadius = 15;
            textField.font = [UIFont systemFontOfSize:12];
            textField.textColor = [UIColor whiteColor];
            UIColor *color = [UIColor whiteColor];
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入关键字" attributes:@{NSForegroundColorAttributeName: color}];
            //            textField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbg"]];
            textField.backgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
            //            textField.leftView = [UIView new];
        }
    }
    ;
    self.navigationItem.titleView = _topsearchbar;
    self.navigationItem.titleView.width = SCREEN_WIDTH-150;
    
}


#pragma mark Private Method
-(void)loadFirstData
{
    page = 1;
    [self.listArray removeAllObjects];
    [self loadData];
}

-(void)loadMoreData
{
    page ++;
    //    NSLog(@"***%li",page);
    [self loadData];
}

-(void)loadData
{
    if (self.is_selected_form) {
        [self loadSearchApproval];
    }else{
        if (self.formType == 0) {
            NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                        @"type":@(3),
                                        @"p":@(page),
                                        @"each":@"10",
                                        @"company_id":self.companyID,
                                        @"approval_type":@(self.type)};
            [[NetworkSingletion sharedManager]getContractReviewList:paramDict onSucceed:^(NSDictionary *dict) {
                //                            NSLog(@"**list*%@",dict);
                [self.listTableview.mj_header endRefreshing];
                [self.listTableview.mj_footer endRefreshing];
                if ([dict[@"code"] integerValue] == 0) {
                    NSArray *array = [ReviewListModel objectArrayWithKeyValuesArray:dict[@"data"]];
                    [self.listArray addObjectsFromArray:array];
                    [self.listTableview reloadData];
                }else{
                    
                    [MBProgressHUD showError:dict[@"message"] toView:self.view];
                }
                
            } OnError:^(NSString *error) {
                [self.listTableview.mj_header endRefreshing];
                [self.listTableview.mj_footer endRefreshing];
                [MBProgressHUD showError:error toView:self.view];
            }];
        }else{
            NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                        @"type":@(3),
                                        @"p":@(page),
                                        @"each":@"10",
                                        @"approval_persona_type":@(self.type)};
            [[NetworkSingletion sharedManager]getPersonalApprovalList:paramDict onSucceed:^(NSDictionary *dict) {
                //                            NSLog(@"**list*%@",dict);
                [self.listTableview.mj_header endRefreshing];
                [self.listTableview.mj_footer endRefreshing];
                if ([dict[@"code"] integerValue] == 0) {
                    NSArray *array = [ReviewListModel objectArrayWithKeyValuesArray:dict[@"data"]];
                    [self.listArray addObjectsFromArray:array];
                    [self.listTableview reloadData];
                }else{
                    
                    [MBProgressHUD showError:dict[@"message"] toView:self.view];
                }
                
            } OnError:^(NSString *error) {
                [self.listTableview.mj_header endRefreshing];
                [self.listTableview.mj_footer endRefreshing];
                [MBProgressHUD showError:error toView:self.view];
            }];
        }
        
        
    }
    
}

-(void)loadSearchApproval
{
    if (self.formType == 0) {
        NSDictionary *paramDict;
        if (![NSString isBlankString:self.keyWords]) {
            paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                          @"company_id":self.companyID,
                          @"approval_type":@(self.type),
                          @"select":self.keyWords,
                          @"p":@(page),
                          @"each":@"10"};
        }else{
            paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                          @"company_id":self.companyID,
                          @"approval_type":@(self.type),
                          @"p":@(page),
                          @"each":@"10"};
        }
        [[NetworkSingletion sharedManager]getPaymentBasisList:paramDict onSucceed:^(NSDictionary *dict) {
            //                                        NSLog(@"**list*%@",dict);
            [self.listTableview.mj_header endRefreshing];
            [self.listTableview.mj_footer endRefreshing];
            if ([dict[@"code"] integerValue] == 0) {
                NSArray *array = [ReviewListModel objectArrayWithKeyValuesArray:dict[@"data"]];
                [self.listArray addObjectsFromArray:array];
                [self.listTableview reloadData];
            }else{
                
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
            
        } OnError:^(NSString *error) {
            [self.listTableview.mj_header endRefreshing];
            [self.listTableview.mj_footer endRefreshing];
            [MBProgressHUD showError:error toView:self.view];
        }];
    }else{
        NSDictionary *paramDict;
        if (![NSString isBlankString:self.keyWords]) {
            paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                          @"approval_type":@(self.type),
                          @"select":self.keyWords,
                          @"p":@(page),
                          @"each":@"10",
                          @"approval_state":@(1)};
        }else{
            paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                          @"approval_state":@(1),
                          @"approval_type":@(self.type),
                          @"p":@(page),
                          @"each":@"10"};
        }
        [[NetworkSingletion sharedManager]searchPersonalApproval:paramDict onSucceed:^(NSDictionary *dict) {
            //                                        NSLog(@"**list*%@",dict);
            [self.listTableview.mj_header endRefreshing];
            [self.listTableview.mj_footer endRefreshing];
            if ([dict[@"code"] integerValue] == 0) {
                NSArray *array = [ReviewListModel objectArrayWithKeyValuesArray:dict[@"data"]];
                [self.listArray addObjectsFromArray:array];
                [self.listTableview reloadData];
            }else{
                
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
            
        } OnError:^(NSString *error) {
            [self.listTableview.mj_header endRefreshing];
            [self.listTableview.mj_footer endRefreshing];
            [MBProgressHUD showError:error toView:self.view];
        }];
    }
    
}

-(void)onBack
{
    if (self.formType == 0) {
        if (self.type == 2) {
            if (self.reviewModel) {
                [self.delegate copyReviewAll:self.reviewModel];
            }
        }else if (self.type == 6) {
            if (self.fileModel) {
                [self.delegate copyAll:self.fileModel];
            }
        }else if (self.type == 5){
            if (self.stampModel) {
                [self.delegate copyAll:self.stampModel];
            }
        }else if (self.type == 0 || self.type == 8||self.type == 9||self.type == 1001){
            if (self.payModel) {
                [self.delegate copyAll:self.payModel];
            }
            
        }else if (self.type == 3 || self.type == 7||self.type == 10||self.type == 1000){
            if (self.purchaseModel) {
                [self.delegate copyAll:self.purchaseModel];
            }
            
        }else if (self.type == 111){
            if (self.company_review_model) {
                [self.delegate copyAll:self.company_review_model];
            }
            
        }else if (self.type == 11){
            if (self.expenseModel) {
                [self.delegate copyAll:self.expenseModel];
            }
            
        }
    }else{
        if (self.type == 3) {
            if (self.fileModel) {
                [self.delegate copyAll:self.fileModel];
            }
        }else if (self.type == 2){
            if (self.payModel) {
                [self.delegate copyAll:self.payModel];
            }
            
        }else if (self.type == 1){
            if (self.purchaseModel) {
                [self.delegate copyAll:self.purchaseModel];
            }
            
        }else if (self.type == 4){
            if (self.expenseModel) {
                [self.delegate copyAll:self.expenseModel];
            }
            
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.topsearchbar resignFirstResponder];
    self.keyWords = searchBar.text;
    [self loadFirstData];
}

#pragma mark Delegate

-(void)copyApprovalFileAll:(ApprovalFileModel *)fileModel
{
    self.fileModel = fileModel;
    
}

-(void)copyStampAll:(StampModel *)StampModel
{
    self.stampModel = StampModel;
}

-(void)copyCompanyReviewAll:(ReviewDetailModel *)detailModel
{
    self.reviewModel = detailModel;
}

-(void)copyPaymentFormsAll:(PaymentModel *)detailModel
{
    self.payModel = detailModel;
}

-(void)copyPurchaseFormAll:(PurchaseModel *)purchaseModel
{
    self.purchaseModel = purchaseModel;
}

-(void)copyNewCompanyReviewAll:(CompanyContractReviewModel *)detailModel
{
    self.company_review_model = detailModel;
}

-(void)clickSeeDetail:(NSInteger)index
{
    ReviewListModel *listModel = self.listArray[index] ;
    [self seeDetail:listModel];
    //    NSLog(@"click  %li",index);
}

-(void)copyExpenseAccountFormAll:(ExpenseAccountModel *)expenseAccountModel
{
    self.expenseModel = expenseAccountModel;
}

#pragma mark UITableViewDelegate & datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SponsorTableViewCell *cell = (SponsorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"SponsorCell"];
    if (!cell) {
        cell = [[SponsorTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SponsorCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    if (self.is_selected_form) {
        cell.is_show_eyebutton = YES;
        cell.delegate = self;
    }
    if (self.listArray.count >0) {
        [cell setSponsorCellWith:self.listArray[indexPath.row]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SponsorTableViewCell *cell = (SponsorTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listArray.count > 0) {
        ReviewListModel *listModel = self.listArray[indexPath.row] ;
        if (self.is_selected_form) {
            if (listModel.approval_state == 1) {
                if (self.type == 6) {
                    UploadPhotoAndTextViewController *uploadVC = [[UploadPhotoAndTextViewController alloc]init];
                    uploadVC.payType = listModel.type;
                    uploadVC.approval_ID = listModel.approval_id;
                    uploadVC.companyID = self.companyID;
                    uploadVC.contractName = listModel.title;
                    uploadVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:uploadVC animated:YES];
                    self.hidesBottomBarWhenPushed = YES;
                }else{
                    PaymentsFormViewController *payVC = [[PaymentsFormViewController alloc]init];
                    payVC.payType = listModel.type;
                    payVC.formID = listModel.approval_id;
                    payVC.companyID = self.companyID;
                    payVC.contractName = listModel.title;
                    payVC.form_type = self.formType;
                    if (self.formType == 1) {
                        payVC.worker_user_id = self.worker_user_id;
                    }
                    payVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:payVC animated:YES];
                }
                
                
            }else if(listModel.approval_state == 0){
                [MBProgressHUD showError:@"审批中..." toView:self.view];
            }else if(listModel.approval_state == 2){
                [MBProgressHUD showError:@"被拒绝..." toView:self.view];
            }else{
                [MBProgressHUD showError:@"已撤销..." toView:self.view];
            }
        }else{
            [self seeDetail:listModel];
        }

    }
}

#pragma mark
-(void)seeDetail:(ReviewListModel*)listModel
{
    CompanyReviewViewController *reviewVC = [[CompanyReviewViewController alloc]init];
    ShowPaymentsViewController *payVC = [[ShowPaymentsViewController alloc]init];
    ShowPurchaseViewController *purchaseVC = [[ShowPurchaseViewController alloc]init];
    ShowStampViewController *stampVC = [[ShowStampViewController alloc]init];
    ShowFileViewController *fileVC = [[ShowFileViewController alloc]init];
    ShowCompanyViewController *companyVC = [[ShowCompanyViewController alloc]init];
    ShowExpenseAccountViewController *expenseAccountVC = [[ShowExpenseAccountViewController alloc]init];
    
    if (self.is_selected_form) {
        
    }else{
        payVC.is_copy = YES;
        payVC.delegate = self;
        payVC.form_type = self.formType;
        
        reviewVC.is_copy = YES;
        reviewVC.delegate = self;
        
        
        purchaseVC.is_copy = YES;
        purchaseVC.delegate = self;
         purchaseVC.form_type = self.formType;
        
        stampVC.is_copy = YES;
        stampVC.delegate = self;
        
        companyVC.is_copy = YES;
        companyVC.delegate = self;
        
        fileVC.is_copy = YES;
        fileVC.delegate = self;
         fileVC.form_type = self.formType;
        
        expenseAccountVC.is_copy = YES;
        expenseAccountVC.delegate =self;
         expenseAccountVC.form_type = self.formType;
    }
    reviewVC.is_aready_approval = YES;
    payVC.is_aready_approval = YES;
    purchaseVC.is_aready_approval = YES;
    stampVC.is_aready_approval = YES;
    fileVC.is_aready_approval = YES;
    companyVC.is_aready_approval = YES;
    expenseAccountVC.is_aready_approval = YES;
    if (self.formType == 0) {
        if (listModel.type == 1 || listModel.type == 2) {
            reviewVC.typeStr = [NSString stringWithFormat:@"%@",@(listModel.type)];
            reviewVC.approval_id = listModel.approval_id;
            reviewVC.participation_id = listModel.participation_id;
            reviewVC.company_id = listModel.company_id;
            reviewVC.is_approval = YES;
            reviewVC.contractTitle = listModel.title;
            reviewVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:reviewVC animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }else if (listModel.type == 0||listModel.type == 8||listModel.type == 9){
            payVC.approvalID = listModel.approval_id;
            [self.navigationController pushViewController:payVC animated:YES];
        }else if (listModel.type == 3 ||listModel.type == 7||listModel.type == 10){
            purchaseVC.approvalID = listModel.approval_id;
            [self.navigationController pushViewController:purchaseVC animated:YES];
        }else if (listModel.type == 5){
            stampVC.approvalID = listModel.approval_id;
            [self.navigationController pushViewController:stampVC animated:YES];
        }else if (listModel.type == 6){
            fileVC.approvalID = listModel.approval_id;
            [self.navigationController pushViewController:fileVC animated:YES];
        }else if (listModel.type == 111){
            companyVC.approval_id = listModel.approval_id;
            [self.navigationController pushViewController:companyVC animated:YES];
        }else if (listModel.type == 11){
            expenseAccountVC.approvalID = listModel.approval_id;
            [self.navigationController pushViewController:expenseAccountVC animated:YES];
        }
    }else{
        if (listModel.type == 2){
            payVC.approvalID = listModel.approval_id;
            [self.navigationController pushViewController:payVC animated:YES];
        }else if (listModel.type==1){
            purchaseVC.approvalID = listModel.approval_id;
            [self.navigationController pushViewController:purchaseVC animated:YES];
        }else if (listModel.type == 3){
            fileVC.approvalID = listModel.approval_id;
            [self.navigationController pushViewController:fileVC animated:YES];
        }else if (listModel.type == 4){
            expenseAccountVC.approvalID = listModel.approval_id;
            [self.navigationController pushViewController:expenseAccountVC animated:YES];
        }
    }
    
   
}

#pragma get / set

-(NSMutableArray*)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}


@end
