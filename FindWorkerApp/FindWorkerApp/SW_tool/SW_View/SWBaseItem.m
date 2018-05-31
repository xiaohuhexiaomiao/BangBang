//
//  SWBaseItem.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWBaseItem.h"

#import "CXZ.h"

@interface SWBaseItem ()

@property (nonatomic, retain) UILabel *titleLbl;

@property (nonatomic, retain) UIButton *SelectBtn;

@end

@implementation SWBaseItem

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        [self initWithView];
        
    }
    
    return self;
    
}

//初始化界面
- (void)initWithView {
    
    _titleLbl = [[UILabel alloc] init];
    _titleLbl.font = [UIFont systemFontOfSize:12];
    [self addSubview:_titleLbl];
    
    _SelectBtn = [[UIButton alloc] init];
    _SelectBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_SelectBtn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_SelectBtn];
    
}

//展示数据
- (void)showData {
    
    _titleLbl.textColor = _UnselectColor;
    _titleLbl.text = _title;
    
    CGSize titleSize = [_title sizeWithFont:[UIFont systemFontOfSize:12] width:self.frame.size.width];
    _titleLbl.frame = CGRectMake((self.frame.size.width - titleSize.width) / 2, (self.frame.size.height - titleSize.height) / 2, titleSize.width, titleSize.height);
    
    _SelectBtn.tag = _page;
    
}

- (void)selectItem:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    
    if(sender.isSelected) {
        
        _titleLbl.textColor = _SelectColor;
        
        if([self.SWBasedelegate respondsToSelector:@selector(selectSWItem:)]) {
            
            [self.SWBasedelegate selectSWItem:self];
            
        }
        
    }else {
        
        _titleLbl.textColor = _UnselectColor;
        
    }
    
    
    
}

- (void)setSelect:(BOOL)select {
    
    _SelectBtn.selected = !select;
    
    [self selectItem:_SelectBtn];
    
}



@end
