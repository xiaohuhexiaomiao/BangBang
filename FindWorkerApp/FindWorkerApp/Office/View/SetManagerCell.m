//
//  SetManagerCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SetManagerCell.h"
#import "CXZ.h"

@interface SetManagerCell()

@property (nonatomic, strong)UIImageView *avatarImageview;

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UILabel *phoneLabel;

@property (nonatomic , strong)UILabel *departmentLabel;

@property (nonatomic , strong)UIButton *upButton;

@property (nonatomic , strong)UIButton *downButton;

@property (nonatomic , strong)UIButton *deletButton;

@end

@implementation SetManagerCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _avatarImageview = [[UIImageView alloc]initWithFrame:CGRectMake(16, 5, 30, 30)];
        _avatarImageview.layer.cornerRadius = _avatarImageview.frame.size.width/2;
        _avatarImageview.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageview];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avatarImageview.right+5, 2, SCREEN_WIDTH-180, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_nameLabel];
        
        _departmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, _nameLabel.width, _nameLabel.height)];
        _departmentLabel.font = [UIFont systemFontOfSize:10];
        _departmentLabel.textColor = SUBTITLECOLOR;
        [self.contentView addSubview:_departmentLabel];
        
        
        _upButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"上移"];
        _upButton.frame = CGRectMake(SCREEN_WIDTH-128, 5, 40, 30);
        [_upButton addTarget:self action:@selector(clickUpButton) forControlEvents:UIControlEventTouchUpInside];
        
        _downButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"下移"];
        _downButton.frame = CGRectMake(_upButton.right, 5, _upButton.width, 30);
        [_downButton addTarget:self action:@selector(clickDownButton) forControlEvents:UIControlEventTouchUpInside];
        
        _deletButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"删除"];
        _deletButton.frame = CGRectMake(_downButton.right, 5, _upButton.width, 30);
        [_deletButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)setManagerCellWith:(PersonelModel *)personalM
{
    if (![NSString isBlankString:personalM.avatar]) {
        NSString *avatar = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,personalM.avatar];
        [self.avatarImageview sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"temp"]];
    }else{
        self.avatarImageview.image = [UIImage imageNamed:@"temp"];
    }
    self.nameLabel.text = personalM.name;
    self.departmentLabel.text = personalM.department_name;

}

-(void)clickDeleteButton
{
    [self.delegate deleteCell:self.tag];
}

-(void)clickUpButton
{
    [self.delegate moveUpOrDownCell:self.tag is_up:YES];
}

-(void)clickDownButton
{
     [self.delegate moveUpOrDownCell:self.tag is_up:NO];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
