//
//  AcceptDetailCell.m
//  BangBangGongRen
//
//  Created by cxz on 2018/3/20.
//  Copyright © 2018年 cxz. All rights reserved.
//

#import "AcceptDetailCell.h"
#import "CXZ.h"
#import "ApplyInfoModel.h"
#import "AcceptInfoModel.h"
#import "SignNameViewController.h"
#import "InputReasonViewController.h"

@interface AcceptDetailCell()<RTLabelDelegate>

@property(nonatomic ,strong) UIButton *agreeButton;

@property(nonatomic ,strong) UIButton *refuseButton;

@property(nonatomic ,strong) UIButton *modifyButton;

@property(nonatomic ,strong) UILabel *moneyLabel;

@property(nonatomic ,strong) RTLabel *resonLabel;

@end
@implementation AcceptDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [CustomView customRTLableWithContentView:self.contentView title:nil];
        _titleLabel.frame = CGRectMake(8, 8, 120, 30);
        
        
    }
    return self;
}

-(void)configAcceptCell
{
    if (self.cellType == 0) {
        [_moneyLabel removeFromSuperview];
        _moneyLabel = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        _moneyLabel.frame = CGRectMake(128, 8, SCREEN_WIDTH-136, 30);
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }else if (self.cellType == 1){
        [_refuseButton removeFromSuperview];
        _refuseButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"拒绝"];
        _refuseButton.frame = CGRectMake(SCREEN_WIDTH-128, 8, 60, 30);
        [_refuseButton addTarget:self action:@selector(clickRefuseButton) forControlEvents:UIControlEventTouchUpInside];
        [_refuseButton setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        
        [_agreeButton removeFromSuperview];
        _agreeButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"同意"];
        _agreeButton.frame = CGRectMake(SCREEN_WIDTH-68, 8, 60, 30);
        [_agreeButton addTarget:self action:@selector(clickAgreeButton) forControlEvents:UIControlEventTouchUpInside];
        [_agreeButton setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        _titleLabel.delegate = self;
        
    }

}

-(void)setInfoModel:(AcceptInfoModel *)infoModel
{
    if (infoModel) {
        _infoModel = infoModel;
        _modifyButton.userInteractionEnabled = YES;
        if (self.tag == 0) {
            self.moneyLabel.text = [NSString stringWithFormat:@"%.2lf元",infoModel.apply_content.money];
        }
        self.refuseButton.hidden = NO;
        if (self.tag == 1 ) {
            if (infoModel.apply_content.inspection_state == 1) {
                self.refuseButton.hidden = YES;
                _agreeButton.userInteractionEnabled = NO;
                [_agreeButton setTitle:@"已通过" forState:UIControlStateNormal];
            }
            if (infoModel.apply_content.inspection_state == 2) {
                self.refuseButton.hidden = YES;
                _agreeButton.userInteractionEnabled = NO;
                [_agreeButton setTitle:@"已拒绝" forState:UIControlStateNormal];
            }
            
        }
        if (self.tag == 2  ) {
            if (infoModel.apply_content.settlement_state == 1) {
                self.refuseButton.hidden = YES;
                _agreeButton.userInteractionEnabled = NO;
                [_agreeButton setTitle:@"已通过" forState:UIControlStateNormal];
            }
            if (infoModel.apply_content.settlement_state == 2) {
                self.refuseButton.hidden = YES;
                _agreeButton.userInteractionEnabled = NO;
                [_agreeButton setTitle:@"已拒绝" forState:UIControlStateNormal];
            }
        }
    }
}


#pragma mark IBAction

-(void)clickAgreeButton
{
    SignNameViewController *signVC = [[SignNameViewController alloc]init];
    signVC.contranctID = [self.infoModel.contract_id integerValue];
    signVC.signType = self.tag +1;
    signVC.applyid = self.infoModel.apply_content.apply_id;
    signVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:signVC animated:YES];
    self.viewController.hidesBottomBarWhenPushed =YES;
}

-(void)clickRefuseButton
{
    InputReasonViewController *inputVC = [[InputReasonViewController alloc]init];
    inputVC.contract_id = self.infoModel.contract_id ;
    inputVC.inputType = self.tag ;
    inputVC.apply_id = self.infoModel.apply_content.apply_id;
    inputVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:inputVC animated:YES];
}

-(void)clickModifyButton
{
    
}

#pragma mark RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
        NSLog(@"did select url %@", self.infoModel.apply_content.inspection_id);
    EditWebViewController *web = [[EditWebViewController alloc]init];
    if(self.tag == 1){
        web.titleString = @"报验单";
        web.editType = 9;
        web.formid = [self.infoModel.apply_content.inspection_id integerValue];
    }else if (self.tag == 2){
        web.titleString = @"结算单";
        web.formid = [self.infoModel.apply_content.settlement_id integerValue];
        web.editType = 10 ;
    }
    web.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:web animated:YES];
    self.viewController.hidesBottomBarWhenPushed = YES;
    
}



@end
