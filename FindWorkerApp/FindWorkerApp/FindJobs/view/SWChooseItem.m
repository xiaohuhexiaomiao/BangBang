//
//  SWChooseItem.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/18.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWChooseItem.h"
#import "CXZ.h"

#import "SWWorkerTypeData.h"


@implementation SWChooseItem{

    UILabel *_titleLbl;
    UIImageView *_accessImg;
    UIButton *_selectBtn;
    UIView   *_selectline;
    UIScrollView *_contentView;
    
}

-(void)setTitle:(NSString *)title {
    
    _title = title;
    
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH / 3];
    
    _titleLbl = [[UILabel alloc] init];
    _titleLbl.frame    = CGRectMake(self.frame.size.width / 2 - titleSize.width / 2, (self.frame.size.height - titleSize.height) / 2, titleSize.width, titleSize.height);
    _titleLbl.textColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1.00];
    _titleLbl.font     = [UIFont systemFontOfSize:15];
    _titleLbl.text     = title;
    [self addSubview:_titleLbl];
    
    UIImage *image = [UIImage imageNamed:@"arrow_gray"];
    
    _accessImg = [[UIImageView alloc] init];
    _accessImg.frame = CGRectMake(CGRectGetMaxX(_titleLbl.frame) + 5, (self.frame.size.height - image.size.height) / 2, image.size.width, image.size.height);
    _accessImg.image = image;
    [self addSubview:_accessImg];
    
    _selectline = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, self.frame.size.width, 2)];
    _selectline.hidden = YES;
    _selectline.backgroundColor = [UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1.00];
    [self addSubview:_selectline];
    
    _selectBtn = [[UIButton alloc] init];
    _selectBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_selectBtn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectBtn];
    
}


- (void)selectItem:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    _isSelect = sender.isSelected;
    
    if(sender.isSelected) {
    
        _selectline.hidden = NO;
        _contentView.hidden = NO;
        _accessImg.image = [UIImage imageNamed:@"arrow_blue"];
        _titleLbl.textColor = [UIColor colorWithRed:0.60 green:0.78 blue:0.96 alpha:1.00];
        
    }else {
    
        _selectline.hidden = YES;
        _contentView.hidden = YES;
        _accessImg.image = [UIImage imageNamed:@"arrow_gray"];
        _titleLbl.textColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1.00];
        
    }
    
    if([self.Choosedelegate respondsToSelector:@selector(selectItem:)]) {
    
        [self.Choosedelegate selectItem:self];
        
    }
    
    
}

//设置强制选择
//select：是否选择
- (void)setSelect:(BOOL)select {
    
    _selectBtn.selected = select;
    if(_selectBtn.isSelected) {
        
        _selectline.hidden = NO;
        _contentView.hidden = NO;
        _accessImg.image = [UIImage imageNamed:@"arrow_blue"];
        _titleLbl.textColor = [UIColor colorWithRed:0.60 green:0.78 blue:0.96 alpha:1.00];
        
    }else {
        
        _selectline.hidden = YES;
        _contentView.hidden = YES;
        _accessImg.image = [UIImage imageNamed:@"arrow_gray"];
        _titleLbl.textColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1.00];
        
    }
    
}

@end
