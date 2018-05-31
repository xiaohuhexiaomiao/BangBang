//
//  SelectedDepartCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/12.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectedDepartCellDelegate <NSObject>

-(void)clickSelectedButton:(NSInteger)index isSelect:(BOOL)selected;

@end


@interface SelectedDepartCell : UITableViewCell

//@property(nonatomic ,strong)UITextField *numberTxtfield;

@property(nonatomic, weak) id <SelectedDepartCellDelegate>delegate;

-(void)setDepartCell:(NSString*)titleStr is_selected:(BOOL)is_selected;

@end
