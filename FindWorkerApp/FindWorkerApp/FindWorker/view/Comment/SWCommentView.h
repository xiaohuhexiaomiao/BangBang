//
//  SWCommentView.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/23.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWCommentView : UIView

//显示数据
//imageName:图片名称
//phone:手机号码
//time:时间
//content:内容
//state:状态 1:非常满意 2:满意 3:不满意
//return 行高
- (CGFloat)showData:(NSString *)imageName phone:(NSString *)phone time:(NSString *)time content:(NSString *)content state:(NSInteger)state;

@end
