//
//  DepartmentTableViewCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/13.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "DepartmentTableViewCell.h"
#import "CXZ.h"
@interface DepartmentTableViewCell()

@property (nonatomic, strong)UIImageView *avatarImageview;

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UILabel *phoneLabel;

@property (nonatomic , strong)UILabel *departmentLabel;

@end

@implementation DepartmentTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _avatarImageview = [[UIImageView alloc]initWithFrame:CGRectMake(16, 5, 30, 30)];
        _avatarImageview.layer.cornerRadius = _avatarImageview.frame.size.width/2;
        _avatarImageview.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageview];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avatarImageview.right+5, 2, 80, 18)];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_nameLabel];
        
        _departmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.right, _nameLabel.top, SCREEN_WIDTH-_nameLabel.right-58, _nameLabel.height)];
        _departmentLabel.font = [UIFont systemFontOfSize:10];
        _departmentLabel.textColor = SUBTITLECOLOR;
        _departmentLabel.hidden = YES;
        [self.contentView addSubview:_departmentLabel];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(SCREEN_WIDTH-20, 0, 20, 20);
        [_deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.hidden = YES;
        [self.contentView addSubview:_deleteButton];
        
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, SCREEN_WIDTH-_nameLabel.left-8, _nameLabel.height)];
        _phoneLabel.font = [UIFont systemFontOfSize:12];
        _phoneLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_phoneLabel];
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(SCREEN_WIDTH-45, 5, 30, 30);
        [_selectBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        _selectBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        _selectBtn.hidden = YES;
        [_selectBtn addTarget:self action:@selector(clickSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectBtn];
        
    }
    return self;
}

-(void)clickSelectButton:(UIButton*)button
{
    NSInteger tag = ((DepartmentTableViewCell*)[[button superview] superview]).tag;
    UIImage *tempImage = [UIImage imageNamed:@"unselect"];
    NSData *tempData = UIImagePNGRepresentation(tempImage);
    UIImage *image = [button imageForState:UIControlStateNormal];
    NSData *data = UIImagePNGRepresentation(image);
    if ([data isEqualToData:tempData]) {
        [_selectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [self.delegate clickSeleteButton:YES tag:tag];
    }else{
        [_selectBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        [self.delegate clickSeleteButton:NO  tag:tag];
    }
}

-(void)clickDeleteButton:(UIButton*)button
{
    NSInteger tag = ((DepartmentTableViewCell*)[[button superview] superview]).tag;
    [self.delegate clickDeleteButton:tag];
}

-(void)setDeparmentCellWith:(PersonelModel *)personalM
{
    if (![NSString isBlankString:personalM.avatar]) {
        NSString *avatar = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,personalM.avatar];
        [self.avatarImageview sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"temp"]];
    }else{
        self.avatarImageview.image = [UIImage imageNamed:@"temp"];
    }
    self.nameLabel.text = personalM.name;
    self.phoneLabel.text = personalM.phone;
//    self.departmentLabel.text = personalM.department_name;
    self.departmentLabel.hidden = YES;
}


-(void)setSelectDeparmentCellWith:(PersonelModel *)personalM
{
    self.selectBtn.hidden = NO;
    if (![NSString isBlankString:personalM.avatar]) {
        NSString *avatar = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,personalM.avatar];
        //        NSLog(@"****%@",avatar);
        [self.avatarImageview sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"temp"]];
    }else{
        self.avatarImageview.image = [UIImage imageNamed:@"temp"];
    }
    self.nameLabel.text = personalM.name;
    self.phoneLabel.text = personalM.phone;
    self.departmentLabel.text = personalM.department_name;
    self.departmentLabel.hidden = NO;
}

-(void)setMangerDataWith:(PersonelModel*)personalM
{
//    NSLog(@"****%@",personalM.avatar);
    if (![NSString isBlankString:personalM.avatar]) {
        NSString *avatar = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,personalM.avatar];
        [self.avatarImageview sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"temp"]];
    }else{
        self.avatarImageview.image = [UIImage imageNamed:@"temp"];
    }
    self.nameLabel.text = personalM.name;
    self.phoneLabel.text = personalM.phone;
    
}

-(void)setNormalDataWith:(PersonelModel*)personalM
{
    if (![NSString isBlankString:personalM.avatar]) {
        NSString *avatar = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,personalM.avatar];
        [self.avatarImageview sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"temp"]];
    }else{
        self.avatarImageview.image = [UIImage imageNamed:@"temp"];
    }
    self.nameLabel.text = personalM.name;
    self.phoneLabel.hidden = YES;
    CGRect frame = self.nameLabel.frame;
    frame.origin.y = 11.0;
    self.nameLabel.frame= frame;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



@end
