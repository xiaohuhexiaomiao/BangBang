//
//  DiaryDetailViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "DiaryDetailViewController.h"
#import "CXZ.h"

#import "AdressBookViewController.h"

#import "DiaryBottomReplyView.h"
#import "DiaryCommentAndGoodView.h"

#import "DiaryDetailModel.h"
#import "FormData.h"

@interface DiaryDetailViewController ()<UIScrollViewDelegate,BottomReplyViewDelegate>

@property(nonatomic ,strong) UILabel *naviTitleLabel;

@property(nonatomic, strong) UIScrollView *bgScrollView;

@property(nonatomic, strong) UIScrollView *secondScrollView;

@property(nonatomic, strong) UIImageView *headImgview;//头像

@property(nonatomic ,strong) UILabel *nameLabel;//姓名

@property(nonatomic ,strong) UILabel *creatTimeLabel;//发表时间

@property(nonatomic ,strong) UIButton *rangeButton;//抄送范围

@property(nonatomic ,strong) UILabel *titleLabel;//日志标题

@property(nonatomic ,strong) UIView *diaryContentView;//日志内容view

@property(nonatomic ,strong) UILabel *typeLabel;//日志类型

@property(nonatomic ,strong)ShowFilesView *showFielsView;//

@property(nonatomic ,strong) UIView *reviewView;

@property(nonatomic ,strong) RTLabel *reviewContentLabel;

@property(nonatomic ,strong) UILabel *reviewTimeLabel;

@property(nonatomic ,strong) UIButton *commentButton;//回复button

@property(nonatomic ,strong) UIButton *goodButton;//点赞button

@property(nonatomic ,strong) UIView *swipeLine1;

@property(nonatomic ,strong) UIView *swipeLine2;

@property(nonatomic ,strong) DiaryBottomReplyView *bottomView;

@property(nonatomic ,strong) DiaryCommentAndGoodView *commentGoodView;

@property(nonatomic , copy) NSString *company_id;


@end

@implementation DiaryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitle];
    [self removeTapGestureRecognizer];
    //    [self setupNextWithString:@"发送" withColor:[UIColor whiteColor]];
    [self config];
    
    [self loadPublishDeatailData];
    [self.commentGoodView reloadDataWithIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTitle
{
    _naviTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-30, 0, 60, TITLE_BAR_HEIGHT)];
    _naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    _naviTitleLabel.text = @"日计划";
    _naviTitleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = _naviTitleLabel;
}

#pragma mark Private Method

-(void)loadPublishDeatailData
{
    NSDictionary *dict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"publish_id":self.publish_id,
                          };
    [[NetworkSingletion sharedManager]getPlanDetail:dict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"***fsfd*%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            self.bgScrollView.hidden = NO;
            DiaryDetailModel *model = [DiaryDetailModel objectWithKeyValues:dict[@"data"]];
            self.company_id = model.company_id;
             self.commentGoodView.company_id = self.company_id;
            [self setUpContentWithModel:model];
        }
        
    } OnError:^(NSString *error) {
        
    }];
}

//回复列表
-(void)clickCommentButton:(UIButton*)button
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakself.swipeLine1.hidden = NO;
        weakself.swipeLine2.hidden = YES;
    }];
    [self.commentGoodView reloadDataWithIndex:0];
}


//点赞列表
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

- (void)copyContent:(UILongPressGestureRecognizer *)gesture

{
    RTLabel *label = (RTLabel*)gesture.view;
    if (gesture.state ==UIGestureRecognizerStateBegan)
        
    {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        [pasteboard setString:label.text];
        
    }
    
}



#pragma mark 界面

-(void)setUpContentWithModel:(DiaryDetailModel*)detailModel;
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
    
    if ([NSString isBlankString:detailModel.like_id]) {
        [self.bottomView.goodButton setImage:[UIImage imageNamed:@"good"] forState:UIControlStateNormal];
        [self.bottomView.goodButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
        //         [self.bottomView.goodButton setTitle:@"赞" forState:UIControlStateNormal];
    }else{
        [self.bottomView.goodButton setImage:[UIImage imageNamed:@"yizan"] forState:UIControlStateNormal];
        [self.bottomView.goodButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //         [self.bottomView.goodButton setTitle:@"已赞" forState:UIControlStateNormal];
    }
    
    NSString *title = [NSString toDateStringWithTimeInterval:detailModel.form_data.start_time];
    self.typeLabel.hidden = NO;
    if (detailModel.form_data.log_type == 1){
        self.titleLabel.text = [NSString stringWithFormat:@"%@ 日计划，由%@点评",title,detailModel.form_data.reviewer_name];
    }else if (detailModel.form_data.log_type == 2){
        self.typeLabel.text = @"周计划";
        self.naviTitleLabel.text =@"周计划";
        NSString *mandy = [NSString toMondyWithDateString:title];
        NSString *sundy = [NSString toSundyWithDateString:title];
        NSString *weekStr = [NSString stringWithFormat:@"%@~%@",mandy,sundy];
        self.titleLabel.text = [NSString stringWithFormat:@"%@ 周计划，由%@点评",weekStr,detailModel.form_data.reviewer_name];
    }else if (detailModel.form_data.log_type == 3){
//        self.titleLabel.text = [NSString stringWithFormat:@"%@ 日计划，由%@点评",title,detailModel.form_data.reviewer_name];
        self.typeLabel.hidden = YES;
        self.naviTitleLabel.text =@"月计划";
        NSString *monthStr = [title substringWithRange:NSMakeRange(0, 8)];
        self.titleLabel.text = [NSString stringWithFormat:@"%@ 月计划，由%@点评",monthStr,detailModel.form_data.reviewer_name];
    }
    
    
    CGFloat height = 0.0f;
    NSArray *formArray = detailModel.form_data.custom_form_elements;
    UIView *lastView =nil;
    for (int i = 0; i < formArray.count; i++) {
        NSString *typeStr = [formArray[i] objectForKey:@"type"];
        NSString *titleStr =[NSString stringWithFormat:@"%@：",[formArray[i] objectForKey:@"title"]] ;
//        NSString *formID = [formArray[i] objectForKey:@"form_element_id"];
        NSString *result = [formArray[i] objectForKey:@"result"];
        NSString *meta = [formArray[i] objectForKey:@"meta_data"];
        if (![NSString isBlankString:meta]) {
            if ([typeStr isEqualToString:@"input_text"]) {
                CGSize titleSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
                CGFloat lableWidth = titleSize.width > 90.0 ? 90.0 :titleSize.width;
                UILabel *lable = [CustomView customTitleUILableWithContentView:_diaryContentView title:titleStr];
                if (lastView) {
                    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(0);
                        make.top.mas_equalTo(lastView.mas_bottom);
                        make.width.mas_equalTo(lableWidth+2);
                        make.height.mas_equalTo(20);
                    }];
                }else{
                    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(0);
                        make.top.mas_equalTo(0);
                        make.width.mas_equalTo(lableWidth+2);
                        make.height.mas_equalTo(20);
                    }];
                }
                
                if (titleSize.width >90.0) {
                    lable.textAlignment = 2;
                }
                
                RTLabel *contentLabel = [CustomView customRTLableWithContentView:_diaryContentView title:nil];
                contentLabel.frame = CGRectMake(lable.right, lastView.bottom,_diaryContentView.width-lableWidth, 30);
                NSString *content;
                if ([NSString isBlankString:result]) {
                    content = @"";
                }else{
                    content = [NSString stringWithFormat:@"%@",result];
                }
                contentLabel.text = content;
                CGSize optimumSize = [contentLabel optimumSize];
                CGFloat studyHeight = optimumSize.height > 30.0 ?optimumSize.height: 30.0;
                [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lable.mas_right);
                    make.top.mas_equalTo(lable.mas_top);
                    make.right.mas_equalTo(self.diaryContentView.mas_right);
                    make.height.mas_equalTo(studyHeight);
                }];
                height += studyHeight;
                lastView = contentLabel;
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(copyContent:)];
                
                [contentLabel addGestureRecognizer:longPress];
                
            }
        }
    }

    CGFloat contentHeight = height > 75 ? height:75;
    [self.diaryContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeight);
    }];
    
    
    CGFloat fileHeight= 10.0f;
    if (detailModel.form_data.enclosure.count > 0) {
        self.showFielsView.hidden = NO;
        fileHeight = [self.showFielsView setShowFilesViewWithArray:detailModel.form_data.enclosure];
        [self.showFielsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(fileHeight);
        }];
    }
    
    CGFloat reviewHeight = 10.0f;
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    if ([detailModel.form_data.reviewer isEqualToString:uid]) {
        self.bottomView.log_id = detailModel.form_data.log_id;
        self.bottomView.is_review = YES;
    }
    if (detailModel.form_data.reviewer_fraction != 0  ) {
        self.reviewView.hidden = NO;
        self.reviewTimeLabel.text = detailModel.form_data.reciewer_time;
        self.reviewContentLabel.text = [NSString stringWithFormat:@"%@:%li分 %@",detailModel.form_data.reviewer_name,detailModel.form_data.reviewer_fraction,detailModel.form_data.reviewer_content];
        CGSize optimumSize = [self.reviewContentLabel optimumSize];
        CGFloat studyHeight = optimumSize.height;
        [self.reviewContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(studyHeight);
        }];
        [self.reviewView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(studyHeight+30);
        }];
        reviewHeight = studyHeight+30;
    }
    
    _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 116+fileHeight+contentHeight+reviewHeight+SCREEN_HEIGHT-64);
//    NSLog(@"*sd**%f",_bgScrollView.contentSize.height);
//    _bgScrollView.scrollEnabled = YES;
    
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
    
    _typeLabel = [CustomView customTitleUILableWithContentView:_bgScrollView title:@"日志"];
    _typeLabel.textColor = UIColorFromRGB(210, 210, 210);
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_right);
        make.right.mas_equalTo(_bgScrollView.mas_right).mas_offset(-8);
        make.top.mas_equalTo(_nameLabel.mas_top);
        make.height.mas_equalTo(_nameLabel.mas_height);
    }];
    _typeLabel.textAlignment = NSTextAlignmentRight;
    
    _creatTimeLabel = [CustomView customTitleUILableWithContentView:_bgScrollView title:nil];
    _creatTimeLabel.font = [UIFont systemFontOfSize:12];
    _creatTimeLabel.textColor = UIColorFromRGB(210, 210, 210);
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
    
    _diaryContentView = [[UIView alloc]init];
    [_bgScrollView addSubview:_diaryContentView];
    [_diaryContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(75);
    }];
    
    
    _showFielsView = [[ShowFilesView alloc]initWithFrame:CGRectMake(0, _diaryContentView.bottom, SCREEN_WIDTH-16, 10)];
    [_bgScrollView addSubview:_showFielsView];
    _showFielsView.hidden = YES;
    [_showFielsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_diaryContentView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(10);
    }];
    
    //--------点评信息展示-------
    _reviewView = [CustomView customLineView:_bgScrollView];
    _reviewView.hidden = YES;
    _reviewView.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:249/ 255.0 blue:248 / 255.0 alpha:1];
    _reviewView.layer.cornerRadius = 3;
    _reviewView.layer.masksToBounds = YES;
    [_reviewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(_showFielsView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-16);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *titleLabel = [CustomView customTitleUILableWithContentView:_reviewView title:@"以下为点评人的点评："];
    titleLabel.font = [UIFont systemFontOfSize:10];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(15);
    }];
    
    UIButton *reviewButton = [CustomView customButtonWithContentView:_reviewView image:@"cxz_teal_checkmark" title:nil];
    [reviewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    _reviewContentLabel = [CustomView customRTLableWithContentView:_reviewView title:nil];
    _reviewContentLabel.frame = CGRectMake(reviewButton.right, reviewButton.top, SCREEN_WIDTH-32, 20);
    _reviewContentLabel.font = [UIFont systemFontOfSize:12];
    [_reviewContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(reviewButton.mas_right);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-32);
        make.height.mas_equalTo(20);
    }];
    
    _reviewTimeLabel = [CustomView customTitleUILableWithContentView:_reviewView title:nil];
    _reviewTimeLabel.font = [UIFont systemFontOfSize:10];
    [_reviewTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_reviewContentLabel.mas_left);
        make.top.mas_equalTo(_reviewContentLabel.mas_bottom);
        make.width.mas_equalTo(_reviewContentLabel.mas_width);
        make.height.mas_equalTo(15);
    }];
    
    //--------点评信息展示-------
    
    UIView *grayView = [CustomView customLineView:_bgScrollView];
    grayView.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238/ 255.0 blue:238 / 255.0 alpha:1];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(_reviewView.mas_bottom).mas_offset(3);
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
    [_bgScrollView addSubview:_commentGoodView];
    [_commentGoodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(buttonView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_HEIGHT-104-31);
    }];
    
    
    _bottomView = [[DiaryBottomReplyView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-104, SCREEN_WIDTH, 40)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.thirdButton.hidden = YES;
    _bottomView.delegate = self;
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(SCREEN_HEIGHT-104);
        make.height.mas_equalTo(40);
    }];
    
    
    self.commentGoodView.publish_id = self.publish_id;
    
    self.bottomView.publish_id = self.publish_id;
    self.bottomView.company_id = self.company_id;
    
}



@end
