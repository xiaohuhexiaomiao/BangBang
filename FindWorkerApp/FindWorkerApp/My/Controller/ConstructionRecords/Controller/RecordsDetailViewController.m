//
//  RecordsDetailViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/5/10.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "RecordsDetailViewController.h"
#import "CXZ.h"

#import "RecordsCell.h"
#import "CommentCell.h"

@interface RecordsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    BOOL _isShow;
}
@property (nonatomic , strong) UITableView *detailTableview;

@property (nonatomic , strong) NSArray *commentArray;

@property (nonatomic ,strong) UITextField *commentTextfield;

@property (nonatomic ,strong) UIView *commentView;

@end

@implementation RecordsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackw];
    [self setupTitleWithString:@"施工详情" withColor:[UIColor whiteColor]];
    
    _detailTableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _detailTableview.delegate = self;
    _detailTableview.dataSource = self;
    _detailTableview.separatorColor = [UIColor clearColor];
    _detailTableview.height = SCREEN_HEIGHT-64-40;
    [self.view addSubview:_detailTableview];
    _detailTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadCommentArray)];
    [_detailTableview.mj_header beginRefreshing];
    
    
    _commentView = [[UIView alloc]initWithFrame:CGRectMake(8, SCREEN_HEIGHT-100, SCREEN_WIDTH-16, 40)];
    _commentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_commentView];
    
    _commentTextfield = [[UITextField alloc]initWithFrame:CGRectMake(8, 1, _commentView.width-40, _commentView.height-1)];
    _commentTextfield.placeholder = @"回复评论";
    _commentTextfield.returnKeyType = UIReturnKeySend;
    _commentTextfield.delegate = self;
    _commentTextfield.backgroundColor = [UIColor whiteColor];
    _commentTextfield.font = [UIFont systemFontOfSize:12];
    [_commentView addSubview:_commentTextfield];
    
    UIButton *sendButon = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButon.frame = CGRectMake(_commentTextfield.right, _commentTextfield.top, 40, 40);
    [sendButon setTitle:@"发送" forState:UIControlStateNormal];
    sendButon.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendButon setTitleColor:TOP_GREEN forState:UIControlStateNormal];
    [sendButon addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [_commentView addSubview:sendButon];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




#pragma mark 数据处理

-(void)loadCommentArray
{
    [[NetworkSingletion sharedManager]constuctionCommentList:@{@"record_id":self.detailsModel.record_id} onSucceed:^(NSDictionary *dict) {
//        NSLog(@"评论：%@",dict);
        [_detailTableview.mj_header endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            self.commentArray = [dict objectForKey:@"data"];
            [self.detailTableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
         [_detailTableview.mj_header endRefreshing];
        [MBProgressHUD showError:error toView:self.view];
    }];
}

-(void)sendComment
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *param = @{@"uid":uid,
                            @"content":self.commentTextfield.text,
                            @"record_id":self.detailsModel.record_id};
    [[NetworkSingletion sharedManager]sendComment:param onSucceed:^(NSDictionary *dict) {
//        NSLog(@"***%@",dict);
        if ([dict[@"code"]integerValue]==0) {

            self.commentTextfield.text = @"";
            [self loadCommentArray];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
}

#pragma mark UITableview Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.commentArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        RecordsCell *cell = (RecordsCell*)[tableView dequeueReusableCellWithIdentifier:@"RecordsCell"];
        if (!cell) {
            cell = [[RecordsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecordsCell" withModel:self.detailsModel];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    CommentCell *cell = (CommentCell*)[tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (!cell) {
        cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCommentCellWithDictionary:self.commentArray[indexPath.row]];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        RecordsCell *cell = (RecordsCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.recordsCellHeight;
    }
    CommentCell *cell = (CommentCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.commentCellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
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


#pragma mark UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"****%@",textField.text);
    [self sendComment];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 键盘处理

- (void)dismissKeyBoard
{
    [self.commentTextfield endEditing:YES];
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0.0f, -kbHeight+64, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }];
}


@end
