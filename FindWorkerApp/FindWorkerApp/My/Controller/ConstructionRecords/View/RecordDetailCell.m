//
//  RecordDetailCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/5/10.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "RecordDetailCell.h"
#import "CXZ.h"

@implementation RecordDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (int i = 0; i < self.recordsImageArray.count; i++) {
        UIImageView *imageview = self.recordsImageArray[i];
        imageview.userInteractionEnabled = YES;
        imageview.tag = i+1;
        imageview.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scanPhotos:)];
        [imageview addGestureRecognizer:tap];
    }
    self.moreButton.hidden = YES;
    self.locoalImageview.hidden = YES;
    self.addressLabel.hidden = YES;
}

-(void)scanPhotos:(UITapGestureRecognizer*)tap
{
    NSInteger row = ((RecordDetailCell*)[[tap.view superview] superview]).tag;
    NSInteger index = tap.view.tag -1;
    //    NSLog(@"row:%li index:%li",row,index);
//    [self.delegate clickRecordImageWithRow:row index:index];
}

- (IBAction)clickMoreButton:(id)sender {
    NSLog(@"点击更多");
}

-(void)setRecordsDetailListCellWithModel:(RecordsDetailListModel*)model
{
    self.timeLabel.text = [model.add_time substringToIndex:10];
    self.contentLabel.text = model.content;
    if (model.picture.count >0) {
        NSInteger count = model.picture.count > 9 ? 9:model.picture.count;
        for (int i = 0; i < count; i++) {
            UIImageView *img = self.recordsImageArray[i];
            img.hidden = NO;
            if ([model.picture[i] isKindOfClass:[NSString class]]) {
                NSString *picStr = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,model.picture[i]];
                [img sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"camera"]];
            }
        }
    }
    if (model.picture.count > 9) {
        self.moreButton.hidden = NO;
    }
    self.commendNumLabel.text = [NSString stringWithFormat:@"评论：（%li）",model.num];
    if (![NSString isBlankString:model.position]) {
        self.addressLabel.text = model.position;
        self.locoalImageview.hidden = NO;
        self.addressLabel.hidden = NO;
    }
    
    self.recordDetailCellHeight = [self countCommentCellHeight:model];
}

#pragma mark 计算cell 高度
-(CGFloat)countCommentCellHeight:(RecordsDetailListModel*)comment
{
//    comment.content = @"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:comment.content];
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc]init];
    [paragrahStyle setLineSpacing:3];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, comment.content.length)];
    self.contentLabel.attributedText = attributedStr;
    CGSize size = CGSizeMake(SCREEN_WIDTH - 90, 5000);
    CGSize labelSize = [self.contentLabel sizeThatFits:size];
//            NSLog(@"label文本高度：%lf",labelSize.height);
    float lableHeight = labelSize.height > 60.0 ? 60.0 :labelSize.height;
    float imageHeight = 0;
    if (comment.picture.count > 0) {
        NSInteger num = comment.picture.count >9 ? 9 :comment.picture.count;
        NSInteger count = num%3 == 0 ? (num/3):(num/3+1);
        imageHeight = 78*count;
    }
    
    CGFloat rowHeight;
    CGFloat cellHeight;
    if ([NSString isBlankString:comment.position]) {
        rowHeight = lableHeight + 16+imageHeight+30;
        cellHeight = rowHeight > 40 ? rowHeight : 40;
    }else{
        rowHeight = lableHeight + 16+imageHeight+50;
        cellHeight = rowHeight > 60 ? rowHeight : 60;
    }

    return  cellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
