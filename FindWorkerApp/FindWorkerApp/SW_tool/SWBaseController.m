//
//  SWBaseController.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWBaseController.h"

#import "SWBaseTopView.h"

#import "CXZ.h"

@interface SWBaseController ()

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, retain) SWBaseTopView *topView;

@end

@implementation SWBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithView];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //添加监听器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChange:) name:@"PAGE_CHANGE" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //移除监听器，防止下个界面的信息传递到上个界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PAGE_CHANGE object:nil];
    
}

- (void)valueChange:(NSNotification *)notif {
    
    NSString *page = notif.userInfo[@"page"];
    
    NSInteger pageNum = [page integerValue];
    
    [_contentView setContentOffset:CGPointMake(SCREEN_WIDTH * (pageNum - 1), 0) animated:YES];
}

- (void)initWithView {
    
    _topView = [[SWBaseTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self.view addSubview:_topView];
    
    _contentView = [[UIScrollView alloc] init];
    _contentView.delegate = self;
    _contentView.pagingEnabled = YES;
    _contentView.frame = CGRectMake(0, CGRectGetMaxY(_topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(_topView.frame));
    [self.view addSubview:_contentView];
    
}



-(void)setTitles:(NSArray *)titles {
    
    _titles = titles;
    
    _page = _titles.count;
    _topView.titleArr = _titles;
    _topView.totalPage = titles.count;
    _contentView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);

    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    _topView.currentPage = page + 1;
    
}



@end
