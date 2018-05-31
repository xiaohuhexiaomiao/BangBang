//
//  CompanyInfoCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/1.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CompanyInfoCell.h"

#import "CXZ.h"

@interface CompanyInfoCell() 
@property(nonatomic ,strong)UILabel *companyNameLabel;

@property(nonatomic ,strong)UILabel *companyPhoneLabel;

@property(nonatomic ,strong)UILabel *addressLabel;
@end

@implementation CompanyInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        UILabel *nameLabel = [self customUILabelWithTitle:@"公司名称:"];
//        [self addSubview:nameLabel];
//        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(5);
//            make.left.mas_equalTo(8);
//            make.width.mas_equalTo(60);
//            make.height.mas_equalTo(20);
//        }];
        
        _companyNameLabel = [self customUIlabelwithContent];
        [self addSubview:_companyNameLabel];
        [_companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(20);
        }];
        
//        UILabel *phoneLabel = [self customUILabelWithTitle:@"公司电话:"];
//        [self addSubview:phoneLabel];
//        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(nameLabel.mas_bottom);
//            make.left.mas_equalTo(nameLabel.mas_left);
//            make.width.mas_equalTo(nameLabel.mas_width);
//            make.height.mas_equalTo(20);
//        }];
        
        _companyPhoneLabel = [self customUIlabelwithContent];
        [self addSubview:_companyPhoneLabel];
        [_companyPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_companyNameLabel.mas_bottom);
            make.left.mas_equalTo(_companyNameLabel.mas_left);
            make.right.mas_equalTo(_companyNameLabel.mas_right);
            make.height.mas_equalTo(20);
        }];
        
//        UILabel *typeLabel = [self customUILabelWithTitle:@"公司地址:"];
//        [self addSubview:typeLabel];
//        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(phoneLabel.mas_bottom);
//            make.left.mas_equalTo(phoneLabel.mas_left);
//            make.width.mas_equalTo(phoneLabel.mas_width);
//            make.height.mas_equalTo(20);
//        }];
        
        _addressLabel = [self customUIlabelwithContent];
        _addressLabel.numberOfLines = 0;
        [self addSubview:_addressLabel];
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_companyPhoneLabel.mas_bottom);
            make.left.mas_equalTo(_companyPhoneLabel.mas_left);
            make.right.mas_equalTo(-8);
            make.bottom.mas_equalTo(-5);
        }];
    }
    return self;
}


-(void)setCompanyInfoCellWithModel:(CompanyInfoModel*)model
{
    self.companyNameLabel.text = model.company_name;
    self.companyPhoneLabel.text = model.company_tel;
    self.addressLabel.text = model.company_address;
    self.infoCellHeight = 70.0f;
    if (![NSString isBlankString:model.company_address]) {
        CGSize size = CGSizeMake(SCREEN_WIDTH-20,CGFLOAT_MAX);
        CGSize labelsize = [model.company_address sizeWithFont:self.addressLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        self.infoCellHeight = 50+labelsize.height;
    }
}




#pragma mark Custom View Method

-(UILabel*)customUILabelWithTitle:(NSString*)title
{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = FORMLABELTITLECOLOR;
    label.text = title;
    return label;
}

-(UILabel*)customUIlabelwithContent
{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = FORMTITLECOLOR;
    return label;
}


@end
