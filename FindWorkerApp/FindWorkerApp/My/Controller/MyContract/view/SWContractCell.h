//
//  SWContractCell.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/19.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWListContractData.h"

@class SWContractCell;

@protocol SWContractDelegate <NSObject>

- (void)rejectData:(SWContractCell *)cell;

- (void)applyAdvancePayment:(SWContractCell*)cell;

- (void)noAgree:(SWContractCell*)cell;//重新编写合同

- (void)agree:(SWContractCell*)cell;

@end

@interface SWContractCell : UITableViewCell

@property (nonatomic, retain) SWListContractData *contractData;

@property (nonatomic, weak) id<SWContractDelegate> contractDelegate;

/**
 初始化cell

 @param tableView tableView
 @return SWContractCell
 */
+ (instancetype)initWithTableViewCell:(UITableView *)tableView;


/**
 显示数据

 @param data data
 */
- (void)showSendData:(SWListContractData *)data;

/**
 显示数据
 
 @param data data
 */
- (void)showReceiveData:(SWListContractData *)data;



@end
