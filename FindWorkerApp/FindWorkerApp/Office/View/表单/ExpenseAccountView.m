//
//  ExpenseAccountView.m
//  FindWorkerApp
//
//  Created by cxz on 2018/1/5.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "ExpenseAccountView.h"
#import "CXZ.h"
#import "ExpenseListModel.h"
@interface ExpenseAccountView ()<UITextFieldDelegate>

//@property(nonatomic ,strong)UILabel *moneyWordsLabel;

@end

@implementation ExpenseAccountView

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
        
        _dayButton = [CustomView customButtonWithContentView:self image:nil title:nil];
//        _dayButton.frame = CGRectMake(timeLabel.right, timeLabel.top, width-timeLabel.right-30, 20);
        [_dayButton addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
        [_dayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeLabel.mas_top);
            make.left.mas_equalTo(timeLabel.mas_right);
            make.width.mas_equalTo(width-timeSize.width-38);
            make.height.mas_equalTo(20);
        }];
        
        _deleteButton = [CustomView customButtonWithContentView:self image:@"delete" title:nil];
//        _deleteButton.frame = CGRectMake(_dayButton.right+5, 2, 20, 20);
        [_deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(2);
            make.left.mas_equalTo(_dayButton.mas_right).mas_offset(5);
            make.width.mas_equalTo(20);
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
            make.height.mas_equalTo(30);
        }];
        
        _contentTextView = [CustomView customUITextViewWithContetnView:self placeHolder:nil];
        _contentTextView.frame = CGRectMake(contentLabel.right, contentLabel.top, width-contentLabel.right-8, 30);
        [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentLabel.mas_top);
            make.left.mas_equalTo(contentLabel.mas_right);
            make.width.mas_equalTo(width-contentSize.width-17);
            make.height.mas_equalTo(30);
        }];
        
        NSString *number = @"单据张数：";
        CGSize numberSize = [number sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *numberLabel = [CustomView customTitleUILableWithContentView:self title:number];
//        numberLabel.frame = CGRectMake(timeLabel.left, _contentTextView.bottom, numberSize.width+1, 20);
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentTextView.mas_bottom);
            make.left.mas_equalTo(timeLabel.mas_left);
            make.width.mas_equalTo(numberSize.width+1);
            make.height.mas_equalTo(20);
        }];
        
        
        _numberTextfield = [CustomView customUITextFieldWithContetnView:self placeHolder:nil];
//        _numberTextfield.frame = CGRectMake(numberLabel.right, numberLabel.top, 80, numberLabel.height);
        _numberTextfield.keyboardType = UIKeyboardTypeDecimalPad;
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
        
        _moneyTextfield = [CustomView customUITextFieldWithContetnView:self placeHolder:nil];
//        _moneyTextfield.frame = CGRectMake(monyLabel.right, monyLabel.top, width-monyLabel.right-8, numberLabel.height);
        _moneyTextfield.keyboardType = UIKeyboardTypeDecimalPad;
        [_moneyTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(monyLabel.mas_top);
            make.left.mas_equalTo(monyLabel.mas_right);
            make.width.mas_equalTo(width-moneySize.width-numberSize.width-106);
            make.height.mas_equalTo(20);
        }];
//        _moneyTextfield.text = [NSString stringWithFormat:@"%@",@(0)];
        _moneyTextfield.delegate = self;
        
        NSString *moneywords = @"大写金额：";
        CGSize wordsSize = [moneywords sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *wordsLabel = [CustomView customTitleUILableWithContentView:self title:moneywords];
        [wordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_moneyTextfield.mas_bottom);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(wordsSize.width+1);
            make.height.mas_equalTo(30);
        }];
        
        _moneyWordsLabel = [CustomView customContentUILableWithContentView:self title:nil];
        [_moneyWordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(wordsLabel.mas_top);
            make.left.mas_equalTo(wordsLabel.mas_right);
            make.width.mas_equalTo(SCREEN_WIDTH-wordsSize.width-17);
            make.height.mas_equalTo(30);
        }];
        
        NSString *markStr = @"备注：";
        CGSize markSize = [markStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *markLabel = [CustomView customTitleUILableWithContentView:self title:markStr];
//        markLabel.frame = CGRectMake(timeLabel.left, _moneyTextfield.bottom, markSize.width+1, 30);
        [markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_moneyWordsLabel.mas_bottom);
            make.left.mas_equalTo(timeLabel.mas_left);
            make.width.mas_equalTo(markSize.width+1);
            make.height.mas_equalTo(30);
        }];
        
        _markTextView = [CustomView customUITextViewWithContetnView:self placeHolder:nil];
        _markTextView.frame = CGRectMake(markLabel.right, markLabel.top, width-markLabel.right-8, 30);
        [_markTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(markLabel.mas_top);
            make.left.mas_equalTo(markLabel.mas_right);
            make.width.mas_equalTo(width-markSize.width-17);
            make.height.mas_equalTo(30);
        }];

        UIView *line = [CustomView customLineView:self];
//        line.frame = CGRectMake(8, frame.size.height-1, frame.size.width-16, 1);
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(width-16);
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
}

-(void)showCopyExpenseViewWithDict:(NSDictionary*)dict
{
    ExpenseListModel *listModel = [ExpenseListModel objectWithKeyValues:dict];
    [self.dayButton setTitle:listModel.month_day forState:UIControlStateNormal];
    self.numberTextfield.text = [NSString stringWithFormat:@"%@",@(listModel.amount)];
    self.moneyTextfield.text = [NSString stringWithFormat:@"%@",@(listModel.price)];
    self.moneyWordsLabel.text = [NSString stringWithFormat:@"大写金额：%@",listModel.big_price];
    if (![NSString isBlankString:listModel.content]) {
        self.contentTextView.text = listModel.content;
    }
    if (![NSString isBlankString:listModel.remarks]) {
        self.markTextView.text = listModel.remarks;
    }
}


-(void)selectDate:(UIButton*)button
{
    
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    //    picker.minimumDate = [NSDate date];
    picker.frame = CGRectMake(0, 40, 320, 200);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择时间\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSDate *date = picker.date;
        [self.dayButton setTitle:[date stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        
        
    }];
    [alertController.view addSubview:picker];
    [alertController addAction:cancelAction];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

-(void)clickDeleteButton:(UIButton*)button
{
    [self.delegate deleteExpenseAccountView:self.tag];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
//    NSLog(@"textField4 - 结束编辑");
    NSString *ammontWords = [NSString digitUppercase:textField.text];
    self.moneyWordsLabel.text = ammontWords;
    [self.delegate editMoneyDone];
}

@end
