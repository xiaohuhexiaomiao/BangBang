//
//  ExpenseAccountView.h
//  FindWorkerApp
//
//  Created by cxz on 2018/1/5.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ExpenseAccountViewDelegate <NSObject>

-(void)deleteExpenseAccountView:(NSInteger)tag;

-(void)editMoneyDone;

@end
@interface ExpenseAccountView : UIView

@property(nonatomic ,strong)UITextField *moneyTextfield;//金额

@property(nonatomic ,strong)UIButton *dayButton;//发生日期

@property(nonatomic ,strong)UITextView *contentTextView;//报销内容

@property(nonatomic ,strong)UITextField *numberTextfield;//单据张数

@property(nonatomic ,strong)UITextView *markTextView;//备注

@property(nonatomic ,strong)UILabel *moneyWordsLabel;

@property(nonatomic ,strong)UIButton *deleteButton;

@property(nonatomic ,weak) id <ExpenseAccountViewDelegate>delegate;

-(void)showCopyExpenseViewWithDict:(NSDictionary*)dict;

@end
