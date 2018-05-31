//
//  CommentCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/5/12.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CommentCell.h"
#import "CXZ.h"

@interface CommentCell()

@property (nonatomic , strong)UIImageView *userImageview;

@property (nonatomic , strong)UILabel *nameLabel;

@property (nonatomic , strong)UILabel *timeLabel;

@property (nonatomic , strong)UILabel *commentLabel;

@end


@implementation CommentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _userImageview = [[UIImageView alloc]initWithFrame:CGRectMake(16, 5, 40, 40)];
        _userImageview.layer.cornerRadius = _userImageview.width/2;
        _userImageview.layer.masksToBounds = YES;
        [self.contentView addSubview:_userImageview];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_userImageview.right+5, _userImageview.top, 100, 18)];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.right+5, _nameLabel.top, SCREEN_WIDTH-_nameLabel.right-8, 18)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_timeLabel];
        
        _commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom+2, SCREEN_WIDTH-_userImageview.right-13, 20)];
        _commentLabel.font = [UIFont systemFontOfSize:12];
        _commentLabel.textColor = TITLECOLOR;
        _commentLabel.numberOfLines = 0;
        [self.contentView addSubview:_commentLabel];
    }
    return self;
}

-(void)setCommentCellWithDictionary:(NSDictionary *)dict
{
    NSString *avatarStr = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,[dict[@"user_info"] objectForKey:@"avatar"]];
    [self.userImageview sd_setImageWithURL:[NSURL URLWithString:avatarStr] placeholderImage:[UIImage imageNamed:@"temp"]];
    self.nameLabel.text = [dict[@"user_info"] objectForKey:@"name"];
    self.timeLabel.text = dict[@"add_time"];
    self.commentLabel.text = dict[@"content"];
    NSString *contentStr = dict[@"content"];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:contentStr];
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc]init];
    [paragrahStyle setLineSpacing:3];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, contentStr.length)];
    self.commentLabel.attributedText = attributedStr;
    CGSize size = CGSizeMake(SCREEN_WIDTH - 30, 5000);
    CGSize labelSize = [self.commentLabel sizeThatFits:size];
    CGFloat cellHeght = labelSize.height+30;
    self.commentCellHeight = cellHeght > 50 ? cellHeght :50;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
