//
//  ShowExpenseAccountView.m
//  FindWorkerApp
//
//  Created by cxz on 2018/2/7.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "ShowExpenseAccountView.h"
#import "CXZ.h"
#import "ExpenseListModel.h"
@interface ShowExpenseAccountView()

@property(nonatomic ,strong)UILabel *moneyTextfield;//金额

@property(nonatomic ,strong)UILabel *dayLabel;//发生日期

@property(nonatomic ,strong)UILabel *contentTextView;//报销内容

@property(nonatomic ,strong)UILabel *numberTextfield;//单据张数

@property(nonatomic ,strong)UILabel *markTextView;//备注

@property(nonatomic ,strong)UILabel *moneyWordsLabel;//大写金额

@end

@implementation ShowExpenseAccountView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat width = frame.size.width;
        NSString *time = @"发生时间：";
        CGSize timeSize =[time sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *timeLabel = [CustomView customTitleUILableWithContentView:self title:time];
        //        timeLabel.frame = CGRectMake(8, 5, timeSize.width+1, 20);
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(timeSize.width+1);
            make.height.mas_equalTo(20);
        }];
        
        _dayLabel = [CustomView customContentUILableWithContentView:self title:nil];
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeLabel.mas_top);
            make.left.mas_equalTo(timeLabel.mas_right);
            make.width.mas_equalTo(width-timeSize.width-38);
            make.height.mas_equalTo(20);
        }];
        
        
        NSString *content = @"报销内容：";
        CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *contentLabel = [CustomView customTitleUILableWithContentView:self title:content];
        //        contentLabel.frame = CGRectMake(timeLabel.left, timeLabel.bottom, contentSize.width+1, 30);
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeLabel.mas_bottom);
            make.left.mas_equalTo(timeLabel.mas_left);
            make.width.mas_equalTo(contentSize.width+1);
            make.height.mas_equalTo(20);
        }];
        
        _contentTextView = [CustomView customContentUILableWithContentView:self title:nil];
        _contentTextView.frame = CGRectMake(contentLabel.right, contentLabel.top, width-contentSize.width-17, 30);
        [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentLabel.mas_top);
            make.left.mas_equalTo(contentLabel.mas_right);
            make.width.mas_equalTo(width-contentSize.width-17);
            make.height.mas_equalTo(30);
        }];
        _contentTextView.numberOfLines = 0;
        
        NSString *number = @"单据张数：";
        CGSize numberSize = [number sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *numberLabel = [CustomView customTitleUILableWithContentView:self title:number];
        //        numberLabel.frame = CGRectMake(timeLabel.left, _contentTextView.bottom, numberSize.width+1, 20);
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentTextView.mas_bottom).mas_offset(3);
            make.left.mas_equalTo(timeLabel.mas_left);
            make.width.mas_equalTo(numberSize.width+1);
            make.height.mas_equalTo(20);
        }];
        
        
        _numberTextfield = [CustomView customContentUILableWithContentView:self title:nil];
        [_numberTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(numberLabel.mas_top);
            make.left.mas_equalTo(numberLabel.mas_right);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(20);
        }];
        
        NSString *money = @"合计金额：";
        CGSize moneySize = [money sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *monyLabel = [CustomView customTitleUILableWithContentView:self title:money];
        //        monyLabel.frame = CGRectMake(_numberTextfield.right, _numberTextfield.top,moneySize.width+1 , numberLabel.height);
        [monyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(numberLabel.mas_top);
            make.left.mas_equalTo(_numberTextfield.mas_right);
            make.width.mas_equalTo(moneySize.width+1);
            make.height.mas_equalTo(20);
        }];
        
        _moneyTextfield = [CustomView customContentUILableWithContentView:self title:nil];
        [_moneyTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(monyLabel.mas_top);
            make.left.mas_equalTo(monyLabel.mas_right);
            make.width.mas_equalTo(width-moneySize.width-numberSize.width-106);
            make.height.mas_equalTo(20);
        }];
        
        NSString *moneywords = @"大写金额：";
        CGSize wordsSize = [moneywords sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *wordsLabel = [CustomView customTitleUILableWithContentView:self title:moneywords];
        [wordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_moneyTextfield.mas_bottom);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(wordsSize.width+1);
            make.height.mas_equalTo(20);
        }];
        
        _moneyWordsLabel = [CustomView customContentUILableWithContentView:self title:nil];
        [_moneyWordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(wordsLabel.mas_top);
            make.left.mas_equalTo(wordsLabel.mas_right);
            make.width.mas_equalTo(SCREEN_WIDTH-wordsSize.width-17);
            make.height.mas_equalTo(20);
        }];
        
        NSString *markStr = @"备注：";
        CGSize markSize = [markStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *markLabel = [CustomView customTitleUILableWithContentView:self title:markStr];
        [markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_moneyWordsLabel.mas_bottom);
            make.left.mas_equalTo(timeLabel.mas_left);
            make.width.mas_equalTo(markSize.width+1);
            make.height.mas_equalTo(20);
        }];
        
        _markTextView = [CustomView customContentUILableWithContentView:self title:nil];
        _markTextView.frame = CGRectMake(markLabel.right, markLabel.top, width-markSize.width-18, 30);
        [_markTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(markLabel.mas_top);
            make.left.mas_equalTo(markLabel.mas_right);
            make.width.mas_equalTo(width-markSize.width-17);
            make.height.mas_equalTo(30);
        }];
//        _markTextView.backgroundColor = [UIColor greenColor];
        _markTextView.numberOfLines = 0;
        
        UIView *line = [CustomView customLineView:self];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.markTextView.mas_bottom).mas_offset(2);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(width-16);
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
}

-(CGFloat)showExpenseViewWithDict:(NSDictionary *)dict
{
   
    
    ExpenseListModel *listModel = [ExpenseListModel objectWithKeyValues:dict];
    self.dayLabel.text = listModel.month_day;
    self.numberTextfield.text = [NSString stringWithFormat:@"%@",@(listModel.amount)];
    self.moneyTextfield.text = [NSString stringWithFormat:@"%@",@(listModel.price)];
    self.moneyWordsLabel.text = listModel.big_price;
    CGFloat viewheight = 30.0;
    
    if (![NSString isBlankString:listModel.content]) {
        self.contentTextView.text = listModel.content;
        CGSize size = CGSizeMake(self.contentTextView.width,CGFLOAT_MAX);
        CGSize labelsize = [listModel.content sizeWithFont:self.contentTextView.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        viewheight = labelsize.height < 30.0 ? 30.0 : labelsize.height;
        [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(viewheight);
        }];
        
    }
    CGFloat markHeight = 30.0;
    
    if (![NSString isBlankString:listModel.remarks]) {
        NSString *mark = [NSString stringWithFormat:@"%@",listModel.remarks];
        self.markTextView.text = mark;
        CGSize size = CGSizeMake(self.markTextView.width,CGFLOAT_MAX);
        CGSize marksize = [mark sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        markHeight = marksize.height < 30.0 ? 30.0 : marksize.height;
        [self.markTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(markHeight+3);
        }];
        
    }
    return 80+markHeight+viewheight;
    
}



@end
