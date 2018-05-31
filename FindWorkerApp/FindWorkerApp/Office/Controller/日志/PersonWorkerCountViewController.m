//
//  PersonWorkerCountViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/24.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "PersonWorkerCountViewController.h"
#import "CXZ.h"

#import "GFCalendar.h"

#import "DiaryListCell.h"
#import "DiaryModel.h"

#import "DiaryDetailViewController.h"
#import "WorkSignViewController.h"
#import "SignDetailViewController.h"
#import "PersonWorkerCountViewController.h"


@interface PersonWorkerCountViewController ()<UITableViewDelegate , UITableViewDataSource>

@property(nonatomic ,strong) UITableView *tableView;

@property(nonatomic ,strong)GFCalendarView *fccalendar;

@property(nonatomic ,strong) NSMutableArray *dataArray;

@end

@implementation PersonWorkerCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
     [self setupTitleWithString:@"日志统计" withColor:[UIColor whiteColor]];
    [self removeTapGestureRecognizer];
    [self config];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMM"];
    NSString *normalDayStr = [formatter stringFromDate:[NSDate date]];
    [self loadDiaryPlaneCountWithStr:normalDayStr];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Method

-(void)config
{
    _fccalendar = [[GFCalendarView  alloc] initWithFrameOrigin:CGPointMake(0, 0) width:SCREEN_WIDTH];
    //    calendar.calendarBasicColor = [UIColor cyanColor]; // 更改颜色
    __weak typeof(self) weakself = self;
    _fccalendar.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day) {
     
        
        NSString *dayStr = [NSString stringWithFormat:@"%ld", year];
        if (month < 10) {
            dayStr = [dayStr stringByAppendingFormat:@"0%ld",month];
        }else{
            dayStr = [dayStr stringByAppendingFormat:@"%ld",month];
        }
        if (day < 10) {
            dayStr = [dayStr stringByAppendingFormat:@"0%ld",day];
        }else{
            dayStr = [dayStr stringByAppendingFormat:@"%ld",day];
        }
//        NSLog(@"dayStr%@",dayStr);
         [weakself loadDayDiaryPlane:dayStr];
    };
    _fccalendar.didCurrentMounthHandler = ^(NSInteger year, NSInteger month) {
        NSString *dayStr = [NSString stringWithFormat:@"%ld", year];
        if (month < 10) {
            dayStr = [dayStr stringByAppendingFormat:@"0%ld",month];
        }else{
            dayStr = [dayStr stringByAppendingFormat:@"%ld",month];
        }
        
//         NSLog(@"dayStrwewewew%@",dayStr);
        [weakself loadDiaryPlaneCountWithStr:dayStr];
    };
    [self.view addSubview:_fccalendar];
    
   
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _fccalendar.calendarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-_fccalendar.calendarHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSString *dayStr = [formatter stringFromDate:[NSDate date]];
        [weakself loadDayDiaryPlane:dayStr];
    }];
    [_tableView.mj_header beginRefreshing];
}

-(void)loadDiaryPlaneCountWithStr:(NSString*)string
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
//                                @"company_id":self.companyID,
                                @"look_uid":self.look_uid,
                                @"month":string};
    [[NetworkSingletion sharedManager]personWorkerPlanCount:paramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"plane %@",dict);
        if ([dict[@"code"] integerValue]==0) {
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSDictionary *dataDict in dict[@"data"]) {
                NSString *timeStr = [dataDict objectForKey:@"add_time"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *date = [formatter dateFromString:timeStr];
                
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSInteger year = [calendar component:NSCalendarUnitYear fromDate:date];
                NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:date];
                NSInteger day = [calendar component:NSCalendarUnitDay fromDate:date];
                
                NSString *dayStr = [NSString stringWithFormat:@"%li年%li月%li日",year,month,day];
                
                [dataArray addObject:dayStr];
                
            }
            [self.fccalendar reloadSignDay:dataArray];
        }
        
    } OnError:^(NSString *error) {
    }];

}

-(void)loadDayDiaryPlane:(NSString*)string
{
    [self.dataArray removeAllObjects];
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
//                                @"company_id":self.companyID,
                                @"look_uid":self.look_uid,
                                @"day":string};
    [[NetworkSingletion sharedManager]lookPersonDiaryOfOneDay:paramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"plane2 %@",dict);
                [self.tableView.mj_header endRefreshing];
                if ([dict[@"code"] integerValue]==0) {
                    NSArray *diaryArray = [DiaryModel objectArrayWithKeyValuesArray:dict[@"data"]];
                    NSArray *resultArray = [diaryArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        DiaryModel *model1 = (DiaryModel*)obj1;
                        DiaryModel *model2 = (DiaryModel*)obj2;
                        NSComparisonResult result = [model1.add_time compare:model2.add_time];
                        return result == NSOrderedAscending;  // 降序
                    }];
                    [self.dataArray addObjectsFromArray:resultArray];
                    
                }
        [self.tableView reloadData];
    } OnError:^(NSString *error) {
                [self.tableView.mj_header endRefreshing];
    }];

}
#pragma mark UITableView Delegate  DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiaryListCell *cell = (DiaryListCell *)[tableView dequeueReusableCellWithIdentifier:@"DiaryListCell"];
    if (!cell) {
        cell = [[DiaryListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DiaryListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count > 0) {
        [cell setDiaryListCellWithModel:self.dataArray[indexPath.section]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiaryListCell* cell = (DiaryListCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        DiaryModel *model = self.dataArray[indexPath.section];
        if (model.form_type == 1) {
            DiaryDetailViewController *detailVC = [[DiaryDetailViewController alloc]init];
//            detailVC.company_id = model.company_id;
            detailVC.publish_id = model.publish_id;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if(model.form_type == 2){
            SignDetailViewController *detailVC = [[SignDetailViewController alloc]init];
//            detailVC.company_id = model.company_id;
            detailVC.publish_id = model.publish_id;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
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
#pragma mark get/set

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
