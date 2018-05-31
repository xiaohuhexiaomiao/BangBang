//
//  ShowStampView.m
//  FindWorkerApp
//
//  Created by cxz on 2018/4/12.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "ShowStampView.h"
#import "CXZ.h"
@interface ShowStampModel : NSObject

@property(nonatomic ,copy)NSString  *reason;

@property(nonatomic ,copy)NSString  *contract_name;

@property(nonatomic ,copy)NSString  *num;

@property(nonatomic ,copy)NSString  *remarks;

@property(nonatomic ,assign)NSInteger  company_type;

@property(nonatomic ,copy)NSString *name_company;

@property(nonatomic ,assign)NSInteger seal_type;

@end

@implementation ShowStampModel


@end

@interface ShowStampView ()

@property(nonatomic ,strong)RTLabel *resonLabel;

@property(nonatomic ,strong)RTLabel *nameLabel;

@property(nonatomic ,strong)UILabel *numberLabel;

@property(nonatomic ,strong)RTLabel *markLabel;

@property(nonatomic ,strong)UILabel *typeLabel;

@property(nonatomic ,strong)UILabel *companyLabel;


@end


@implementation ShowStampView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *reason = @"盖章事由：";
        CGSize reasonSize = [reason sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *reasonLabel = [CustomView customTitleUILableWithContentView:self title:reason];
        [reasonLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(reasonSize.width+1);
            make.height.mas_equalTo(25);
        }];
        reasonLabel.font = [UIFont systemFontOfSize:12];
        
        _resonLabel = [CustomView customRTLableWithContentView:self title:nil];
        _resonLabel.font = [UIFont systemFontOfSize:12];
        _resonLabel.frame = CGRectMake(reasonLabel.right, reasonLabel.top, SCREEN_WIDTH-reasonSize.width-17, 25);
        [_resonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(2);
            make.left.mas_equalTo(reasonLabel.mas_right);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(23);
        }];
        
        NSString *file = @"资料名称：";
        CGSize fileSize = [file sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *fileLabel = [CustomView customTitleUILableWithContentView:self title:file];
        [fileLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_resonLabel.mas_bottom);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(fileSize.width+1);
            make.height.mas_equalTo(25);
        }];
        fileLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel = [CustomView customRTLableWithContentView:self title:nil];
         _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.frame = CGRectMake(fileLabel.right, reasonLabel.top, SCREEN_WIDTH-fileSize.width-17, 25);
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(fileLabel.mas_top).mas_offset(2);
            make.left.mas_equalTo(fileLabel.mas_right);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(23);
        }];
    
        
        NSString *num = @"数量：";
        CGSize numSize = [num sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *numLabel = [CustomView customTitleUILableWithContentView:self title:num];
        [numLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.mas_bottom);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(numSize.width+1);
            make.height.mas_equalTo(25);
        }];
        numLabel.font = [UIFont systemFontOfSize:12];
        _numberLabel = [CustomView customContentUILableWithContentView:self title:nil];
        _numberLabel.font = [UIFont systemFontOfSize:12];
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(numLabel.mas_top);
            make.left.mas_equalTo(numLabel.mas_right);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(25);
        }];
        
        
        NSString *stamp = @"印章类别：";
        CGSize stampSize = [stamp sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *stampLabel = [CustomView customTitleUILableWithContentView:self title:stamp];
        [stampLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_numberLabel.mas_bottom);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(stampSize.width+1);
            make.height.mas_equalTo(25);
        }];
        stampLabel.font = [UIFont systemFontOfSize:12];
        _typeLabel = [CustomView customContentUILableWithContentView:self title:nil];
        _typeLabel.font = [UIFont systemFontOfSize:12];
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(stampLabel.mas_top);
            make.left.mas_equalTo(stampLabel.mas_right);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(25);
        }];
        
        UILabel *companyLabel = [CustomView customTitleUILableWithContentView:self title:@"公司："];
        [companyLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_typeLabel.mas_top);
            make.left.mas_equalTo(_typeLabel.mas_right);
            make.width.mas_equalTo(numSize.width+1);
            make.height.mas_equalTo(25);
        }];
         companyLabel.font = [UIFont systemFontOfSize:12];
        _companyLabel = [CustomView customContentUILableWithContentView:self title:nil];
        _companyLabel.font = [UIFont systemFontOfSize:12];
        [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(companyLabel.mas_top);
            make.left.mas_equalTo(companyLabel.mas_right);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(25);
        }];
        
    
        NSString *mark = @"备注：";
        CGSize markSize = [mark sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *markLabel = [CustomView customTitleUILableWithContentView:self title:mark];
         markLabel.font = [UIFont systemFontOfSize:12];
        [markLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_companyLabel.mas_bottom);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(markSize.width+1);
            make.height.mas_equalTo(25);
        }];
        _markLabel = [CustomView customRTLableWithContentView:self title:nil];
        _markLabel.font = [UIFont systemFontOfSize:12];
        _markLabel.frame = CGRectMake(markLabel.right, markLabel.top, SCREEN_WIDTH-markSize.width-17, 25);
        [_markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(markLabel.mas_top).mas_offset(2);
            make.left.mas_equalTo(markLabel.mas_right);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(23);
        }];
        
        UIView *line = [CustomView customLineView:self];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_markLabel.mas_bottom);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
}

-(CGFloat)showStampViewData:(NSDictionary*)dict
{
    ShowStampModel *stamp = [ShowStampModel objectWithKeyValues:dict];
    self.resonLabel.text = stamp.reason;
    CGSize resonSize = [self.resonLabel optimumSize];
    CGFloat reasonHeight = resonSize.height > 23.0 ? resonSize.height :23.0;
    [self.resonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(reasonHeight);
    }];
    
    
    self.nameLabel.text = stamp.contract_name;
    CGSize nameSize = [self.nameLabel optimumSize];
    CGFloat nameHeight = nameSize.height > 23.0 ? nameSize.height :23.0;
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(nameHeight);
    }];
    
    self.numberLabel.text = stamp.num;
    
    if (stamp.company_type) {
        if (stamp.company_type ==1) {
            self.companyLabel.text = @"杭州旭邦装饰有限公司";
            
        }else{
            self.companyLabel.text = @"杭州大旭邦装饰有限公司";
            
        }
    }
    if (![NSString isBlankString:stamp.name_company]) {
        self.companyLabel.text = stamp.name_company;
    }
    switch (stamp.seal_type) {
        case 1:self.typeLabel.text = @"公章";
            break;
        case 2:self.typeLabel.text = @"法人章";break;
        case 3:self.typeLabel.text = @"财务章";break;
        case 4:self.typeLabel.text = @"发票章";break;
        case 5:self.typeLabel.text = @"合同章";
        default:
            break;
    }
    self.markLabel.text = stamp.remarks;
    CGSize optimumSize = [self.markLabel optimumSize];
    CGFloat markHeight = optimumSize.height > 23.0 ? optimumSize.height :23.0;
    [self.markLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(markHeight);
    }];
 
    return reasonHeight+nameHeight+markHeight+53;
}


@end
