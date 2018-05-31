//
//  SelectedDepartCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/12.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SelectedDepartCell.h"
#import "CXZ.h"
@interface SelectedDepartCell()

@property(nonatomic ,strong)UIButton *selectButton;

@property(nonatomic ,strong)UILabel *departLabel;



@end
@implementation SelectedDepartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_selectButton];
        [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(8);
            make.width.height.mas_equalTo(20);
        }];
        [_selectButton setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(clickSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _departLabel = [CustomView customContentUILableWithContentView:self title:nil];
        [_departLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.left.mas_equalTo(_selectButton.mas_right).mas_offset(5);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
        }];
        
//        _numberTxtfield = [CustomView customUITextFieldWithContetnView:self placeHolder:@"输入人数"];
//        _numberTxtfield.textAlignment = NSTextAlignmentRight;
//        [_numberTxtfield mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(5);
//            make.left.mas_equalTo(_departLabel.mas_right);
//            make.height.mas_equalTo(20);
//            make.right.mas_equalTo(self.contentView.mas_right);
//        }];

    }
    
    return self;
}

-(void)setDepartCell:(NSString *)titleStr is_selected:(BOOL)is_selected
{
    self.departLabel.text = titleStr;
    if (is_selected) {
        [_selectButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    }else{
         [_selectButton setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    }
}

-(void)clickSelectedBtn:(UIButton*)btn
{
    UIImage *btnImg = [btn imageForState:UIControlStateNormal];
    UIImage *tmpImg = [UIImage imageNamed:@"unselect"];
    NSData *btnData = UIImagePNGRepresentation(btnImg);
    NSData *tmpData = UIImagePNGRepresentation(tmpImg);
    BOOL isSelected;
    if ([btnData isEqualToData:tmpData]) {
        [_selectButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        isSelected = YES;
    }else{
       [_selectButton setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        isSelected = NO;
    }
    
    [self.delegate clickSelectedButton:self.tag isSelect:isSelected];
}


@end
