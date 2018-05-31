//
//  DiarySendRangeView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/17.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "DiarySendRangeView.h"
#import "CXZ.h"
#import "AdressBookViewController.h"
#import "CommentsRangeViewController.h"

@interface DiarySendRangeView ()<AdressBookDelegate,CommentsRangeViewControllerDelegate>

@property(nonatomic ,strong) UIButton *rangeButton;

//@property(nonatomic ,strong) UIButton *commentsButton;

@end

@implementation DiarySendRangeView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _rangeButton = [CustomView customButtonWithContentView:self image:@"chaosong" title:@"抄送范围："];
        NSString *rangeStr = @"抄送范围：";
        CGSize rangeSize = [rangeStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        _rangeButton.frame = CGRectMake(8, 0, rangeSize.width+50, frame.size.height);
        [_rangeButton setTitleColor:TOP_GREEN forState:UIControlStateNormal];
        _rangeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _rangeButton.layer.cornerRadius = frame.size.height/2;
        _rangeButton.layer.borderColor = TOP_GREEN.CGColor;
         _rangeButton.layer.borderWidth =0.8;
        _rangeButton.layer.masksToBounds = YES;
        [_rangeButton addTarget:self action:@selector(clickRangeButton:) forControlEvents:UIControlEventTouchUpInside];
        [_rangeButton setTitle:rangeStr forState:UIControlStateNormal];
        
        _commentsButton = [CustomView customButtonWithContentView:self image:@"dianping" title:@"点评人："];
//        NSString *commentStr = @"点评人：";
//        CGSize commentSize = [commentStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        _commentsButton.frame = CGRectMake(SCREEN_WIDTH-88, 0, 80, frame.size.height);
        [_commentsButton setTitleColor:TOP_GREEN forState:UIControlStateNormal];
        _commentsButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _commentsButton.layer.cornerRadius = frame.size.height/2;
        _commentsButton.layer.borderWidth =0.8;
        _commentsButton.layer.borderColor = TOP_GREEN.CGColor;
        _commentsButton.layer.masksToBounds = YES;
        [_commentsButton addTarget:self action:@selector(clickCommentsButton:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *reviewid = [[NSUserDefaults standardUserDefaults]objectForKey:@"Review_id"];
        if (![NSString isBlankString:reviewid]) {
            self.reviewer_id = reviewid;
        }
        NSString *reviewName = [[NSUserDefaults standardUserDefaults]objectForKey:@"Review_Name"];
        if (![NSString isBlankString:reviewName]) {
           [self.commentsButton setTitle:reviewName forState:UIControlStateNormal];
        }
        
    }
    return self;
}

-(void)clickRangeButton:(UIButton*)button
{
    CommentsRangeViewController *rangeVC = [[CommentsRangeViewController alloc]init];
    rangeVC.company_id = self.company_id;
    rangeVC.delegate = self;
    [self.viewController.navigationController pushViewController:rangeVC animated:YES];
}

-(void)clickCommentsButton:(UIButton*)button
{
    AdressBookViewController *bookVC = [[AdressBookViewController alloc]init];
    bookVC.companyid = self.company_id;
    bookVC.delegate = self;
    bookVC.isSelectedManager = YES;
    bookVC.loadDataType = 2;
    [self.viewController.navigationController pushViewController:bookVC animated:YES];
    
}

#pragma mark RangeViewController Delegate

-(void)didSelectedRangeArray:(NSArray *)rangeArray rangeDescription:(NSString *)description
{
    self.rangeArray = rangeArray;
    [self.rangeButton setTitle:[NSString stringWithFormat:@"抄送：%@",description] forState:UIControlStateNormal];
//    CGSize rangeSize = [description sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
//    CGFloat rangeWidth = (rangeSize.width+25) > (SCREEN_WIDTH-125) ? ((SCREEN_WIDTH-125)):(rangeSize.width+25);
//    CGRect fame = self.rangeButton.frame;
//    fame.size.width = rangeWidth;
//    self.rangeButton.frame = fame;
}

#pragma mark AdressBookViewController Delegate

-(void)selectedPorjectManager:(NSDictionary *)dict
{
    NSString *name = [dict objectForKey:@"name"];
    if (![NSString isBlankString:name]) {
        [self.commentsButton setTitle:name forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"Review_Name"];
    }
    self.reviewer_id = [dict objectForKey:@"uid"];
    
    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:@"uid"] forKey:@"Review_id"];
    
}

@end
