//
//  RCMAddMemberTableViewCell.m
//  FindWorkerApp
//
//  Created by cxz on 2018/5/10.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "RCMAddMemberTableViewCell.h"
#import "CXZ.h"
#import "SWWorkerData.h"


@interface RCMAddMemberTableViewCell ()

@property(nonatomic, strong) UIImageView *memberImageView;

@property(nonatomic, strong) UILabel *memberNameLabel;

@end

@implementation RCMAddMemberTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //群组头像
        CGFloat imvGroupPortWidth = 30;
        CGFloat imvGroupPortHeight = imvGroupPortWidth;
        _memberImageView= [[UIImageView alloc]init];
        [self.contentView addSubview:_memberImageView];
        [_memberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(8);
            make.width.mas_equalTo(imvGroupPortWidth);
            make.height.mas_equalTo(imvGroupPortHeight);
        }];
        _memberImageView.layer.cornerRadius = imvGroupPortWidth/2;
        _memberImageView.layer.masksToBounds = YES;
        
        _memberNameLabel = [CustomView customTitleUILableWithContentView:self.contentView title:nil];
        [_memberNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_memberImageView.mas_top);
            make.left.mas_equalTo(_memberImageView.mas_right).mas_offset(8);
            make.height.mas_equalTo(imvGroupPortHeight);
            make.right.mas_equalTo(-30);
        }];
        
        _selectBtn = [CustomView customButtonWithContentView:self.contentView image:@"unselect" title:nil];
        _selectBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_selectBtn addTarget:self action:@selector(clickSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.left.mas_equalTo(_memberNameLabel.mas_right).mas_offset(10);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(25);
        }];
    }
    return self;
}

-(void)setModel:(SWWorkerData *)model
{
    if (![NSString isBlankString:model.avatar]) {
        NSString *avatar = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,model.avatar];
        [self.memberImageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"temp"]];
    }else{
        self.memberImageView.image = [UIImage imageNamed:@"temp"];
    }
    self.memberNameLabel.text = model.name;
    if (model.is_selected) {
        [self.selectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    }else{
       [self.selectBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    }
}

-(void)setMemberModel:(RCUserInfo *)model
{
    if (![NSString isBlankString:model.portraitUri]) {
        [self.memberImageView sd_setImageWithURL:[NSURL URLWithString:model.portraitUri] placeholderImage:[UIImage imageNamed:@"temp"]];
    }else{
        self.memberImageView.image = [UIImage imageNamed:@"temp"];
    }
    self.memberNameLabel.text = model.name;
    [self.selectBtn setImage:[UIImage imageNamed:@"dustbin"] forState:UIControlStateNormal];
}

-(IBAction)clickSelectButton:(id)sender
{
    UIImage *tempImage = [UIImage imageNamed:@"unselect"];
    NSData *tempData = UIImagePNGRepresentation(tempImage);
    
    UIImage *tempImage0 = [UIImage imageNamed:@"select"];
    NSData *tempData0 = UIImagePNGRepresentation(tempImage0);
    
    UIImage *tempImage1 = [UIImage imageNamed:@"dustbin"];
    NSData *tempData1 = UIImagePNGRepresentation(tempImage1);
    
    UIImage *image = [(UIButton*)sender imageForState:UIControlStateNormal];
    NSData *data = UIImagePNGRepresentation(image);
    if ([data isEqualToData:tempData]) {
        [_selectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [self.delegate clickSelected:self.tag is_seleted:YES];
    }else if ([data isEqualToData:tempData0]){
        [_selectBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        [self.delegate clickSelected:self.tag is_seleted:NO];
    
    }else if ([data isEqualToData:tempData1]){
        [self.delegate clickSelected:self.tag is_seleted:YES];
    }
}




@end
