//
//  TransactionCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/1/7.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "TransactionCell.h"
#import "CXZ.h"
@interface TransactionCell()

@property (nonatomic ,strong) UILabel *timeLable;

@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation TransactionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _timeLable = [[UILabel alloc]initWithFrame:CGRectMake(8, 3, SCREEN_WIDTH, 20)];
        _timeLable.textColor = SUBTITLECOLOR;
        _timeLable.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLable];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_timeLable.left, _timeLable.bottom, _timeLable.width, _timeLable.height)];
        _contentLabel.textColor = TITLECOLOR;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_contentLabel];
        
    }
    return self;
}

-(void)setTransaction:(Transaction *)transaction
{
    self.timeLable.text = transaction.addtime;
    static NSString *money;
    if (transaction.amount_type == 0) {
        money = [NSString stringWithFormat:@"-%.2f",transaction.amount];
    }else{
        money = [NSString stringWithFormat:@"+%.2f",transaction.amount];
    }
    self.contentLabel.attributedText = [self setAttributionWithTitle:[NSString stringWithFormat:@"%@：%@",transaction.body,money]];
}

-(NSMutableAttributedString*)setAttributionWithTitle:(NSString*)title
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange range = [title rangeOfString:@"："];
    self.contentLabel.textColor = [UIColor redColor];
    [attributedStr addAttribute:NSForegroundColorAttributeName value: [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] range:NSMakeRange(0, range.location+1)];
    return attributedStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
