//
//  UploadImageCollectionViewCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/12/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UploadImageModel;

@protocol UploadImageCollectionViewCellDelegate <NSObject>

-(void)clickDeleteImage:(NSInteger)tag;

-(void)clickLargeImageView:(NSInteger)tag;

@end

@interface UploadImageCollectionViewCell : UICollectionViewCell

@property(nonatomic ,strong) UILabel *progressLabel;

@property(nonatomic ,weak) id <UploadImageCollectionViewCellDelegate> delegate;

-(void)setUploadImageCollectonCellWithModel:(UploadImageModel*)uploadImageModel;

@end
