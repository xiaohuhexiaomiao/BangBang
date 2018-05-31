//
//  PermissionUpdateViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/4/6.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "PermissionUpdateViewController.h"
#import "CXZ.h"
#import "SWAlipay.h"
#import "RTLabel.h"

#import "RecommendFriendViewController.h"

@interface PermissionUpdateViewController ()
{
    NSInteger selectedTag;
}
@property(nonatomic ,strong)UIWindow *addWindow;

@property(nonatomic ,strong)UIView *clickView;

@property(nonatomic ,strong)UIView *bagView;

@property(nonatomic ,strong)UILabel *priceLabel;

@property(nonatomic ,strong)NSArray *priceArray;

@end

@implementation PermissionUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupBackw];
    
    [self setupTitleWithString:@"权限升级" withColor:[UIColor whiteColor]];
    
    [self config];
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark Private Method

-(void)loadData
{
    [[NetworkSingletion sharedManager]getVipPrice:nil onSucceed:^(NSDictionary *dict) {
//        NSLog(@"***23*%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            self.priceArray = [dict objectForKey:@"data"];
        }
    } OnError:^(NSString *error) {
        
    }];
}

-(void)config
{

    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH, 20)];
    title1.text = @"权限";
    title1.textColor = TITLECOLOR;
    title1.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:title1];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, title1.bottom+5, SCREEN_WIDTH-16, 1)];
    line.backgroundColor = UIColorFromRGB(233, 233, 233);
    [self.view addSubview:line];
    
    RTLabel *ruleLabel = [[RTLabel alloc]initWithFrame:CGRectMake(title1.left, line.bottom+5, title1.width, 60)];
    ruleLabel.text = @"<font size=12 >1.可以查看所有工人信息。<br>2.可以发布需求。<br>3.客服24小时服务。  </font>";
    ruleLabel.textColor = SUBTITLECOLOR;
    [self.view addSubview:ruleLabel];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(ruleLabel.left, ruleLabel.bottom+5, title1.width, 1)];
    line2.backgroundColor = line.backgroundColor;
    [self.view addSubview:line2];
    
    UILabel *title2  = [[UILabel alloc]initWithFrame:CGRectMake(title1.left, line2.bottom+5, 100, 20)];
    title2.text = @"方法一";
    title2.font = [UIFont systemFontOfSize:14];
    title2.textColor = TITLECOLOR;
    [self.view addSubview:title2];
    
    UIButton *clickBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn1.frame = CGRectMake(SCREEN_WIDTH-68, title2.top, 60, 20);
    [clickBtn1 setTitle:@"点击" forState:UIControlStateNormal];
    clickBtn1.backgroundColor = TOP_GREEN;
    clickBtn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [clickBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clickBtn1 addTarget:self action:@selector(clickType1) forControlEvents:UIControlEventTouchUpInside];
    clickBtn1.layer.cornerRadius = 3;
    clickBtn1.layer.masksToBounds = YES;
    [self.view addSubview:clickBtn1];
    
    UILabel *typeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(title2.left, title2.bottom+5, title1.width, 20)];
    typeLabel1.textColor = SUBTITLECOLOR;
    typeLabel1.font = [UIFont systemFontOfSize:12];
    typeLabel1.text = @"支付宝购买权限。";
    [self.view addSubview:typeLabel1];
    
    UIView *line3 =  [[UIView alloc]initWithFrame:CGRectMake(line.left, typeLabel1.bottom+5, SCREEN_WIDTH-16, 1)];
    line3.backgroundColor = line.backgroundColor;
    [self.view addSubview:line3];
    
    UILabel *title3= [[UILabel alloc]initWithFrame:CGRectMake(line.left, line3.bottom+5, title2.width, title2.height)];
    title3.text = @"方法二";
    title3.font = [UIFont systemFontOfSize:14];
    title3.textColor = TITLECOLOR;
    [self.view addSubview:title3];
    
    UIButton *clickBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn2.frame = CGRectMake(clickBtn1.left, title3.top, clickBtn1.width, clickBtn1.height);
    [clickBtn2 setTitle:@"点击" forState:UIControlStateNormal];
    clickBtn2.backgroundColor = TOP_GREEN;
    clickBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
    [clickBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clickBtn2 addTarget:self action:@selector(clickType2) forControlEvents:UIControlEventTouchUpInside];
    clickBtn2.layer.cornerRadius = 3;
    clickBtn2.layer.masksToBounds = YES;
    [self.view addSubview:clickBtn2];
    
    UILabel *typeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(title3.left, title3.bottom+3, typeLabel1.width, 35)];
    typeLabel2.numberOfLines = 2;
    typeLabel2.font = [UIFont systemFontOfSize:12];
    typeLabel2.textColor = SUBTITLECOLOR;
    typeLabel2.text = @"邀请30个工人并成功注册可享受1年权限并赠送10元话费。";
    [self.view addSubview:typeLabel2];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(typeLabel2.left, typeLabel2.bottom, typeLabel2.width, 1)];
    line4.backgroundColor = line.backgroundColor;
    [self.view addSubview:line4];
    
}


-(void)configAddView
{
    if (!_addWindow) {
        _addWindow = [[UIWindow alloc] initWithFrame:self.view.bounds];
        _addWindow.windowLevel = UIWindowLevelNormal;
        _addWindow.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        
        _clickView = [[UIView alloc] initWithFrame:self.view.bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCancelBtn)];
        [_clickView addGestureRecognizer:tap];
        [_addWindow addSubview:_clickView];
        
        _bagView = [[UIView alloc] initWithFrame:CGRectMake(0, _addWindow.bottom-200, SCREEN_WIDTH, 200)];
        _bagView.backgroundColor = [UIColor whiteColor];
        _bagView.layer.cornerRadius = 5;
        _bagView.layer.masksToBounds = YES;
        [_addWindow addSubview:_bagView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 100, 20)];
        titleLabel.text = @"购买权限";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = TITLECOLOR;
        [_bagView addSubview:titleLabel];
        
        UIView *lastView ;
        CGFloat width = (SCREEN_WIDTH-76)/3;
        for (int i = 0; i <_priceArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button setTitle:[_priceArray[i] objectForKey:@"desc"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button.layer.borderColor= TOP_GREEN.CGColor;
            button.layer.borderWidth = 1;
            button.tag = i+10;
//            [button setTitleColor:[UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(clickPriceBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_bagView addSubview:button];
            if (_priceArray.count < 4) {
                button.frame = CGRectMake(8+(width+30)*i, titleLabel.bottom+8, width, 20);
                lastView = button;
            }
            if (_priceArray.count >3 && _priceArray.count < 6) {
                button.frame = CGRectMake(8+(width+30)*i, titleLabel.bottom+8+28, width, 20);
                lastView = button;
            }
        }
        
        _priceLabel = [[ UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, lastView.bottom+20, 200, 20)];
        _priceLabel.textColor = TITLECOLOR;
        _priceLabel.text = @"付款：";
        _priceLabel.font = [UIFont systemFontOfSize:14];
        [_bagView addSubview:_priceLabel];
        
        UIButton *permissionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        permissionBtn.frame = CGRectMake(8, 150, SCREEN_WIDTH-16, 40);
        [permissionBtn setTitle:@"立即升级" forState:UIControlStateNormal];
        permissionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        permissionBtn.backgroundColor = TOP_GREEN;
        [permissionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [permissionBtn addTarget:self action:@selector(clickPermissionBtn) forControlEvents:UIControlEventTouchUpInside];
        permissionBtn.layer.cornerRadius = 5;
        permissionBtn.layer.masksToBounds = YES;
        [_bagView addSubview:permissionBtn];
        
        
        [self.view addSubview:_addWindow];
        
    }
    
    [_addWindow makeKeyWindow];
    _addWindow.hidden = NO;
    
}

-(void)clickCancelBtn
{
    [_addWindow resignKeyWindow];
    _addWindow.hidden = YES;
}

-(void)clickPriceBtn:(UIButton*)btn
{
    if (selectedTag != 0) {
        UIButton *button = (UIButton*)[_bagView viewWithTag: selectedTag];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    
    [btn setTitleColor:[UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1] forState:UIControlStateNormal];
    NSInteger tag = btn.tag-10;
    NSDictionary *dict = self.priceArray[tag];
    _priceLabel.text = [NSString stringWithFormat:@"付款：%@元",[dict objectForKey:@"money"]];
    selectedTag = btn.tag;
}
-(void)clickPermissionBtn
{
    if (selectedTag == 0) {
        [MBProgressHUD showError:@"请选择购买权限" toView:_clickView];
        return;
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSDictionary *dict = self.priceArray[selectedTag-10];
    NSDictionary *paramDict = @{@"uid":uid, @"id":dict[@"iid"],@"total_price":dict[@"money"]};
    [[NetworkSingletion sharedManager]vipPay:paramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"*wer**%@",dict);
        if ([dict[@"code"] integerValue ]== 0) {
            SWAlipay *pay = [SWAlipay new];
            NSString *payStr = dict[@"data"];
            [pay payToStr:payStr];
        }
        
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:_clickView];
    }];
}



-(void)clickType1
{
    [self configAddView];
}

-(void)clickType2
{
    RecommendFriendViewController *rfVC = [[RecommendFriendViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rfVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
}




@end
