//
//  AdressBookButton.m
//  FindWorkerApp
//
//  Created by cxz on 2017/8/24.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "AdressBookButton.h"

@implementation AdressBookButton


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
//        self.backgroundColor = [UIColor blackColor];
        [self setImage:[UIImage imageNamed:@"AdressBook"] forState:UIControlStateNormal];
        self.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        [self addTarget:self action:@selector(clickAdressBookBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickAdressBookBtn
{
    AdressBookViewController *logVC = [[AdressBookViewController alloc]init];
    logVC.navigationController.navigationBarHidden = NO;
    logVC.companyid = self.companyID;
    logVC.isSelectedManager = YES;
    logVC.delegate = self;
    logVC.loadDataType = 2;
    UIViewController *resultVC = [self topViewController];
    [resultVC.navigationController pushViewController:logVC animated:YES];
}

-(void)selectedPorjectManager:(NSDictionary *)dict
{
    if (_DidSelectObjectBlock) {
       _DidSelectObjectBlock(dict);
    }
}

// 获取topviewcontroller
- (UIViewController *)topViewController {
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
    
}


@end
