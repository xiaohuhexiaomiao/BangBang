//
//  SWCommentingView.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/25.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWLookUserData.h"

@protocol SWCommentViewDelegate <NSObject>

- (void)showKeyBoard:(UITextView *)textView;



@end

@interface SWCommentingView : UIView

@property (nonatomic, retain) NSString *infomation_id;

@property (nonatomic, weak) id<SWCommentViewDelegate> SWCommentingViewDelegate;

@property (nonatomic, retain) SWLookUserData *data;

- (void)showData:(NSString *)imageName name:(NSString *)name jobArr:(NSArray *)jobs;

@end
