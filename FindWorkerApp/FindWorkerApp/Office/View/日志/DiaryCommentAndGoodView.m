//
//  DiaryCommentAndGood.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "DiaryCommentAndGoodView.h"
#import "CXZ.h"

#import "DiaryCommentCell.h"
#import "DepartmentTableViewCell.h"

#import "DiaryCommentModel.h"

#import "PersonDetailViewController.h"

@interface DiaryCommentAndGoodView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic , strong) UIScrollView *bgScrollView;

@property(nonatomic , strong) UITableView *commentTableView;

@property(nonatomic , strong) UITableView *goodTableView;

@property(nonatomic , strong) NSArray *commentArray;

@property(nonatomic , strong) NSArray *goodArray;

@end

@implementation DiaryCommentAndGoodView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _commentArray = [NSMutableArray array];
        _goodArray = [NSMutableArray array];
        
        _bgScrollView = [[UIScrollView alloc]initWithFrame:frame];
        _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, frame.size.height);
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_bgScrollView];
        
        _commentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height) style:UITableViewStylePlain];
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        _commentTableView.tableFooterView = [UIView new];
        [_bgScrollView addSubview:_commentTableView];
        __weak typeof(self) weakself = self;
        _commentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakself getCommentsData];
        }];
        
        _goodTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, frame.size.height) style:UITableViewStylePlain];
        _goodTableView.delegate = self;
        _goodTableView.dataSource = self;
        _goodTableView.tableFooterView = [UIView new];
        [_bgScrollView addSubview:_goodTableView];
        _goodTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakself getGoodData];
        }];
    }
    return self;
}

-(void)reloadDataWithIndex:(NSInteger)tag
{
    [self.bgScrollView scrollRectToVisible:CGRectMake(tag*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.frame.size.height) animated:YES];
    if (tag == 0) {
        [self getCommentsData];
    }else{
        [self getGoodData];
    }
}

-(void)getCommentsData
{
    NSDictionary *dict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"publish_id":self.publish_id,
                           };
    [[NetworkSingletion sharedManager]getDiaryCommentsList:dict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"***Comments**%@",dict);
        [self.commentTableView.mj_header  endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            self.commentArray = [DiaryCommentModel objectArrayWithKeyValuesArray:dict[@"data"]];
            [self.commentTableView reloadData];
        }
    } OnError:^(NSString *error) {
        [self.commentTableView.mj_header  endRefreshing];
    }];
}

-(void)getGoodData
{
    NSDictionary *dict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"publish_id":self.publish_id,
                           };
    [[NetworkSingletion sharedManager]getDiaryGoodsList:dict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"***Comments**%@",dict);
        [self.goodTableView.mj_header  endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            self.goodArray = [PersonelModel objectArrayWithKeyValuesArray:dict[@"data"]];
            [self.goodTableView reloadData];
        }
        
    } OnError:^(NSString *error) {
        [self.commentTableView.mj_header  endRefreshing];
    }];
}

#pragma mark UITableView Delegate & DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.commentTableView) {
       return  self.commentArray.count;
    }
  
    return self.goodArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.commentTableView) {
        DiaryCommentCell *cell = (DiaryCommentCell*)[tableView dequeueReusableCellWithIdentifier:@"DiaryCommentCell"];
        if (!cell) {
            cell = [[DiaryCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DiaryCommentCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.commentArray.count > 0) {
           [cell setDiaryCommentCellWithModel:self.commentArray[indexPath.row]];
            cell.company_id = self.company_id;
        }

        return cell;
    }
    if (tableView == self.goodTableView) {
        DepartmentTableViewCell *cell = (DepartmentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"GoodCell"];
        if (!cell) {
            cell = [[DepartmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GoodCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.goodArray.count > 0) {
            [cell setNormalDataWith:self.goodArray[indexPath.row]];
        }
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.commentTableView) {
        DiaryCommentCell *cell = (DiaryCommentCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    return 40.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.goodTableView) {
        if (self.goodArray.count > 0) {
            PersonelModel *person = self.goodArray[indexPath.row];
            PersonDetailViewController *personVC = [[PersonDetailViewController alloc]init];
            personVC.look_uid = person.uid;
            personVC.companyID = self.company_id;
            personVC.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:personVC animated:YES];
        }
    }
}

@end
