//
//  ProductionCollectionViewCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/4/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductionCellDelegate <NSObject>

-(void)clickProductionCollectionViewCell:(NSDictionary*)dict;

@end

@interface ProductionCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong)NSDictionary *productionDict;

@property (weak, nonatomic) IBOutlet UIImageView *productionImgview;

@property (weak, nonatomic) IBOutlet UILabel *productionTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *productionTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *clickView;

@property (nonatomic , weak) id <ProductionCellDelegate> delegate;

@end
