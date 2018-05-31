//
//  PersonCollectionViewCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "PersonCollectionViewCell.h"
#import "CXZ.h"
@implementation PersonCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _per_avatarImageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
        _per_avatarImageview.image = [UIImage imageNamed:@"temp"];
        _per_avatarImageview.layer.cornerRadius = _per_avatarImageview.frame.size.width/2;
        _per_avatarImageview.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAdd:)];
        _per_avatarImageview.userInteractionEnabled = YES;
        [_per_avatarImageview addGestureRecognizer:tap];
        [self addSubview:_per_avatarImageview];
        
        _per_nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _per_avatarImageview.bottom, frame.size.width, 20)];
        _per_nameLabel.textAlignment = NSTextAlignmentCenter;
        _per_nameLabel.font = [UIFont systemFontOfSize:10];
        _per_nameLabel.textColor = SUBTITLECOLOR;
        [self addSubview:_per_nameLabel];
        
//        _per_departLabel = [[UILabel alloc]initWithFrame:CGRectMake(_per_nameLabel.left, _per_nameLabel.bottom, _per_nameLabel.width, _per_nameLabel.height)];
//        _per_departLabel.textAlignment = NSTextAlignmentCenter;
//        _per_departLabel.font = [UIFont systemFontOfSize:10];
//        _per_departLabel.textColor = SUBTITLECOLOR;
//        [self addSubview:_per_departLabel];
        
        _per_deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _per_deleteBtn.frame = CGRectMake(frame.size.width-20, 0, 20, 20);
//        [_per_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_per_deleteBtn setTitle:@"×" forState:UIControlStateNormal];
        [_per_deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _per_deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _per_deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [_per_deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: _per_deleteBtn];
        
    }
    return self;
}



-(void)clickDeleteBtn :(UIButton*)btn
{
    NSInteger tag = [btn superview].tag;
//    NSLog(@"点击了删除");
    [self.delegate clickPersonCOllectionCell:@"delete" withIndex:tag];
}

-(void)clickAdd:(UITapGestureRecognizer*)tap
{
    if (self.isEdit) {
        NSInteger tag = [(UIButton*)tap.view superview].tag;
        UIImage *temp = [UIImage imageNamed:@"add"];
        NSData *tempData = UIImagePNGRepresentation(temp);
        NSData *data = UIImagePNGRepresentation(self.per_avatarImageview.image);
        if ([data isEqualToData:tempData]) {
            //        NSLog(@"add");
            [self.delegate clickPersonCOllectionCell:@"add" withIndex:tag];
        }
    }
    
}

@end
