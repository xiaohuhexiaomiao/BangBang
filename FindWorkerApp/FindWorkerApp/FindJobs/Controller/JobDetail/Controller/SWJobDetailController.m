//
//  SWJobDetailController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/23.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWJobDetailController.h"
#import "CXZ.h"

#import "SWJobDetailCmd.h"
#import "SWJobDetailInfo.h"
#import "SWJobDetailData.h"
#import "SWFindWorkType.h"

#import "SWApplyCmd.h"
#import "SWApplyInfo.h"

#import "SWBrowseCmd.h"
#import "SWBrowseInfo.h"

#import "SWAcceptCmd.h"
#import "SWAcceptInfo.h"

#import "SWContactController.h"

#import "SWPaySuccessCmd.h"
#import "SWPaySuccessInfo.h"

#import "SWComfirmCompletionCmd.h"
#import "SWComfirmCompletionInfo.h"

#define padding 10

@interface SWJobDetailController ()<UITableViewDelegate,UITableViewDataSource,ContactDelegate>

@property (nonatomic, retain) UIScrollView *contentView;

@property (nonatomic, retain) UIView *last_View; //上一个视图

@property (nonatomic, retain) SWJobDetailData *detailData;

@property (nonatomic, retain) UIButton *acceptBtn;

@property (nonatomic, retain) UIButton *rejectBtn;

@property (nonatomic, retain) UIButton *applyBtn;

@property (nonatomic, retain) UIView *shadowView;

@property (nonatomic, retain) UIView *workerContent;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSArray *jobArr;

@property (nonatomic, retain) NSString *aid; //临时保存的申请id

@end

@implementation SWJobDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupBackw];
    
    [self sendBroswerMsg];
    
    [self loadData];
    
}

- (void)setDetailTitle:(NSString *)detailTitle {
    
    _detailTitle = detailTitle;
    
    [self setupTitleWithString:detailTitle withColor:[UIColor whiteColor]];
    
}

/** 加载数据 */
- (void)loadData {
    
    SWJobDetailCmd *detailCmd = [[SWJobDetailCmd alloc] init];
    detailCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    detailCmd.iid = self.iid;
    
    [[HttpNetwork getInstance] requestPOST:detailCmd success:^(BaseRespond *respond) {
        
        SWJobDetailInfo *detailInfo = [[SWJobDetailInfo alloc] initWithDictionary:respond.data];
        
        SWJobDetailData *detailData = detailInfo.data;
        _detailData = detailData;
        _jobArr = _detailData.worker;
        _aid = _detailData.aid;
        
        //初始化界面
        [self initWithView];
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        
        
    }];
    
}

/** 初始化界面 */
- (void)initWithView {
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame         = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    [self.view addSubview:contentView];
    _contentView = contentView;
    
    if(_type == 0) {
        
        CGFloat startBtnH = 39;
        CGFloat startBtnW = SCREEN_WIDTH;
        CGFloat startBtnX = 0;
        CGFloat startBtnY = SCREEN_HEIGHT - 64 - startBtnH;
        
        UIButton *startBtn = [[UIButton alloc] init];
        startBtn.frame     = CGRectMake(startBtnX, startBtnY, startBtnW, startBtnH);
        startBtn.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        if(_detailData.isapply == 1) {
            
            startBtn.selected = YES;
            startBtn.backgroundColor = [UIColor colorWithRed:0.88 green:0.48 blue:0.32 alpha:1.00];
            [startBtn setTitle:@"取消申请" forState:UIControlStateNormal];
            
        }else {
            
            startBtn.selected = NO;
            startBtn.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
            [startBtn setTitle:@"申请用工" forState:UIControlStateNormal];
            
        }
        
        [startBtn addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:startBtn];
        _applyBtn = startBtn;
        
    }else if(self.type == 1){
        
        
        CGFloat accptBtnW = SCREEN_WIDTH / 2;
        CGFloat accptBtnH = 39;
        CGFloat accptBtnX = 0;
        CGFloat accptBtnY = SCREEN_HEIGHT - 64 - accptBtnH;
        
        UIButton *acceptBtn = [[UIButton alloc] init];
        acceptBtn.frame     = CGRectMake(accptBtnX, accptBtnY, accptBtnW, accptBtnH);
        acceptBtn.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
        acceptBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        acceptBtn.selected = NO;
        acceptBtn.backgroundColor = [UIColor colorWithRed:0.47 green:0.75 blue:0.76 alpha:1.00];
        [acceptBtn setTitle:@"接受雇佣" forState:UIControlStateNormal];
        
        [acceptBtn addTarget:self action:@selector(acceptClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:acceptBtn];
        _acceptBtn = acceptBtn;
        
        CGFloat rejectBtnW = accptBtnW;
        CGFloat rejectBtnH = accptBtnH;
        CGFloat rejectBtnX = CGRectGetMaxX(acceptBtn.frame);
        CGFloat rejectBtnY = accptBtnY;
        
        UIButton *rejectBtn = [[UIButton alloc] init];
        rejectBtn.frame     = CGRectMake(rejectBtnX, rejectBtnY, rejectBtnW, rejectBtnH);
        rejectBtn.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
        rejectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        rejectBtn.selected = NO;
        rejectBtn.backgroundColor = [UIColor colorWithRed:0.86 green:0.28 blue:0.00 alpha:1.00];
        [rejectBtn setTitle:@"拒绝雇佣" forState:UIControlStateNormal];
        
        [rejectBtn addTarget:self action:@selector(rejectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rejectBtn];
        _rejectBtn = rejectBtn;
        
        
    }else if(self.type == 2) {
        
        CGFloat startBtnH = 39;
        CGFloat startBtnW = SCREEN_WIDTH;
        CGFloat startBtnX = 0;
        CGFloat startBtnY = SCREEN_HEIGHT - 64 - startBtnH;
        
        UIButton *startBtn = [[UIButton alloc] init];
        startBtn.frame     = CGRectMake(startBtnX, startBtnY, startBtnW, startBtnH);
        startBtn.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        if(_waitingStatus == 1) {
            
            startBtn.selected = YES;
            startBtn.backgroundColor = [UIColor colorWithRed:0.88 green:0.48 blue:0.32 alpha:1.00];
            [startBtn setTitle:@"等待雇主开始施工" forState:UIControlStateNormal];
            
        }else {
            
            startBtn.selected = NO;
            startBtn.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
            [startBtn setTitle:@"确认收款" forState:UIControlStateNormal];
            
        }
        
//        [startBtn addTarget:self action:@selector(collectionClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:startBtn];
        _applyBtn = startBtn;
        
    }else if(self.type == 3) {
    
        CGFloat startBtnH = 39;
        CGFloat startBtnW = SCREEN_WIDTH;
        CGFloat startBtnX = 0;
        CGFloat startBtnY = SCREEN_HEIGHT - 64 - startBtnH;
        
        UIButton *startBtn = [[UIButton alloc] init];
        startBtn.frame     = CGRectMake(startBtnX, startBtnY, startBtnW, startBtnH);
        startBtn.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        if(_ongoingStatus == 3) {
            
            startBtn.selected = YES;
            startBtn.backgroundColor = [UIColor colorWithRed:0.88 green:0.48 blue:0.32 alpha:1.00];
            [startBtn setTitle:@"等待雇主确认" forState:UIControlStateNormal];
            
        }else {
            
            startBtn.selected = NO;
            startBtn.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
            [startBtn setTitle:@"确认完工" forState:UIControlStateNormal];
            
        }
        
        [startBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:startBtn];
        _applyBtn = startBtn;
        
    }else if(self.type == 4) {
    
        
        
    }else if(self.type == 5) {
        
//        CGFloat startBtnH = 39;
//        CGFloat startBtnW = SCREEN_WIDTH;
//        CGFloat startBtnX = 0;
//        CGFloat startBtnY = SCREEN_HEIGHT - 64 - startBtnH;
//        
//        UIButton *startBtn = [[UIButton alloc] init];
//        startBtn.frame     = CGRectMake(startBtnX, startBtnY, startBtnW, startBtnH);
//        startBtn.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
//        startBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        
//        if(_ongoingStatus == 3) {
//            
//            startBtn.selected = YES;
//            startBtn.backgroundColor = [UIColor colorWithRed:0.88 green:0.48 blue:0.32 alpha:1.00];
//            [startBtn setTitle:@"等待雇主确认" forState:UIControlStateNormal];
//            
//        }else {
//            
//            startBtn.selected = NO;
//            startBtn.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
//            [startBtn setTitle:@"接受雇佣" forState:UIControlStateNormal];
//            
//        }
//        
//        [startBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:startBtn];
//        _applyBtn = startBtn;
        
    }
    
    //显示数据
    [self showData];
}


/**
 确认完工

 @param sender button
 */
- (void)finishClick:(UIButton *)sender {

    sender.userInteractionEnabled = NO;
    sender.selected = YES;
    
    SWComfirmCompletionCmd *completionCmd = [[SWComfirmCompletionCmd alloc] init];
    completionCmd.information_id = _iid;
    completionCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    [[HttpNetwork getInstance] requestPOST:completionCmd success:^(BaseRespond *respond) {
        
        SWComfirmCompletionInfo *completionInfo = [[SWComfirmCompletionInfo alloc] initWithDictionary:respond.data];
        
        if(completionInfo.code == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_ONGOINGCELL" object:nil];
            
        }else {
            
            [MBProgressHUD showError:@"确认失败" toView:self.view];
            
            
        }
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        [MBProgressHUD showError:@"确认失败" toView:self.view];
        
    }];
    
}

/**
 确认收款

 @param sender button
 */
- (void)collectionClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    sender.selected = YES;
    
    if(sender.isSelected) {
        
        SWPaySuccessCmd *paySuccess = [[SWPaySuccessCmd alloc] init];
        paySuccess.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        paySuccess.information_id = _iid;
        
        [[HttpNetwork getInstance] requestPOST:paySuccess success:^(BaseRespond *respond) {
            
            SWPaySuccessInfo *paySuccessInfo = [[SWPaySuccessInfo alloc] initWithDictionary:respond.data];
            
            if(paySuccessInfo.code == 0) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_WAITINGCELL" object:nil];
                
            }else {
                
                [MBProgressHUD showError:paySuccessInfo.message toView:self.view];
                
            }
            
        } failed:^(BaseRespond *respond, NSString *error) {
            
        }];
        
    }
    
}


- (void)acceptClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    sender.selected = YES;
    SWAcceptCmd *acceptCmd = [[SWAcceptCmd alloc] init];
    acceptCmd.eid = _eid;
    acceptCmd.invite_status = @"1";
    
    [[HttpNetwork getInstance] requestPOST:acceptCmd success:^(BaseRespond *respond) {
        
        SWAcceptInfo *acceptInfo = [[SWAcceptInfo alloc] initWithDictionary:respond.data];
        
        if(acceptInfo.code == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_REPEAT" object:nil];
            
        }
        
        sender.userInteractionEnabled = YES;
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        sender.userInteractionEnabled = YES;
        
    }];
    
}

- (void)rejectClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    sender.selected = YES;
    
    if(sender.isSelected) {
        
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"是否拒绝用工？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alerVC addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alerVC addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SWAcceptCmd *acceptCmd = [[SWAcceptCmd alloc] init];
            acceptCmd.eid = self.eid;
            acceptCmd.invite_status = @"2";
            
            [[HttpNetwork getInstance] requestPOST:acceptCmd success:^(BaseRespond *respond) {
                
                SWAcceptInfo *acceptInfo = [[SWAcceptInfo alloc] initWithDictionary:respond.data];
                
                if(acceptInfo.code == 0) {
                    
                    [UIView animateWithDuration:1 animations:^{
                        
                        sender.frame = CGRectMake(0, sender.frame.origin.y, SCREEN_WIDTH, sender.frame.size.height);
                        _acceptBtn.frame = CGRectMake(0, _rejectBtn.frame.origin.y, 0, sender.frame.size.height);
                        
                    } completion:^(BOOL finished) {
                        
                        sender.userInteractionEnabled = YES;
                        sender.backgroundColor = [UIColor colorWithRed:0.88 green:0.48 blue:0.32 alpha:1.00];
                        [sender setTitle:@"已拒绝雇佣" forState:UIControlStateNormal];
                        
                    }];
                    
                    [MBProgressHUD showError:@"已拒绝雇佣" toView:self.view];
                    
                }else {
                    
                    sender.userInteractionEnabled = YES;
                    
                }
                
            } failed:^(BaseRespond *respond, NSString *error) {
                
                sender.userInteractionEnabled = YES;
                
            }];
            
            
        }]];
        [self presentViewController:alerVC animated:YES completion:nil];
        
       
        
    }
    
    

    
}

#pragma mark ----------- 申请按钮点击事件 start -----------------
- (void)startClick:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    
    if(sender.isSelected) {
        
        SWApplyCmd *applyCmd = [[SWApplyCmd alloc] init];
        applyCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        applyCmd.iid = self.iid;
        //    applyCmd.wid = workType.wid;
        applyCmd.type = @"1";
        
        [[HttpNetwork getInstance] requestPOST:applyCmd success:^(BaseRespond *respond) {
            
            SWApplyInfo *applyInfo = [[SWApplyInfo alloc] initWithDictionary:respond.data];
            
            if(applyInfo.code == 0) {
                
                [MBProgressHUD showError:@"申请成功,半个小时内可以取消" toView:self.view];
                _aid = applyInfo.data;
                _applyBtn.backgroundColor = [UIColor colorWithRed:0.88 green:0.48 blue:0.32 alpha:1.00];
                [_applyBtn setTitle:@"取消申请" forState:UIControlStateNormal];
                
            }else {
                
                [MBProgressHUD showError:applyInfo.message toView:self.view];
                
            }
            
        } failed:^(BaseRespond *respond, NSString *error) {
            
            [MBProgressHUD showError:@"申请失败" toView:self.view];
            
        }];
        
    }else {
        
        SWApplyCmd *applyCmd = [[SWApplyCmd alloc] init];
        applyCmd.type = @"2";
        applyCmd.aid = _aid;
        
        [[HttpNetwork getInstance] requestPOST:applyCmd success:^(BaseRespond *respond) {
            
            SWApplyInfo *applyInfo = [[SWApplyInfo alloc] initWithDictionary:respond.data];
            
            if(applyInfo.code == 0) {
                
                sender.backgroundColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.76 alpha:1.00];
                [sender setTitle:@"申请用工" forState:UIControlStateNormal];
                
            }else {
                
                [MBProgressHUD showError:applyInfo.message toView:self.view];
                
            }
            
        } failed:^(BaseRespond *respond, NSString *error) {
            
            [MBProgressHUD showError:@"取消申请失败" toView:self.view];
            
        }];
        
        
        
    }
    
}
#pragma mark ----------- 申请按钮点击事件 end -----------------
//显示数据
- (void)showData {
    
    UIView *infoView = [[UIView alloc] init];
    infoView.backgroundColor = [UIColor whiteColor];
    infoView.frame   = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [_contentView addSubview:infoView];
    _last_View = infoView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,_detailData.avatar]] placeholderImage:[UIImage imageNamed:@"temp"]];
    imageView.frame        = CGRectMake(padding, (49 - 30) / 2, 30, 30);
    imageView.layer.cornerRadius = 15;
    imageView.layer.masksToBounds = YES;
    [infoView addSubview:imageView];
    
    NSString *nameStr = _detailData.name;
    CGSize nameSize = [nameStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *nameLbl = [[UILabel alloc] init];
    nameLbl.frame    = CGRectMake(CGRectGetMaxX(imageView.frame) + padding, (49 - nameSize.height) / 2, nameSize.width, nameSize.height);
    nameLbl.font     = [UIFont systemFontOfSize:12];
    nameLbl.text     = nameStr;
    nameLbl.textColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.36 alpha:1.00];
    [infoView addSubview:nameLbl];
    
    UIButton *phoneBtn = [[UIButton alloc] init];
    [phoneBtn setImage:[UIImage imageNamed:@"callHim"] forState:UIControlStateNormal];
    [phoneBtn sizeToFit];
    
    [phoneBtn addTarget:self action:@selector(callHim:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat phoneW = phoneBtn.bounds.size.width;
    CGFloat phoneH = phoneBtn.bounds.size.height;
    CGFloat phoneX = SCREEN_WIDTH - padding - phoneW;
    CGFloat phoneY = (49 - phoneH) / 2;
    phoneBtn.frame = CGRectMake(phoneX, phoneY, phoneW, phoneH);
    [infoView addSubview:phoneBtn];
    
    UIView *line = [[UIView alloc] init];
    line.frame   = CGRectMake(0, 49, SCREEN_WIDTH, 1);
    line.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [infoView addSubview:line];
    
    [self setUpData:@"标题" content:_detailData.title last_view:_last_View];
    
    [self setUpWorkerNumber];
    
    [self setUpData:@"工期" content:[NSString stringWithFormat:@"%@天",_detailData.schedule] last_view:_last_View];
    
    [self setUpData:@"预算" content:[NSString stringWithFormat:@"%@元",_detailData.budget] last_view:_last_View];
    
    [self setUpData:@"开始时间" content:[NSString stringWithFormat:@"%@",_detailData.start_time] last_view:_last_View];
    
    [self setUpLocation];
    
    [self setUpRemark];

    _contentView.contentSize = CGSizeMake(0, CGRectGetMaxY(_last_View.frame) + 39);
    
}

- (void)callHim:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_detailData.phone];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
    sender.userInteractionEnabled = YES;
    
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
//    remarkText.text        = _detailData.;
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

//位置
- (void)setUpLocation {
    
    UIView *locationView = [[UIView alloc] init];
    locationView.backgroundColor = [UIColor whiteColor];
    locationView.frame   = CGRectMake(0, CGRectGetMaxY(_last_View.frame), SCREEN_WIDTH, 50);
    [_contentView addSubview:locationView];
    
    NSString *titleStr = @"位置";
    
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
    [locationView addSubview:titleLbl];
    
    UIButton *locationBtn = [[UIButton alloc] init];
    [locationBtn setImage:[UIImage imageNamed:@"WorkerLocation"] forState:UIControlStateNormal];
    [locationBtn sizeToFit];
    
    CGFloat locationW = locationBtn.bounds.size.width;
    CGFloat locationH = locationBtn.bounds.size.height;
    CGFloat locationX = SCREEN_WIDTH - padding - locationW;
    CGFloat locationY = (49 - locationH) / 2;
    
    locationBtn.frame = CGRectMake(locationX, locationY, locationW, locationH);
    [locationView addSubview:locationBtn];
    
    NSString *contentStr = _detailData.address;
    
    CGSize contentSize = [contentStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    CGFloat contentW = contentSize.width;
    CGFloat contentH = contentSize.height;
    CGFloat contentX = CGRectGetMinX(locationBtn.frame) - padding - contentW;
    CGFloat contentY = titleY;
    
    UILabel *contentLbl = [[UILabel alloc] init];
    contentLbl.frame    = CGRectMake(contentX, contentY, contentW, contentH);
    contentLbl.font     = [UIFont systemFontOfSize:12];
    contentLbl.textColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00];
    contentLbl.text     = contentStr;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(intoGPS)];
    contentLbl.userInteractionEnabled = YES;
    [contentLbl addGestureRecognizer:tap];
    [locationView addSubview:contentLbl];
    
    CGFloat lineX = 0;
    CGFloat lineY = CGRectGetMaxY(contentLbl.frame) + (49 - titleSize.height) / 2;
    CGFloat lineW = SCREEN_WIDTH;
    CGFloat lineH = 1.0f;
    
    UIView *line = [[UIView alloc] init];
    line.frame   = CGRectMake(lineX, lineY, lineW, lineH);
    line.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [locationView addSubview:line];
    _last_View = locationView;
    
}
-(void)intoGPS
{
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([self.detailData.latitude floatValue], [self.detailData.longitude floatValue]);
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
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
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (SWFindWorkType *workType in _detailData.worker) {
        
        NSString *str = [NSString stringWithFormat:@"%@(%@名)",workType.type,workType.num];
        
        [tempArr addObject:str];
        
        
    }
    
    
    NSArray *numArr = tempArr;
    
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

- (void)hideView {
    
    _shadowView.hidden = YES;
    _workerContent.hidden = YES;
    
}

- (void)addWorerContent:(UIView *)parentView {
    
    NSString *workerTitle = @"请选择职位";
    
    CGSize workerSize = [workerTitle sizeWithFont:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH];
    
    UILabel *titleLbl  = [[UILabel alloc] init];
    titleLbl.font      = [UIFont systemFontOfSize:17];
    titleLbl.textColor = RGBA(51, 51, 51, 1.0);
    titleLbl.text      = workerTitle;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.frame     = CGRectMake(padding, padding, parentView.frame.size.width, workerSize.height);
    [parentView addSubview:titleLbl];
    
    UIView *line = [[UIView alloc] init];
    line.frame   = CGRectMake(0, CGRectGetMaxY(titleLbl.frame) + padding, parentView.frame.size.width, 0.5);
    line.backgroundColor = [UIColor colorWithRed:0.54 green:0.54 blue:0.55 alpha:1.00];
    [parentView addSubview:line];
    
    CGFloat workerX = 0;
    CGFloat workerY = CGRectGetMaxY(line.frame);
    CGFloat workerW = parentView.frame.size.width;
    CGFloat workerH = parentView.frame.size.height - workerY;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate     = self;
    tableView.dataSource   = self;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
    tableView.frame        = CGRectMake(workerX, workerY, workerW, workerH);
    tableView.tableFooterView = [UIView new];
    [parentView addSubview:tableView];
    _tableView = tableView;
    
}

- (void)sendBroswerMsg {
    
    BOOL is_login = [[NSUserDefaults standardUserDefaults] boolForKey:@"IS_LOGIN"];
    
    if(is_login) {
        
        SWBrowseCmd *broswerCmd = [[SWBrowseCmd alloc] init];
        broswerCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        broswerCmd.iid = self.iid;
        
        [[HttpNetwork getInstance] requestPOST:broswerCmd success:^(BaseRespond *respond) {
            
            
            
        } failed:^(BaseRespond *respond, NSString *error) {
            
            
            
        }];
        
    }
    
    
}

#pragma mark ---------- tableView delegate & dataSource start --------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _jobArr.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CELL_ID = @"CELL_ID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    
    if(!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
        
    }
    
    [cell.contentView removeAllSubviews];
    
    SWFindWorkType *workType = _jobArr[indexPath.row];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame    = CGRectMake(0, 0, tableView.frame.size.width, 49);
    label.textColor = RGBA(51, 51, 51, 1.0);
    label.text     = workType.type;
    label.font      = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:label];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 49.0f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self hideView];
    
    SWFindWorkType *workType = _jobArr[indexPath.row];
    
    SWApplyCmd *applyCmd = [[SWApplyCmd alloc] init];
    applyCmd.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    applyCmd.iid = self.iid;
//    applyCmd.wid = workType.wid;
    applyCmd.type = @"1";
    
    [[HttpNetwork getInstance] requestPOST:applyCmd success:^(BaseRespond *respond) {
        
        SWApplyInfo *applyInfo = [[SWApplyInfo alloc] initWithDictionary:respond.data];
        
        if(applyInfo.code == 0) {
            
            [MBProgressHUD showError:@"申请成功,半个小时内可以取消" toView:self.view];
            _aid = applyInfo.data;
            _applyBtn.backgroundColor = [UIColor colorWithRed:0.88 green:0.48 blue:0.32 alpha:1.00];
            [_applyBtn setTitle:@"取消申请" forState:UIControlStateNormal];
            
        }else {
            
            [MBProgressHUD showError:applyInfo.message toView:self.view];
            
        }
        
    } failed:^(BaseRespond *respond, NSString *error) {
        
        [MBProgressHUD showError:@"申请失败" toView:self.view];
        
    }];
    
    
}

#pragma mark ---------- tableView delegate & dataSource end --------------

#pragma mark ---------- ContactDelegate start ----------------------------

/** 回调是否同意合同 */
- (void)bactToAgree:(BOOL)isAgree {

    if(isAgree) {
        
        if(self.type == 0) {
        
            if(_shadowView == nil){
                
                _shadowView = [[UIView alloc] init];
                _shadowView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                _shadowView.backgroundColor = [UIColor blackColor];
                _shadowView.alpha = 0.7;
                [[UIApplication sharedApplication].keyWindow addSubview:_shadowView];
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
                [_shadowView addGestureRecognizer:tapGesture];
                
                CGFloat workerX = 40;
                CGFloat workerY = 100;
                CGFloat workerW = SCREEN_WIDTH - workerX * 2;
                CGFloat workerH = SCREEN_HEIGHT - workerY * 2 - 100;
                
                _workerContent = [[UIView alloc] init];
                _workerContent.frame = CGRectMake(workerX, workerY, workerW, workerH);
                _workerContent.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
                _workerContent.layer.cornerRadius = 6;
                _workerContent.layer.masksToBounds = YES;
                [[UIApplication sharedApplication].keyWindow addSubview:_workerContent];
                
                [self addWorerContent:_workerContent];
                
            }else {
                
                _shadowView.hidden = NO;
                _workerContent.hidden = NO;
                
            }
            
            [_tableView reloadData];
            
        }else {
            
            SWAcceptCmd *acceptCmd = [[SWAcceptCmd alloc] init];
            acceptCmd.eid = self.eid;
            acceptCmd.invite_status = @"1";
            
            [[HttpNetwork getInstance] requestPOST:acceptCmd success:^(BaseRespond *respond) {
                
                SWAcceptInfo *acceptInfo = [[SWAcceptInfo alloc] initWithDictionary:respond.data];
                
                if(acceptInfo.code == 0) {
                    
                    [UIView animateWithDuration:1 animations:^{
                        
                        _acceptBtn.frame = CGRectMake(_acceptBtn.frame.origin.x, _acceptBtn.frame.origin.y, SCREEN_WIDTH, _acceptBtn.frame.size.height);
                        _rejectBtn.frame = CGRectMake(CGRectGetMaxX(_acceptBtn.frame), _rejectBtn.frame.origin.y, 0, _acceptBtn.frame.size.height);
                        
                    } completion:^(BOOL finished) {
                        
                        //                    sender.userInteractionEnabled = YES;
                        _acceptBtn.backgroundColor = [UIColor colorWithRed:0.88 green:0.48 blue:0.32 alpha:1.00];
                        [_acceptBtn setTitle:@"已接受雇佣" forState:UIControlStateNormal];
                        
                    }];
                    
                    [MBProgressHUD showError:@"接受成功" toView:self.view];
                    
                }else {
                    
                    _acceptBtn.userInteractionEnabled = YES;
                    
                }
                
            } failed:^(BaseRespond *respond, NSString *error) {
                
                _acceptBtn.userInteractionEnabled = YES;
                
            }];

            
        }
        
    }
    
}

#pragma mark ---------- ContactDelegate end ----------------------------

@end
