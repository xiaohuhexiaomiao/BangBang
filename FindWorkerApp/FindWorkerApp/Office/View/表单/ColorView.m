//
//  ColorView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/5.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ColorView.h"
#import "CXZ.h"

@interface ColorView()

@property(nonatomic ,strong)NSArray *colorArray;

@property(nonatomic ,strong)UIView *bgview;

@end

@implementation ColorView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor whiteColor];
        
        _bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 5, frame.size.width, frame.size.height-5)];
        _bgview.layer.cornerRadius= 3;
        _bgview.layer.borderColor = LINE_GRAY.CGColor;
        _bgview.layer.borderWidth = 0.5;
        _bgview.layer.masksToBounds = YES;
        [self addSubview:_bgview];
    }
    return self;
    
}

-(void)setColorCardView:(NSArray *)colorArray
{
    self.colorArray = colorArray;
    NSInteger count = colorArray.count;
    CGFloat height = (self.frame.size.height-5)/count;
    for (int i = 0; i < colorArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorWithHexString:colorArray[i]];
        button.frame = CGRectMake(0, height*i, self.frame.size.width, height);
        button.tag = i;
        [button addTarget:self action:@selector(clickColorButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgview addSubview:button];
        
    }
}

-(void)clickColorButton:(UIButton*)btn
{
    NSInteger tag = btn.tag;
    self.hidden = YES;
    if (_DidClickColorCard) {
        self.DidClickColorCard(self.colorArray[tag]);
    }
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.5); //线宽
    CGContextSetAllowsAntialiasing(context, true);
//    CGContextSetRGBStrokeColor(context, 0.82, 0.82, 0.82, 1.0); //线的颜色
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.frame.size.width/2+2, 0); //起点坐标
    CGContextAddLineToPoint(context, self.frame.size.width/2-3, 5); //终点坐标
    CGContextAddLineToPoint(context, self.frame.size.width/2+7, 5); //终点坐标
    CGContextClosePath(context);
    [[UIColor whiteColor] setFill];
    //设置填充色
    
    
    [LINE_GRAY setStroke]; //设置边框颜色
    
    CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
}


@end
