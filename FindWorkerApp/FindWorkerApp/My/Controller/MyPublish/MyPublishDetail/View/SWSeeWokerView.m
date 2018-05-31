//
//  SWSeeWokerView.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/23.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWSeeWokerView.h"
#import "CXZ.h"

#define padding 10

#define cellHeight 55.0f

@interface SWSeeWokerView ()

@property (nonatomic, retain) UIImageView *icon;

@property (nonatomic, retain) UILabel *name; //姓名

@property (nonatomic, retain) UILabel *moneyLbl; //付款金额

@property (nonatomic, retain) UIButton *hireBtn; // 雇佣按钮

@property (nonatomic, retain) UIButton *cancelhireBtn; // 取消雇佣按钮

@property (nonatomic, retain) UIButton *remarkBtn; //评论按钮

@property (nonatomic, retain) UILabel *job; //工作

@property (nonatomic, retain) NSMutableArray *viewArr;

@property (nonatomic, strong) UIButton *collectonBtn;

@end

@implementation SWSeeWokerView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        _viewArr = [NSMutableArray array];
        [self initView];
        
    }
    
    return self;
    
}

//初始化视图
- (void)initView {
    
    _icon = [[UIImageView alloc] init];
    _icon.frame = CGRectMake(5, 12.5, 30, 30);
    _icon.layer.masksToBounds = YES;
    _icon.layer.cornerRadius = _icon.frame.size.height / 2;
    [self addSubview:_icon];
    
    _name = [[UILabel alloc] init];
    _name.frame = CGRectMake(_icon.right + 5, _icon.frame.origin.y, 10, 10);
    _name.font = [UIFont systemFontOfSize:12];
    _name.textColor = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00];
    [self addSubview:_name];
    
    _collectonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectonBtn.frame = CGRectMake(120, _name.top-5, 20, 20);
    _collectonBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 5);
   
    [_collectonBtn setImage:[UIImage imageNamed:@"favorite_unclick"] forState:UIControlStateNormal];
    [_collectonBtn addTarget:self action:@selector(clickCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
//    _collectonBtn.backgroundColor = [UIColor redColor];
    [self addSubview:_collectonBtn];
    
    _moneyLbl = [[UILabel alloc] init];
//    _moneyLbl.frame = CGRectMake(CGRectGetMaxX(_icon.frame) + 5, _icon.frame.origin.y, 10, 10);
    _moneyLbl.font = [UIFont systemFontOfSize:12];
    _moneyLbl.textColor = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00];
    [self addSubview:_moneyLbl];
    
    _remarkBtn = [[UIButton alloc] init];
    _remarkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_remarkBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
//    [self addSubview:_remarkBtn];
    
}

-(void)clickCollectionBtn:(UIButton*)sender
{
//    NSLog(@"***%@",self.data);
    //0 取消收藏 1收藏
    UIImage *tempImage = [UIImage imageNamed:@"favorite_click"];
    NSData *tempData = UIImagePNGRepresentation(tempImage);
    UIImage *btnImage = [sender imageForState:UIControlStateNormal];
    NSData *data = UIImagePNGRepresentation(btnImage);
    if ([data isEqualToData:tempData]) {
//        NSLog(@"qu xiao shou cang");
        [self colletedWorkersWithStatus:0];
        
    }else{
        [self colletedWorkersWithStatus:1];
        
    }
}

-(void)colletedWorkersWithStatus:(NSInteger)status
{
//    NSLog(@"***%@",self.data.collect);
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSDictionary *paramDict = @{@"uid":uid,
                                @"worker_id":self.data.uid,
                                @"status":@(status)};
    [[NetworkSingletion sharedManager]colletedWorker:paramDict onSucceed:^(NSDictionary *dict) {
        NSLog(@"***%@",dict);
        if ([dict[@"code"] integerValue] == 0) {
            if (status == 0) {
                [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_unclick"] forState:UIControlStateNormal];
                [WFHudView showMsg:@"取消收藏成功" inView:self];
            }else{
                [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_click"] forState:UIControlStateNormal];
                [WFHudView showMsg:@"收藏成功" inView:self];
            }
        }else{
//             [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_click"] forState:UIControlStateNormal];
            [WFHudView showMsg:dict[@"message"] inView:self];
        }
    } OnError:^(NSString *error) {
        [WFHudView showMsg:error inView:self];
    }];
}

/**
 展示正在工作的工人信息

 @param imageName 头像
 @param name 姓名
 @param jobs 工种
 @param status 标志
 */
- (void)showOngoingWorkerData:(NSString *)imageName name:(NSString *)name jobs:(NSArray *)jobs status:(NSInteger)status {

    if (self.data.collect == 0) {
        [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_unclick"] forState:UIControlStateNormal];
    }else{
        [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_click"] forState:UIControlStateNormal];
    }
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,imageName]] placeholderImage:[UIImage imageNamed:@"temp"]];
    
    _name.text = name;
    [_name sizeToFit];
    
    [self removeAllView:self.viewArr];
    
    CGFloat x = CGRectGetMaxX(_icon.frame) + 5;
    CGFloat y = CGRectGetMaxY(_name.frame) + 5;
    
    for (NSString *jobName in jobs) {
        
        CGSize nameSize = [jobName sizeWithFont:[UIFont systemFontOfSize:10] width:SCREEN_WIDTH];
        
        UILabel *jobLbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, nameSize.width + 10, nameSize.height + 5)];
        jobLbl.textColor = [UIColor colorWithRed:0.52 green:0.53 blue:0.53 alpha:1.00];
        jobLbl.font      = [UIFont systemFontOfSize:10];
        jobLbl.text      = jobName;
        jobLbl.textAlignment = NSTextAlignmentCenter;
        jobLbl.layer.cornerRadius = nameSize.height / 2;
        jobLbl.layer.masksToBounds = YES;
        jobLbl.layer.borderWidth = 0.5;
        jobLbl.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00].CGColor;
        [self addSubview:jobLbl];
        [self.viewArr addObject:jobLbl];
        
        x = CGRectGetMaxX(jobLbl.frame) + 5;
        
    }
    
    NSString *stateStr = @"等待工人确认完工";
    UIColor *stateColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.69 alpha:1.00];
    
    if(status == 9) {
        
        stateStr = @"工人确认完工";
        
    }
    
    CGSize stateSize = [stateStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    UILabel *stateLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - padding - stateSize.width, (cellHeight - stateSize.height) / 2, stateSize.width, stateSize.height)];
    stateLbl.text = stateStr;
    stateLbl.font = [UIFont systemFontOfSize:12];
    stateLbl.textColor = stateColor;
    [self addSubview:stateLbl];
    [self.viewArr addObject:stateLbl];
    
}

/**
 展示数据

 @param imageName 照片名
 @param name 名称
 @param jobs 职业
 @param status 状态值 0 等待客户发送合同 1 客户已经发送合同 2 签订合同
 */
-(void)showUnWorkerData:(NSString *)imageName name:(NSString *)name jobs:(NSArray *)jobs status:(NSInteger)status{
//    NSLog(@"**zhjuangt*%@，%@",imageName,name);
    
    if (self.data.collect == 0) {
        [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_unclick"] forState:UIControlStateNormal];
    }else{
        [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_click"] forState:UIControlStateNormal];
    }
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,imageName]] placeholderImage:[UIImage imageNamed:@"temp"]];
    
    _name.text = name;
    [_name sizeToFit];
    
    [self removeAllView:self.viewArr];
    
    CGFloat x = CGRectGetMaxX(_icon.frame) + 5;
    CGFloat y = CGRectGetMaxY(_name.frame) + 5;
    
    for (NSString *jobName in jobs) {
        
        CGSize nameSize = [jobName sizeWithFont:[UIFont systemFontOfSize:10] width:SCREEN_WIDTH];
        
        UILabel *jobLbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, nameSize.width + 10, nameSize.height + 5)];
        jobLbl.textColor = [UIColor colorWithRed:0.52 green:0.53 blue:0.53 alpha:1.00];
        jobLbl.font      = [UIFont systemFontOfSize:10];
        jobLbl.text      = jobName;
        jobLbl.textAlignment = NSTextAlignmentCenter;
        jobLbl.layer.cornerRadius = nameSize.height / 2;
        jobLbl.layer.masksToBounds = YES;
        jobLbl.layer.borderWidth = 0.5;
        jobLbl.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00].CGColor;
        [self addSubview:jobLbl];
        [self.viewArr addObject:jobLbl];
        
        x = CGRectGetMaxX(jobLbl.frame) + 5;
        
    }
    if (self.type == 0) {
        
        _hireBtn = [[UIButton alloc] init];
        [_hireBtn setTitle:@"发送合同" forState:UIControlStateNormal];
        _hireBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_hireBtn setTitleColor:[UIColor colorWithRed:0.49 green:0.76 blue:0.75 alpha:1.00] forState:UIControlStateNormal];
        [_hireBtn sizeToFit];
        [_hireBtn addTarget:self action:@selector(hireClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat btnW = _hireBtn.bounds.size.width;
        CGFloat btnH = _hireBtn.bounds.size.height;
        _hireBtn.frame = CGRectMake(SCREEN_WIDTH - padding - btnW, (cellHeight - btnH) / 2, btnW, btnH);
        _btnStr = _hireBtn.currentTitle;
        [self addSubview:_hireBtn];
        
        _cancelhireBtn = [[UIButton alloc] init];
        [_cancelhireBtn setTitle:@"拒绝雇佣" forState:UIControlStateNormal];
        _cancelhireBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_cancelhireBtn setTitleColor:[UIColor colorWithRed:0.49 green:0.76 blue:0.75 alpha:1.00] forState:UIControlStateNormal];
        _cancelhireBtn.frame = CGRectMake(_hireBtn.left-100, _hireBtn.top, 100, _hireBtn.height);
        [_cancelhireBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelhireBtn];
        [self.viewArr addObject:_hireBtn];
        
        
        if(status == 1) {
            
            _hireBtn.userInteractionEnabled = NO;
            [_hireBtn setTitle:@"等待工人响应" forState:UIControlStateNormal];
            
        }
        //    else if(status == 2) {
        //        
        //        _hireBtn.userInteractionEnabled = NO;
        ////        [_hireBtn setTitle:@"工人同意合同" forState:UIControlStateNormal];
        //        [_cancelhireBtn setTitle:@"解除合同" forState:UIControlStateNormal];
        //    }
    }
    
    
}

- (void)clickCancelBtn:(UIButton*)sender
{
    sender.userInteractionEnabled = NO;
    
    NSString *title = [sender titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"拒绝雇佣"]) {
        if([self.seeDelegate respondsToSelector:@selector(refuseApply:)]) {
            
            [self.seeDelegate refuseApply:self];
            
        }
    }else{
        [self.seeDelegate cancelWorker:self];
    }
    
    
    sender.userInteractionEnabled = YES;
}

- (void)hireClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    if([self.seeDelegate respondsToSelector:@selector(applyWorker: data:)]) {
        
        [self.seeDelegate applyWorker:self data:self.data];
        
    }
    
    sender.userInteractionEnabled = YES;
    
}

- (void)showWorkerCommentView:(NSString *)imageName name:(NSString *)name jobs:(NSArray *)jobs status:(BOOL)rate{
    if (self.data.collect == 0) {
        [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_unclick"] forState:UIControlStateNormal];
    }else{
        [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_click"] forState:UIControlStateNormal];
    }

    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,imageName]] placeholderImage:[UIImage imageNamed:@"temp"]];
    
    _name.text = name;
    [_name sizeToFit];
    
    [self removeAllView:self.viewArr];
    
    CGFloat x = CGRectGetMaxX(_icon.frame) + 5;
    CGFloat y = CGRectGetMaxY(_name.frame) + 5;
    
    for (NSString *jobName in jobs) {
        
        CGSize nameSize = [jobName sizeWithFont:[UIFont systemFontOfSize:10] width:SCREEN_WIDTH];
        
        UILabel *jobLbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, nameSize.width + 10, nameSize.height + 5)];
        jobLbl.textColor = [UIColor colorWithRed:0.52 green:0.53 blue:0.53 alpha:1.00];
        jobLbl.font      = [UIFont systemFontOfSize:10];
        jobLbl.text      = jobName;
        jobLbl.textAlignment = NSTextAlignmentCenter;
        jobLbl.layer.cornerRadius = nameSize.height / 2;
        jobLbl.layer.masksToBounds = YES;
        jobLbl.layer.borderWidth = 0.5;
        jobLbl.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00].CGColor;
        [self addSubview:jobLbl];
        [self.viewArr addObject:jobLbl];
        
        x = CGRectGetMaxX(jobLbl.frame) + 5;
        
    }
    
    _cancelhireBtn = [[UIButton alloc] init];
    [_cancelhireBtn setTitle:@"立即评价" forState:UIControlStateNormal];
    _cancelhireBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_cancelhireBtn setTitleColor:[UIColor colorWithRed:0.49 green:0.76 blue:0.75 alpha:1.00] forState:UIControlStateNormal];
    
    if(rate) {
        
        [_cancelhireBtn setTitle:@"已评价" forState:UIControlStateNormal];
//        _cancelhireBtn setTitleColor:<#(nullable UIColor *)#> forState:<#(UIControlState)#>
        _cancelhireBtn.userInteractionEnabled = NO;
    }
    
    [_cancelhireBtn sizeToFit];
    [_cancelhireBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat btnW = _cancelhireBtn.bounds.size.width;
    CGFloat btnH = _cancelhireBtn.bounds.size.height;
    _cancelhireBtn.frame = CGRectMake(SCREEN_WIDTH - padding - btnW, (cellHeight - btnH) / 2, btnW, btnH);
    [self addSubview:_cancelhireBtn];
    [self.viewArr addObject:_cancelhireBtn];
    
    
}

- (void)commentClick:(UIButton *)sender {
    
    if([self.seeDelegate respondsToSelector:@selector(commentToWorker:)]) {
        
        [self.seeDelegate commentToWorker:self];
        
    }
    
}

//展示雇佣的工人数据
//image:头像
//name:姓名
//jobs:工种
//state:0等待用户同意 1已接受，等待客户发送合同 2客户已经发送合同 4签订合同 5拒绝 6等待用户确认付款 7用户已经确认付款
- (void)showWorkerData:(NSString *)imageName name:(NSString *)name jobs:(NSArray *)jobs state:(NSInteger)state {
    if (self.data.collect == 0) {
        [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_unclick"] forState:UIControlStateNormal];
    }else{
        [self.collectonBtn setImage:[UIImage imageNamed:@"favorite_click"] forState:UIControlStateNormal];
    }

    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,imageName]] placeholderImage:[UIImage imageNamed:@"temp"]];
    
    _name.text = name;
    [_name sizeToFit];
    
    [self removeAllView:self.viewArr];
    
    CGFloat x = CGRectGetMaxX(_icon.frame) + 5;
    CGFloat y = CGRectGetMaxY(_name.frame) + 5;
    
    for (NSString *jobName in jobs) {
        
        CGSize nameSize = [jobName sizeWithFont:[UIFont systemFontOfSize:10] width:SCREEN_WIDTH];
        
        UILabel *jobLbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, nameSize.width + 10, nameSize.height + 5)];
        jobLbl.textColor = [UIColor colorWithRed:0.52 green:0.53 blue:0.53 alpha:1.00];
        jobLbl.font      = [UIFont systemFontOfSize:10];
        jobLbl.text      = jobName;
        jobLbl.textAlignment = NSTextAlignmentCenter;
        jobLbl.layer.cornerRadius = nameSize.height / 2;
        jobLbl.layer.masksToBounds = YES;
        jobLbl.layer.borderWidth = 0.5;
        jobLbl.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00].CGColor;
        [self addSubview:jobLbl];
        [self.viewArr addObject:jobLbl];
        
        x = CGRectGetMaxX(jobLbl.frame) + 5;
        
    }
    
    NSString *stateStr = @"已同意";
    UIColor *stateColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.69 alpha:1.00];
    
    
    _cancelhireBtn = [[UIButton alloc] init];
    [_cancelhireBtn setTitle:@"取消雇佣" forState:UIControlStateNormal];
    _cancelhireBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_cancelhireBtn setTitleColor:[UIColor colorWithRed:0.49 green:0.76 blue:0.75 alpha:1.00] forState:UIControlStateNormal];
    [_cancelhireBtn sizeToFit];
    [_cancelhireBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancelhireBtn.hidden = YES;
    CGFloat btnW = _cancelhireBtn.bounds.size.width;
    CGFloat btnH = _cancelhireBtn.bounds.size.height;
    _cancelhireBtn.frame = CGRectMake(SCREEN_WIDTH - padding - btnW, (cellHeight - btnH) / 2, btnW, btnH);
    [self addSubview:_cancelhireBtn];
    [self.viewArr addObject:_cancelhireBtn];
    
    if(state == 0){
        
        stateStr = @"待同意";
        stateColor = [UIColor colorWithRed:0.39 green:0.39 blue:0.40 alpha:1.00];
        _cancelhireBtn.hidden = NO;
        
    }else if(state == 1) {
        
        stateStr = @"已同意";
        _cancelhireBtn.hidden = NO;
        [_cancelhireBtn setTitle:@"发送合同" forState:UIControlStateNormal];
        [_cancelhireBtn removeTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelhireBtn addTarget:self action:@selector(hireClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if(state == 6) {
        
        stateStr = @"已同意";
        _cancelhireBtn.hidden = NO;
        [_cancelhireBtn setTitle:@"付预付款" forState:UIControlStateNormal];
        [_cancelhireBtn removeTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelhireBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    CGSize stateSize = [stateStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
   
    UILabel *stateLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_cancelhireBtn.frame) - padding - stateSize.width, (cellHeight - stateSize.height) / 2, stateSize.width, stateSize.height)];
    stateLbl.text = stateStr;
    stateLbl.font = [UIFont systemFontOfSize:12];
    stateLbl.textColor = stateColor;
    [self addSubview:stateLbl];
    [self.viewArr addObject:stateLbl];
    
    if(state == 2) {
        
        stateLbl.hidden = YES;
        _cancelhireBtn.hidden = YES;
        
        NSString *moneyStr = @"等待工人响应合同";
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.91 green:0.68 blue:0.45 alpha:1.00]} range:[moneyStr rangeOfString:@"300"]];
        
        CGSize moneySize = [moneyStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        
        _moneyLbl.frame = CGRectMake(SCREEN_WIDTH - padding - moneySize.width, (cellHeight - moneySize.height) / 2, moneySize.width, moneySize.height);
        _moneyLbl.attributedText = attrStr;
        
    }else if(state == 4){
    
        stateLbl.hidden = YES;
        _cancelhireBtn.hidden = YES;
        
        NSString *moneyStr = @"工人同意合同";
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.91 green:0.68 blue:0.45 alpha:1.00]} range:[moneyStr rangeOfString:@"300"]];
        
        CGSize moneySize = [moneyStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        
        _moneyLbl.frame = CGRectMake(SCREEN_WIDTH - padding - moneySize.width, (cellHeight - moneySize.height) / 2, moneySize.width, moneySize.height);
        _moneyLbl.attributedText = attrStr;
        
        
    }else if(state == 5) {
        
        stateLbl.hidden = YES;
        _cancelhireBtn.hidden = YES;
        
        NSString *moneyStr = @"工人拒绝合同";
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.91 green:0.68 blue:0.45 alpha:1.00]} range:[moneyStr rangeOfString:@"300"]];
        
        CGSize moneySize = [moneyStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        
        _moneyLbl.frame = CGRectMake(SCREEN_WIDTH - padding - moneySize.width, (cellHeight - moneySize.height) / 2, moneySize.width, moneySize.height);
        _moneyLbl.attributedText = attrStr;
        
    }else if(state == 7) {
        
        stateLbl.hidden = YES;
        _cancelhireBtn.hidden = YES;
        
        NSString *moneyStr = @"已付款";
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.91 green:0.68 blue:0.45 alpha:1.00]} range:[moneyStr rangeOfString:@"300"]];
        
        CGSize moneySize = [moneyStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        
        _moneyLbl.frame = CGRectMake(SCREEN_WIDTH - padding - moneySize.width, (cellHeight - moneySize.height) / 2, moneySize.width, moneySize.height);
        _moneyLbl.attributedText = attrStr;
        
    }
    
    
}

/** 支付点击 */
- (void)payClick:(UIButton *)sender {
    
    if([self.seeDelegate respondsToSelector:@selector(payToWorker:)]) {
        
        [self.seeDelegate payToWorker:self];
        
    }
    
}

/** 取消雇佣 */
- (void)cancelClick:(UIButton *)sender {
    
    if([self.seeDelegate respondsToSelector:@selector(cancelWorker:)]) {
        
        [self.seeDelegate cancelWorker:self];
        
    }
    
}

- (void)removeAllView:(NSMutableArray *)arr {
    
    for (UILabel *view in arr) {
        
        [view removeFromSuperview];
        
    }
    
    [arr removeAllObjects];
    
}


@end
