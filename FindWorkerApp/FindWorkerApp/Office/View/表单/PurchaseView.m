//
//  PurchaseView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/27.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "PurchaseView.h"
#import "CXZ.h"
#import "JXPopoverView.h"
@interface GoodsModel : NSObject

@property(nonatomic ,copy)NSString  *model;

@property(nonatomic ,copy)NSString  *name;

@property(nonatomic ,copy)NSString  *purpose;

@property(nonatomic ,copy)NSString  *unit;

@property(nonatomic ,copy)NSString  *spec;

@property(nonatomic ,copy)NSString  *num;

@property(nonatomic ,copy)NSString  *price;

@property(nonatomic ,copy)NSString  *subtotal;

@property(nonatomic ,copy)NSString *remarks;

@end

@implementation GoodsModel



@end

@interface PurchaseView ()<UITextFieldDelegate>

@property(nonatomic ,strong)UIButton *unitButton;

@property(nonatomic ,strong)UILabel *marksTitleLabel;

@property(nonatomic ,strong)UILabel *marksLabel;

@property(nonatomic ,strong)UILabel *usesLabel;

@property(nonatomic ,strong)UIView *line;

@end

@implementation PurchaseView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *name = @"名称：";
        CGSize nameSize = [name sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *nameLabel = [self customUILabelWithFrame:CGRectMake(8, 3, nameSize.width, 20) title:name];
        [self addSubview:nameLabel];
        
        _nameTxt = [self customTextFieldWithFrame:CGRectMake(nameLabel.right, nameLabel.top, SCREEN_WIDTH-nameLabel.right-20, nameLabel.height)];
        [self addSubview:_nameTxt];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(SCREEN_WIDTH-20, 0, 20, 20);
        [_deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deletePurchaseView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        NSString *type = @"规格：";
        CGSize typeSize = [type sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *typeLabel = [self customUILabelWithFrame:CGRectMake(nameLabel.left, _nameTxt.bottom, typeSize.width, _nameTxt.height) title:type];
        [self addSubview:typeLabel];
        
        _typeTxt = [self customTextFieldWithFrame:CGRectMake(typeLabel.right, typeLabel.top, 60, nameLabel.height)];
        [self addSubview:_typeTxt];
        
        UILabel *normsLabel = [self customUILabelWithFrame:CGRectMake(_typeTxt.right, _nameTxt.bottom, typeLabel.width, typeLabel.height) title:@"型号："];
        [self addSubview:normsLabel];
        
        _normsTxt = [self customTextFieldWithFrame:CGRectMake(normsLabel.right, normsLabel.top, 60, normsLabel.height)];
        [self addSubview:_normsTxt];
        
  
        UILabel *priceLabel = [self customUILabelWithFrame:CGRectMake(nameLabel.left, _typeTxt.bottom, typeSize.width, nameLabel.height) title:@"单价："];
        [self addSubview:priceLabel];
        
        _priceTxt = [self customTextFieldWithFrame:CGRectMake(priceLabel.right, priceLabel.top, 60, nameLabel.height)];
        _priceTxt.keyboardType = UIKeyboardTypeDecimalPad;
        [self addSubview:_priceTxt];
        
        UILabel *numLabel = [self customUILabelWithFrame:CGRectMake(_priceTxt.right, _priceTxt.top, nameLabel.width, nameLabel.height) title:@"数量："];
        [self addSubview:numLabel];
        
        _numTxt = [self customTextFieldWithFrame:CGRectMake(numLabel.right, numLabel.top, 40, numLabel.height)];
        _numTxt.keyboardType = UIKeyboardTypeDecimalPad;
        [self addSubview:_numTxt];
        
        UILabel *totalLabel = [self customUILabelWithFrame:CGRectMake(_numTxt.right, numLabel.top, nameLabel.width, numLabel.height) title:@"总额："];
        [self addSubview:totalLabel];
        
        _totalMoneyTxt = [self customTextFieldWithFrame:CGRectMake(totalLabel.right, numLabel.top, SCREEN_WIDTH-totalLabel.right, numLabel.height)];
//        _totalMoneyTxt.userInteractionEnabled = NO;
        [self addSubview:_totalMoneyTxt];
        
        NSString *unit = @"单位：";
        CGSize unitSize = [unit sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *unitLabel = [self customUILabelWithFrame:CGRectMake(totalLabel.left, _typeTxt.top, unitSize.width, nameLabel.height) title:unit];
        [self addSubview:unitLabel];
        
        _unitTxt = [self customTextFieldWithFrame:CGRectMake(unitLabel.right, unitLabel.top, 40, nameLabel.height)];
        [self addSubview:_unitTxt];
        
        _unitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _unitButton.frame = CGRectMake(_unitTxt.right, _unitTxt.top, 20, 20);
        [_unitButton setImage:[UIImage imageNamed:@"arrow_gray"] forState:UIControlStateNormal];
        [_unitButton addTarget:self action:@selector(clickUnitButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_unitButton];
        
        
        UILabel *useLabel =[self customUILabelWithFrame:CGRectMake(nameLabel.left, numLabel.bottom, 55, 30) title:@"申报采购原因及用途："];
        useLabel.numberOfLines = 2;
        useLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:useLabel];
        
        _usesTxt = [[UITextView alloc]initWithFrame:CGRectMake(useLabel.right, useLabel.top, SCREEN_WIDTH-useLabel.right-8, useLabel.height)];
        _usesTxt.font = [UIFont systemFontOfSize:12];
        _usesTxt.textColor = FORMTITLECOLOR;
        [self addSubview:_usesTxt];
        
        _usesLabel = [[UILabel alloc]initWithFrame:_usesTxt.frame];
        _usesLabel.font = [UIFont systemFontOfSize:12];
        _usesLabel.textColor  = FORMTITLECOLOR;
        _usesLabel.numberOfLines = 0;
        _usesLabel.hidden = YES;
        [self addSubview:_usesLabel];
        
        _marksTitleLabel = [self customUILabelWithFrame:CGRectMake(nameLabel.left, useLabel.bottom, numLabel.width, 20) title:@""];
        _marksLabel.hidden = YES;
        [self addSubview:_marksTitleLabel];
        
        _marksLabel = [[UILabel alloc]initWithFrame:CGRectMake(_marksTitleLabel.right, _marksTitleLabel.top, SCREEN_WIDTH-_marksTitleLabel.right, _marksTitleLabel.height)];
        _marksLabel.font = [UIFont systemFontOfSize:12];
        _marksLabel.textColor  = FORMTITLECOLOR;
        _marksLabel.numberOfLines = 0;
        _marksLabel.hidden = YES;
        [self addSubview:_marksLabel];
        
        _line = [[UIView alloc]initWithFrame:CGRectMake(8, frame.size.height-1, SCREEN_WIDTH-16, 1)];
         _line.backgroundColor = UIColorFromRGB(224, 223, 226);
        [self addSubview:_line];
    }
    return self;
}

-(CGFloat)showPurchaseViewWithDict:(NSDictionary *)dict
{
    self.nameTxt.userInteractionEnabled = NO;
    self.typeTxt.userInteractionEnabled = NO;
    self.unitTxt.userInteractionEnabled = NO;
    self.numTxt.userInteractionEnabled = NO;
    self.priceTxt.userInteractionEnabled = NO;
    self.totalMoneyTxt.userInteractionEnabled = NO;
    self.usesTxt.userInteractionEnabled = NO;
    self.markTxt.userInteractionEnabled = NO;
    self.normsTxt.userInteractionEnabled = NO;
    self.deleteButton.hidden = YES;
    self.unitButton.hidden = YES;
    self.usesTxt.hidden = YES;
    self.usesLabel.hidden = NO;
    
    GoodsModel *goods = [GoodsModel objectWithKeyValues:dict];
    
    self.nameTxt.text = goods.name;
    self.typeTxt.text = goods.spec;
    if (![NSString isBlankString:goods.unit]) {
        self.unitTxt.text = goods.unit;
    }
    self.numTxt.text = goods.num;
    
    self.priceTxt.text = goods.price;
    self.totalMoneyTxt.text = goods.subtotal;
    if (![NSString isBlankString:goods.model]) {
         self.normsTxt.text = goods.model;
    }
    
    CGFloat viewheight = 30;
    NSString *uses = goods.purpose;
    if (![NSString isBlankString:uses]) {
        self.usesLabel.text = uses;
        CGSize size = CGSizeMake(self.usesLabel.width,CGFLOAT_MAX);
        CGSize labelsize = [uses sizeWithFont:self.marksLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        CGRect frame = self.usesLabel.frame;
        frame.size = labelsize;
        frame.size.height = labelsize.height< 30 ? 30:labelsize.height;
        self.usesLabel.frame = frame;
        self.line.top = self.usesLabel.bottom;
        viewheight = self.usesLabel.height < 30 ? 30 : self.usesLabel.height;
    }
    
    NSString *remarks = [dict objectForKey:@"remarks"];
    if (![NSString isBlankString:remarks]) {
        self.marksLabel.hidden = NO;
        self.marksTitleLabel.hidden = NO;
        self.marksTitleLabel.top = self.usesLabel.bottom;
        self.marksLabel.top = self.marksTitleLabel.top;
        self.marksLabel.text = remarks;
        self.marksTitleLabel.text = @"备注：";
        CGSize size = CGSizeMake(self.marksLabel.width,CGFLOAT_MAX);
        CGSize labelsize = [remarks sizeWithFont:self.marksLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        CGRect frame = self.marksLabel.frame;
        frame.size = labelsize;
        self.marksLabel.frame = frame;
        self.line.top = self.marksLabel.bottom;
        viewheight = self.usesLabel.height+ self.marksLabel.height;
    }else{
        [self.marksTitleLabel removeFromSuperview];
        [self.marksLabel removeFromSuperview];
    }
  
    return 62+viewheight;
}

-(void)showCopyPurchaseViewWithDict:(NSDictionary*)dict
{
    GoodsModel *goods = [GoodsModel objectWithKeyValues:dict];
    
    self.nameTxt.text = goods.name;
    self.typeTxt.text = goods.spec;
    if (![NSString isBlankString:goods.unit]) {
        self.unitTxt.text = goods.unit;
    }
    self.numTxt.text = goods.num;
    self.priceTxt.text = goods.price;
    self.totalMoneyTxt.text = goods.subtotal;
    if (![NSString isBlankString:goods.model]) {
        self.normsTxt.text = goods.model;
    }
    
     self.usesTxt.text = goods.purpose;
    //    self.markTxt.text = [dict objectForKey:@"remarks"];
}

-(void)deletePurchaseView:(UIButton*)button
{
    [self.delegate deletePurchaseView:self.tag];
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
        self.totalMoneyTxt.text = [NSString stringWithFormat:@"%.2lf元",total];
    }
    if (textField == self.priceTxt) {
        num = [self.numTxt.text integerValue];
        price = [self.priceTxt.text floatValue];
        total = num *price;
        self.totalMoneyTxt.text = [NSString stringWithFormat:@"%.2lf元",total];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
