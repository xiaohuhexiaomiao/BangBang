//
//  SearchView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/1/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewDelegate <NSObject>

-(void)didClickWorker:(NSDictionary*)dict;

-(void)clickedAddWorker:(NSInteger)index;
@end

@interface SearchView : UIView

@property(nonatomic ,weak) id<SearchViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *searchArray;

@end
