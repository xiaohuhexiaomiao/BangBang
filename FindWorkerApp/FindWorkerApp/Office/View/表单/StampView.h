//
//  StampView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/29.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StampViewDelegate <NSObject>

-(void)deleteStampView:(NSInteger)tag;

@end
@interface StampView : UIView

@property(nonatomic ,strong)UITextField *reasonTxt;

@property(nonatomic ,strong)UITextField *fileNameTxt;

@property(nonatomic ,strong)UITextField *numTxt;

@property(nonatomic ,strong)UITextField *remarkTxt;

@property(nonatomic ,strong)UITextField *selectedCompanyButton;

@property(nonatomic ,copy)NSString *companyType;

@property(nonatomic ,copy)NSString *stampType;

@property(nonatomic ,weak)id <StampViewDelegate> delegate;

-(void)showCopyStampViewData:(NSDictionary*)dict;

@end
