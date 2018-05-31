//
//  SWBaseTopView.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWBaseTopView.h"

#import "CXZ.h"

#import "SWBaseController.h"

#define minW 125

#import "SWBaseItem.h"

@interface SWBaseTopView ()<SWBaseItemDelegate>

@property (nonatomic, retain) UIScrollView *topContent;

@property (nonatomic, retain) UIView *line;

@property (nonatomic, assign) CGFloat itemWid; //item宽度

@property (nonatomic, retain) NSMutableArray *itemArr;

@end

@implementation SWBaseTopView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        _itemArr = [NSMutableArray array];
        
        _topContent = [[UIScrollView alloc] init];
        _topContent.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height - 1);
        [self addSubview:_topContent];
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1.00];
        [self addSubview:_line];
        
    }
    
    return self;
    
}

- (void)setTotalPage:(NSInteger)totalPage {
    
    _totalPage = totalPage;
    
    CGFloat width = SCREEN_WIDTH / 3;
    
    if(width >= minW) {
        
        width = minW;
        
    }
    
    _currentPage = 1;
    
    _itemWid = width;
    
    _line.frame = CGRectMake(0, CGRectGetMaxY(_topContent.frame), width, 1);
    
    _topContent.contentSize = CGSizeMake(width * totalPage, 0);
    
    for (int i = 0; i < _totalPage; i++) {
        
        NSString *title = _titleArr[i];
        
        SWBaseItem *item = [[SWBaseItem alloc] initWithFrame:CGRectMake(i * width, 0, width, self.frame.size.height - 1)];
        item.page = i + 1;
        item.title = title;
        item.UnselectColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1.00];
        item.SelectColor = [UIColor colorWithRed:0.53 green:0.75 blue:0.99 alpha:1.00];
        [item showData];
        item.SWBasedelegate = self;
        [_topContent addSubview:item];
        
        if(i == 0) {
            
            [item setSelect:YES];
            
        }
        
        [_itemArr addObject:item];

        
    }
 
}

- (void)selectSWItem:(SWBaseItem *)item {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _line.frame = CGRectMake((item.page - 1) * _itemWid, CGRectGetMaxY(_topContent.frame), _itemWid, 1);
        
    }];
    
    for (SWBaseItem *item1 in _itemArr) {
        
        if(item1.page != item.page) {
            
            [item1 setSelect:NO];
            
        }
        
    }
    
    _currentPage = item.page;
    if(_isClick) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PAGE_CHANGE" object:nil userInfo:@{@"page":[NSString stringWithFormat:@"%ld",(long)_currentPage]}];
        
        
    }else {
    
        _isClick = YES;
        
    }
    
    
}

- (void)setCurrentPage:(NSInteger)currentPage {
    
    _currentPage = currentPage;
    _isClick = NO;
    for (SWBaseItem *item in _itemArr) {
        
        if(item.page == _currentPage) {
            
            [item setSelect:YES];
            
        }
        
    }
    
}

@end
