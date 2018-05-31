//
//  PerssonalTableViewCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpdateApprovalList <NSObject>

-(void)updateApprovalList:(NSMutableArray*)listarray;

-(void)clickAddBtn:(NSMutableArray*)listarray index:(NSInteger)index;

@end

@interface PerssonalTableViewCell : UITableViewCell

@property(nonatomic , assign) BOOL isDelete;

@property(nonatomic , assign) NSInteger index;

@property(nonatomic , weak) id <UpdateApprovalList> delegate;

-(void)setPerssonalCell:(NSArray *)dataArray;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
