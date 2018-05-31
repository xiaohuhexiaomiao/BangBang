//
//  AcceptDetailCell.m
//  BangBangGongRen
//
//  Created by cxz on 2018/3/20.
//  Copyright © 2018年 cxz. All rights reserved.
//

#import "ReceiveAcceptDetailCell.h"
#import "CXZ.h"
#import "ListViewController.h"
#import "ApplyInfoModel.h"
#import "AcceptInfoModel.h"
@interface ReceiveAcceptDetailCell()<RTLabelDelegate,UITextFieldDelegate>

@property(nonatomic ,strong) UIButton *agreeButton;

@property(nonatomic ,strong) UIButton *refuseButton;

@property(nonatomic ,strong) UIButton *modifyButton;

@property(nonatomic ,strong) RTLabel *resonLabel;

@end
@implementation ReceiveAcceptDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [CustomView customRTLableWithContentView:self.contentView title:nil];
        _titleLabel.frame = CGRectMake(8, 8, 120, 30);
        
        self.cellHeight = 40.0f;
    }
    return self;
}

-(void)configAcceptCell
{
    if (self.cellType == 0) {
        [_inputMoneyTextfield removeFromSuperview];
        _inputMoneyTextfield = [CustomView customUITextFieldWithContetnView:self.contentView placeHolder:@"请与结算单金额保持一致"];
        _inputMoneyTextfield.frame = CGRectMake(128, 8, SCREEN_WIDTH-136, 30);
        _inputMoneyTextfield.textAlignment = NSTextAlignmentRight;
        _inputMoneyTextfield.keyboardType = UIKeyboardTypeDecimalPad;
        _inputMoneyTextfield.delegate = self;
    }else if (self.cellType == 1){
        _refuseButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"拒绝"];
        _refuseButton.frame = CGRectMake(SCREEN_WIDTH-128, 8, 60, 30);
        [_refuseButton addTarget:self action:@selector(clickRefuseButton) forControlEvents:UIControlEventTouchUpInside];
        [_refuseButton setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        
        _agreeButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"同意"];
        _agreeButton.frame = CGRectMake(SCREEN_WIDTH-68, 8, 60, 30);
        [_agreeButton addTarget:self action:@selector(clickAgreeButton) forControlEvents:UIControlEventTouchUpInside];
        [_agreeButton setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        _titleLabel.delegate = self;
        
    }else if (self.cellType == 2){
        [_modifyButton removeFromSuperview];
        _modifyButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"点击编辑"];
        _modifyButton.frame = CGRectMake(SCREEN_WIDTH-108, 8, 100, 30);
        [_modifyButton setTitleColor:[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1.00] forState:UIControlStateNormal];
        [_modifyButton addTarget:self action:@selector(clickModifyButton) forControlEvents:UIControlEventTouchUpInside];
        _titleLabel.delegate = self;
        
    }else if (self.cellType == 3){
        [_modifyButton removeFromSuperview];
        _modifyButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"点击修改"];
        _modifyButton.frame = CGRectMake(SCREEN_WIDTH-108, 8, 100, 30);
        [_modifyButton setTitleColor:[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1.00] forState:UIControlStateNormal];
        [_modifyButton addTarget:self action:@selector(clickModifyButton) forControlEvents:UIControlEventTouchUpInside];
        _titleLabel.delegate = self;
        
        [_resonLabel removeFromSuperview];
        _resonLabel = [CustomView customRTLableWithContentView:self.contentView title:nil];
        _resonLabel.frame = CGRectMake(8, _titleLabel.bottom, SCREEN_WIDTH-16, 30);
    }else if (self.cellType == 4){
         [_modifyButton removeFromSuperview];
        _modifyButton = [CustomView customButtonWithContentView:self.contentView image:nil title:@"重新编辑"];
        _modifyButton.frame = CGRectMake(SCREEN_WIDTH-108, 8, 100, 30);
        [_modifyButton setTitleColor:[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1.00] forState:UIControlStateNormal];
        [_modifyButton addTarget:self action:@selector(clickModifyButton) forControlEvents:UIControlEventTouchUpInside];
        _titleLabel.delegate = self;
        
        [_resonLabel removeFromSuperview];
        _resonLabel = [CustomView customRTLableWithContentView:self.contentView title:nil];
        _resonLabel.frame = CGRectMake(8, _titleLabel.bottom, SCREEN_WIDTH-16, 30);
    }

}

-(void)setInfoModel:(AcceptInfoModel *)infoModel
{
    if (infoModel) {
        _infoModel = infoModel;
        if (infoModel.apply_content) {
            if (self.tag == 0) {
                self.inputMoneyTextfield.text = [NSString stringWithFormat:@"%.2lf",infoModel.apply_content.money];
            }
        }
        if (self.cellType == 3) {
            _modifyButton.userInteractionEnabled = YES;
           
            if (self.tag == 1 ) {
                if (infoModel.apply_content.inspection_state == 1) {
                    _modifyButton.userInteractionEnabled = NO;
                    [_modifyButton setTitle:@"已通过" forState:UIControlStateNormal];
                }
                if (![NSString isBlankString: self.infoModel.apply_content.inspection_reason]) {
                   _resonLabel.text =[NSString stringWithFormat:@"拒绝原因：%@",infoModel.apply_content.inspection_reason];
                    CGSize optimumSize = [self.resonLabel optimumSize];
                    CGRect frame = _resonLabel.frame;
                    frame.size.height = optimumSize.height+3;
                    _resonLabel.frame = frame;
                    self.cellHeight = 38+ optimumSize.height+8;
                }
               
            }
            if (self.tag == 2  ) {
                if (infoModel.apply_content.settlement_state == 1) {
                    _modifyButton.userInteractionEnabled = NO;
                    [_modifyButton setTitle:@"已通过" forState:UIControlStateNormal];
                }
                if (![NSString isBlankString: self.infoModel.apply_content.settlement_reason]) {
                    _resonLabel.text =[NSString stringWithFormat:@"拒绝原因：%@",infoModel.apply_content.settlement_reason];
                    CGSize optimumSize = [self.resonLabel optimumSize];
                    CGRect frame = _resonLabel.frame;
                    frame.size.height = optimumSize.height+3;
                    _resonLabel.frame = frame;
                    self.cellHeight = 38+ optimumSize.height+8;
                }
            }
        }

    }
}

#pragma mark IBAction


-(void)clickModifyButton
{
    if (self.cellType == 2 || self.cellType == 4) {//上传
//        NSLog(@"indexpath%li",self.tag);
        ListViewController *listVC = [[ListViewController alloc]init];
        listVC.contract_id = [self.infoModel.contract_id integerValue];
        if(self.tag == 1){
          listVC.list_type = 2;
        }else if (self.tag == 2){
            listVC.list_type =3;
        }
        listVC.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:listVC animated:YES];
        self.viewController.hidesBottomBarWhenPushed = YES;
    }
    if (self.cellType == 3) {
        EditWebViewController *web = [[EditWebViewController alloc]init];
        if(self.tag == 1){
            web.titleString = @"报验单";
            web.contractID = [self.infoModel.contract_id integerValue];
            NSString *inspection_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"inspection_id"];
            if ([NSString isBlankString:inspection_id]) {
                web.formid = [self.infoModel.apply_content.inspection_id integerValue];
            }else{
                web.formid = [inspection_id integerValue];
            }
            web.editType = 5;
        }else if (self.tag == 2){
            web.titleString = @"结算单";
            web.contractID = [self.infoModel.contract_id integerValue];
            web.editType = 6 ;
            NSString *settlement_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"settlement_id"];
            if ([NSString isBlankString:settlement_id]) {
                web.formid = [self.infoModel.apply_content.settlement_id integerValue];
            }else{
                web.formid = [settlement_id integerValue];
            }
            
        }
        web.apply_id = [self.infoModel.apply_content.apply_id integerValue];
        web.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:web animated:YES];
        self.viewController.hidesBottomBarWhenPushed = YES;
    }
    
}

#pragma mark RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
//        NSLog(@"did select url %@", url);
    EditWebViewController *web = [[EditWebViewController alloc]init];
    if(self.tag == 1){
        web.titleString = @"报验单";
        web.editType = 9;
        if (self.infoModel.apply_content) {
            web.formid = [self.infoModel.apply_content.inspection_id integerValue];
        }else{
            NSString *inspection_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"inspection_id"];
             web.formid = [inspection_id integerValue];
        }
    }else if (self.tag == 2){
        web.titleString = @"结算单";
        if (self.infoModel.apply_content) {
            web.formid = [self.infoModel.apply_content.settlement_id integerValue];
        }else{
           NSString *settlement_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"settlement_id"];
            web.formid = [settlement_id integerValue];
        }
        web.editType = 10 ;
    }
    web.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:web animated:YES];
    self.viewController.hidesBottomBarWhenPushed = YES;
}

#pragma mark UITextfield Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.placeholder = @"";
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}



@end
