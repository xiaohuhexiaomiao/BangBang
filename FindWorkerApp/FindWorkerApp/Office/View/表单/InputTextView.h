//
//  InputTextView.h
//  FindWorkerApp
//
//  Created by cxz on 2018/4/10.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputTextViewDelegate <NSObject>

-(void)didLoadNewData;

@end

@interface InputTextView : UIView

@property(nonatomic ,strong)UITextView *textView;

@property(nonatomic ,copy)NSString *participation_id;//审批操作id

@property(nonatomic ,copy)NSString *approval_id;//审批id

@property(nonatomic ,copy)NSString *other_uid;//回复uid

@property(nonatomic ,weak) id<InputTextViewDelegate>delegate;

@end
