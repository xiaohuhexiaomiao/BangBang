//
//  EnclosureView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/22.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnclosureViewDelegate <NSObject>

-(void)clickEnclosure;

-(void)clickDeleteEnclosure;

@end

@interface EnclosureView : UIView

@property(nonatomic ,strong)UIButton *deleteButton;

@property(nonatomic ,strong)UIButton *enclosureButton;

@property(nonatomic ,weak)id <EnclosureViewDelegate> delegate;

@end
