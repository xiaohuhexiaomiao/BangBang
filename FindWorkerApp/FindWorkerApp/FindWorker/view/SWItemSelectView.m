//
//  SWItemSelectView.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/18.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWItemSelectView.h"
#import "CXZ.h"

#import "ValuePickerView.h"

@interface SWItemSelectView ()<UITextFieldDelegate>

@property (nonatomic, retain) UITextField *numberLbl;

@property (nonatomic, retain) UIView *numberSelect;

@property (nonatomic, retain) UIButton *selectJobBtn;

@end

@implementation SWItemSelectView

-(CGFloat)showView:(SWWorkerTypeData *)typeData {
    
    _workerName = typeData;
    
    UIImage *dow = [UIImage imageNamed:@"dow_unselect"];
    
    UIButton *dowBtn = [[UIButton alloc] init];
    dowBtn.frame     = CGRectMake(0, self.frame.size.height / 2 - dow.size.height / 2, dow.size.width, dow.size.height);
    [dowBtn setImage:dow forState:UIControlStateNormal];
    [dowBtn setImage:[UIImage imageNamed:@"dow_select"] forState:UIControlStateSelected];
    [dowBtn setTitle:typeData.type_name forState:UIControlStateNormal];
    dowBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [dowBtn addTarget:self action:@selector(selectJob:) forControlEvents:UIControlEventTouchUpInside];
    dowBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 1, 0, -1);
    [dowBtn setTitleColor:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00] forState:UIControlStateNormal];
    [self addSubview:dowBtn];
    [dowBtn sizeToFit];
    _selectJobBtn = dowBtn;
    
    
    UIView *numberSelect = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dowBtn.frame) + 5, (self.frame.size.height - 20) / 2 + 2, 40, 20)];
    numberSelect.layer.borderWidth = 0.5;
    numberSelect.layer.cornerRadius = 5;
    numberSelect.layer.masksToBounds = YES;
    numberSelect.layer.borderColor = [UIColor colorWithRed:0.61 green:0.62 blue:0.62 alpha:1.00].CGColor;
    numberSelect.backgroundColor = [UIColor whiteColor];
    [self addSubview:numberSelect];
    _numberSelect = numberSelect;
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectNumber)];
//    [numberSelect addGestureRecognizer:tapGesture];
    
    NSString *num = @"1";
    
    CGSize numSize = [num sizeWithFont:[UIFont systemFontOfSize:10] width:60];
    
    UITextField *numberLbl = [[UITextField alloc] init];
    numberLbl.frame = CGRectMake(numberSelect.frame.size.width / 2 - 10, numberSelect.frame.size.height / 2 - numSize.height / 2, 20, numSize.height);
    numberLbl.text = num;
    numberLbl.textAlignment = NSTextAlignmentCenter;
    numberLbl.font = [UIFont systemFontOfSize:10];
    [numberSelect addSubview:numberLbl];
    numberLbl.keyboardType = UIKeyboardTypePhonePad;
    numberLbl.returnKeyType = UIReturnKeyDone;
    numberLbl.delegate  = self;
    _numberLbl = numberLbl;
    
    UIImage *down = [UIImage imageNamed:@"down"];
    
    UIImageView *downImg = [[UIImageView alloc] init];
    downImg.frame        = CGRectMake(numberSelect.frame.size.width - down.size.width - 5, (numberSelect.frame.size.height - down.size.height) / 2, down.size.width, down.size.height);
//    downImg.image        = down;
    [numberSelect addSubview:downImg];
    
    return CGRectGetMaxX(numberSelect.frame);
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(_selectJobBtn.isSelected) {
        
        if([self.selectViewDelegate respondsToSelector:@selector(selectItem:)]) {
            
            [self.selectViewDelegate selectItem:self];
            
        }
    }
}

- (void)selectNumber {
    
    ValuePickerView *pickerView = [[ValuePickerView alloc] init];
    pickerView.pickerTitle = @"选择工人数量";
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i <= 100; i++) {
        
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [arr addObject:str];
        
    }
    pickerView.dataSource = arr;
    [pickerView show];
    pickerView.valueDidSelect = ^(NSString * value) {
        
        NSString *num = value;
        
        CGSize numSize = [num sizeWithFont:[UIFont systemFontOfSize:10] width:60];
        
        _numberLbl.frame = CGRectMake(_numberSelect.frame.size.width / 2 - numSize.width / 2, _numberSelect.frame.size.height / 2 - numSize.height / 2, numSize.width, numSize.height);
        _numberLbl.text = value;
        
        self.workerNum = [value integerValue];
        
        if(_selectJobBtn.isSelected) {
            
            if([self.selectViewDelegate respondsToSelector:@selector(selectItem:)]) {
                
                [self.selectViewDelegate selectItem:self];
                
            }
            
        }
        
        
        
    };
    
}

- (void)selectJob:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    
//    self.workerName = sender.currentTitle;
    self.workerNum = [_numberLbl.text integerValue];
    
    if(sender.isSelected) {
        
        
        if([self.selectViewDelegate respondsToSelector:@selector(selectItem:)]) {
            
            [self.selectViewDelegate selectItem:self];
            
        }
        
    } else {
        
        if([self.selectViewDelegate respondsToSelector:@selector(deselectItem:)]) {
            
            [self.selectViewDelegate deselectItem:self];
            
        }
        
    }
    
}

@end
