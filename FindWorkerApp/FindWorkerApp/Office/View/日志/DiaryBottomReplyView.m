//
//  DiaryBottomReplyView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "DiaryBottomReplyView.h"
#import "CXZ.h"
#import "PublishCommentViewController.h"


@implementation DiaryBottomReplyView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *line = [CustomView customLineView:self];
        line.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
        
        UIButton *replyButton = [CustomView customButtonWithContentView:self image:@"reply" title:@"回复"];
        replyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        replyButton.frame = CGRectMake(8, line.bottom, SCREEN_WIDTH/3-8, frame.size.height-1);
        [replyButton addTarget:self action:@selector(clickReplyButton:) forControlEvents:UIControlEventTouchUpInside];
        
         _goodButton = [CustomView customButtonWithContentView:self image:@"good" title:@"赞"];
        _goodButton.frame = CGRectMake(replyButton.right, line.bottom, SCREEN_WIDTH/3, replyButton.height);
        [_goodButton addTarget:self action:@selector(clickGoodButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _thirdButton = [CustomView customButtonWithContentView:self image:@"dustbin" title:@"删除"];
        _thirdButton.frame = CGRectMake(_goodButton.right, line.bottom, SCREEN_WIDTH/3, replyButton.height);
        [_thirdButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}


-(void)clickReplyButton:(UIButton*)button
{
    if (self.is_review) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertView addAction:[UIAlertAction actionWithTitle:@"点评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            PublishCommentViewController *publishVC = [[PublishCommentViewController alloc]init];
            publishVC.comment_type = 2;
            publishVC.publish_id = self.publish_id;
            publishVC.log_id =  self.log_id;
            publishVC.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:publishVC animated:YES];
        } ]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            PublishCommentViewController *publishVC = [[PublishCommentViewController alloc]init];
            publishVC.comment_type = 1;
            publishVC.publish_id = self.publish_id;
            publishVC.log_id = self.log_id;
            publishVC.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:publishVC animated:YES];
        } ]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        } ]];
        
        [self.viewController.navigationController presentViewController:alertView animated:YES completion:nil];
    }else{
        PublishCommentViewController *publishVC = [[PublishCommentViewController alloc]init];
        publishVC.comment_type = 1;
        publishVC.publish_id = self.publish_id;
        publishVC.log_id = self.log_id;
        publishVC.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:publishVC animated:YES];
    }

    
}

-(void)clickGoodButton:(UIButton*)button
{
    NSInteger type;
    UIImage *tempImage = [UIImage imageNamed:@"good"];
    NSData *tempData = UIImagePNGRepresentation(tempImage);
    UIImage *image = [button imageForState:UIControlStateNormal];
    NSData *data = UIImagePNGRepresentation(image);
    if ([data isEqualToData:tempData]) {
        [_goodButton setImage:[UIImage imageNamed:@"yizan"] forState:UIControlStateNormal];
//        [_goodButton setTitle:@"赞" forState:UIControlStateNormal];
        [_goodButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        type = 1;
    }else{
        [_goodButton setImage:[UIImage imageNamed:@"good"] forState:UIControlStateNormal];
//        [_goodButton setTitle:@"赞" forState:UIControlStateNormal];
        [_goodButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
       type = 2;
    }
    NSDictionary *dict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"publish_id":self.publish_id,
                           @"type":@(type),
                           @"company_id":self.company_id};
    [[NetworkSingletion sharedManager]clickDiaryGoodsButton:dict onSucceed:^(NSDictionary *dict) {
        
        if ([dict[@"code"] integerValue]==0) {
            if (type == 1) {
                [WFHudView showMsg:@"成功" inView:self.viewController.view];
            }else{
                [WFHudView showMsg:@"取消" inView:self.viewController.view];
            }
        }
    } OnError:^(NSString *error) {
       
    }];
    
}

-(void)clickMoreButton:(UIButton*)button
{
    NSString *title = [self.thirdButton titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"点评"]) {
        PublishCommentViewController *publishVC = [[PublishCommentViewController alloc]init];
        publishVC.comment_type = 2;
        publishVC.publish_id = self.publish_id;
        publishVC.log_id = self.log_id;
        publishVC.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:publishVC animated:YES];
    }else{
        [self.delegate clickThirdButton];
    }
    
   
}



@end
