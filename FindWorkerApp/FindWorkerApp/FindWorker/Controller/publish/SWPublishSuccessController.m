//
//  SWPublishSuccessController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWPublishSuccessController.h"
#import "SWNearbyWorkerController.h"
#import "CXZ.h"

#import "SWPublishWorkInfo.h"
#import "SWWorkerTypeData.h"

#import "SWWantWorker.h"


#define padding 10

@interface SWPublishSuccessController ()

@property (nonatomic, retain) UIScrollView *contentView;

@property (nonatomic, retain) UIView *last_View; //上一个视图



@end

@implementation SWPublishSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupBackw];
    
    [self setupTitleWithString:@"我发布的用工详情" withColor:[UIColor whiteColor]];
    
//    [self initWithView];

}

- (void)setPublishWorkCmd:(SWPublishWorkCmd *)publishWorkCmd {
    
    _publishWorkCmd = publishWorkCmd;
    
    [self initWithView];
    
}

//初始化界面
- (void)initWithView {
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame         = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    [self.view addSubview:contentView];
    _contentView = contentView;
    
    [self setUpData:@"标题" content:_publishWorkCmd.title last_view:_last_View];
    
    [self setUpWorkerNumber];
    
    NSInteger day = [self calculateDay];
    
    if(day == 0) {
        
        day = 1;
        
    }
    
    _publishWorkCmd.schedule = [NSString stringWithFormat:@"%ld",day];
    
    [self setUpData:@"工期" content:[NSString stringWithFormat:@"%ld天",day] last_view:_last_View];
    
    BOOL isFace = [_publishWorkCmd.isface boolValue];
    
    if(isFace) {
        
       [self setUpData:@"预算" content:@"面议" last_view:_last_View];
        
    }else {
    
        [self setUpData:@"预算" content:[NSString stringWithFormat:@"%@元",_publishWorkCmd.budget] last_view:_last_View];
        
    }
    
    
    [self setUpData:@"开始时间" content:_publishWorkCmd.start_time last_view:_last_View];
    
    [self setUpData:@"位置" content:_publishWorkCmd.address last_view:_last_View];
    
    [self setUpData:@"有效期" content:@"3天" last_view:_last_View];
    
    [self setUpRemark];
    
    _contentView.contentSize = CGSizeMake(0, CGRectGetMaxY(_last_View.frame) + 39);
    
    CGFloat startBtnH = 39;
    CGFloat startBtnW = SCREEN_WIDTH;
    CGFloat startBtnX = 0;
    CGFloat startBtnY = SCREEN_HEIGHT - 64 - startBtnH;
    
    UIButton *startBtn = [[UIButton alloc] init];
    startBtn.frame     = CGRectMake(startBtnX, startBtnY, startBtnW, startBtnH);
    startBtn.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [startBtn setTitle:@"去找工人" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
}

//计算两个日期相差
- (NSInteger)calculateDay {
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd";
    
    // 截止时间字符串格式
    NSString *expireDateStr = _publishWorkCmd.end_time;
    // 当前时间字符串格式
    NSString *nowDateStr = _publishWorkCmd.start_time;
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    // 当前时间data格式
    NSDate *nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    
    return dateCom.day;
    
}

- (void)startClick:(UIButton *)sender {
    NSLog(@"***%@",_publishWorkCmd);
    [[HttpNetwork getInstance] requestPOST:_publishWorkCmd success:^(BaseRespond *respond) {
        
        SWPublishWorkInfo *workerInfo = [[SWPublishWorkInfo alloc] initWithDictionary:respond.data];
        
        if(workerInfo.code == 0) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }else {
            
            [MBProgressHUD showError:workerInfo.message toView:self.view];
            
        }
        
        
    } failed:^(BaseRespond *respond, NSString *error) {
    
        [MBProgressHUD showError:@"发布失败" toView:self.view];
        
    }];
    
}

//显示普通标签的view（标签，工期，预算，开始时间）
- (void)setUpData:(NSString *)title content:(NSString *)content last_view:(UIView *)lastView {
    
    
    UIView *base_content = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame), SCREEN_WIDTH, 50)];
    base_content.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:base_content];
    
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    CGFloat titleX = padding;
    CGFloat titleY = (49 - titleSize.height) / 2;
    CGFloat titleW = titleSize.width;
    CGFloat titleH = titleSize.height;
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.frame    = CGRectMake(titleX, titleY, titleW, titleH);
    titleLbl.font     = [UIFont systemFontOfSize:12];
    titleLbl.textColor = [UIColor colorWithRed:0.41 green:0.42 blue:0.42 alpha:1.00];
    titleLbl.text     = title;
    [base_content addSubview:titleLbl];
    
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    CGFloat contentW = contentSize.width;
    CGFloat contentH = contentSize.height;
    CGFloat contentX = SCREEN_WIDTH - padding - contentW;
    CGFloat contentY = titleY;
    
    UILabel *contentLbl = [[UILabel alloc] init];
    contentLbl.frame    = CGRectMake(contentX, contentY, contentW, contentH);
    contentLbl.font     = [UIFont systemFontOfSize:12];
    contentLbl.textColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00];
    contentLbl.text     = content;
    [base_content addSubview:contentLbl];
    
    CGFloat lineX = 0;
    CGFloat lineY = CGRectGetMaxY(contentLbl.frame) + (49 - titleSize.height) / 2;
    CGFloat lineW = SCREEN_WIDTH;
    CGFloat lineH = 1.0f;
    
    UIView *line = [[UIView alloc] init];
    line.frame   = CGRectMake(lineX, lineY, lineW, lineH);
    line.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [base_content addSubview:line];
    _last_View = base_content;
    
}

//员工数量
- (void)setUpWorkerNumber {
    
    UIView *workerNumber_view = [[UIView alloc] init];
    workerNumber_view.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:workerNumber_view];
    
    NSString *titleStr = @"数量";
    
    CGSize titleSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    CGFloat titleX = padding;
    CGFloat titleY = (49 - titleSize.height) / 2;
    CGFloat titleW = titleSize.width;
    CGFloat titleH = titleSize.height;
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.frame    = CGRectMake(titleX, titleY, titleW, titleH);
    titleLbl.font     = [UIFont systemFontOfSize:12];
    titleLbl.textColor = [UIColor colorWithRed:0.41 green:0.42 blue:0.42 alpha:1.00];
    titleLbl.text     = titleStr;
    [workerNumber_view addSubview:titleLbl];
    
    NSString *typeIdArrStr = _publishWorkCmd.typeId;
    NSString *numArrStr = _publishWorkCmd.typenum;
    
    NSArray *num = [numArrStr componentsSeparatedByString:@","];
    NSMutableArray *numArrs = [NSMutableArray arrayWithArray:num];
    [numArrs removeObjectAtIndex:num.count - 1];
    NSArray *arr = [typeIdArrStr componentsSeparatedByString:@","];
    NSMutableArray *typeArr = [NSMutableArray arrayWithArray:arr];
    [typeArr removeObjectAtIndex:arr.count - 1];

    int i = 0;
    
    NSMutableArray *numArr = [NSMutableArray array];
    
    for (NSString *wantWorker in typeArr) {
        
        NSString *name = @"";
        
        for (SWWorkerTypeData *typeData in _workArr) {
            
            if([typeData.wid integerValue] == [wantWorker integerValue]) {
                
                name = typeData.type_name;
                break;
                
            }
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@(%@名)",name,numArrs[i]];
        [numArr addObject:str];
        i++;
    }
    
//    NSArray *numArr = @[@"水电工(1名)",@"油漆工(1名)"];
    
    CGFloat numY = titleY;
    
    
    CGFloat maxH = 0;
    
    for (NSString *numStr in numArr) {
        
        CGSize numSize = [numStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        
        CGFloat numX = SCREEN_WIDTH - padding - numSize.width;
        CGFloat numW = numSize.width;
        CGFloat numH = numSize.height;
        
        UILabel *numLbl = [[UILabel alloc] init];
        numLbl.frame    = CGRectMake(numX, numY, numW, numH);
        numLbl.font     = [UIFont systemFontOfSize:12];
        numLbl.textColor = [UIColor blackColor];
        numLbl.text     = numStr;
        [workerNumber_view addSubview:numLbl];
        
        numY = CGRectGetMaxY(numLbl.frame) + padding;
        
        maxH = CGRectGetMaxY(numLbl.frame);
        
    }
    
    CGFloat lineX = 0;
    CGFloat lineY = maxH + titleY;
    CGFloat lineW = SCREEN_WIDTH;
    CGFloat lineH = 1.0f;
    
    UIView *line = [[UIView alloc] init];
    line.frame   = CGRectMake(lineX, lineY, lineW, lineH);
    line.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [workerNumber_view addSubview:line];
    
    CGFloat viewH = CGRectGetMaxY(line.frame);
    
    workerNumber_view.frame = CGRectMake(0, CGRectGetMaxY(_last_View.frame), SCREEN_WIDTH, viewH);
    _last_View = workerNumber_view;
    
}

//备注
- (void)setUpRemark {
    
    UIView *remarkView = [[UIView alloc] init];
    remarkView.backgroundColor = [UIColor whiteColor];
    remarkView.frame   = CGRectMake(0, CGRectGetMaxY(_last_View.frame), SCREEN_WIDTH, 49);
    [_contentView addSubview:remarkView];
    
    NSString *titleStr = @"备注";
    
    CGSize titleSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    CGFloat titleX = padding;
    CGFloat titleY = (49 - titleSize.height) / 2;
    CGFloat titleW = titleSize.width;
    CGFloat titleH = titleSize.height;
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.frame    = CGRectMake(titleX, titleY, titleW, titleH);
    titleLbl.font     = [UIFont systemFontOfSize:12];
    titleLbl.textColor = [UIColor colorWithRed:0.41 green:0.42 blue:0.42 alpha:1.00];
    titleLbl.text     = titleStr;
    [remarkView addSubview:titleLbl];
    
    CGFloat textViewX = padding;
    CGFloat textViewY = CGRectGetMaxY(titleLbl.frame) + padding;
    CGFloat textViewW = SCREEN_WIDTH - 2 * padding;
    CGFloat textViewH = textViewW / 4;
    
    UITextView *remarkText = [[UITextView alloc] init];
    remarkText.frame       = CGRectMake(textViewX, textViewY, textViewW, textViewH);
    remarkText.text        = _publishWorkCmd.remark;
    remarkText.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    remarkText.font = [UIFont systemFontOfSize:12];
    remarkText.editable = NO;
    remarkText.layer.cornerRadius = 5;
    remarkText.layer.masksToBounds = YES;
    [remarkView addSubview:remarkText];
    
    CGFloat lineX = 0;
    CGFloat lineY = CGRectGetMaxY(remarkText.frame) + (49 - titleSize.height) / 2;
    CGFloat lineW = SCREEN_WIDTH;
    CGFloat lineH = 1.0f;
    
    UIView *line = [[UIView alloc] init];
    line.frame   = CGRectMake(lineX, lineY, lineW, lineH);
    line.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [remarkView addSubview:line];
    
    remarkView.frame = CGRectMake(0, CGRectGetMaxY(_last_View.frame), SCREEN_WIDTH, CGRectGetMaxY(line.frame));
    
    _last_View = remarkView;
    
}





@end
