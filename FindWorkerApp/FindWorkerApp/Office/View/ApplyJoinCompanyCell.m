//
//  ApplyJoinCompanyCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/9/1.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ApplyJoinCompanyCell.h"
#import "CXZ.h"
#import "JXPopoverView.h"
#import "ApplyCompanyModel.h"
@interface ApplyJoinCompanyCell()

@property(nonatomic ,strong)UIImageView *avatarImageview;

@property(nonatomic ,strong)UILabel *applyTimeLabel;

@property(nonatomic ,strong)UILabel *applyNameLabel;

@property(nonatomic ,strong)UILabel *applyPhoneLabel;

@property(nonatomic ,strong)UILabel *applyTypeLabel;

@property(nonatomic ,strong)UILabel *applyMarksLabel;

@property(nonatomic ,strong)UIButton *agreeButton;

@property(nonatomic ,strong)UIButton *listButton;

@property(nonatomic ,strong)UIButton *cancelButton;

@property(nonatomic ,strong)UIButton *confirmButton;

@end


@implementation ApplyJoinCompanyCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageview = [[UIImageView alloc]init];
        _avatarImageview.image = [UIImage imageNamed:@"model"];
        [self addSubview:_avatarImageview];
        [_avatarImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(8);
            make.width.height.mas_equalTo(40);
        }];
        _avatarImageview.layer.cornerRadius = 20;
        _avatarImageview.layer.masksToBounds = YES;
        
        _applyTimeLabel = [self customUIlabelwithContent];
        _applyTimeLabel.textAlignment = NSTextAlignmentRight;
        _applyTimeLabel.textColor = FORMLABELTITLECOLOR;
        [self addSubview:_applyTimeLabel];
        [_applyTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(-16);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
            make.height.mas_equalTo(15);
        }];

        
        UILabel *nameLabel = [self customUILabelWithTitle:@"姓名:"];
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_applyTimeLabel.mas_bottom);
            make.left.mas_equalTo(53);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(20);
        }];
        
        
        _applyNameLabel = [self customUIlabelwithContent];
        [self addSubview:_applyNameLabel];
        [_applyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_top);
            make.left.mas_equalTo(nameLabel.mas_right);
            make.right.mas_equalTo(-88);
            make.height.mas_equalTo(20);
        }];
        
        UILabel *phoneLabel = [self customUILabelWithTitle:@"电话:"];
        [self addSubview:phoneLabel];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom);
            make.left.mas_equalTo(nameLabel.mas_left);
            make.width.mas_equalTo(nameLabel.mas_width);
            make.height.mas_equalTo(20);
        }];
        
        _applyPhoneLabel = [self customUIlabelwithContent];
        [self addSubview:_applyPhoneLabel];
        [_applyPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(phoneLabel.mas_top);
            make.left.mas_equalTo(phoneLabel.mas_right);
            make.right.mas_equalTo(_applyNameLabel.mas_right);
            make.height.mas_equalTo(20);
        }];
        
//        UILabel *typeLabel = [self customUILabelWithTitle:@"类型:"];
//        [self addSubview:typeLabel];
//        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(phoneLabel.mas_bottom);
//            make.left.mas_equalTo(phoneLabel.mas_left);
//            make.width.mas_equalTo(phoneLabel.mas_width);
//            make.height.mas_equalTo(20);
//        }];
//        
//        _applyTypeLabel = [self customUIlabelwithContent];
//        [self addSubview:_applyTypeLabel];
//        [_applyTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(typeLabel.mas_top);
//            make.left.mas_equalTo(typeLabel.mas_right);
//            make.right.mas_equalTo(_applyNameLabel.mas_right);
//            make.height.mas_equalTo(20);
//        }];
        
        UILabel *markLable = [self customUILabelWithTitle:@"备注:"];
        [self addSubview:markLable];
        [markLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(phoneLabel.mas_bottom);
            make.left.mas_equalTo(phoneLabel.mas_left);
            make.width.mas_equalTo(phoneLabel.mas_width);
            make.height.mas_equalTo(20);
        }];
        
        _applyMarksLabel = [self customUIlabelwithContent];
        _applyMarksLabel.numberOfLines = 0;
        [self addSubview:_applyMarksLabel];
        [_applyMarksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(markLable.mas_top);
            make.left.mas_equalTo(markLable.mas_right);
            make.right.mas_equalTo(-88);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        UIView  *buttonView = [[UIView alloc]init];
        [self addSubview:buttonView];
        [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(25);
            make.right.mas_equalTo(-8);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
        buttonView.layer.cornerRadius = 5;
        buttonView.layer.borderColor = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00].CGColor;

        _listButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonView addSubview:_listButton];
        [_listButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(0);
            make.width.height.mas_equalTo(20);
        }];
        [_listButton setImage:[UIImage imageNamed:@"arrow_gray"] forState:UIControlStateNormal];
        [_listButton addTarget:self action:@selector(clickListButton) forControlEvents:UIControlEventTouchUpInside];
        
        _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonView addSubview:_agreeButton];
        [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _agreeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(0);
            make.right.mas_equalTo(_listButton.mas_left);
        }];
        [_agreeButton addTarget:self action:@selector(clickAgreeButton) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

#pragma mark 点击时间
-(void)clickListButton
{
    JXPopoverView *popoverView = [JXPopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    JXPopoverAction *action1 = [JXPopoverAction actionWithTitle:@"同意" handler:^(JXPopoverAction *action) {
         [self.agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [self.delegate approvalApplyComapany:1 withModel:self.applyModel];
    }];
    JXPopoverAction *action2 = [JXPopoverAction actionWithTitle:@"拒绝" handler:^(JXPopoverAction *action) {
        [self.agreeButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [self.delegate approvalApplyComapany:2 withModel:self.applyModel];
    }];
    [popoverView showToView:self.listButton withActions:@[action1,action2]];
}

-(void)clickAgreeButton
{
    [self.delegate approvalApplyComapany:1 withModel:self.applyModel];
}

#pragma mark
-(void)setApplyJoinCellWith:(ApplyCompanyModel*)model
{
    [self.avatarImageview sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"model"]];
    self.applyTimeLabel.text = model.add_time;
    self.applyNameLabel.text = model.request_user_name;
    self.applyPhoneLabel.text = model.request_user_phone;
    switch (model.request_type) {
        case 1:
            self.applyTypeLabel.text = @"公司员工";
            break;
        case 2:self.applyTypeLabel.text = @"工人";break;
        case 3:self.applyTypeLabel.text = @"分包商";break;
        case 4:self.applyTypeLabel.text = @"供应商";break;
        default:
            break;
    }
    self.agreeButton.userInteractionEnabled = YES;
    self.listButton.userInteractionEnabled = YES;
    [self.agreeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.listButton.hidden = NO;
    if (model.state == 1) {
        [self.agreeButton setTitle:@"已同意" forState:UIControlStateNormal];
        self.agreeButton.userInteractionEnabled = NO;
        self.listButton.userInteractionEnabled = NO;
        self.listButton.hidden = YES;
        [self.agreeButton setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    }else if (model.state == 2){
        [self.agreeButton setTitle:@"已拒绝" forState:UIControlStateNormal];
        self.agreeButton.userInteractionEnabled = NO;
        self.listButton.userInteractionEnabled = NO;
        self.listButton.hidden = YES;
        [self.agreeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    self.applyMarksLabel.text = model.request_content;
    NSString *remarks = model.request_content;
    self.cellHeight = 85.0f;
    if (![NSString isBlankString:remarks]) {
       
        CGSize size = CGSizeMake(SCREEN_WIDTH-170,CGFLOAT_MAX);
        CGSize labelsize = [remarks sizeWithFont:self.applyMarksLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        self.cellHeight = 65+labelsize.height;
    }
    
}


#pragma mark Custom View Method

-(UILabel*)customUILabelWithTitle:(NSString*)title
{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = FORMLABELTITLECOLOR;
    label.text = title;
    return label;
}

-(UILabel*)customUIlabelwithContent
{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = FORMTITLECOLOR;
    return label;
}

@end
