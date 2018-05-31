//
//  RecordsCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/5/12.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "RecordsCell.h"
#import "CXZ.h"
@interface RecordsCell() 

@property(nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, strong) UILabel *contentLabel;

@property(nonatomic, strong) UILabel *locationLabel;

@property(nonatomic, strong) UIImageView *locationImageview;
@end


@implementation RecordsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(RecordsDetailListModel*)detailModel
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 5, SCREEN_WIDTH-16, 18)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = TITLECOLOR;
        _timeLabel.text = [NSString stringWithFormat:@"%@",detailModel.add_time];
        [self.contentView addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, _timeLabel.bottom, SCREEN_WIDTH-28, 20)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = TITLECOLOR;
        _contentLabel.text = detailModel.content;
        [self.contentView addSubview:_contentLabel];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:detailModel.content];
        NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc]init];
        [paragrahStyle setLineSpacing:3];
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, detailModel.content.length)];
        _contentLabel.attributedText = attributedStr;
        CGSize size = CGSizeMake(SCREEN_WIDTH - 30, 5000);
        CGSize labelSize = [_contentLabel sizeThatFits:size];
        _contentLabel.height = labelSize.height+3;
        
        if (![NSString isBlankString:detailModel.position]) {
            _locationImageview = [[UIImageView alloc]initWithFrame:CGRectMake(_contentLabel.left, _contentLabel.bottom+2, 12, 18)];
            _locationImageview.image = [UIImage imageNamed:@"WorkerLocation"];
            [self.contentView addSubview:_locationImageview];
            
            _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(_locationImageview.right+2, _contentLabel.bottom, SCREEN_WIDTH-_locationImageview.right-10, 20)];
            _locationLabel.font = [UIFont systemFontOfSize:12];
            _locationLabel.text = detailModel.position;
            _locationLabel.textColor =SUBTITLECOLOR;
            [self.contentView addSubview:_locationLabel];
        }
        
        NSInteger num = detailModel.picture.count /4;
        NSInteger count = detailModel.picture.count%4 == 0 ? num : (num+1);
        CGFloat width = (SCREEN_WIDTH-36-10)/3;
        CGFloat top;
        if ([NSString isBlankString:detailModel.position]) {
            top = 23+labelSize.height+5;
        }else{
           top = 23+labelSize.height+25;
        }
        for (int i = 0; i < count; i++) {
            if (3*i +0 < detailModel.picture.count) {
                UIImageView *imgview = [[UIImageView alloc]init];
                NSString *imgStr = [NSString stringWithFormat:@"%@%@",IMAGE_HOST, detailModel.picture[3*i +0]];
                [imgview sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:nil];
                imgview.tag = 3*i +0;
                imgview.contentMode = UIViewContentModeScaleAspectFill;
                imgview.layer.masksToBounds = YES;
                [self.contentView addSubview:imgview];
                imgview.frame = CGRectMake(_contentLabel.left, top+(width+5)*i, width, width);
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotos:)];
                imgview.userInteractionEnabled = YES;
                [imgview addGestureRecognizer:tap];
            }
            if (3*i +1 < detailModel.picture.count) {
                UIImageView *imgview = [[UIImageView alloc]init];
                NSString *imgStr = [NSString stringWithFormat:@"%@%@",IMAGE_HOST, detailModel.picture[3*i +1]];
                [imgview sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:nil];
                imgview.tag = 3*i +1;
                [self.contentView addSubview:imgview];
                imgview.contentMode = UIViewContentModeScaleAspectFill;
                imgview.layer.masksToBounds = YES;
                imgview.frame = CGRectMake(_contentLabel.left+width+5, top+(width+5)*i, width, width);
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotos:)];
                imgview.userInteractionEnabled = YES;
                [imgview addGestureRecognizer:tap];
            }
            if(3*i +2 < detailModel.picture.count){
                UIImageView *imgview = [[UIImageView alloc]init];
                NSString *imgStr = [NSString stringWithFormat:@"%@%@",IMAGE_HOST, detailModel.picture[3*i +2]];
                [imgview sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:nil];
                imgview.tag = 3*i +2;
                [self.contentView addSubview:imgview];
                imgview.contentMode = UIViewContentModeScaleAspectFill;
                imgview.layer.masksToBounds = YES;
                imgview.frame = CGRectMake(_contentLabel.left+(width+5)*2, top+(width+5)*i, width, width);
               
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotos:)];
                imgview.userInteractionEnabled = YES;
                [imgview addGestureRecognizer:tap];
            }
        }
        self.recordsCellHeight = top +count*(width+5)+10;
    }
    return self;
}

-(void)addPhotos:(UITapGestureRecognizer*)tap
{
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
