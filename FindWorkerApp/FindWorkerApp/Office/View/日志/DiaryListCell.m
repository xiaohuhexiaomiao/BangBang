//
//  DiaryListCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/16.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "DiaryListCell.h"

#import "CXZ.h"
#import "DiaryBottomReplyView.h"

#import "DiaryModel.h"

#import "PublishCommentViewController.h"
#import "PersonDetailViewController.h"

#import "PersonelModel.h"

@interface DiaryListCell()<BottomReplyViewDelegate>

@property(nonatomic, strong) UIImageView *headImgview;

@property(nonatomic, strong) UILabel *nameLabel;

@property(nonatomic, strong) UILabel *diaryTypeLabel;

@property(nonatomic, strong) UILabel *creatTimeLabel;

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UIButton *signButton;

@property(nonatomic, strong) UIView *line;

@property(nonatomic, strong) RTLabel *contentLabel;

@property(nonatomic, strong) DiaryBottomReplyView *replyView;

@property(nonatomic , copy) NSString *publish_id;

@property(nonatomic , copy) NSString *log_id;

@property(nonatomic, assign) BOOL is_delete;//是否可以删除

@property(nonatomic, strong)DiaryModel *diaryModel;

@end


@implementation DiaryListCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImgview = [[UIImageView alloc]init];
        [self.contentView addSubview:_headImgview];
        [_headImgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(8);
            make.width.height.mas_equalTo(40);
        }];
        _headImgview.layer.cornerRadius = 20;
        _headImgview.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeadImageView:)];
        _headImgview.userInteractionEnabled = YES;
        [_headImgview addGestureRecognizer:tap];
        
        
        _nameLabel = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgview.mas_right).mas_offset(5);
            make.top.mas_equalTo(_headImgview.mas_top);
            make.width.mas_equalTo(SCREEN_WIDTH-150);
            make.height.mas_equalTo(25);
        }];
        
        //发布时间
        _creatTimeLabel = [CustomView customTitleUILableWithContentView:self.contentView title:nil];
        _creatTimeLabel.textColor = UIColorFromRGB(210, 210, 210);
        _creatTimeLabel.font = [UIFont systemFontOfSize:12];
        [_creatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.top.mas_equalTo(_nameLabel.mas_bottom);
            make.width.mas_equalTo(_nameLabel.mas_width);
            make.height.mas_equalTo(15);
        }];
        
        //日志类别 点评
        _diaryTypeLabel = [CustomView customTitleUILableWithContentView:self.contentView title:nil];
        _diaryTypeLabel.textAlignment = NSTextAlignmentRight;
        _diaryTypeLabel.font = [UIFont systemFontOfSize:12];
        _diaryTypeLabel.textColor = UIColorFromRGB(210, 210, 210);
        [_diaryTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCREEN_WIDTH-98);
            make.top.mas_equalTo(_nameLabel.mas_top);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(20);
        }];
        
        //日志标题
        _titleLabel = [CustomView customTitleUILableWithContentView:self.contentView title:nil];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_headImgview.mas_bottom).mas_offset(15);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo(20);
        }];
        
        //日志内容
        _contentLabel = [CustomView customRTLableWithContentView:self.contentView title:nil];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.frame = CGRectMake(8, _titleLabel.bottom, SCREEN_WIDTH-16, 40);
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_titleLabel.mas_bottom).mas_offset(5);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo(35);
        }];
        
        
        //签到地址
        _signButton = [CustomView customButtonWithContentView:self.contentView image:@"blue_position" title:nil];
        _signButton.hidden = YES;
        _signButton.layer.cornerRadius = 2;
        _signButton.layer.masksToBounds = YES;
        _signButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _signButton.backgroundColor = FONTBACKGROUNDCOLOR;
        [_signButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
        _signButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_signButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_contentLabel.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo(40);
        }];
        
        _replyView = [[DiaryBottomReplyView alloc]initWithFrame:CGRectMake(0,_contentLabel.bottom, SCREEN_WIDTH, 40)];
        _replyView.delegate = self;
        [self.contentView addSubview:_replyView];
        [_replyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(_contentLabel.mas_bottom).mas_offset(5);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(40);
        }];
        
        
//        UIView *line = [[UIView alloc]init];
//        line.backgroundColor = UIColorFromRGB(241, 241, 241);
//        [self.contentView addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
//            make.top.mas_equalTo(_replyView.mas_bottom);
//            make.width.mas_equalTo(SCREEN_WIDTH);
//            make.height.mas_equalTo(8);
//        }];
        
    }
    return self;
}


-(void)setDiaryListCellWithModel:(DiaryModel*)model
{
    self.diaryModel = model;
    [self.headImgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,model.avatar]] placeholderImage:[UIImage imageNamed:@"temp"]];
    self.nameLabel.text = model.name;
    self.creatTimeLabel.text = model.add_time;
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    self.is_delete = [model.uid isEqualToString:uid];
    self.publish_id= model.publish_id;
    self.log_id = model.log_id;
    self.replyView.publish_id = model.publish_id;
    self.replyView.log_id = model.log_id;
    self.replyView.company_id = model.company_id;
    self.replyView.is_review = [model.reviewer isEqualToString:uid];
    
    if ([NSString isBlankString:model.like_id]) {
        [self.replyView.goodButton setImage:[UIImage imageNamed:@"good"] forState:UIControlStateNormal];
        [self.replyView.goodButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
        //         [self.replyView.goodButton setTitle:@"赞" forState:UIControlStateNormal];
    }else{
        [self.replyView.goodButton setImage:[UIImage imageNamed:@"yizan"] forState:UIControlStateNormal];
        [self.replyView.goodButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //        [self.replyView.goodButton setTitle:@"已赞" forState:UIControlStateNormal];
    }
    if (model.form_type == 1) {
        NSString *date = [NSString toDateStringWithTimeInterval:model.start_time];
        NSString *contentString = @"";
        NSArray *resultArray = [FormElementsModel objectArrayWithKeyValuesArray:model.custom_form_elements];
        for (FormElementsModel *elementModel in resultArray) {
            contentString = [contentString stringByAppendingFormat:@"<font color=#d2d2d2>%@</font><br>%@<br>",elementModel.title,elementModel.result];
        }
        self.contentLabel.text = contentString;
        if (model.log_type == 1) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@ 日计划，由%@点评",date,model.reviewer_name];
        }else if (model.log_type == 2){
            NSString *mandy = [NSString toMondyWithDateString:date];
            NSString *sundy = [NSString toSundyWithDateString:date];
            NSString *weekStr = [NSString stringWithFormat:@"%@~%@",mandy,sundy];
            self.titleLabel.text = [NSString stringWithFormat:@"%@ 周计划，由%@点评",weekStr,model.reviewer_name];
        }else if (model.log_type == 3){
            NSString *monthStr = [date substringWithRange:NSMakeRange(0, 8)];
            self.titleLabel.text = [NSString stringWithFormat:@"%@ 月计划，由%@点评",monthStr,model.reviewer_name];
        }
        if (model.reviewer_fraction == 0) {
            self.diaryTypeLabel.text = @"日志-未点评";
        }else{
            self.diaryTypeLabel.text = [NSString stringWithFormat:@"已点评：%li分",model.reviewer_fraction];
        }
        self.signButton.hidden = YES;
        [self.replyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentLabel.mas_bottom).mas_offset(5);
        }];
        CGSize optimumSize = [self.contentLabel optimumSize];
        CGFloat contentHeight = optimumSize.height > 200.0 ? 200.0 :optimumSize.height;
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentHeight);
        }];
        self.cellHeight =  132.0 + contentHeight;
        
    }
    if (model.form_type == 2 ) {
        
        self.diaryTypeLabel.text = @"外勤签到";
        NSDate *date = [NSDate dateFromString:model.add_time];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        NSString *signTime = [formatter stringFromDate:date];
        self.titleLabel.text = [NSString stringWithFormat:@"签到时间 %@",signTime];
        self.contentLabel.text = model.remarks;
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(35.0);
        }];
        [self.signButton setTitle:model.describe forState:UIControlStateNormal];
        self.signButton.hidden =NO;
        [self.replyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentLabel.mas_bottom).mas_offset(60);
        }];
        self.cellHeight =  222.0;
    }
    if (self.is_delete) {
        self.replyView.thirdButton.hidden = NO;
    }else{
        self.replyView.thirdButton.hidden = YES;
    }
}

-(void)setSignListCellWithModel:(DiaryModel*)model
{
    self.diaryModel = model;
    [self.headImgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,model.avatar]] placeholderImage:[UIImage imageNamed:@"temp"]];
    self.nameLabel.text = model.name;
    self.creatTimeLabel.text = model.add_time;
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    self.is_delete = [model.uid isEqualToString:uid];
    self.publish_id= model.publish_id;
    self.log_id = model.log_id;
    self.replyView.publish_id = model.publish_id;
    self.replyView.log_id = model.log_id;
    self.replyView.company_id = model.company_id;
    self.replyView.is_review = [model.reviewer isEqualToString:uid];
    
    if ([NSString isBlankString:model.like_id]) {
        [self.replyView.goodButton setImage:[UIImage imageNamed:@"good"] forState:UIControlStateNormal];
        [self.replyView.goodButton setTitleColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] forState:UIControlStateNormal];
        //         [self.replyView.goodButton setTitle:@"赞" forState:UIControlStateNormal];
    }else{
        [self.replyView.goodButton setImage:[UIImage imageNamed:@"yizan"] forState:UIControlStateNormal];
        [self.replyView.goodButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //        [self.replyView.goodButton setTitle:@"已赞" forState:UIControlStateNormal];
    }
    self.diaryTypeLabel.text = @"外勤签到";
    NSDate *date = [NSDate dateFromString:model.add_time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *signTime = [formatter stringFromDate:date];
    self.titleLabel.text = [NSString stringWithFormat:@"签到时间 %@",signTime];
    self.contentLabel.text = model.remarks;
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35.0);
    }];
    [self.signButton setTitle:model.describe forState:UIControlStateNormal];
    self.signButton.hidden =NO;
    [self.replyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentLabel.mas_bottom).mas_offset(60);
    }];
    self.cellHeight =  222.0;
    if (self.is_delete) {
        self.replyView.thirdButton.hidden = NO;
    }else{
        self.replyView.thirdButton.hidden = YES;
    }

}

-(void)clickThirdButton
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"确认是否删除？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    } ]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteDiary];
    } ]];
    
    [self.viewController.navigationController presentViewController:alertView animated:YES completion:nil];
    
}

-(void)clickDianPingButton:(UIButton*)button
{
    NSString *buttonTitle = [button titleForState:UIControlStateNormal];
    if ([buttonTitle isEqualToString:@"点评"]) {
        PublishCommentViewController *publishVC = [[PublishCommentViewController alloc]init];
        publishVC.comment_type = 2;
        publishVC.publish_id = self.diaryModel.publish_id;
        publishVC.log_id = self.diaryModel.log_id;
        publishVC.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:publishVC animated:YES];
    }else if ([buttonTitle isEqualToString:@"删除"]) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"确认是否删除？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        } ]];
        
        [alertView addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           [self deleteDiary];
        } ]];
        
        [self.viewController.navigationController presentViewController:alertView animated:YES completion:nil];
        
    }
    
}

-(void)deleteDiary
{
    [self.delegate deleteDiary:self.diaryModel];
}

-(void)clickHeadImageView:(UITapGestureRecognizer*)tap
{
    PersonDetailViewController *person = [[PersonDetailViewController alloc]init];
    person.look_uid = self.diaryModel.uid;
    person.companyID = self.diaryModel.company_id;
    person.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:person animated:YES];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
