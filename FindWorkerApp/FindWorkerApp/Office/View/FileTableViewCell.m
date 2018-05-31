//
//  FileTableViewCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/10/20.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "FileTableViewCell.h"
#import "CXZ.h"
#import "FileModel.h"
@interface FileTableViewCell()

@property(nonatomic ,strong) UILabel *titleLabel;

@property(nonatomic ,strong) UILabel *timeLable;

@property(nonatomic ,strong) UIButton *selectedButton;

@end
@implementation FileTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [CustomView customTitleUILableWithContentView:self.contentView title:nil];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-40);
            make.height.mas_equalTo(25);
            make.top.mas_equalTo(3);
        }];
        
        _timeLable = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        _timeLable.font = [UIFont systemFontOfSize:10];
        [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.width.mas_equalTo(_titleLabel.mas_width);
            make.height.mas_equalTo(15);
            make.top.mas_equalTo(_titleLabel.mas_bottom);
        }];
        
        _selectedButton = [CustomView customButtonWithContentView:self.contentView image:@"file_unselected" title:nil];
        [_selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(7);
        }];
       
        _selectedButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_selectedButton addTarget:self action:@selector(clickSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)setFileCellWithModel:(FileModel*)file
{
    self.titleLabel.text = file.file_all_name;
    self.timeLable.text = file.file_add_time;
}
-(void)clickSelectButton:(UIButton *)button;
{
    NSInteger tag = ((FileTableViewCell*)[[button superview] superview]).tag;
    UIImage *tempImage = [UIImage imageNamed:@"file_unselected"];
    NSData *tempData = UIImagePNGRepresentation(tempImage);
    UIImage *image = [button imageForState:UIControlStateNormal];
    NSData *data = UIImagePNGRepresentation(image);
    if ([data isEqualToData:tempData]) {
        [_selectedButton setImage:[UIImage imageNamed:@"file_selected"] forState:UIControlStateNormal];
        [self.delegate clickSeleteButton:YES tag:tag];
    }else{
        [_selectedButton setImage:[UIImage imageNamed:@"file_unselected"] forState:UIControlStateNormal];
        [self.delegate clickSeleteButton:NO  tag:tag];
    }

}

@end
