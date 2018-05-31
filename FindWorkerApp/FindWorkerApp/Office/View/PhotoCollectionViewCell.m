//
//  PhotoCollectionViewCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/12/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "CXZ.h"
@implementation PhotoCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photoImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _photoImageview.image = [UIImage imageNamed:@"placeholder"];
        _photoImageview.layer.masksToBounds = YES;
        [self addSubview:_photoImageview];
        
    }
    return self;
}



@end
