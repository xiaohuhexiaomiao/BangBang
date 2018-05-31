//
//  SignDetailViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/21.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SignDetailViewController.h"
#import "CXZ.h"

#import "DiaryBottomReplyView.h"
#import "DiaryCommentAndGoodView.h"

#import "SignDetailModel.h"
#import "SignFormModel.h"

@interface SignDetailViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong) UIScrollView *bgScrollView;

@property(nonatomic, strong) UIScrollView *secondScrollView;

@property(nonatomic, strong) UIImageView *headImgview;//头像

@property(nonatomic ,strong) UILabel *nameLabel;//姓名

@property(nonatomic ,strong) UILabel *creatTimeLabel;//发表时间

@property(nonatomic ,strong) UIButton *rangeButton;//抄送范围

@property(nonatomic ,strong) UILabel *titleLabel;//日志标题

@property(nonatomic ,strong) RTLabel *contentLabel;//内容；

@property(nonatomic, strong) UIButton *signButton;

@property(nonatomic ,strong)ShowFilesView *showFielsView;//

@property(nonatomic ,strong) UIButton *commentButton;//回复button

@property(nonatomic ,strong) UIButton *goodButton;//点赞button

@property(nonatomic ,strong) UIView *swipeLine1;

@property(nonatomic ,strong) UIView *swipeLine2;

@property(nonatomic ,strong) DiaryBottomReplyView *bottomView;

@property(nonatomic ,strong) DiaryCommentAndGoodView *commentGoodView;

@property(nonatomic , copy) NSString *company_id;

@end

@implementation SignDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"外勤签到" withColor:[UIColor whiteColor]];
    [self removeTapGestureRecognizer];
    [self config];

    [self loadPublishDeatailData];
    [self.commentGoodView reloadDataWithIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Private Method

-(void)loadPublishDeatailData
{
    NSDictionary *paramdict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"publish_id":self.publish_id,
                           };
    [[NetworkSingletion sharedManager]getPlanDetail:paramdict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"***fsfd*%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            self.bgScrollView.hidden = NO;
            SignDetailModel *model = [SignDetailModel objectWithKeyValues:dict[@"data"]];
            self.company_id = model.company_id;
            self.commentGoodView.company_id = self.company_id;
            [self setUpContentWithModel:model];
        }
    } OnError:^(NSString *error) {
        
    }];
}

//回复
-(void)clickCommentButton:(UIButton*)button
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakself.swipeLine1.hidden = NO;
        weakself.swipeLine2.hidden = YES;
    }];
    [self.commentGoodView reloadDataWithIndex:0];
}


//点赞
-(void)clickGoodButton:(UIButton*)button
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakself.swipeLine1.hidden = YES;
        weakself.swipeLine2.hidden = NO;
    }];
    [self.commentGoodView reloadDataWithIndex:1];
}

-(void)clickSendRangeButton:(UIButton*)button
{
    AdressBookViewController *bookVC = [[AdressBookViewController alloc]init];
    bookVC.loadDataType = 3;
    bookVC.publishID = self.publish_id;
    bookVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bookVC animated:YES];
}

#pragma mark 界面

-(void)setUpContentWithModel:(SignDetailModel*)detailModel
{
    
    [self.headImgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,detailModel.avatar]] placeholderImage:[UIImage imageNamed:@"temp"]];
    self.nameLabel.text = detailModel.name;
    self.creatTimeLabel.text = detailModel.add_time;
    
    NSString *rangStr = @"抄送范围：";
    NSInteger departCount = 0;
    NSInteger personCount = 0;
    NSArray *rangeArray = [NSString arrayWithJsonString:detailModel.form_data.cc];
    for (NSDictionary *dict in rangeArray) {
        if ([dict[@"type"] integerValue]==3) {
            rangStr =[rangStr stringByAppendingString:@"全公司"];
        }
        if ([dict[@"type"] integerValue]==2) {
            departCount++;
        }
        if ([dict[@"type"] integerValue]==1) {
            personCount++;
        }
    }
    if (departCount > 0) {
        rangStr =[rangStr stringByAppendingFormat:@"%li个部门",departCount];
    }
    if (personCount > 0) {
        rangStr = [rangStr stringByAppendingFormat:@"%li个同事",personCount];
    }
    CGSize rangeSize = [rangStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    CGFloat rangeWidth = (rangeSize.width+25) > (SCREEN_WIDTH-16) ? ((SCREEN_WIDTH-16)):(rangeSize.width+25);
    [self.rangeButton setTitle:rangStr forState:UIControlStateNormal];
    [self.rangeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(rangeWidth);
    }];
    
    self.bottomView.company_id = self.company_id;
    self.bottomView.publish_id = self.publish_id;
    if ([NSString isBlankString:detailModel.like_id]) {
        [self.bottomView.goodButton setImage:[UIImage imageNamed:@"good"] forState:UIControlStateNormal];
        [self.bottomView.goodButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
        //         [self.bottomView.goodButton setTitle:@"赞" forState:UIControlStateNormal];
    }else{
        [self.bottomView.goodButton setImage:[UIImage imageNamed:@"yizan"] forState:UIControlStateNormal];
        [self.bottomView.goodButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //         [self.bottomView.goodButton setTitle:@"已赞" forState:UIControlStateNormal];
    }
    
    NSDate *date = [NSDate dateFromString:detailModel.add_time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *signTime = [formatter stringFromDate:date];
    self.titleLabel.text = [NSString stringWithFormat:@"签到时间 %@",signTime];
    
    CGFloat studyHeight = 0.0f;
    if (![NSString isBlankString:detailModel.form_data.remarks]) {
        self.contentLabel.text = detailModel.form_data.remarks;
        CGSize optimumSize = [self.contentLabel optimumSize];
        studyHeight = optimumSize.height > 30.0 ?optimumSize.height: 30.0;
        
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(studyHeight);
        }];
       
    }
    
    [self.signButton setTitle:detailModel.form_data.describe forState:UIControlStateNormal];
    
    CGFloat fileHeight = 10.0f;
    if (detailModel.form_data.enclosure.count > 0) {
        self.showFielsView.hidden = NO;
        fileHeight = [self.showFielsView setShowFilesViewWithArray:detailModel.form_data.enclosure];
        [self.showFielsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(fileHeight);
        }];
    }
    
    _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 170+fileHeight+studyHeight+SCREEN_HEIGHT-64);

}

-(void)config

{
    _bgScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_bgScrollView];
    [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.scrollsToTop = YES;
    _bgScrollView.hidden = YES;
    
    _headImgview = [[UIImageView alloc]init];
    [_bgScrollView addSubview:_headImgview];
    [_headImgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(8);
        make.width.height.mas_equalTo(40);
    }];
    _headImgview.layer.cornerRadius = 20;
    _headImgview.layer.masksToBounds = YES;
    
    
    _nameLabel = [CustomView customContentUILableWithContentView:_bgScrollView title:nil];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImgview.mas_right).mas_offset(5);
        make.top.mas_equalTo(_headImgview.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH-100);
        make.height.mas_equalTo(20);
    }];
    
    
    UILabel *typeLabel = [CustomView customTitleUILableWithContentView:_bgScrollView title:@"外勤签到"];
    typeLabel.textColor = UIColorFromRGB(210, 210, 210);
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCREEN_WIDTH-108);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(_nameLabel.mas_top);
        make.height.mas_equalTo(_nameLabel.mas_height);
    }];
    typeLabel.textAlignment = NSTextAlignmentRight;
    
    _creatTimeLabel = [CustomView customTitleUILableWithContentView:_bgScrollView title:nil];
    _creatTimeLabel.textColor = UIColorFromRGB(210, 210, 210);
    _creatTimeLabel.font = [UIFont systemFontOfSize:12];
    [_creatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.top.mas_equalTo(_nameLabel.mas_bottom).mas_offset(5);
        make.width.mas_equalTo(_nameLabel.mas_width);
        make.height.mas_equalTo(15);
    }];
    
    _rangeButton = [CustomView customButtonWithContentView:_bgScrollView image:@"chaosong" title:nil];
    [_rangeButton setTitleColor:TOP_GREEN forState:UIControlStateNormal];
    _rangeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _rangeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_rangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(_headImgview.mas_bottom).mas_equalTo(10);
        make.height.mas_equalTo(25);
    }];
    [_rangeButton addTarget:self action:@selector(clickSendRangeButton:) forControlEvents:UIControlEventTouchUpInside];
    _rangeButton.layer.cornerRadius = 12.5;
    _rangeButton.layer.borderColor = TOP_GREEN.CGColor;
    _rangeButton.layer.borderWidth =0.8;
    _rangeButton.layer.masksToBounds = YES;
    
    _titleLabel = [CustomView customTitleUILableWithContentView:_bgScrollView title:nil];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textColor = [UIColor grayColor];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_rangeButton.mas_bottom).mas_offset(6);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(25);
    }];
    
    
    _contentLabel = [CustomView customRTLableWithContentView:_bgScrollView title:nil];
    _contentLabel.frame = CGRectMake(8, _titleLabel.bottom, SCREEN_WIDTH-16, 30);
    _contentLabel.font = [UIFont systemFontOfSize:14];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_titleLabel.mas_bottom).mas_offset(5);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(30);
    }];
    
    _signButton = [CustomView customButtonWithContentView:_bgScrollView image:@"blue_position" title:nil];
    _signButton.layer.cornerRadius = 2;
    _signButton.layer.masksToBounds = YES;
    _signButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _signButton.backgroundColor = FONTBACKGROUNDCOLOR;
    [_signButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
    _signButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_contentLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(40);
    }];

    
    _showFielsView = [[ShowFilesView alloc]initWithFrame:CGRectMake(0, _signButton.bottom, SCREEN_WIDTH-16, 10)];
    _showFielsView.hidden = YES;
    [_bgScrollView addSubview:_showFielsView];
    [_showFielsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_signButton.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(10);
    }];
    
    
    UIView *grayView = [CustomView customLineView:_bgScrollView];
    grayView.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238/ 255.0 blue:238 / 255.0 alpha:1];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(_showFielsView.mas_bottom);
        make.height.mas_equalTo(10);
    }];
    
    UIView *buttonView = [CustomView customLineView:_bgScrollView];
    buttonView.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:249/ 255.0 blue:248 / 255.0 alpha:1];
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(grayView.mas_bottom);
        make.height.mas_equalTo(31);
    }];
    
    CGSize commentSize = [@"回复" sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    _commentButton = [CustomView customButtonWithContentView:buttonView image:nil title:@"回复"];
    [_commentButton addTarget:self action:@selector(clickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(commentSize.width+2);
        make.top.mas_equalTo(grayView.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    _swipeLine1 = [CustomView customLineView:buttonView];
    [_swipeLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_commentButton.mas_left);
        make.top.mas_equalTo(_commentButton.mas_bottom);
        make.width.mas_equalTo(_commentButton.mas_width);
        make.height.mas_equalTo(1);
    }];
    _swipeLine1.backgroundColor = GREEN_COLOR;
    
    CGSize goodSize = [@"赞" sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    _goodButton = [CustomView customButtonWithContentView:buttonView image:nil title:@"赞"];
    [_goodButton addTarget:self action:@selector(clickGoodButton:) forControlEvents:UIControlEventTouchUpInside];
    [_goodButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_commentButton.mas_right).mas_offset(30);
        make.width.mas_equalTo(goodSize.width+2);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    _swipeLine2 = [CustomView customLineView:buttonView];
    [_swipeLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_goodButton.mas_left);
        make.top.mas_equalTo(_swipeLine1.mas_top);
        make.width.mas_equalTo(_goodButton.mas_width);
        make.height.mas_equalTo(1);
    }];
    _swipeLine2.hidden = YES;
    _swipeLine2.backgroundColor = GREEN_COLOR;
    
    _commentGoodView = [[DiaryCommentAndGoodView alloc]initWithFrame:CGRectMake(0, buttonView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-104-40)];
    _commentGoodView.publish_id = self.publish_id;
    [_bgScrollView addSubview:_commentGoodView];
    [_commentGoodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(buttonView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_HEIGHT-104-31);
    }];
    
    _bottomView = [[DiaryBottomReplyView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-104, SCREEN_WIDTH, 40)];
    _bottomView.publish_id = self.publish_id;
    _bottomView.thirdButton.hidden = YES;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(SCREEN_HEIGHT-104);
        make.height.mas_equalTo(40);
    }];
    
}



@end
