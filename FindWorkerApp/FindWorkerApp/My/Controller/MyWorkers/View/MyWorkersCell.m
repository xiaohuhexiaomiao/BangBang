//
//  MyWorkersCell.m
//  FindWorkerApp
//
//  Created by cxz on 2016/12/28.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "MyWorkersCell.h"
#import "CXZ.h"
@interface MyWorkersCell()<UITextFieldDelegate>
{
    UILabel *titleLable4;
}
@property (nonatomic, strong) UIImageView *selectImageView;

@property (nonatomic, strong) UIImageView *userImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UITextField *moneyTextfield;//发工资设置金额

@property (nonatomic, strong) UILabel *contractLabel;//合同金额

@property (nonatomic, strong) UILabel *alreadyPayLabel;//已发金额

@property (nonatomic, strong) UILabel *noPayLabel;//未发金额

@property (nonatomic, strong) UILabel *applyLabel;//申请金额

@end

@implementation MyWorkersCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)initViews
{
    self.selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-28, 8, 20, 20)];
    if (self.type == SearchType) {
        self.selectImageView.hidden = YES;
    }
    
    self.selectImageView.image = [UIImage imageNamed:@"unselect"];
    
    self.selectImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickChooseImage:)];
    [self.selectImageView addGestureRecognizer:imgTap];
    [self.contentView addSubview:self.selectImageView];
    
    self.userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 40, 40)];
    self.userImageView.layer.cornerRadius = 20.0;
    self.userImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.userImageView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.userImageView.right+5, self.userImageView.top, 80, 20)];
    self.nameLabel.textColor = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.nameLabel];
    
    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.right, self.nameLabel.top, SCREEN_WIDTH-self.nameLabel.right-40, 20)];
    if (self.type == SearchType) {
        self.phoneLabel.hidden = YES;
    }
    self.phoneLabel.font = [UIFont systemFontOfSize:12];
    self.phoneLabel.textAlignment = NSTextAlignmentRight;
    self.phoneLabel.textColor = [UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1.00];
    [self.contentView addSubview:self.phoneLabel];
    

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom, 65, 20)];
    titleLabel.text = @"合同金额：";
    titleLabel.textColor =  TITLECOLOR;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:titleLabel];
    
    self.contractLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 100, 20)];
    self.contractLabel.textColor = SUBTITLECOLOR;
    self.contractLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.contractLabel];
    
    UILabel *titleLable2 = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, titleLabel.width, 20)];
    titleLable2.text = @"已发金额：";
    titleLable2.textColor =  TITLECOLOR;
    titleLable2.font = titleLabel.font;
    [self.contentView addSubview:titleLable2];
    
    //
    self.alreadyPayLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLable2.right, titleLable2.top, self.contractLabel.width, 20)];
    self.alreadyPayLabel.textColor = SUBTITLECOLOR;
    self.alreadyPayLabel.font = self.contractLabel.font;
    [self.contentView addSubview:self.alreadyPayLabel];
    
    UILabel *titleLable3 = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.left, titleLable2.bottom, titleLabel.width, 20)];
    titleLable3.text = @"未发金额：";
    titleLable3.textColor =  TITLECOLOR;
    titleLable3.font = titleLabel.font;
    [self.contentView addSubview:titleLable3];
    
    self.noPayLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLable3.right, titleLable3.top, self.contractLabel.width, 20)];
    self.noPayLabel.textColor = [UIColor redColor];
    self.noPayLabel.font = self.contractLabel.font;
    [self.contentView addSubview:self.noPayLabel];
    
    titleLable4 = [[UILabel alloc]initWithFrame:CGRectMake(titleLable3.left, titleLable3.bottom, titleLabel.width, 20)];
    titleLable4.text = @"申请金额：";
    titleLable4.textColor =  TITLECOLOR;
    titleLable4.font = titleLabel.font;
    [self.contentView addSubview:titleLable4];
    
    self.applyLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLable4.right, titleLable4.top, 60, 20)];
    self.applyLabel.textColor = TOP_GREEN;
    self.applyLabel.font = self.contractLabel.font;
    [self.contentView addSubview:self.applyLabel];
    
    self.moneyTextfield = [[UITextField alloc]initWithFrame:CGRectMake(self.applyLabel.right, titleLable3.top+10, SCREEN_WIDTH-40-self.applyLabel.right, 30)];
    self.moneyTextfield.font = [UIFont systemFontOfSize:12];
    self.moneyTextfield.textColor = [UIColor blackColor];
    self.moneyTextfield.hidden = NO;
    self.moneyTextfield.text = @"设置金额";
    self.moneyTextfield.textAlignment = NSTextAlignmentRight;
    self.moneyTextfield.delegate = self;
    self.moneyTextfield.keyboardType = UIKeyboardTypePhonePad;
    self.moneyTextfield.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:self.moneyTextfield];

}



//-(void)setMoney:(NSString *)moneyStr
//{
//    if (self.type == SearchType) {
//        self.moneyTextfield.text = [NSString stringWithFormat:@"发工资：¥%@",moneyStr];
//        self.moneyTextfield.textAlignment = NSTextAlignmentLeft;
//        self.moneyTextfield.userInteractionEnabled = NO;
//    }
//}


-(void)setMyWorkersCell:(NSDictionary*)dict
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,dict[@"avatar"]];
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"header_icon"]];
    
    self.nameLabel.text = dict[@"name"];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",dict[@"phone"]];
    
    CGFloat contract;
    CGFloat hadpay;
    CGFloat nopay;
    CGFloat apply;
    if (![self isBlankString:dict[@"contract_price"]]) {
        contract = [dict[@"contract_price"] floatValue];
        
    }else{
        contract = 0.00;
    }
   
    if (![self isBlankString:dict[@"had_pay"]]) {
        hadpay = [dict[@"had_pay"] floatValue];
    }else{
        hadpay = 0.00;
    }
    if (![self isBlankString:dict[@"apply_amount"]]) {
        apply = [dict[@"apply_amount"] floatValue];
    }else{
        apply = 0.00;
    }
    nopay = (contract-hadpay) > 0 ? (contract-hadpay):0.00;
    self.contractLabel.text = [NSString stringWithFormat:@"%.2f",contract];
    self.alreadyPayLabel.text = [NSString stringWithFormat:@"%.2f",hadpay];
    self.noPayLabel.text = [NSString stringWithFormat:@"%.2f",nopay];
    if (apply > 0) {
        self.applyLabel.text = [NSString stringWithFormat:@"%.2f",apply];
    }else{
        self.applyLabel.hidden = YES;
        titleLable4.hidden = YES;
    }
    
    if (self.type == SearchType) {
        self.selectImageView.hidden = YES;
        self.moneyTextfield.hidden = NO;
    }else{
        self.moneyTextfield.hidden = YES;
    }
//    self.applyLabel.text = @"¥5000.00";
    
}


- (void) setSelectImage:(NSString*)select
{
    if ([select integerValue] == 1) {
        self.selectImageView.image = [UIImage imageNamed:@"select"];
    }else{
         self.selectImageView.image = [UIImage imageNamed:@"unselect"];
    }
}

//点击选中按钮
-(void)clickChooseImage:(UITapGestureRecognizer*)tap
{
    NSInteger tag = ((MyWorkersCell*)[[tap.view superview] superview]).tag;
    UIImageView *img = (UIImageView*)tap.view;
    UIImage *tempImg = [UIImage imageNamed:@"unselect"];
    NSData *tempData = UIImagePNGRepresentation(tempImg);
    NSData *imgData = UIImagePNGRepresentation(img.image);
    CGFloat money;
    if ([self.moneyTextfield.text isEqualToString:@"设置金额"]) {
        money = 0.00;
    }else{
        money = [self.moneyTextfield.text floatValue];
    }
    
    if ([imgData isEqualToData:tempData]) {
        self.selectImageView.image = [UIImage imageNamed:@"select"];
        [self.delegate setMoney:tag isSelect:YES isPut:NO money:money];
    }else{
        self.selectImageView.image = [UIImage imageNamed:@"unselect"];
        [self.delegate setMoney:tag isSelect:NO isPut:NO money:money];
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger tag = ((MyWorkersCell*)[[textField superview] superview]).tag;
    UIImage *tempImg = [UIImage imageNamed:@"unselect"];
    NSData *tempData = UIImagePNGRepresentation(tempImg);
    NSData *imgData = UIImagePNGRepresentation(self.selectImageView.image);
    CGFloat money = [textField.text floatValue];
    if ([imgData isEqualToData:tempData]) {
        //        self.selectImageView.image = [UIImage imageNamed:@"select"];
        [self.delegate setMoney:tag isSelect:NO isPut:YES money:money];
    }else{
        [self.delegate setMoney:tag isSelect:YES isPut:YES money:money];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
}



- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    //    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
    //        return YES;
    //    }
    return NO;
}

-(NSMutableAttributedString*)setAttributionWithTitle:(NSString*)title
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange range = [title rangeOfString:@"："];
    self.moneyTextfield.textColor = TOP_GREEN;
    [attributedStr addAttribute:NSForegroundColorAttributeName value: [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] range:NSMakeRange(0, range.location+1)];
    return attributedStr;
}


//-(void)setIsEditing:(BOOL)editing
//{
//    if (editing) {
//       [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//           self.selectImageView.hidden = NO;
//           self.selectImageView.image = [UIImage imageNamed:@"unselect"];
//           self.moneyLabel.hidden = NO;
//       } completion:^(BOOL finished) {
//
//       }];
//    }
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
