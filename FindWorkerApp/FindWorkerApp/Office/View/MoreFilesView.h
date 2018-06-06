//
//  MoreFilesView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/10/25.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreFilesView : UIView

@property(nonatomic , strong) UILabel *descripeLabel;

@property(nonatomic ,strong)NSMutableArray *file_id_array;

@property(nonatomic ,strong)NSMutableArray *imgArray;


-(CGFloat)setMoreFilesViewWithArray:(NSArray*)filesArray;

@end
