//
//  CompanyFitView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/7/5.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CompanyFitViewDelegate <NSObject>

-(void)deleteCompanyFitView:(NSInteger)tag;

@end

@interface CompanyFitView : UIView<UITextFieldDelegate>

@property(nonatomic ,strong) UITextField *goodsNameTxt;

@property(nonatomic ,strong) UITextField *unitTxt;

@property(nonatomic ,strong) UITextField *numTxt;

@property(nonatomic ,strong) UITextField *priceTxt;

@property(nonatomic ,strong) UITextField *countTxt;

@property(nonatomic ,strong) UITextField *linkNameTxt;

@property(nonatomic ,strong) UITextField *linkPhoneTxt;

@property(nonatomic ,strong)UIButton *deleteButton;

@property(nonatomic, weak) id <CompanyFitViewDelegate>delegate;

-(void)showCompanyFitViewWithDict:(NSDictionary*)dict;

-(void)showCopyCompanyFitViewWithDict:(NSDictionary*)dict;

@end
