//
//  DiaryTypeView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/7.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "DiaryTypeView.h"
#import "CXZ.h"


@interface TypeView:UIView

@property(nonatomic , strong) UIImageView *imageView;

@property(nonatomic , strong) UILabel *titleLabel;

@end

@implementation TypeView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-25, 2, 50, 50)];
        [self addSubview:_imageView];
        
        _titleLabel = [CustomView customTitleUILableWithContentView:self title:nil];
        _titleLabel.frame = CGRectMake(0, _imageView.bottom+3, frame.size.width, 20);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

-(void)setTypeViewWithImage:(NSString*)imgeStr title:(NSString*)title
{
    self.imageView.image = [UIImage imageNamed:imgeStr];
    self.titleLabel.text = title;
}

@end

@implementation DiaryTypeView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *bgView = [[UIView alloc]initWithFrame:frame];
        UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBackgroundView)];
        [bgView addGestureRecognizer:tap0];
        [self addSubview:bgView];
        
        UILabel *titleLabel = [CustomView customTitleUILableWithContentView:self title:@"创建一个..."];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.frame = CGRectMake(16, 30, 100, 20);
        
        
        NSArray *imageArray = @[@"diary",@"week",@"mounth",@"signIn"];
        NSArray *titleArray = @[@"日计划",@"周计划",@"月计划",@"外勤签到"];
        NSInteger j = imageArray.count/3+1;
        CGFloat top = 200.0;
        CGFloat width = SCREEN_WIDTH/3;
        CGFloat height = 90;
        for (int i = 0; i < j; i++) {
            if (3*i <imageArray.count) {
                TypeView *typeView = [[TypeView alloc]initWithFrame:CGRectMake(0, top+height*i, width, height)];
                [typeView setTypeViewWithImage:imageArray[3*i] title:titleArray[3*i]];
                typeView.tag = 3*i;
                [self addSubview:typeView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTypeView:)];
                [typeView addGestureRecognizer:tap];
            }
            if (3*i+1 <imageArray.count) {
                TypeView *typeView = [[TypeView alloc]initWithFrame:CGRectMake(width, top+height*i, width, height)];
                [typeView setTypeViewWithImage:imageArray[3*i+1] title:titleArray[3*i+1]];
                typeView.tag = 3*i+1;
                [self addSubview:typeView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTypeView:)];
                [typeView addGestureRecognizer:tap];
            }
            if (3*i+2 <imageArray.count) {
                TypeView *typeView = [[TypeView alloc]initWithFrame:CGRectMake(width*2, top+height*i, width, height)];
                [typeView setTypeViewWithImage:imageArray[3*i+2] title:titleArray[3*i+2]];
                typeView.tag = 3*i+2;
                [self addSubview:typeView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTypeView:)];
                [typeView addGestureRecognizer:tap];
            }
        }
    }
    return self;
}

-(void)clickBackgroundView
{
//    NSLog(@"xiaoshi");
    [self.delegate close];
}

-(void)clickTypeView:(UITapGestureRecognizer*)tap
{
//    NSLog(@"tap %li",tap.view.tag);
   
    [self.delegate clickViewType:tap.view.tag];
    
}

@end
