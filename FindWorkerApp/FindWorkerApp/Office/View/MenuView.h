//
//  MenuView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/4.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MenuViewDelegate <NSObject>

-(void)selectedDepartment:(NSDictionary*)dict is_department:(BOOL)is_selected_depart;

@end
@interface MenuView : UIView

@property(nonatomic ,strong)NSString *companyID;

@property(nonatomic ,weak)id <MenuViewDelegate>delegate;

-(void)setTableviewFrame;

-(void)loadMenuData;

-(void)loadJobData:(NSArray*)jobArray;


@end
