//
//  DiaryCommentCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/15.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "DiaryCommentCell.h"
#import "CXZ.h"
#import "PublishCommentViewController.h"
#import "DiaryCommentModel.h"
#import "PersonDetailViewController.h"

@interface DiaryCommentCell()<RTLabelDelegate>

@property(nonatomic ,strong)UILabel *nameLabel;

@property(nonatomic ,strong)UIImageView *headImageview;

@property(nonatomic ,strong)RTLabel *contentLabel;

@property(nonatomic ,strong)UIButton *replyButton;

@property(nonatomic ,strong)UILabel *creatTimeLabel;

@property(nonatomic ,strong)ShowFilesView *showFielsView;//

@property(nonatomic ,strong) DiaryCommentModel *commentModel;

@end

@implementation DiaryCommentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headImageview = [[UIImageView alloc]init];
        [self.contentView addSubview:_headImageview];
        [_headImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(5);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
        }];
        _headImageview.layer.cornerRadius = 12.5;
        _headImageview.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookPersonDetail:)];
        _headImageview.userInteractionEnabled = YES;
        [_headImageview addGestureRecognizer:tap];
        
        _nameLabel = [CustomView customTitleUILableWithContentView:self.contentView title:nil];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImageview.mas_right).mas_offset(3);
            make.top.mas_equalTo(5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(25);
        }];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookPersonDetail:)];
        _nameLabel.userInteractionEnabled = YES;
        [_nameLabel addGestureRecognizer:tap2];
        
        _replyButton = [CustomView customButtonWithContentView:self.contentView image:@"reply" title:nil];
        [_replyButton addTarget:self action:@selector(clickReplyButton:) forControlEvents:UIControlEventTouchUpInside];
        [_replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCREEN_WIDTH-25);
            make.top.mas_equalTo(5);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        
        _contentLabel  = [CustomView customRTLableWithContentView:self.contentView title:nil];
        _contentLabel.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom, SCREEN_WIDTH-_nameLabel.left-8, 25);
        _contentLabel.delegate = self;
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.top.mas_equalTo(_nameLabel.mas_bottom);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(25);
        }];
        
        _showFielsView = [[ShowFilesView alloc]initWithFrame:CGRectMake(_nameLabel.left, _contentLabel.bottom, SCREEN_WIDTH-_nameLabel.left-8, 2)];
        _showFielsView.hidden = YES;
        [self.contentView addSubview:_showFielsView];
        [_showFielsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.top.mas_equalTo(_contentLabel.mas_bottom);
            make.width.mas_equalTo(_contentLabel.mas_width);
            make.height.mas_equalTo(2);
        }];

        
        _creatTimeLabel = [CustomView customTitleUILableWithContentView:self.contentView title:nil];
        _creatTimeLabel.font = [UIFont systemFontOfSize:10];
        [_creatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.top.mas_equalTo(_showFielsView.mas_bottom);
            make.width.mas_equalTo(_contentLabel.mas_width);
            make.height.mas_equalTo(15);
        }];
        
    }
    return self;
}

-(void)setDiaryCommentCellWithModel:(DiaryCommentModel*)commentModel
{
    self.commentModel = commentModel;
    [self.headImageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,commentModel.avatar]] placeholderImage:[UIImage imageNamed:@"temp"]];
    self.nameLabel.text = commentModel.name;
    self.creatTimeLabel.text = commentModel.add_time;
    if (commentModel.categary_id == 0) {
        self.contentLabel.text =  commentModel.content;
    }else{
        self.contentLabel.text =  [NSString stringWithFormat:@"回复<font size=12 color=\"blue\"><a href=''>%@</a></font>:%@",commentModel.reply_name,commentModel.content];

    }
    CGFloat fileHeight = 0.0f;
    if (commentModel.enclosure.count > 0) {
        fileHeight = [self.showFielsView setShowFilesViewWithArray:commentModel.enclosure];
        _showFielsView.hidden = NO;
        [self.showFielsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(fileHeight);
        }];
        
    }
    CGSize optimumSize = [self.contentLabel optimumSize];
    CGFloat todayHeight = optimumSize.height >20.0 ? optimumSize.height : 20.0;
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(todayHeight);
    }];
    self.cellHeight = 48.0 + todayHeight+fileHeight;
    
    

}
-(void)clickReplyButton:(UIButton*)button
{
    PublishCommentViewController *publishVC = [[PublishCommentViewController alloc]init];
    publishVC.publish_id = self.commentModel.publish_id;
    publishVC.comment_type = 1;
    publishVC.parent_id = [NSString stringWithFormat:@"%@",@(self.commentModel.comment_id)];
    publishVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:publishVC animated:YES];
}

-(void)lookPersonDetail:(UITapGestureRecognizer*)tap
{
    PersonDetailViewController *person = [[PersonDetailViewController alloc]init];
    person.look_uid = self.commentModel.uid;
    person.companyID = self.company_id;
    person.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:person animated:YES];
}

#pragma mark RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
//    NSLog(@"did select url %@", url);
    PersonDetailViewController *person = [[PersonDetailViewController alloc]init];
    person.look_uid = self.commentModel.reply_uid;
    person.companyID = self.company_id;
    person.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:person animated:YES];
}



@end
