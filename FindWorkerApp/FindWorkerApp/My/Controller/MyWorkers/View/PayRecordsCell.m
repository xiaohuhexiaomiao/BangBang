//
//  PayRecordsCell.m
//  FindWorkerApp
//
//  Created by cxz on 2018/3/21.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "PayRecordsCell.h"
#import "CXZ.h"
#import "PayRecordsModel.h"

@interface PayRecordsCell()

@property(nonatomic, strong) UILabel *creat_time_label;//创建时间

@property(nonatomic, strong) UILabel *alipay_account_label;//支付宝账号

@property(nonatomic, strong) UILabel *phone_label;//手机号

@property(nonatomic, strong) UILabel *total_money_label;//总金额

@property(nonatomic, strong) UILabel *this_time_pay_label;//本次付款

@property(nonatomic, strong) RTLabel *pay_content_label;//付款内容

@property(nonatomic, strong) UILabel *pay_type_Label;//付款方式

@property(nonatomic, strong) UIView *lastView;

@property(nonatomic, strong) UIView *line100;

@property(nonatomic, strong) UIButton *screenshotButton;//查看付款截图

@property(nonatomic ,strong) PayRecordsModel *payModel;

@end

@implementation PayRecordsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        _creat_time_label = [CustomView customTitleUILableWithContentView:self.contentView title:nil];
//        [_creat_time_label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
//            make.top.mas_equalTo(8);
//            make.width.mas_equalTo(SCREEN_WIDTH-16);
//            make.height.mas_equalTo(28);
//        }];
//        _creat_time_label.textAlignment = NSTextAlignmentRight;
//        _creat_time_label.font = [UIFont systemFontOfSize:12];
        
        NSString *alipay = @"支付宝账号：";
        CGSize alipaySize = [alipay sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *alipayLabel = [CustomView customTitleUILableWithContentView:self.contentView title:alipay];
        [alipayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(8);
            make.width.mas_equalTo(alipaySize.width+1);
            make.height.mas_equalTo(28);
        }];
        
        _alipay_account_label = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        [_alipay_account_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(alipayLabel.mas_right);
            make.top.mas_equalTo(alipayLabel.mas_top);
            make.width.mas_equalTo(SCREEN_WIDTH-alipaySize.width-17);
            make.height.mas_equalTo(alipayLabel.mas_height);
        }];
        _alipay_account_label.textAlignment = NSTextAlignmentRight;
        
        NSString *phone = @"手机号码：";
        CGSize phoneSize = [phone sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *phoneLabel = [CustomView customTitleUILableWithContentView:self.contentView title:phone];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_alipay_account_label.mas_bottom);
            make.width.mas_equalTo(phoneSize.width+1);
            make.height.mas_equalTo(alipayLabel.mas_height);
        }];
        
        _phone_label = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        [_phone_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(phoneLabel.mas_right);
            make.top.mas_equalTo(phoneLabel.mas_top);
            make.width.mas_equalTo(SCREEN_WIDTH-phoneSize.width-17);
            make.height.mas_equalTo(alipayLabel.mas_height);
        }];
        _phone_label.textAlignment = NSTextAlignmentRight;
        
        
        NSString *content = @"付款内容：";
        CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *contentLabel = [CustomView customTitleUILableWithContentView:self.contentView title:content];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_phone_label.mas_bottom);
            make.width.mas_equalTo(contentSize.width+1);
            make.height.mas_equalTo(alipayLabel.mas_height);
        }];
        
        _pay_content_label = [CustomView customRTLableWithContentView:self.contentView title:nil];
        _pay_content_label.frame = CGRectMake(contentLabel.right, contentLabel.top+2, SCREEN_WIDTH-contentSize.width-9, 26);
        [_pay_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(contentLabel.mas_right);
            make.top.mas_equalTo(contentLabel.mas_top).mas_offset(2);
            make.width.mas_equalTo(SCREEN_WIDTH-contentSize.width-17);
            make.height.mas_equalTo(26);
        }];
        _pay_content_label.textAlignment = RTTextAlignmentRight;
        
        
        NSString *total = @"总金额：";
        CGSize totalSize = [total sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *totalLabel = [CustomView customTitleUILableWithContentView:self.contentView title:total];
        [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_pay_content_label.mas_bottom);
            make.width.mas_equalTo(totalSize.width+1);
            make.height.mas_equalTo(alipayLabel.mas_height);
        }];
        
        _total_money_label = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        [_total_money_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(totalLabel.mas_right);
            make.top.mas_equalTo(totalLabel.mas_top);
            make.width.mas_equalTo(SCREEN_WIDTH-totalSize.width-17);
            make.height.mas_equalTo(alipayLabel.mas_height);
        }];
        _total_money_label.textAlignment = NSTextAlignmentRight;
        
        
        
        NSString *this = @"本次付款金额：";
        CGSize thisSize = [this sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *thisLabel = [CustomView customTitleUILableWithContentView:self.contentView title:this];
        [thisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_total_money_label.mas_bottom);
            make.width.mas_equalTo(thisSize.width+1);
            make.height.mas_equalTo(alipayLabel.mas_height);
        }];
        
        _this_time_pay_label = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        [_this_time_pay_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(thisLabel.mas_right);
            make.top.mas_equalTo(thisLabel.mas_top);
            make.width.mas_equalTo(SCREEN_WIDTH-thisSize.width-17);
            make.height.mas_equalTo(alipayLabel.mas_height);
        }];
        _this_time_pay_label.textAlignment = NSTextAlignmentRight;
        
        
        NSString *payType = @"付款方式：";
        CGSize payTypeSize = [payType sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        UILabel *payTypeLbl = [CustomView customTitleUILableWithContentView:self.contentView title:payType];
        [payTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(_this_time_pay_label.mas_bottom);
            make.width.mas_equalTo(payTypeSize.width+1);
            make.height.mas_equalTo(alipayLabel.mas_height);
        }];
        
        _pay_type_Label = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        [_pay_type_Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(payTypeLbl.mas_right);
            make.top.mas_equalTo(payTypeLbl.mas_top);
            make.width.mas_equalTo(SCREEN_WIDTH-payTypeSize.width-17);
            make.height.mas_equalTo(alipayLabel.mas_height);
        }];
        _pay_type_Label.textAlignment = NSTextAlignmentRight;
        
        
        _screenshotButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"点击查看付款截图"];
        [_screenshotButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(payTypeLbl.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH-16);
            make.height.mas_equalTo(alipayLabel.mas_height);
        }];
        //    [_more_list_button setTitleColor:[UIColor colorWithHexString:@"#0000ff"] forState:UIControlStateNormal];
        [_screenshotButton setTitleColor:[UIColor colorWithHexString:@"#0000ff"] forState:UIControlStateNormal];
        _screenshotButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_screenshotButton addTarget:self action:@selector(clickMoreListButton) forControlEvents:UIControlEventTouchUpInside];
        _screenshotButton.hidden = YES;
        _lastView = _screenshotButton;
        
        self.cellHeight = 28*6+8;
    }
    return self;
}

-(void)setPayRecordsWithModel:(PayRecordsModel*)model
{
    self.payModel = model;
    self.creat_time_label.text = model.add_time;
    if ([NSString isBlankString:model.alipay_id]) {
        self.alipay_account_label.text = @"未填写";
    }else{
        self.alipay_account_label.text = model.alipay_id;
    }
    self.alipay_account_label.text = model.alipay_id;
    self.phone_label.text  = model.phone;
    self.pay_content_label.text = model.body;
    self.total_money_label.text = [NSString stringWithFormat:@"%.2f",model.money];
    self.this_time_pay_label.text = [NSString stringWithFormat:@"%.2f",model.pay_paid];
    CGSize optimumSize = [self.pay_content_label optimumSize];
    CGFloat contentHeighy = optimumSize.width > 26 ? optimumSize.height:26;
    [self.pay_content_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeighy);
    }];
    
    if (model.pay_type == 1) {
        self.pay_type_Label.text = @"支付宝";
        self.screenshotButton.hidden = YES;
        self.cellHeight = 176+optimumSize.height;
    }else{
        self.pay_type_Label.text = @"其他";
        self.screenshotButton.hidden = NO;
        self.cellHeight = 176+optimumSize.height+28;
    }
    
}

-(void)clickMoreListButton
{
    [[NetworkSingletion sharedManager]getReviewAnnexDetail:@{@"enclosure_id":self.payModel.basis} onSucceed:^(NSDictionary *dict) {
        //        NSLog(@"**img**%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            NSArray *imageArray = [dict[@"data"] objectForKey:@"picture"];
            
            NSMutableArray *photoArray = [NSMutableArray array];
            for (int i = 0 ; i < imageArray.count ; i++) {
                NSString *pic = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,imageArray[i]];
//                NSString *pic1 = [NSString stringWithFormat:@"%@%@?imageView2/2/w/80/h/80",IMAGE_HOST,imageArray[i]];
                ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                photo.photoURL = [NSURL URLWithString:pic];
                [photoArray addObject:photo];;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(0) inSection:0];
            ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
            // 淡入淡出效果
            // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
            // 数据源/delegate
            pickerBrowser.editing = NO;
            pickerBrowser.photos = photoArray;
            // 当前选中的值
            pickerBrowser.currentIndex = indexPath.row;
            // 展示控制器
            [pickerBrowser showPickerVc:self.viewController];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self];
    }];

}


@end
