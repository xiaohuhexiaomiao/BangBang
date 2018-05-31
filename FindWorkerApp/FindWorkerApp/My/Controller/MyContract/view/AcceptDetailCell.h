//
//  AcceptDetailCell.h
//  BangBangGongRen
//
//  Created by cxz on 2018/3/20.
//  Copyright © 2018年 cxz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTLabel;
@class AcceptInfoModel;

@interface AcceptDetailCell : UITableViewCell

@property(nonatomic ,strong)RTLabel *titleLabel;


@property(nonatomic ,assign) CGFloat cellHeight;

@property(nonatomic ,assign) NSInteger cellType;//0 输入cell 1 同意拒绝cell 

@property(nonatomic , strong)AcceptInfoModel *infoModel;// 0 合同id

-(void)configAcceptCell;

-(void)setInfoModel:(AcceptInfoModel *)infoModel;

@end
