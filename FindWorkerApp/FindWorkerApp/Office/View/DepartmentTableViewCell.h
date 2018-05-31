//
//  DepartmentTableViewCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/13.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PersonelModel.h"
@protocol DepartmentCellDelegate <NSObject>

-(void)clickSeleteButton:(BOOL)isSeleted tag:(NSInteger)tag;

-(void)clickDeleteButton:(NSInteger)tag;
@end;
@interface DepartmentTableViewCell : UITableViewCell

@property (nonatomic , strong)UIButton *selectBtn;

@property (nonatomic , strong)UIButton *deleteButton;

@property (nonatomic ,weak) id <DepartmentCellDelegate> delegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)setDeparmentCellWith:(PersonelModel*)personalM;

-(void)setSelectDeparmentCellWith:(PersonelModel*)personalM;

-(void)setMangerDataWith:(PersonelModel*)personalM;

-(void)setNormalDataWith:(PersonelModel*)personalM;


@end
