//
//  NormalCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/12/6.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "NormalCell.h"
#import "CXZ.h"

@interface NormalCell ()

@property(nonatomic ,strong) UILabel *titleLabel;

@property(nonatomic ,strong) UIImageView *imgView;

@end

@implementation NormalCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 40, 40)];
        _imgView.layer.cornerRadius = 20;
        _imgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imgView];
        
        _titleLabel = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        _titleLabel.frame = CGRectMake(_imgView.right+8, 8, SCREEN_WIDTH-_imgView.right-16, 27);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        
        _subtitleLabel = [CustomView customTitleUILableWithContentView:self.contentView title:nil];
        _subtitleLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom, _titleLabel.width, 15);
        _subtitleLabel.font = [UIFont systemFontOfSize:12];
        
        UIView *line = [CustomView customLineView:self.contentView];
        line.frame = CGRectMake(_titleLabel.left, _subtitleLabel.bottom+9, SCREEN_WIDTH-_titleLabel.left, 1);
    }
    return self;
}

-(void)setImageViewWithImage:(NSString *)imgString Title:(NSString *)title SubTitle:(NSString *)subtitle
{
    if (imgString) {
        self.imgView.image = [UIImage imageNamed:imgString];
    }
    if (title) {
        self.titleLabel.text = title;
    }
    if (subtitle) {
        self.subtitleLabel.text = subtitle;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
