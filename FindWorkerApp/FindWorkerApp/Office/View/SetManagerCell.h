//
//  SetManagerCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonelModel;

@protocol SetManagerCellDelegate <NSObject>

-(void)moveUpOrDownCell:(NSInteger)row is_up:(BOOL)is_up;

-(void)deleteCell:(NSInteger)row;

@end


@interface SetManagerCell : UITableViewCell

@property(nonatomic ,weak) id<SetManagerCellDelegate> delegate;

-(void)setManagerCellWith:(PersonelModel *)personalM;

@end
