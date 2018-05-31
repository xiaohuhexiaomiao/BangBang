//
//  RCMGroupListViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/5/10.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "RCMGroupListViewController.h"
#import "CXZ.h"
#import "RCMGroupTableViewCell.h"

#import "RCMCreatGroupViewController.h"
#import "RCMChatViewController.h"

@interface RCMGroupListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *groupTableView;

@property(nonatomic, strong) NSMutableArray *groups;

@end

@implementation RCMGroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupNextWithImage:[UIImage imageNamed:@"creat"]];
    [self setupTitleWithString:@"群组" withColor:[UIColor whiteColor]];
    
    
    _groupTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _groupTableView.delegate =  self;
    _groupTableView.dataSource = self;
    [self.view addSubview:_groupTableView];
    _groupTableView.tableFooterView = [UIView new];

    
    _groups = [NSMutableArray arrayWithArray:[[RCDataBaseManager shareInstance] getAllGroup]];
    if ([_groups count] > 0) {
        [self.groupTableView reloadData];
    }
    [self refreshGroup];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshGroup) name:@"REFRESH_GROUP_NEW_INFO" object:nil];

}

-(void)refreshGroup
{
    [[NetworkSingletion sharedManager]getMyGroupsWithDictionary:nil onSucceed:^(NSDictionary *dict) {
        NSLog(@"***%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            NSArray *allGroups = dict[@"data"];
            if (allGroups.count > 0) {
                [self.groups removeAllObjects];
                NSMutableArray *groups = [NSMutableArray new];
                [[RCDataBaseManager shareInstance] clearGroupfromDB];
                for (NSDictionary *groupInfo in allGroups) {
                    RCDGroupInfo *group = [[RCDGroupInfo alloc] init];
                    group.groupId = [groupInfo objectForKey:@"chat_id"];
                    group.groupName = [groupInfo objectForKey:@"name"];
                    group.portraitUri = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,[groupInfo objectForKey:@"avatar"]];
                    if (!group.introduce) {
                        group.introduce = @"";
                    }
                    [self.groups addObject:group];
                }
                [[RCDataBaseManager shareInstance] insertGroupsToDB:groups
                                                           complete:^(BOOL result) {
                                                               
                                                           }];
                [self.groupTableView reloadData];
            }
        }
    } OnError:^(NSString *error) {
        
    }];
}

#pragma mark 继承方法
//创建群
-(void)onNext
{
    RCMCreatGroupViewController *creatGroupVC = [[RCMCreatGroupViewController alloc]init];
    creatGroupVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:creatGroupVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark UITableView Delegate & DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RCMGroupTableViewCell";
    RCMGroupTableViewCell *cell = (RCMGroupTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[RCMGroupTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.groups.count > 0) {
        [cell setModel:self.groups[indexPath.row]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.groups.count > 0) {
        RCDGroupInfo *group = self.groups[indexPath.row];
        RCMChatViewController *chatVC = [[RCMChatViewController alloc] init];
        //    chatVC.needPopToRootView = YES;
        chatVC.targetId = group.groupId;
        chatVC.conversationType = ConversationType_GROUP;
//        NSLog(@"***%@",group.groupId);
        chatVC.groupName = group.groupName;
        [self.navigationController pushViewController:chatVC animated:YES];
            
       
    }
    
}

#pragma mark warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
