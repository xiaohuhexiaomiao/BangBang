//
//  ToolCollectionCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/4/13.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ToolCollectionCell.h"
#import "CXZ.h"
@implementation ToolCollectionCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 2, 30, 40)];
        //        _headImgView.center = CGPointMake(self.bounds.size.width/2, 17);
        //        _headImgView.layer.cornerRadius = 15;
        //        _headImgView.layer.masksToBounds = YES;
        //        _headImgView.image = nil;
        //        [self addSubview:_headImgView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width-1, self.bounds.size.height)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.textColor = TITLECOLOR;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTop)];
        _nameLabel.userInteractionEnabled = YES;
        [_nameLabel addGestureRecognizer:tap];
        [self addSubview:_nameLabel];
    }
    return self;
}
-(void)clickTop
{
//    NSLog(@"clickk");
    [self.delegate clickCollectionCell:self.dict[@"wid"]];
}
-(void)setHeadImgViewWithUrl:(NSURL*)url Title:(NSString*)title
{
    //    [self.headImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"face_default"]];
    self.nameLabel.text = title;
}


@end
