//
//  CommentsRangeViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/17.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@protocol CommentsRangeViewControllerDelegate <NSObject>

-(void)didSelectedRangeArray:(NSArray*)rangeArray rangeDescription:(NSString*)description;

@end

@interface CommentsRangeViewController : CXZBaseViewController

@property(nonatomic ,copy)NSString *company_id;

@property(nonatomic , weak) id<CommentsRangeViewControllerDelegate> delegate;

@end
