//
//  SingleComponentDelegate.m
//  DataSourceDelegate
//
//  Created by 闫建刚 on 15/6/3.
//  Copyright (c) 2015年 闫建刚. All rights reserved.
//

#import "SingleComponentDelegate.h"

@interface SingleComponentDelegate()


@end

@implementation SingleComponentDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _dataSource.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _dataSource[row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _lastSelectedIndex = row;
    id selectedRow = _dataSource[row];
    if (_selectedRowChanged) {
        _selectedRowChanged(selectedRow, row);
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont systemFontOfSize:14];
        pickerLabel.adjustsFontSizeToFitWidth = NO;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
       
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

@end
