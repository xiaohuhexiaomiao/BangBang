//
//  SearchWorkerCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/1/8.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SearchWorkerCell.h"
#import "CXZ.h"
@interface SearchWorkerCell()

@property (nonatomic ,strong) UIImageView *headImageview;

@property (nonatomic ,strong) UILabel *nameLabel;

@property (nonatomic ,strong) UILabel *phoneLabel;

@property (nonatomic ,strong) UIButton *addBtn;
@end

@implementation SearchWorkerCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageview = [[UIImageView alloc]initWithFrame:CGRectMake(8, 5, 36, 36)];
        _headImageview.layer.cornerRadius = 18;
        _headImageview.layer.masksToBounds = YES;
        [self.contentView addSubview:_headImageview];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImageview.right+8, _headImageview.top, SCREEN_WIDTH-56-60, 18)];
        _nameLabel.textColor = SUBTITLECOLOR;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_nameLabel];
        
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, _nameLabel.width, _nameLabel.height)];
        _phoneLabel.textColor = SUBTITLECOLOR;
        _phoneLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_phoneLabel];
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(_nameLabel.right, 0, 52, 46);
        [_addBtn setTitle:@"添加工人" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_addBtn addTarget:self action:@selector(clickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addBtn];
        
    }
    return self;
}
-(void)setSearchCellWithDictionay:(NSDictionary*)dict
{
    if (dict) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMAGE_HOST, dict[@"avatar"]];
        [self.headImageview sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"header_icon"]];
        self.nameLabel.text = dict[@"name"];
        self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",dict[@"phone"]];
    }
}

-(IBAction)clickAddBtn:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSInteger tag = ((SearchWorkerCell*)[[btn superview] superview]).tag;
//    NSLog(@"***sear %li",tag);
    [self.delegate didClickedAddWorkerBtn:tag];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
