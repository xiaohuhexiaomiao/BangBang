//
//  CompanyContractCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/16.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyContractModel.h"
@protocol CompanyContractDelegate <NSObject>

-(void)clickSelected:(NSInteger)index;


@end
@interface CompanyContractCell : UITableViewCell

@property(nonatomic ,assign)BOOL isSelected;

@property(nonatomic ,weak)id <CompanyContractDelegate> delegate;

-(void)setSendContractCell:(CompanyContractModel*)company;


@end
