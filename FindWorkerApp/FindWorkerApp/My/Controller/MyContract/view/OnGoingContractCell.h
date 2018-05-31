//
//  OnGoingContractCell.h
//  FindWorkerApp
//
//  Created by cxz on 2018/3/23.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContractStatusModel;

@interface OnGoingContractCell : UITableViewCell


-(void)setOnGoingContractCellWithModel:(ContractStatusModel*)goingModel;

@end
