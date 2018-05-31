//
//  ContractCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/23.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContractCelleDelegate <NSObject>

-(void)clickTitleWithTag:(NSInteger)indext;

@end

@interface ContractCell : UITableViewCell

@property(nonatomic ,weak)id <ContractCelleDelegate> delegate;

-(void)showPersonalContract:(NSDictionary*)dict;

-(void)showCompanyContract:(NSDictionary*)dict;



@end
