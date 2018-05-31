//
//  CompanyInfoCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/1.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyInfoModel.h"
#import "ComporationModel.h"
@interface CompanyInfoCell : UITableViewCell

@property(nonatomic ,assign)CGFloat infoCellHeight;

-(void)setCompanyInfoCellWithModel:(CompanyInfoModel*)model;

-(void)setCompanyInfoCellWithComporationModel:(ComporationModel*)model;

@end
