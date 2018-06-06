//
//  SponsorTableViewCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/17.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SponsorTableViewCell.h"
#import "CXZ.h"
@interface SponsorTableViewCell()

@property (nonatomic ,strong) UILabel *timeLabel;

@property (nonatomic ,strong) UILabel *typeLabel;

@property (nonatomic ,strong) UILabel *contentLable;

@property (nonatomic ,strong) UILabel *contentNameLabel;

@property (nonatomic ,strong) UILabel *statusLabel;

@property (nonatomic ,strong) UILabel *cashierLabel;

@property (nonatomic ,strong) UIButton *eyeButton;

@property (nonatomic ,strong) UIButton *deleteButton;

@end
@implementation SponsorTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 2, SCREEN_WIDTH-16-20 , 20)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor =TITLECOLOR;
        [self.contentView addSubview:_timeLabel];
        
        
        _deleteButton = [CustomView customButtonWithContentView:self.contentView image:@"delete" title:nil];
        _deleteButton.frame = CGRectMake(_timeLabel.right, 0, 22, 22);
        [_deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.hidden = YES;
        
        UILabel *type = [[UILabel alloc]initWithFrame:CGRectMake(_timeLabel.left, _timeLabel.bottom, 45, 20)];
        type.text = @"类型：";
        type.font = _timeLabel.font;
        type.textColor = TITLECOLOR;
        [self.contentView addSubview:type];
        
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(type.right, type.top, SCREEN_WIDTH-type.right-8, type.height)];
        _typeLabel.font = _timeLabel.font;
        _typeLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_typeLabel];
        
        _contentNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(type.left, type.bottom, type.width, type.height)];
        _contentNameLabel.font = _timeLabel.font;
        _contentNameLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_contentNameLabel];
        
        _contentLable = [[UILabel alloc]initWithFrame:CGRectMake(_contentNameLabel.right, _contentNameLabel.top, SCREEN_WIDTH-_contentNameLabel.right-8, 20)];
        _contentLable.font = _timeLabel.font;
        _contentLable.textColor = TITLECOLOR;
        [self.contentView addSubview:_contentLable];
        
        UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(type.left, _contentLable.bottom, 70, type.height)];
        status.font = type.font;
        status.textColor = TITLECOLOR;
        status.text = @"审批进程：";
        [self.contentView addSubview:status];
        
        _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(status.right, status.top, SCREEN_WIDTH-status.right-30, status.height)];
        _statusLabel.font = status.font;
        [self.contentView addSubview:_statusLabel];
        
        _cashierLabel = [[UILabel alloc]initWithFrame:CGRectMake(status.left, _statusLabel.bottom, SCREEN_WIDTH-16, status.height)];
        _cashierLabel.font = status.font;
        _cashierLabel.textColor = FORMTITLECOLOR;
        _cashierLabel.numberOfLines = 0;
        [self.contentView addSubview:_cashierLabel];
        
        _eyeButton = [CustomView customButtonWithContentView:self.contentView image:@"eye" title:nil];
        _eyeButton.frame = CGRectMake(_statusLabel.right, _statusLabel.top, 30, 20);
        _eyeButton.hidden = YES;
        [_eyeButton addTarget:self action:@selector(clickSeeDetailButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setSponsorCellWith:(ReviewListModel*)reviewModel
{
    self.cellHeight = 85.0;
    self.cashierLabel.hidden = YES;
    
    self.timeLabel.text = [NSString stringWithFormat:@"处理时间：%@",reviewModel.add_time];;
    self.contentNameLabel.text = @"标题：";
    if (reviewModel.type == 0) {
        self.typeLabel.text = @"请款单（家装）";
    }else if (reviewModel.type == 1){
        self.typeLabel.text = @"合同评审表";
    }else if(reviewModel.type == 2){
        self.typeLabel.text = @"家装合同评审表";
    }else if(reviewModel.type == 3){
        self.typeLabel.text = @"请购单（家装）";
    }else if(reviewModel.type == 5){
        self.typeLabel.text = @"印章申请单";
    }else if(reviewModel.type == 6){
        self.typeLabel.text = @"呈批件";
    }else if(reviewModel.type == 7){
        self.typeLabel.text = @"请购单";
    }else if(reviewModel.type == 8){
        self.typeLabel.text = @"请款单";
    }else if(reviewModel.type == 9){
        self.typeLabel.text = @"请款单（其他）";
    }else if(reviewModel.type == 10){
        self.typeLabel.text = @"请购单（其他）";
    }else if(reviewModel.type == 111){
        self.typeLabel.text = @"合同评审表";
    }else if(reviewModel.type == 11){
        self.typeLabel.text = @"报销单";
    }else if(reviewModel.type == 12){
        self.typeLabel.text = @"验收单";
    }
    
    self.contentLable.text = reviewModel.title;
    self.deleteButton.hidden = YES;
    if (reviewModel.approval_state == 0) {
        self.statusLabel.text = @"审批中...";
        self.statusLabel.textColor = ORANGE_COLOR;
        
    }else if (reviewModel.approval_state == 1){
        self.statusLabel.text = @"√已通过";
         self.statusLabel.textColor = GREEN_COLOR;
    }else if (reviewModel.approval_state == 2){
        self.statusLabel.text = @"×被拒绝";
         self.statusLabel.textColor = UIColorFromRGB(217, 13, 14);
    }else if (reviewModel.approval_state == 3){
        self.statusLabel.text = @"！已撤销";
        self.statusLabel.textColor = UIColorFromRGB(254, 42, 1);
        self.deleteButton.hidden = NO;
        if (![NSString isBlankString:reviewModel.withdrawal_reason]) {
            self.cashierLabel.hidden = NO;
            NSString *mark = [NSString stringWithFormat:@"撤销原因：%@",reviewModel.withdrawal_reason];
            self.cashierLabel.text = mark;
            CGSize size = CGSizeMake(self.cashierLabel.width,CGFLOAT_MAX);
            CGSize marksize = [mark sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat markHeight = marksize.height < 20.0 ? 20.0 : marksize.height;
            CGRect frame = self.cashierLabel.frame;
            frame.size.height = markHeight;
            self.cashierLabel.frame = frame;
            self.cellHeight = 85.0 +markHeight;
        }else{
            NSString *mark = [NSString stringWithFormat:@"撤销原因：无"];
             self.cellHeight = 105;
             self.cashierLabel.text = mark;
             self.cashierLabel.hidden = NO;
        }
    }else if (reviewModel.approval_state == 4){
        self.statusLabel.text = @"！已通过（废弃）";
        self.statusLabel.textColor = UIColorFromRGB(254, 42, 1);
        self.deleteButton.hidden = NO;
        if (![NSString isBlankString:reviewModel.withdrawal_reason]) {
            self.cashierLabel.hidden = NO;
            NSString *mark = [NSString stringWithFormat:@"撤销原因：%@",reviewModel.withdrawal_reason];
            self.cashierLabel.text = mark;
            CGSize size = CGSizeMake(self.cashierLabel.width,CGFLOAT_MAX);
            CGSize marksize = [mark sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat markHeight = marksize.height < 20.0 ? 20.0 : marksize.height;
            CGRect frame = self.cashierLabel.frame;
            frame.size.height = markHeight;
            self.cashierLabel.frame = frame;
            self.cellHeight = 85.0 +markHeight;
        }else{
            NSString *mark = [NSString stringWithFormat:@"撤销原因：无"];
            self.cellHeight = 105;
            self.cashierLabel.text = mark;
             self.cashierLabel.hidden = NO;
        }
    }
    if (self.is_show_eyebutton) {
        _eyeButton.hidden = NO;
        self.deleteButton.hidden = YES;
    }
    
   
    
}

-(void)setPersonalSponsorCellWith:(ReviewListModel*)reviewModel
{
    self.cellHeight = 85.0;
    self.cashierLabel.hidden = YES;
    
    self.timeLabel.text = [NSString stringWithFormat:@"处理时间：%@",reviewModel.add_time];;
    self.contentNameLabel.text = @"标题：";
    if(reviewModel.type == 3){
        self.typeLabel.text = @"呈批件";
    }else if(reviewModel.type == 1){
        self.typeLabel.text = @"请购单";
    }else if(reviewModel.type == 2){
        self.typeLabel.text = @"请款单";
    }else if(reviewModel.type == 4){
        self.typeLabel.text = @"报销单";
    }else if(reviewModel.type == 12){
        self.typeLabel.text = @"验收单";
    }
    
    self.contentLable.text = reviewModel.title;
    self.deleteButton.hidden = YES;
    if (reviewModel.approval_state == 0) {
        self.statusLabel.text = @"审批中...";
        self.statusLabel.textColor = ORANGE_COLOR;
        self.deleteButton.hidden = NO;
        
    }else if (reviewModel.approval_state == 1){
        self.statusLabel.text = @"√已通过";
        self.statusLabel.textColor = GREEN_COLOR;
    }else if (reviewModel.approval_state == 2){
        self.statusLabel.text = @"×被拒绝";
        self.statusLabel.textColor = UIColorFromRGB(217, 13, 14);
    }else if (reviewModel.approval_state == 3){
        self.statusLabel.text = @"！已撤销";
        self.statusLabel.textColor = UIColorFromRGB(254, 42, 1);
        self.deleteButton.hidden = NO;
        if (![NSString isBlankString:reviewModel.withdrawal_reason]) {
            self.cashierLabel.hidden = NO;
            NSString *mark = [NSString stringWithFormat:@"撤销原因：%@",reviewModel.withdrawal_reason];
            self.cashierLabel.text = mark;
            CGSize size = CGSizeMake(self.cashierLabel.width,CGFLOAT_MAX);
            CGSize marksize = [mark sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat markHeight = marksize.height < 20.0 ? 20.0 : marksize.height;
            CGRect frame = self.cashierLabel.frame;
            frame.size.height = markHeight;
            self.cashierLabel.frame = frame;
            self.cellHeight = 85.0 +markHeight;
        }else{
            NSString *mark = [NSString stringWithFormat:@"撤销原因：无"];
            self.cellHeight = 105;
            self.cashierLabel.text = mark;
            self.cashierLabel.hidden = NO;
        }
    }else if (reviewModel.approval_state == 4){
        self.statusLabel.text = @"！已通过（废弃）";
        self.statusLabel.textColor = UIColorFromRGB(254, 42, 1);
        self.deleteButton.hidden = NO;
        if (![NSString isBlankString:reviewModel.withdrawal_reason]) {
            self.cashierLabel.hidden = NO;
            NSString *mark = [NSString stringWithFormat:@"撤销原因：%@",reviewModel.withdrawal_reason];
            self.cashierLabel.text = mark;
            CGSize size = CGSizeMake(self.cashierLabel.width,CGFLOAT_MAX);
            CGSize marksize = [mark sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat markHeight = marksize.height < 20.0 ? 20.0 : marksize.height;
            CGRect frame = self.cashierLabel.frame;
            frame.size.height = markHeight;
            self.cashierLabel.frame = frame;
            self.cellHeight = 85.0 +markHeight;
        }else{
            NSString *mark = [NSString stringWithFormat:@"撤销原因：无"];
            self.cellHeight = 105;
            self.cashierLabel.text = mark;
            self.cashierLabel.hidden = NO;
        }
    }
    if (self.is_show_eyebutton) {
        _eyeButton.hidden = NO;
        self.deleteButton.hidden = YES;
    }

}

-(void)clickDeleteButton
{
    [self.delegate clickSeeDetail:self.tag];
}

-(void)clickSeeDetailButton
{
    [self.delegate clickSeeDetail:self.tag];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
