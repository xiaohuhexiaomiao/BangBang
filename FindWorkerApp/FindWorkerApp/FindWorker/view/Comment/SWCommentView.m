//
//  SWCommentView.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/23.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWCommentView.h"

#import "CXZ.h"

#define padding 10

@interface SWCommentView ()

@property (nonatomic, retain) UIImageView *iconView;

@property (nonatomic, retain) UILabel *phoneLbl;

@property (nonatomic, retain) UILabel *timeLbl;

@property (nonatomic, retain) UILabel *contentLbl;

@property (nonatomic, retain) UILabel *stateLbl;

@end

@implementation SWCommentView


- (instancetype)init {
    
    if(self = [super init]) {
        
        //初始化界面
        [self initWithView];
        
    }
    
    return self;
    
}

//初始化界面
- (void)initWithView {
    
    _iconView = [[UIImageView alloc] init];
    [self addSubview:_iconView];
    
    _phoneLbl = [[UILabel alloc] init];
    _phoneLbl.font = [UIFont systemFontOfSize:12];
    _phoneLbl.textColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.17 alpha:1.00];
    [self addSubview:_phoneLbl];
    
    _timeLbl = [[UILabel alloc] init];
    _timeLbl.font = [UIFont systemFontOfSize:10];
    _timeLbl.textColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.17 alpha:1.00];
    [self addSubview:_timeLbl];
    
    _contentLbl = [[UILabel alloc] init];
    _contentLbl.font = [UIFont systemFontOfSize:12];
    _contentLbl.textColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.17 alpha:1.00];;
    _contentLbl.numberOfLines = 0;
    [self addSubview:_contentLbl];
    
    _stateLbl = [[UILabel alloc] init];
    _stateLbl.font = [UIFont systemFontOfSize:12];
    [self addSubview:_stateLbl];
    
}

//显示数据
//imageName:图片名称
//phone:手机号码
//time:时间
//content:内容
//state:状态 1:非常满意 2:满意 3:不满意
//return 行高
- (CGFloat)showData:(NSString *)imageName phone:(NSString *)phone time:(NSString *)time content:(NSString *)content state:(NSInteger)state{
    
    CGFloat cellHeight = 0.0f;
    
    _iconView.frame = CGRectMake(padding, padding, 30, 30);
    _iconView.layer.cornerRadius = _iconView.frame.size.height / 2;
    _iconView.layer.masksToBounds = YES;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"temp"]];
    
    CGSize phoneSize = [phone sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    CGFloat phoneX = CGRectGetMaxX(_iconView.frame) + padding;
    CGFloat phoneY = padding;
    CGFloat phoneW = phoneSize.width;
    CGFloat phoneH = phoneSize.height;
    
    _phoneLbl.frame = CGRectMake(phoneX, phoneY, phoneW, phoneH);
    _phoneLbl.text = phone;
    
    
    CGSize timeSize = [time sizeWithFont:[UIFont systemFontOfSize:10] width:SCREEN_WIDTH];
    
    CGFloat timeX = phoneX;
    CGFloat timeY = CGRectGetMaxY(_phoneLbl.frame) + padding;
    CGFloat timeW = timeSize.width;
    CGFloat timeH = timeSize.height;
    
    _timeLbl.frame = CGRectMake(timeX, timeY, timeW, timeH);
    _timeLbl.text = time;
    
    NSString *stateStr = @"";
    UIColor *stateColor = [UIColor colorWithRed:0.87 green:0.32 blue:0.33 alpha:1.00];
    
    if(state == 0) {
        
        stateStr = @"非常满意";
        stateColor = [UIColor colorWithRed:0.87 green:0.32 blue:0.33 alpha:1.00];
        
    }else if(state == 1) {
        
        stateStr = @"满意";
        stateColor = [UIColor colorWithRed:0.91 green:0.65 blue:0.47 alpha:1.00];
        
    }else {
        
        stateStr = @"不满意";
        stateColor = [UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1.00];
        
    }
    
    CGSize stateSize = [stateStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    
    CGFloat stateX = SCREEN_WIDTH - padding - stateSize.width;
    CGFloat stateY = phoneY;
    CGFloat stateW = stateSize.width;
    CGFloat stateH = stateSize.height;
    
    _stateLbl.frame = CGRectMake(stateX, stateY, stateW, stateH);
    _stateLbl.text = stateStr;
    _stateLbl.textColor = stateColor;
    
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH - phoneX - padding];
    
    CGFloat contentX = phoneX;
    CGFloat contentY = CGRectGetMaxY(_timeLbl.frame) + padding;
    CGFloat contentW = contentSize.width;
    CGFloat contentH = contentSize.height;
    
    _contentLbl.frame = CGRectMake(contentX, contentY, contentW, contentH);
    _contentLbl.text = content;
    
    cellHeight = CGRectGetMaxY(_contentLbl.frame) + padding;
    
    return cellHeight;
    
}

@end
