//
//  DatePickerView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/23.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "DatePickerView.h"
#import "CXZ.h"

@interface DatePickerView ()

@property (nonatomic, strong) NSArray  *monthArray;

@property (nonatomic, strong) NSMutableArray  *yearArray;



@end

@implementation DatePickerView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIPickerView *picker = [[UIPickerView alloc]initWithFrame:frame];
        picker.delegate = self;
        picker.dataSource = self;
        
        [self addSubview:picker];
        _monthArray = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
        _yearArray = [NSMutableArray array];
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
        [calendar setTimeZone: timeZone];
        NSDateComponents *theComponents = [calendar components:kCFCalendarUnitYear|kCFCalendarUnitMonth fromDate:date];
        NSInteger year = theComponents.year;
        NSInteger month = theComponents.month;
        for (int i = 0; i < 20; i++) {
            [self.yearArray addObject:[NSString stringWithFormat:@"%li年",(year-20+i)]];
        }
        for (int i = 0; i < 20; i++) {
            [self.yearArray addObject:[NSString stringWithFormat:@"%li年",(year+i)]];
        }
        [picker selectRow:20 inComponent:0 animated:YES];
        [picker selectRow:(month-1) inComponent:1 animated:YES];
        self.yearString = [NSString stringWithFormat:@"%li年",year];
        self.monthString = [NSString stringWithFormat:@"%li月",month];
    }
    return  self;
    
}

- (BOOL) canBecomeFirstResponder {
    
    return YES;
}

#pragma mark DataSource && Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.datePickerType == 0) {
         return 2;
    }else{
        return 1;
    }
   
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (self.datePickerType == 0) {
        if (component == 0) {
            
            return self.yearArray.count;
            
        } else {
            
            return self.monthArray.count;
        }
    }else if (self.datePickerType == 1){
        return self.yearArray.count;
    }else{
        return self.monthArray.count;
    }
    
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.datePickerType == 0) {
        return SCREEN_WIDTH/2.0;
    }
    return SCREEN_WIDTH;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED {
    
    return 40;
}


- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (self.datePickerType == 0) {
        if (component == 0) {
            return self.yearArray[row];
        } else {
            
            return self.monthArray[row];
        }
    }else if (self.datePickerType == 1){
        return self.yearArray[row];
    }else{
        return self.monthArray[row];
    }

    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.datePickerType == 0) {
        if (component == 0) {
            self.yearString = self.yearArray[row];
        }else if (component == 1){
            self.monthString = self.monthArray[row];
        }
    }else if (self.datePickerType == 1){
        self.yearString = self.yearArray[row];
    }else{
        self.monthString = self.monthArray[row];
    }
    
    
}



@end
