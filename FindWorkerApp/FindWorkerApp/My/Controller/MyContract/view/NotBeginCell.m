//
//  NotBeginCell.m
//  FindWorkerApp
//
//  Created by cxz on 2018/3/26.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "NotBeginCell.h"
#import "CXZ.h"
#import "ContractStatusModel.h"
#import "SWAlipay.h"

@interface NotBeginCell()

@property(nonatomic ,strong)UILabel *titleLabel;

@property(nonatomic ,strong)UILabel *addTimeLabel;

@property(nonatomic ,strong)UILabel *workerName;

@property(nonatomic ,strong)UIButton *overButton;//查看申请验收记录

@property(nonatomic ,strong)ContractStatusModel *statusModel;

@end
@implementation NotBeginCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _titleLabel = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        _titleLabel.numberOfLines = 2;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(25);
            
        }];
        _addTimeLabel = [CustomView customContentUILableWithContentView:self.contentView title:nil];
//        _addTimeLabel.font = [UIFont systemFontOfSize:12];
//        _addTimeLabel.textAlignment = NSTextAlignmentRight;
        [_addTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(_titleLabel.mas_bottom);
            make.height.mas_equalTo(25);
        }];
        

        _workerName = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        [_workerName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(_addTimeLabel.mas_bottom);
            make.height.mas_equalTo(25);
        }];
        
        
        NSString *buttonStr =@"等待乙方签字确认";
        CGSize buttonSize = [buttonStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
        _overButton = [CustomView customButtonWithContentView:self.contentView image:nil title:buttonStr];
        [_overButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(_workerName.mas_bottom).mas_offset(2);
            make.width.mas_equalTo(buttonSize.width+20);
            make.height.mas_equalTo(26);
        }];
        _overButton.layer.cornerRadius = 13.0;
        _overButton.layer.borderColor = ORANGE_COLOR.CGColor;
        _overButton.layer.borderWidth = 0.8;
        [_overButton setBackgroundColor:ORANGE_COLOR];
        [_overButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _overButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_overButton addTarget:self action:@selector(clickOverButton) forControlEvents:UIControlEventTouchUpInside];
        
       
        
    }
    return self;
}

#pragma mark

-(void)setNotStarCellWithModel:(ContractStatusModel *)statusModle
{
    self.addTimeLabel.text = [NSString stringWithFormat:@"创建时间：%@",statusModle.add_time];
    self.titleLabel.text =[NSString stringWithFormat:@"合同名称：%@",statusModle.contract_name];
    self.workerName.text = [NSString stringWithFormat:@"乙方姓名：%@",statusModle.worker_name];
    self.statusModel = statusModle;
    NSString *buttonStr;
    if (statusModle.take_effect == 0) {
        buttonStr =@"等待乙方签字确认";
        self.overButton.userInteractionEnabled = NO;
    }else if (statusModle.take_effect == 1){
        buttonStr =@"去付预付款";
        self.overButton.userInteractionEnabled = YES;
    }else if (statusModle.take_effect == 2){
        buttonStr =@"合同被退回，点击修改";
        self.overButton.userInteractionEnabled = YES;
    }else if (statusModle.take_effect == 3){
        buttonStr =@"乙方已拒绝";
        self.overButton.userInteractionEnabled = NO;
    }else if (statusModle.take_effect == 4){
        buttonStr =@"合同签订成功";
        self.overButton.userInteractionEnabled = NO;
    }
    CGSize buttonSize = [buttonStr sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] width:SCREEN_WIDTH];
    [self.overButton setTitle:buttonStr forState:UIControlStateNormal];
    [self.overButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonSize.width);
    }];

}

#pragma mark IBACTION


-(void)clickOverButton
{
    if (self.statusModel.take_effect== 1) {//预付款
        NSDictionary *paramDict = @{@"contract_id":@(self.statusModel.contract_id),
                                    @"worker_id":self.statusModel.worker_id,
                                    @"type":@(2)};
        [[NetworkSingletion sharedManager]toPayDownPayment:paramDict onSucceed:^(NSDictionary *dict) {
//            NSLog(@"***%@",dict);
            if ([dict[@"code"] integerValue ]== 0) {
                SWAlipay *pay = [SWAlipay new];
                NSString *payStr = dict[@"data"];
                [pay payToStr:payStr];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.viewController.view];
            }
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.viewController.view];
        }];

    }else if (self.statusModel.take_effect == 2){//xiugai编辑
        EditWebViewController *web = [[EditWebViewController alloc]init];
        if (![NSString isBlankString:self.statusModel.contract_name]) {
            web.titleString = self.statusModel.contract_name;
        }
        web.editType = 4;
        web.contractID = self.statusModel.contract_id;
        web.workID = self.statusModel.worker_id;
        web.form_Type_ID = self.statusModel.contract_type_id;
        web.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:web animated:YES];
        self.viewController.hidesBottomBarWhenPushed = YES;
    }
}


@end
