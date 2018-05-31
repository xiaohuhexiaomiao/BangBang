//
//  EnclosureView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/22.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "EnclosureView.h"
#import "CXZ.h"

@implementation EnclosureView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        _enclosureButton = [CustomView customButtonWithContentView:self image:nil title:@"附件"];
        [_enclosureButton addTarget:self action:@selector(clickEnclosureButton) forControlEvents:UIControlEventTouchUpInside];
        _enclosureButton.frame = CGRectMake(0, 2, 30, 30);
        [_enclosureButton setTitleColor:TOP_GREEN forState:UIControlStateNormal];
        
        _deleteButton = [CustomView customButtonWithContentView:self image:@"delete" title:nil];
        [_deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.frame = CGRectMake(_enclosureButton.right, 0, 25, 25);
    }
    return self;

}


-(void)clickEnclosureButton
{
    [self.delegate clickEnclosure];
}

-(void)clickDeleteButton
{
    [self.delegate clickDeleteEnclosure];
}

@end
