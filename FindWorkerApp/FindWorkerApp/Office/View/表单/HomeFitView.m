//
//  HomeFitView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/7/5.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "HomeFitView.h"
#import "CXZ.h"
@implementation HomeFitView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *contractStr = @"承包方式：";
        CGSize contractSize = [contractStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *contractType = [self customUILabelWithFrame:CGRectMake(8, 0, contractSize.width, 25) title:contractStr];
        [self addSubview:contractType];
        
        _contractTypeTxt = [self customTextFieldWithFrame:CGRectMake(contractType.right, contractType.top, SCREEN_WIDTH-contractType.right-20, contractType.height)];
        [self addSubview:_contractTypeTxt];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(SCREEN_WIDTH-20, 0, 20, 20);
        [_deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        NSString *totalStr = @"合同金额：";
        CGSize totalSize = [totalStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *totalLabel = [self customUILabelWithFrame:CGRectMake(contractType.left, contractType.bottom, totalSize.width, contractType.height) title:totalStr];
        [self addSubview:totalLabel];
        
        _totalMoneyTxt = [self customTextFieldWithFrame:CGRectMake(totalLabel.right, totalLabel.top, SCREEN_WIDTH-totalLabel.right, totalLabel.height)];
        [self addSubview:_totalMoneyTxt];
        
        NSString *nameStr = @"联系人：";
        CGSize nameSize = [nameStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *nameLabel = [self customUILabelWithFrame:CGRectMake(totalLabel.left, totalLabel.bottom, nameSize.width, totalLabel.height) title:nameStr];
        [self addSubview:nameLabel];
        
        _nameTxt = [self customTextFieldWithFrame:CGRectMake(nameLabel.right, nameLabel.top, 80, nameLabel.height)];
        [self addSubview:_nameTxt];
        
        UILabel *phoneLabel = [self customUILabelWithFrame:CGRectMake(_nameTxt.right, _nameTxt.top, contractType.width, _nameTxt.height) title:@"联系电话："];
        [self addSubview:phoneLabel];
        
        _phoneTxt = [self customTextFieldWithFrame:CGRectMake(phoneLabel.right, phoneLabel.top, SCREEN_WIDTH-phoneLabel.right-8, phoneLabel.height)];
        [self addSubview:_phoneTxt];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, frame.size.height-1, SCREEN_WIDTH-16, 1)];
        line.backgroundColor = UIColorFromRGB(224, 223, 226);
        [self addSubview:line];
        
    }
    return self;
}

-(void)clickDeleteButton:(UIButton*)button
{
    [self.delegate deleteHomeFitView:self.tag];
}

-(void)showHomeFitViewWithDict:(NSDictionary*)dict
{
    self.contractTypeTxt.userInteractionEnabled = NO;
    self.totalMoneyTxt.userInteractionEnabled = NO;
    self.nameTxt.userInteractionEnabled = NO;
    self.phoneTxt.userInteractionEnabled = NO;
    self.deleteButton.hidden = YES;
    
    self.contractTypeTxt.text = dict[@"contracting_method"];
    self.totalMoneyTxt.text = dict[@"subtotal"];
    self.nameTxt.text = dict[@"contacts"];
    self.phoneTxt.text = dict[@"tel"];
}

-(void)showCopyHomeFitViewWithDict:(NSDictionary*)dict
{
    self.contractTypeTxt.text = dict[@"contracting_method"];
    self.totalMoneyTxt.text = dict[@"subtotal"];
    self.nameTxt.text = dict[@"contacts"];
    self.phoneTxt.text = dict[@"tel"];
}

#pragma mark 自定义view

-(UITextField*)customTextFieldWithFrame:(CGRect)frame
{
    UITextField *textfield = [[UITextField alloc]initWithFrame:frame];
    textfield.delegate = self;
    textfield.font = [UIFont systemFontOfSize:12];
    textfield.returnKeyType = UIReturnKeyDone;
    textfield.textColor = FORMTITLECOLOR;
    return textfield;
}

-(UILabel*)customUILabelWithFrame:(CGRect)frame title:(NSString*)title
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = FORMLABELTITLECOLOR;
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    return label;
}

#pragma mark UITextfield Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}










@end
