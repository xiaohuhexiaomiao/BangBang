//
//  PersonCollectionViewCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PersonCollectionDelegate <NSObject>

-(void)clickPersonCOllectionCell:(NSString*)typeStr withIndex:(NSInteger)index;

@end
@interface PersonCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) UILabel *per_nameLabel;

@property (nonatomic ,strong) UILabel *per_departLabel;

@property (nonatomic ,strong) UIImageView *per_avatarImageview;

@property (nonatomic ,strong) UIButton *per_deleteBtn;

@property (nonatomic ,assign) NSInteger isEdit;

@property (nonatomic ,weak) id <PersonCollectionDelegate> delegate;


@end
