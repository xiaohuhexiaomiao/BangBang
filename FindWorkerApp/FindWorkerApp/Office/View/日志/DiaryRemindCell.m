//
//  DiaryRemindCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/12/5.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "DiaryRemindCell.h"
#import "CXZ.h"
#import "RemindDetailModel.h"
#import "ReplyApprovalContentModel.h"
#import "PublishCommentViewController.h"
@interface DiaryRemindCell()

@property(nonatomic ,strong)UIImageView *headImageview;

@property(nonatomic ,strong)RTLabel *titleLabel;

@property(nonatomic ,strong)RTLabel *contentLabel;

@property(nonatomic ,strong)ShowFilesView *showFielsView;

@property(nonatomic ,strong)UIButton *replyButton;

@property(nonatomic ,strong)UILabel *creatTimeLabel;

@property(nonatomic ,strong)RemindDetailModel *detailModel;


@end

@implementation DiaryRemindCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageview = [[UIImageView alloc]init];
        [self.contentView addSubview:_headImageview];
        [_headImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(8);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(28);
        }];
        _headImageview.layer.cornerRadius = 14.0;
        _headImageview.layer.masksToBounds = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookPersonDetail:)];
//        _headImageview.userInteractionEnabled = YES;
//        [_headImageview addGestureRecognizer:tap];
        
        _titleLabel  = [CustomView customRTLableWithContentView:self.contentView title:nil];
        _titleLabel.frame = CGRectMake(_headImageview.right+3, 10, SCREEN_WIDTH-_headImageview.right-11, 25);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImageview.mas_right).mas_offset(8);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(25);
        }];
        
        _showFielsView = [[ShowFilesView alloc]initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom, _titleLabel.width, 2)];
        _showFielsView.hidden = YES;
        [self.contentView addSubview:_showFielsView];
        [_showFielsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.top.mas_equalTo(_titleLabel.mas_bottom);
            make.width.mas_equalTo(_titleLabel.mas_width);
            make.height.mas_equalTo(2);
        }];
        
        _contentLabel = [CustomView customRTLableWithContentView:self.contentView title:nil];
        _contentLabel.backgroundColor = UIColorFromRGB(248, 249, 248);
        _contentLabel.frame = CGRectMake(_showFielsView.left, _showFielsView.bottom+3, _showFielsView.width, 40);
        _contentLabel.textColor = UIColorFromRGB(152, 152, 152);
        _contentLabel.layer.cornerRadius = 5;
        _contentLabel.layer.masksToBounds = YES;
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_showFielsView.mas_left);
            make.top.mas_equalTo(_showFielsView.mas_bottom);
            make.width.mas_equalTo(_showFielsView.mas_width);
            make.height.mas_equalTo(40);
        }];
        
        _creatTimeLabel = [CustomView customTitleUILableWithContentView:self.contentView title:nil];
        _creatTimeLabel.font = [UIFont systemFontOfSize:12];
        [_creatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentLabel.mas_left);
            make.top.mas_equalTo(_contentLabel.mas_bottom);
            make.right.mas_equalTo(-38);
            make.height.mas_equalTo(30);
        }];
        
        _replyButton = [CustomView customButtonWithContentView:self.contentView image:@"reply" title:nil];
        [_replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_creatTimeLabel.mas_right);
            make.top.mas_equalTo(_contentLabel.mas_bottom);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        [_replyButton addTarget:self action:@selector(clickReplyButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line = [CustomView customLineView:self.contentView];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_creatTimeLabel.mas_left);
            make.top.mas_equalTo(_replyButton.mas_bottom).mas_offset(2);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}


-(void)clickReplyButton:(UIButton*)button
{
    PublishCommentViewController *publishVC = [[PublishCommentViewController alloc]init];
    publishVC.publish_id = self.detailModel.publish_id;
    publishVC.comment_type = 1;
    publishVC.parent_id =  self.detailModel.reply_id;
    publishVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:publishVC animated:YES];
}


-(void)setDiaryRemindCellWithCommentModel:(RemindDetailModel*)remind
{
    self.detailModel = remind;
    
    [self.headImageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,remind.avatar]] placeholderImage:[UIImage imageNamed:@"temp"]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@：回复：%@",remind.name,remind.reply_content];
    self.creatTimeLabel.text = remind.time;
 
    if ([NSString isBlankString:remind.description_detail]) {
        NSString *date = [NSString toDateStringWithTimeInterval:remind.start_time];
        NSString *content;
        if (remind.log_type == 1) {
            content = [NSString stringWithFormat:@"%@ 日计划",date];
        }else if (remind.log_type == 2){
            NSString *mandy = [NSString toMondyWithDateString:date];
            NSString *sundy = [NSString toSundyWithDateString:date];
            NSString *weekStr = [NSString stringWithFormat:@"%@~%@",mandy,sundy];
            content = [NSString stringWithFormat:@"%@ 周计划",weekStr];
        }else if (remind.log_type == 3){
            NSString *monthStr = [date substringWithRange:NSMakeRange(0, 8)];
            content = [NSString stringWithFormat:@"%@ 月计划",monthStr];
        }
         self.contentLabel.text = [NSString stringWithFormat:@"回复我的：%@",content];
    }else{
        
        self.contentLabel.text = [NSString stringWithFormat:@"回复我的：%@",remind.description_detail];
    }
    self.height = 110;
    
}

-(void)setDiaryRemindCellWithZanModel:(RemindDetailModel*)remind
{
    self.detailModel = remind;
    [self.headImageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,remind.avatar]] placeholderImage:[UIImage imageNamed:@"temp"]];
    if (remind.publish_type == 1) {
        NSString *date = [NSString toDateStringWithTimeInterval:remind.start_time];
        NSString *content;
        if (remind.log_type == 1) {
            content = [NSString stringWithFormat:@"%@ 日计划",date];
        }else if (remind.log_type == 2){
            NSString *mandy = [NSString toMondyWithDateString:date];
            NSString *sundy = [NSString toSundyWithDateString:date];
            NSString *weekStr = [NSString stringWithFormat:@"%@~%@",mandy,sundy];
            content = [NSString stringWithFormat:@"%@ 周计划",weekStr];
        }else if (remind.log_type == 3){
            NSString *monthStr = [date substringWithRange:NSMakeRange(0, 8)];
            content = [NSString stringWithFormat:@"%@ 月计划",monthStr];
        }
        self.titleLabel.text = [NSString stringWithFormat:@"%@：赞了我的日志",remind.name];
        self.contentLabel.text = [NSString stringWithFormat:@"对我的日志：%@",content];
    }else if (remind.publish_type == 2){
        self.titleLabel.text = [NSString stringWithFormat:@"%@：赞了我的签到",remind.name];
        self.contentLabel.text = [NSString stringWithFormat:@"对我的外勤签到：%@",remind.description_detail];
    }
    self.creatTimeLabel.text = remind.time;
    self.height = 110;
    self.replyButton.hidden = YES;
}

-(void)setDiaryRemindCellWithReplyContentModel:(ReplyApprovalContentModel*)remind
{
    [self.headImageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,remind.avatar]] placeholderImage:[UIImage imageNamed:@"temp"]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@：回复了我的审批",remind.name];
    self.contentLabel.text = [NSString stringWithFormat:@"回复：%@",remind.descriptionStr];
    self.creatTimeLabel.text = remind.add_time;
    self.height = 110;
    self.replyButton.hidden = YES;
}


@end
