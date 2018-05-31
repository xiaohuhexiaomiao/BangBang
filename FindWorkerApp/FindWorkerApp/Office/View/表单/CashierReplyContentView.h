//
//  CashierReplyContentView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/10/18.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashierReplyContentView : UIView

@property(nonatomic ,strong) NSDictionary *replyContentDict;

-(CGFloat)setCashierReplyContentWith:(NSDictionary*)dict;
@end
