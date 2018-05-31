//
//  RCMShowGroupMemberViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/5/11.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "RCMShowGroupMemberViewController.h"
#import "CXZ.h"
#import "RCMAddMemberTableViewCell.h"
@interface RCMShowGroupMemberViewController ()<UITableViewDelegate,UITableViewDataSource,RCMAddMemberCellDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *members;

@end

@implementation RCMShowGroupMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
//    [self setupNextWithImage:[UIImage imageNamed:@"creat"]];
    [self setupTitleWithString:@"群成员" withColor:[UIColor whiteColor]];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate =  self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    __weak typeof(self) weakself = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshData];
    }];
    [_tableView.mj_header beginRefreshing];

}

- (void)refreshData
{
    NSDictionary *pramDict = @{@"group_id":self.groupID};
    NSArray *memberArray = [[RCDataBaseManager shareInstance]getGroupMember:self.groupID];
    [self.members addObjectsFromArray:memberArray];
    [self.tableView reloadData];
    [[NetworkSingletion sharedManager]getGroupMemberByID:@{@"group_id":self.groupID} onSucceed:^(NSDictionary *dict) {
//                NSLog(@"234234234%@",dict);
        [self.tableView.mj_header endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            [self.members removeAllObjects];
            NSArray *arr = dict[@"data"] ;
            for (NSDictionary *dataDict in arr) {
                NSString *avatar = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,dataDict[@"avatar"]];
                RCUserInfo *data = [[RCUserInfo alloc]initWithUserId:dataDict[@"uid"] name:dataDict[@"name"] portrait:avatar];
                [self.members addObject:data];
            }
            [self.tableView reloadData];
        }
    } OnError:^(NSString *error) {
        NSLog(@"***%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark RCMAddMemberCellDelegate

-(void)clickSelected:(NSInteger)tag is_seleted:(BOOL)is_selected
{
    RCUserInfo *model = self.members[tag];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除此成员么？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *pramDict = @{@"group_id":self.groupID,@"uids":[NSString dictionaryToJson:@[model.userId]]};
        [[NetworkSingletion sharedManager]deleteGroupMember:pramDict onSucceed:^(NSDictionary *dict) {
            if ([dict[@"code"] integerValue]==0) {
                [self.members removeObject:model];
                [self.tableView reloadData];
            }
        } OnError:^(NSString *error) {
            
        }];

    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark UITableView Delegate & DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.members.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RCMAddMemberTableViewCell";
    RCMAddMemberTableViewCell *cell = (RCMAddMemberTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[RCMAddMemberTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    if (self.members.count > 0) {
        [cell setMemberModel:self.members[indexPath.row]];
        if (self.is_manager) {
            cell.selectBtn.hidden = NO;
            cell.delegate = self;
        }else{
           cell.selectBtn.hidden = YES;
        }
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

#pragma mark get/set

-(NSMutableArray*)members
{
    if (!_members) {
        _members = [NSMutableArray array];
    }
    return _members;
}


#pragma mark warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
