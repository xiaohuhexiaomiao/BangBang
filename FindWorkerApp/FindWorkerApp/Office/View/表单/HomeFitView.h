//
//  HomeFitView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/7/5.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeFitViewDelegate <NSObject>

-(void)deleteHomeFitView:(NSInteger)tag;

@end

@interface HomeFitView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *contractTypeTxt;

@property (nonatomic, strong) UITextField *totalMoneyTxt;

@property (nonatomic, strong) UITextField *nameTxt;

@property (nonatomic, strong) UITextField *phoneTxt;

@property(nonatomic ,strong)UIButton *deleteButton;

@property(nonatomic, weak) id <HomeFitViewDelegate> delegate;

-(void)showHomeFitViewWithDict:(NSDictionary*)dict;

-(void)showCopyHomeFitViewWithDict:(NSDictionary*)dict;

@end
