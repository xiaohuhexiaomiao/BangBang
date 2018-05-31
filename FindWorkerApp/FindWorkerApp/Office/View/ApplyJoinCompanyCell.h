//
//  ApplyJoinCompanyCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/1.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApplyCompanyModel;

@protocol ApplyCompanyCellDelegate <NSObject>

-(void)approvalApplyComapany:(NSInteger)agreeType withModel:(ApplyCompanyModel*)model;

@end

@interface ApplyJoinCompanyCell : UITableViewCell

@property(nonatomic ,strong) ApplyCompanyModel *applyModel;

@property(nonatomic ,assign) CGFloat cellHeight;

@property(nonatomic ,weak)id <ApplyCompanyCellDelegate> delegate;

-(void)setApplyJoinCellWith:(ApplyCompanyModel*)model;

@end
