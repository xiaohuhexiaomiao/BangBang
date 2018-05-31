//
//  PurchaseView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/27.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PurchaseViewDelegate <NSObject>

-(void)deletePurchaseView:(NSInteger)tag;

@end

@interface PurchaseView : UIView

@property(nonatomic ,weak) id <PurchaseViewDelegate>delegate;

@property(nonatomic ,strong)UITextField *nameTxt;

@property(nonatomic ,strong)UITextField *normsTxt;//型号

@property(nonatomic ,strong)UITextField *typeTxt;//规格

@property(nonatomic ,strong)UITextField *unitTxt;

@property(nonatomic ,strong)UITextField *numTxt;

@property(nonatomic ,strong)UITextField *priceTxt;

@property(nonatomic ,strong)UITextField *totalMoneyTxt;

@property(nonatomic ,strong)UITextView *usesTxt;

@property(nonatomic ,strong)UITextView *markTxt;

@property(nonatomic ,strong)UIButton *deleteButton;

-(CGFloat)showPurchaseViewWithDict:(NSDictionary*)dict;
-(void)showCopyPurchaseViewWithDict:(NSDictionary*)dict;

@end
