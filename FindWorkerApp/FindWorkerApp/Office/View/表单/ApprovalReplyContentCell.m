//
//  ApprovalReplyContentCell.m
//  FindWorkerApp
//
//  Created by cxz on 2018/4/9.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "ApprovalReplyContentCell.h"
#import "CXZ.h"
#import "ApprovalReplyModel.h"
#import "ApprovalContentModel.h"

@interface ApprovalReplyContentCell ()

@property(nonatomic, strong)RTLabel *replyLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UIButton *replyButton;

@property(nonatomic ,strong)ApprovalReplyModel *replyModel;

@property(nonatomic ,strong)ShowFilesView *showFielsView;//

@end

@implementation ApprovalReplyContentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _replyLabel = [CustomView customRTLableWithContentView:self title:nil];
        _replyLabel.frame = CGRectMake(48, 0, SCREEN_WIDTH-56, 30);
        _replyLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_replyLabel];
        
        _showFielsView = [[ShowFilesView alloc]initWithFrame:CGRectMake(0, _replyLabel.bottom, SCREEN_WIDTH-16, 10)];
        _showFielsView.hidden = YES;
        [self addSubview:_showFielsView];
      
        NSString *timeStr = @"2018-01-17 15:51:51";
        CGSize timeSize = [timeStr sizeWithFont:[UIFont systemFontOfSize:10] width:SCREEN_WIDTH];
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_replyLabel.left, _replyLabel.bottom, timeSize.width+10, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = TITLECOLOR;
        [self addSubview:_timeLabel];
        
        _replyButton = [CustomView customButtonWithContentView:self image:@"reply" title:@"回复"];
        _replyButton.frame = CGRectMake(_timeLabel.right, _timeLabel.top, 60, 20);
        _replyButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _replyButton.imageEdgeInsets = UIEdgeInsetsMake(2, -3, 0, 3);
        [_replyButton addTarget:self action:@selector(clickReplyButton) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

-(void)setApprovalReplyContentWithDict:(NSDictionary *)dict
{
    self.replyModel = [ApprovalReplyModel objectWithKeyValues:dict];
    self.timeLabel.text = self.replyModel.add_time;
    if ([self.replyModel.return_person_uid isEqualToString:self.approvalContentModel.uid]) {
        self.replyLabel.text = [NSString stringWithFormat:@"%@<font size=12 color=\"blue\">回复</font>:%@",self.replyModel.name,self.replyModel.reply_content];
    }else{
        self.replyLabel.text = [NSString stringWithFormat:@"%@<font size=12 color=\"blue\">回复<a href=''></a></font>%@:%@",self.replyModel.name,self.replyModel.return_person_name,self.replyModel.reply_content];
    }
    
    CGSize optimumSize = [self.replyLabel optimumSize];
    CGRect frame = self.replyLabel.frame;
    frame.size = optimumSize;
    self.replyLabel.frame = frame;

    self.timeLabel.top = self.replyLabel.bottom;
    self.replyButton.top = self.timeLabel.top;
    self.cellHeight = 20+ optimumSize.height;
    
    if (self.replyModel.many_enclosure.count > 0) {
        self.showFielsView.hidden = NO;
        CGFloat fileHeight = [self.showFielsView setShowFilesViewWithArray:self.replyModel.many_enclosure];
        CGRect frame = self.showFielsView.frame;
        frame.size.height = fileHeight;
        self.showFielsView.frame = frame;
        self.timeLabel.top = self.showFielsView.bottom;
        self.replyButton.top = self.timeLabel.top;
        self.cellHeight =  20+ optimumSize.height+fileHeight;
    }
}


-(void)clickReplyButton
{
//    NSLog(@"click reply");
    [self.delegate clickReplyButtonOfCellWith:self.approvalContentModel replyModel:self.replyModel];
}



@end
