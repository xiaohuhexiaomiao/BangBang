//
//  DiaryCommentAndGood.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaryCommentAndGoodView : UIView

@property(nonatomic , copy) NSString *company_id;

@property(nonatomic , copy) NSString *publish_id;

-(void)reloadDataWithIndex:(NSInteger)tag;

@end
