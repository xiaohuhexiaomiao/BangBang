//
//  RCMGroupTableViewCell.m
//  FindWorkerApp
//
//  Created by cxz on 2018/5/10.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "RCMGroupTableViewCell.h"
#import "CXZ.h"
#import "RCDGroupInfo.h"
@implementation RCMGroupTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //群组头像
        CGFloat imvGroupPortWidth = 36;
        CGFloat imvGroupPortHeight = imvGroupPortWidth;
        _imvGroupPort = [[UIImageView alloc]init];
        [self.contentView addSubview:_imvGroupPort];
        [_imvGroupPort mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(8);
            make.width.mas_equalTo(imvGroupPortWidth);
            make.height.mas_equalTo(imvGroupPortHeight);
        }];
        _imvGroupPort.layer.cornerRadius = imvGroupPortWidth/2;
        _imvGroupPort.layer.masksToBounds = YES;
        
        _lblGroupName = [CustomView customTitleUILableWithContentView:self.contentView title:nil];
        [_lblGroupName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imvGroupPort.mas_top);
            make.left.mas_equalTo(_imvGroupPort.mas_right).mas_offset(8);
            make.height.mas_equalTo(34);
            make.right.mas_equalTo(-8);
        }];
        
//        _introduceLabel = [CustomView customTitleUILableWithContentView:self.contentView title:nil];
//        [_introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_lblGroupName.mas_bottom);
//            make.left.mas_equalTo(_lblGroupName.mas_left);
//            make.height.mas_equalTo(18);
//            make.right.mas_equalTo(-8);
//        }];
    }
    return self;
}

-(void)setModel:(RCDGroupInfo *)group
{
    NSURL *imgUrl = [NSURL URLWithString:group.portraitUri];
    [self.imvGroupPort sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.lblGroupName.text = group.groupName;
//    self.introduceLabel.text = group.introduce;
}



@end
