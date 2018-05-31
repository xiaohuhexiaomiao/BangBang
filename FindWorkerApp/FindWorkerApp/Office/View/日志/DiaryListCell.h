//
//  DiaryListCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/16.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiaryModel;

@protocol DiaryListCellDelegate <NSObject>

-(void)deleteDiary:(DiaryModel*)diary;

@end

@interface DiaryListCell : UITableViewCell

@property(nonatomic, assign)CGFloat cellHeight;


@property(nonatomic, weak) id<DiaryListCellDelegate> delegate;


-(void)setDiaryListCellWithModel:(DiaryModel*)model;

-(void)setSignListCellWithModel:(DiaryModel*)model;

@end
