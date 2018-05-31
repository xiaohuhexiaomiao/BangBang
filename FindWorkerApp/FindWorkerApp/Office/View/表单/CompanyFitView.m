//
//  CompanyFitView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/7/5.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CompanyFitView.h"
#import "CXZ.h"
#import "JXPopoverView.h"

@interface CompanyFitView()

@property(nonatomic ,strong)UIButton *unitButton;

@end

@implementation CompanyFitView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        NSString *contractStr = @"材料名称：";
        CGSize contractSize = [contractStr sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *contractType = [self customUILabelWithFrame:CGRectMake(8, 0, contractSize.width, 25) title:contractStr];
        [self addSubview:contractType];
        
        _goodsNameTxt = [self customTextFieldWithFrame:CGRectMake(contractType.right, contractType.top, SCREEN_WIDTH-contractType.right-20, contractType.height)];
        [self addSubview:_goodsNameTxt];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(SCREEN_WIDTH-20, 0, 20, 20);
        [_deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        NSString *unit = @"单位：";
        CGSize unitSize = [unit sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *unitLabel = [self customUILabelWithFrame:CGRectMake(contractType.left, contractType.bottom, unitSize.width+2, contractType.height) title:unit];
        [self addSubview:unitLabel];
        
        _unitTxt = [self customTextFieldWithFrame:CGRectMake(unitLabel.right, unitLabel.top, 40, unitLabel.height)];
        [self addSubview:_unitTxt];
        
        _unitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _unitButton.frame = CGRectMake(_unitTxt.right, _unitTxt.top, 25, 25);
        [_unitButton setImage:[UIImage imageNamed:@"arrow_gray"] forState:UIControlStateNormal];
        [_unitButton addTarget:self action:@selector(clickUnitButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_unitButton];
        
        
        UILabel *numLabel = [self customUILabelWithFrame:CGRectMake(SCREEN_WIDTH/2, _unitTxt.top, unitLabel.width, _unitTxt.height) title:@"数量："];
        [self addSubview:numLabel];
        
        _numTxt = [self customTextFieldWithFrame:CGRectMake(numLabel.right, numLabel.top, SCREEN_WIDTH-numLabel.right-8, numLabel.height)];
        _numTxt.keyboardType = UIKeyboardTypeDecimalPad;
        [self addSubview:_numTxt];
        
        UILabel *priceLabel = [self customUILabelWithFrame:CGRectMake(unitLabel.left, unitLabel.bottom, unitLabel.width, unitLabel.height) title:@"单价："];
        [self addSubview:priceLabel];
        
        _priceTxt = [self customTextFieldWithFrame:CGRectMake(priceLabel.right, priceLabel.top, SCREEN_WIDTH/2-priceLabel.width, priceLabel.height)];
        _priceTxt.keyboardType = UIKeyboardTypeDecimalPad;
        [self addSubview:_priceTxt];
        
        UILabel *totalLabel = [self customUILabelWithFrame:CGRectMake(_priceTxt.right, _priceTxt.top, numLabel.width, priceLabel.height) title:@"合计："];
        [self addSubview:totalLabel];
        
        _countTxt = [self customTextFieldWithFrame:CGRectMake(totalLabel.right, totalLabel.top, SCREEN_WIDTH-totalLabel.right-8, totalLabel.height)];
        _countTxt.userInteractionEnabled = NO;
        [self addSubview:_countTxt];
        
        NSString *link = @"联系人：";
        CGSize linkSize = [link sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *linkLabel = [self customUILabelWithFrame:CGRectMake(priceLabel.left, priceLabel.bottom, linkSize.width, priceLabel.height) title:link];
        [self addSubview:linkLabel];
        
        _linkNameTxt = [self customTextFieldWithFrame:CGRectMake(linkLabel.right, linkLabel.top, SCREEN_WIDTH/2-linkLabel.right-30, linkLabel.height)];
        [self addSubview:_linkNameTxt];
        
        NSString *linkName = @"联系方式：";
        CGSize linkPhoneSize = [linkName sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *phoneLabel = [self customUILabelWithFrame:CGRectMake(_linkNameTxt.right, _linkNameTxt.top, linkPhoneSize.width, _linkNameTxt.height) title:linkName];
        [self addSubview:phoneLabel];
        
        _linkPhoneTxt = [self customTextFieldWithFrame:CGRectMake(phoneLabel.right, phoneLabel.top, SCREEN_WIDTH-phoneLabel.right-8, phoneLabel.height)];
        [self addSubview:_linkPhoneTxt];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, frame.size.height-1, SCREEN_WIDTH-16, 1)];
        line.backgroundColor = UIColorFromRGB(224, 223, 226);
        [self addSubview:line];
        
    }
    return self;
}

-(void)clickUnitButton
{
    JXPopoverView *popoverView = [JXPopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    JXPopoverAction *action1 = [JXPopoverAction actionWithTitle:@"个" handler:^(JXPopoverAction *action) {
        //个、箱、根、斤、吨、米、平方米
        self.unitTxt.text = @"个";
    }];
    JXPopoverAction *action2 = [JXPopoverAction actionWithTitle:@"箱" handler:^(JXPopoverAction *action) {
        self.unitTxt.text = @"箱";
    }];
    JXPopoverAction *action3 = [JXPopoverAction actionWithTitle:@"根" handler:^(JXPopoverAction *action) {
        self.unitTxt.text = @"根";
    }];
    JXPopoverAction *action4 = [JXPopoverAction actionWithTitle:@"斤" handler:^(JXPopoverAction *action) {
        self.unitTxt.text = @"斤";
    }];
    JXPopoverAction *action5 = [JXPopoverAction actionWithTitle:@"吨" handler:^(JXPopoverAction *action) {
        self.unitTxt.text = @"吨";
    }];
    JXPopoverAction *action6 = [JXPopoverAction actionWithTitle:@"米" handler:^(JXPopoverAction *action) {
        self.unitTxt.text = @"米";
    }];
    JXPopoverAction *action7 = [JXPopoverAction actionWithTitle:@"平方米" handler:^(JXPopoverAction *action) {
        self.unitTxt.text = @"平方米";
    }];
    [popoverView showToView:self.unitButton withActions:@[action1,action2,action3,action4,action5,action6,action7]];
}

-(void)clickDeleteButton:(UIButton*)button
{
    [self.delegate deleteCompanyFitView:self.tag];
}

-(void)showCompanyFitViewWithDict:(NSDictionary*)dict
{
    self.goodsNameTxt.userInteractionEnabled = NO;
    self.unitTxt.userInteractionEnabled = NO;
    self.priceTxt.userInteractionEnabled = NO;;
    self.countTxt.userInteractionEnabled = NO;
    self.linkNameTxt.userInteractionEnabled = NO;
    self.linkPhoneTxt.userInteractionEnabled = NO;
    self.numTxt.userInteractionEnabled = NO;
    self.deleteButton.hidden = YES;
    self.unitButton.hidden = YES;
    
    self.goodsNameTxt.text = dict[@"material_name"];
    self.linkNameTxt.text = dict[@"contacts"];
    self.linkPhoneTxt.text = dict[@"tel"];
    if (![NSString isBlankString:dict[@"num"]]) {
        self.numTxt.text = dict[@"num"];
    }
    if (![NSString isBlankString:dict[@"prive"]]) {
        self.priceTxt.text = dict[@"prive"];
    }
    if (![NSString isBlankString:dict[@"total_prive"]]) {
        self.countTxt.text = dict[@"total_prive"];
    }
    if (![NSString isBlankString:dict[@"unit"]]) {
        self.unitTxt.text = dict[@"unit"];
    }
    
}

-(void)showCopyCompanyFitViewWithDict:(NSDictionary*)dict
{
    self.goodsNameTxt.text = dict[@"material_name"];
    self.linkNameTxt.text = dict[@"contacts"];
    self.linkPhoneTxt.text = dict[@"tel"];
    if (![NSString isBlankString:dict[@"num"]]) {
        self.numTxt.text = dict[@"num"];
    }
    if (![NSString isBlankString:dict[@"prive"]]) {
        self.priceTxt.text = dict[@"prive"];
    }
    if (![NSString isBlankString:dict[@"total_prive"]]) {
        self.countTxt.text = dict[@"total_prive"];
    }
    if (![NSString isBlankString:dict[@"unit"]]) {
        self.unitTxt.text = dict[@"unit"];
    }
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


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    static NSInteger num = 1;
    static CGFloat price = 0.0;
    static CGFloat total;
    if (textField == self.numTxt) {
        num = [self.numTxt.text integerValue];
        price = [self.priceTxt.text floatValue];
        total = num * price;
        self.countTxt.text = [NSString stringWithFormat:@"%.2lf元",total];
    }
    if (textField == self.priceTxt) {
        num = [self.numTxt.text integerValue];
        price = [self.priceTxt.text floatValue];
        total = num *price;
        self.countTxt.text = [NSString stringWithFormat:@"%.2lf元",total];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    static NSInteger num = 1;
    static CGFloat price = 0.0;
    static CGFloat total;
    if (textField == self.numTxt) {
        num = [self.numTxt.text integerValue];
        total = num * total;
        self.countTxt.text = [NSString stringWithFormat:@"%lf元",total];
    }
    if (textField == self.priceTxt) {
        price = [self.priceTxt.text floatValue];
        total = num *total;
        self.countTxt.text = [NSString stringWithFormat:@"%lf元",total];
    }
    
    return YES;
}


@end
