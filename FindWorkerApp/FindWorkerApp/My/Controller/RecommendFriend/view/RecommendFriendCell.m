//
//  RecommendFriendCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/3/23.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "RecommendFriendCell.h"
#import "CXZ.h"

@interface RecommendFriendCell()

@property(nonatomic, strong)UIImageView *iconImgview;

@property(nonatomic, strong)UILabel *nameLabel;

@property(nonatomic, strong)UILabel *typeLabel;

@property(nonatomic, strong)UILabel *phoneLabel;

@end

@implementation RecommendFriendCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconImgview = [[UIImageView alloc]initWithFrame:CGRectMake(8, 5, 40, 40)];
        _iconImgview.image = [UIImage imageNamed:@"header_icon"];
        _iconImgview.layer.cornerRadius = 20;
        _iconImgview.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImgview];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImgview.right+8, _iconImgview.top, 60, 20)];
//        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_nameLabel];
        
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.right+3, _iconImgview.top, 40, 20)];
        _typeLabel.font = [UIFont systemFontOfSize:10];
        _typeLabel.textColor = [UIColor grayColor];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.text = @"未注册";
        [self.contentView addSubview:_typeLabel];
        
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, 100, 20)];
        _phoneLabel.font = [UIFont systemFontOfSize:12];
        _phoneLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_phoneLabel];
    
    }
    return self;
}

-(void)setRecommendCell:(NSDictionary*)dict
{
    self.nameLabel.text = dict[@"name"];
    self.phoneLabel.text = dict[@"mobile"];
    if ([dict[@"status"]integerValue]==0) {
        self.typeLabel.hidden = NO;
    }else{
        self.typeLabel.hidden = YES;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
