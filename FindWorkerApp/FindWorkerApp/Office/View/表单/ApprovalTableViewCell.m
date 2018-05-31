//
//  ApprovalTableViewCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ApprovalTableViewCell.h"
#import "CXZ.h"
#import "ColorView.h"
@interface ApprovalTableViewCell()

@property (nonatomic ,strong) UIImageView *avatarImageview;

@property (nonatomic ,strong) UILabel *nameLabel;

@property (nonatomic ,strong) UILabel *typeLabel;

@property (nonatomic ,strong) UILabel *contentLable;

@property (nonatomic ,strong) UILabel *statusLable;

@property (nonatomic ,strong) UILabel *contentNameLabel;

@property (nonatomic ,strong) UILabel *statusLabel;

@property (nonatomic ,strong) UILabel *status;

@property (nonatomic ,strong) UILabel *createTimeLabel;

@property (nonatomic ,strong) UILabel *reasonLabel;

@property (nonatomic ,strong) UIView *signView;

@property (nonatomic ,strong) UIView *signBtnView;

@property (nonatomic ,strong) ColorView *colorView;

@property (nonatomic ,strong) ReviewListModel *tempModel;

@property (nonatomic ,assign) BOOL is_remind;

@end

@implementation ApprovalTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _avatarImageview = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 30, 30)];
        _avatarImageview.image = [UIImage imageNamed:@"temp"];
        _avatarImageview.layer.cornerRadius = _avatarImageview.frame.size.width/2;
        _avatarImageview.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageview];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avatarImageview.right, 2, SCREEN_WIDTH-_avatarImageview.right-18, 15)];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = SUBTITLECOLOR;
        [self.contentView addSubview:_timeLabel];
        
        _signView = [[UIView alloc]initWithFrame:CGRectMake(_timeLabel.right, _timeLabel.top, 18, 18)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSignColorButton)];
        [_signView addGestureRecognizer:tap];
        [self.contentView addSubview:_signView];
        
        
        CGFloat with = 11;
        _signBtnView = [[UIView alloc]initWithFrame:CGRectMake(2, 2, with, with)];
        _signBtnView.layer.cornerRadius= with/2;
        _signBtnView.layer.borderColor = LINE_GRAY.CGColor;
        _signBtnView.layer.borderWidth = 0.8;
        _signBtnView.layer.masksToBounds = YES;
        _signBtnView.backgroundColor = [UIColor whiteColor];
        [_signView addSubview:_signBtnView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avatarImageview.right +5 , _avatarImageview.top, SCREEN_WIDTH-_avatarImageview.right-13, 15)];
        _nameLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        _nameLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_nameLabel];
        
        _companyName = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.left , _nameLabel.bottom, SCREEN_WIDTH-_avatarImageview.right-13, 15)];
        _companyName.font = [UIFont systemFontOfSize:FONT_SIZE];
        _companyName.textColor = [UIColor grayColor];
        [self.contentView addSubview:_companyName];
        
        CGSize typeSize = [@"类型：" sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *type = [[UILabel alloc]initWithFrame:CGRectMake(_avatarImageview.left, _avatarImageview.bottom+3, typeSize.width+2, 18)];
        type.text = @"类型：";
        type.font = _nameLabel.font;
        type.textColor = TITLECOLOR;
        [self.contentView addSubview:type];
        
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(type.right, type.top, SCREEN_WIDTH-type.right-8, type.height)];
        _typeLabel.font = _nameLabel.font;
        _typeLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_typeLabel];
        
        _contentNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(type.left, type.bottom, type.width, type.height)];
        _contentNameLabel.font = _nameLabel.font;
        _contentNameLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_contentNameLabel];
        
        _contentLable = [[UILabel alloc]initWithFrame:CGRectMake(_contentNameLabel.right, _contentNameLabel.top, SCREEN_WIDTH-_contentNameLabel.right-8, 20)];
        _contentLable.font = _nameLabel.font;
        _contentLable.textColor = TITLECOLOR;
        [self.contentView addSubview:_contentLable];
        
        CGSize createTimeSize = [@"发起时间：" sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *createTime = [[UILabel alloc]initWithFrame:CGRectMake(type.left, _contentLable.bottom, createTimeSize.width+2, type.height)];
        createTime.font = type.font;
        createTime.textColor = TITLECOLOR;
        createTime.text = @"发起时间：";
        [self.contentView addSubview: createTime];
        
        _createTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(createTime.right, createTime.top, SCREEN_WIDTH-createTime.right-8, createTime.height)];
        _createTimeLabel.font = createTime.font;
        _createTimeLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_createTimeLabel];
        
        CGSize statusSize = [@"审批进程：" sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        _status = [[UILabel alloc]initWithFrame:CGRectMake(createTime.left, createTime.bottom, statusSize.width+1, type.height)];
        _status.font = type.font;
        _status.textColor = TITLECOLOR;
        _status.text = @"审批进程：";
        _status.hidden = YES;
        [self.contentView addSubview:_status];
        
        _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(_status.right, _status.top, SCREEN_WIDTH-_status.right-8, _status.height)];
        _statusLabel.font = _status.font;
        _statusLabel.hidden = YES;
        [self.contentView addSubview:_statusLabel];
        
        _reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, _statusLabel.bottom, SCREEN_WIDTH-16, 20)];
        _reasonLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        _reasonLabel.textColor = FORMTITLECOLOR;
        _reasonLabel.hidden = YES;
        _reasonLabel.numberOfLines = 0;
        [self.contentView addSubview:_reasonLabel];
        
    }
    return self;
}

-(void)setApprovalCellWith:(ReviewListModel*)reviewModel
{
    self.tempModel = reviewModel;
    self.signView.hidden = YES;
    NSString *avataStr = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,reviewModel.avatar];
    [self.avatarImageview sd_setImageWithURL:[NSURL URLWithString:avataStr] placeholderImage:[UIImage imageNamed:@"temp"]];
    self.nameLabel.text =  reviewModel.name;
    
    if (self.is_More) {
        self.companyName.text = [NSString stringWithFormat:@"%@",reviewModel.company_name];
    }else{
        self.nameLabel.top = self.avatarImageview.center.y-self.nameLabel.height/2;
    }
    if (self.formType == 0) {
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
        }
        
    }else{
        if(reviewModel.type == 3){
            self.typeLabel.text = @"呈批件";
        }else if(reviewModel.type == 1){
            self.typeLabel.text = @"请购单";
        }else if(reviewModel.type == 2){
            self.typeLabel.text = @"请款单";
        }else if(reviewModel.type == 4){
            self.typeLabel.text = @"报销单";
        }
    }
    self.contentNameLabel.text = @"标题：";
    self.contentLable.text = reviewModel.title;
    self.createTimeLabel.text = reviewModel.add_time;
}



-(void)setSearchApprovalCellWith:(ReviewListModel*)reviewModel
{
    self.reasonLabel.hidden = YES;
    self.cellHeight = 122.0;
    
    self.tempModel = reviewModel;
    self.signView.hidden = NO;
    self.signView.backgroundColor = [UIColor whiteColor];
    if (![NSString isBlankString:reviewModel.tagging]) {
        self.signBtnView.backgroundColor = [UIColor colorWithHexString:reviewModel.tagging];
    }
    //    NSLog(@"**color*%@*%@",reviewModel.add_time,reviewModel.tagging);
    
    NSString *avataStr = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,reviewModel.avatar];
    [self.avatarImageview sd_setImageWithURL:[NSURL URLWithString:avataStr] placeholderImage:[UIImage imageNamed:@"temp"]];
    self.nameLabel.text =  reviewModel.name;
    self.timeLabel.text = [NSString stringWithFormat:@"处理时间：%@",reviewModel.add_time];
    if (self.is_More) {
        self.companyName.text = [NSString stringWithFormat:@"%@",reviewModel.company_name];
    }else{
        self.nameLabel.top = self.avatarImageview.center.y-self.nameLabel.height/2;
    }
    if (self.formType == 0) {
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
        }
        
    }else{
        if(reviewModel.type == 3){
            self.typeLabel.text = @"呈批件";
        }else if(reviewModel.type == 1){
            self.typeLabel.text = @"请购单";
        }else if(reviewModel.type == 2){
            self.typeLabel.text = @"请款单";
        }else if(reviewModel.type == 4){
            self.typeLabel.text = @"报销单";
        }
    }

    self.contentNameLabel.text = @"标题：";
    self.contentLable.text = reviewModel.title;
    
    self.createTimeLabel.text = reviewModel.creat_time;
    
    self.status.hidden = NO;
    self.statusLabel.hidden = NO;
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
        if (![NSString isBlankString:reviewModel.withdrawal_reason]) {
            self.reasonLabel.hidden = NO;
            NSString *mark = [NSString stringWithFormat:@"撤销原因：%@",reviewModel.withdrawal_reason];
            self.reasonLabel.text = mark;
            CGSize size = CGSizeMake(self.reasonLabel.width,CGFLOAT_MAX);
            CGSize marksize = [mark sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat markHeight = marksize.height < 20.0 ? 20.0 : marksize.height;
            CGRect frame = self.reasonLabel.frame;
            frame.size.height = markHeight;
            self.reasonLabel.frame = frame;
            self.cellHeight = 122.0 +markHeight;
        }else{
            self.reasonLabel.hidden = NO;
            NSString *mark = [NSString stringWithFormat:@"撤销原因：无"];
            self.cellHeight = 142;
            self.reasonLabel.text = mark;
        }
    }else if (reviewModel.approval_state == 4){
        self.statusLabel.text = @"！已通过（废弃）";
        self.statusLabel.textColor = UIColorFromRGB(254, 42, 1);
        if (![NSString isBlankString:reviewModel.withdrawal_reason]) {
            self.reasonLabel.hidden = NO;
            NSString *mark = [NSString stringWithFormat:@"撤销原因：%@",reviewModel.withdrawal_reason];
            self.reasonLabel.text = mark;
            CGSize size = CGSizeMake(self.reasonLabel.width,CGFLOAT_MAX);
            CGSize marksize = [mark sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat markHeight = marksize.height < 20.0 ? 20.0 : marksize.height;
            CGRect frame = self.reasonLabel.frame;
            frame.size.height = markHeight;
            self.reasonLabel.frame = frame;
            self.cellHeight = 122.0 +markHeight;
        }else{
            NSString *mark = [NSString stringWithFormat:@"撤销原因：无"];
            self.cellHeight = 142;
            self.reasonLabel.text = mark;
            self.reasonLabel.hidden = NO;
        }
    }
    
}

-(void)setCashierApprovalCellWith:(ReviewListModel*)reviewModel
{
    self.tempModel = reviewModel;
    self.is_remind = YES;
    self.signView.backgroundColor = [UIColor whiteColor];
    if (![NSString isBlankString:reviewModel.tagging]) {
        self.signBtnView.backgroundColor = [UIColor colorWithHexString:reviewModel.tagging];
    }
    //        NSLog(@"**color*%@*%@",reviewModel.add_time,reviewModel.tagging);
    
    NSString *avataStr = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,reviewModel.avatar];
    [self.avatarImageview sd_setImageWithURL:[NSURL URLWithString:avataStr] placeholderImage:[UIImage imageNamed:@"temp"]];
    self.nameLabel.text =  reviewModel.name;
    self.timeLabel.text = [NSString stringWithFormat:@"处理时间：%@",reviewModel.save_time];
    if (self.is_More) {
        self.companyName.text = [NSString stringWithFormat:@"%@",reviewModel.company_name];
    }else{
        self.nameLabel.top = self.avatarImageview.center.y-self.nameLabel.height/2;
    }
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
    }
    self.contentNameLabel.text = @"标题：";
    self.contentLable.text = reviewModel.title;
    
    self.createTimeLabel.text = reviewModel.add_time;
    
    self.status.hidden = NO;
    self.statusLabel.hidden = NO;
    if (reviewModel.approval_state == 0) {
        self.statusLabel.text = @"审批中...";
        self.statusLabel.textColor = ORANGE_COLOR;
        
    }else if (reviewModel.approval_state == 1){
        self.statusLabel.text = @"√已通过";
        self.statusLabel.textColor = GREEN_COLOR;
    }else if (reviewModel.approval_state == 2){
        self.statusLabel.text = @"×被拒绝";
        self.statusLabel.textColor = UIColorFromRGB(217, 13, 14);
    }else  if (reviewModel.approval_state == 3){
        self.statusLabel.text = @"！已撤销";
        self.statusLabel.textColor = UIColorFromRGB(254, 42, 1);
        if (![NSString isBlankString:reviewModel.withdrawal_reason]) {
            self.reasonLabel.hidden = NO;
            NSString *mark = [NSString stringWithFormat:@"撤销原因：%@",reviewModel.withdrawal_reason];
            self.reasonLabel.text = mark;
            CGSize size = CGSizeMake(self.reasonLabel.width,CGFLOAT_MAX);
            CGSize marksize = [mark sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat markHeight = marksize.height < 20.0 ? 20.0 : marksize.height;
            CGRect frame = self.reasonLabel.frame;
            frame.size.height = markHeight;
            self.reasonLabel.frame = frame;
            self.cellHeight = 122.0 +markHeight;
        }else{
            NSString *mark = [NSString stringWithFormat:@"撤销原因：无"];
            self.cellHeight = 142;
            self.reasonLabel.text = mark;
            self.reasonLabel.hidden = NO;
        }
    }else if (reviewModel.approval_state == 4){
        self.statusLabel.text = @"！已通过（废弃）";
        self.statusLabel.textColor = UIColorFromRGB(254, 42, 1);
        if (![NSString isBlankString:reviewModel.withdrawal_reason]) {
            self.reasonLabel.hidden = NO;
            NSString *mark = [NSString stringWithFormat:@"撤销原因：%@",reviewModel.withdrawal_reason];
            self.reasonLabel.text = mark;
            CGSize size = CGSizeMake(self.reasonLabel.width,CGFLOAT_MAX);
            CGSize marksize = [mark sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat markHeight = marksize.height < 20.0 ? 20.0 : marksize.height;
            CGRect frame = self.reasonLabel.frame;
            frame.size.height = markHeight;
            self.reasonLabel.frame = frame;
            self.cellHeight = 122.0 +markHeight;
        }else{
            NSString *mark = [NSString stringWithFormat:@"撤销原因：无"];
            self.cellHeight = 142;
            self.reasonLabel.text = mark;
            self.reasonLabel.hidden = NO;
        }
    }
    
}

-(void)clickSignColorButton
{
    if (!_colorView) {
        _colorView = [[ColorView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-32, self.signView.bottom, 30, 80)];
        _colorView.backgroundColor = [UIColor whiteColor];
        _colorView.hidden = YES;
        [_colorView setColorCardView: @[@"FF0000",@"FFFF00",@"00FF00",@"0000FF"]];
        [self.contentView addSubview:_colorView];
    }
    _colorView.hidden = !_colorView.isHidden;
    if (!_colorView.isHidden) {
        __weak typeof(self) weakself = self;
        _colorView.DidClickColorCard = ^(NSString *colorString) {
            //        NSLog(@"**colorsign**%@",colorString);
            weakself.signBtnView.backgroundColor = [UIColor colorWithHexString:colorString];
            if (weakself.is_remind) {
                [weakself setSignColorWithString:colorString];
            }else{
                [weakself addSignColorWithString:colorString];
            }
            
        };
    }
    
    
}



-(void)setSignColorWithString:(NSString*)colorString
{
    //    NSLog(@"**colorsign**%@",colorString);
    NSDictionary *paramDict = @{@"true_uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                @"tagging":colorString,
                                @"company_id":self.tempModel.company_id,
                                @"participation_id":self.tempModel.approval_id};
    [[NetworkSingletion sharedManager]cashierListSign:paramDict onSucceed:^(NSDictionary *dict) {
        //        NSLog(@"**colorsign**%@",dict);
        if ([dict[@"code"] integerValue] != 0) {
            [MBProgressHUD showError:dict[@"message"] toView:self];
        }
    } OnError:^(NSString *error) {
        
    }];
    
}

-(void)addSignColorWithString:(NSString*)colorString
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                @"tagging":colorString,
                                @"participation_id":self.tempModel.participation_id};
    [[NetworkSingletion sharedManager]addColorSign:paramDict onSucceed:^(NSDictionary *dict) {
        
        if ([dict[@"code"] integerValue] != 0) {
            [MBProgressHUD showError:dict[@"message"] toView:self];
        }
    } OnError:^(NSString *error) {
        
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
