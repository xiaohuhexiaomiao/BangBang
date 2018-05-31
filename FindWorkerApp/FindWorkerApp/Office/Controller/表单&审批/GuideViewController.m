//
//  GuideViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/10/19.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "GuideViewController.h"
#import "CXZ.h"

@interface GuideViewController ()



@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"上传文件说明" withColor:[UIColor whiteColor]];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH-16)/375*565*3+100);
    [self.view addSubview:scrollView];
    
    UIView *lastView;
    
    NSArray *titleArray = @[@"description1",@"description2",@"description3"];
    for (int i = 0; i < titleArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, lastView.bottom, SCREEN_WIDTH-16, (SCREEN_WIDTH-16)/375*565)];
        imageView.image = [UIImage imageNamed:titleArray[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imageView];
        lastView = imageView;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
