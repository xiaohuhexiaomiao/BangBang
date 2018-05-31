//
//  AdressBookButton.h
//  FindWorkerApp
//
//  Created by cxz on 2017/8/24.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdressBookViewController.h"


@interface AdressBookButton : UIButton<AdressBookDelegate>

@property(nonatomic ,copy)NSString *companyID;

@property(nonatomic ,copy) void (^ DidSelectObjectBlock)(NSDictionary *dict);

@end
