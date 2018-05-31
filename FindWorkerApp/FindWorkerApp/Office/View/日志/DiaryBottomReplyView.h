//
//  DiaryBottomReplyView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BottomReplyViewDelegate<NSObject>

-(void)clickThirdButton;


@end
@interface DiaryBottomReplyView : UIView

@property(nonatomic , strong) UIButton *goodButton;

@property(nonatomic ,strong)UIButton *thirdButton;

@property(nonatomic , copy) NSString *company_id;

@property(nonatomic , copy) NSString *publish_id;

@property(nonatomic , copy) NSString *log_id;

@property(nonatomic, assign) BOOL is_review;//是否可以点评

@property(nonatomic , weak) id <BottomReplyViewDelegate> delegate;


@end
