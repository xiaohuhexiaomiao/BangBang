//
//  ToolCollectionCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/4/13.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ToolCollectionCellDelegate <NSObject>

-(void)clickCollectionCell:(NSString*)workID;

@end
@interface ToolCollectionCell : UICollectionViewCell

@property(nonatomic,strong)UILabel* nameLabel;//姓名

@property(nonatomic, strong)NSDictionary *dict;

//@property(nonatomic,strong)UIImageView *headImgView;//头像

@property(nonatomic, weak) id <ToolCollectionCellDelegate> delegate;

-(void)setHeadImgViewWithUrl:(NSURL*)url Title:(NSString*)title;

@end
