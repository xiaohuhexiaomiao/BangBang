//
//  ApprovalTableView.m
//  FindWorkerApp
//
//  Created by cxz on 2018/4/9.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "ApprovalTableView.h"
#import "CXZ.h"
#import "ApprovalResultModel.h"
#import "ApprovalContentModel.h"
#import "ApprovalReplyModel.h"
#import "ApprovalContentCell.h"
#import "ApprovalReplyContentCell.h"
#import "InputTextView.h"

@interface ApprovalTableView ()<UITableViewDelegate, UITableViewDataSource,ApprovalContentCellDelegate,ApprovalReplyContentCellDelegate,InputTextViewDelegate>

@property(nonatomic , strong)UITableView *approvalTableView;

@property(nonatomic , strong)InputTextView *inputView;

@property (nonatomic ,strong)ApprovalResultModel *resultModel;

@property(nonatomic ,assign) CGFloat headerHeight;

@end

@implementation ApprovalTableView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _approvalTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height) style:UITableViewStyleGrouped];
        _approvalTableView.delegate = self;
        _approvalTableView.dataSource = self;
        _approvalTableView.tableFooterView = [UIView new];
//        _approvalTableView.separatorColor = [UIColor clearColor];
        _approvalTableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_approvalTableView];
        [_approvalTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}


-(void)setApprovalTableViewWithModel:(ApprovalResultModel *)model
{
    self.resultModel = model;
    [self.approvalTableView reloadData];
}



#pragma mark InputTextView Delegate

-(void)didLoadNewData
{
    NSDictionary *paramDict = @{ @"company_id":self.companyID,
                                 @"approval_id":self.approvalID,};
    [[NetworkSingletion sharedManager]getReviewResult:paramDict onSucceed:^(NSDictionary *dict) {
        
        if ([dict[@"code"] integerValue] == 0) {
            ApprovalResultModel *resultModel = [ApprovalResultModel objectWithKeyValues:dict[@"data"]];
            self.resultModel = resultModel;
            [self.approvalTableView reloadData];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.viewController.view];
    }];
}


#pragma mark Cell Delegate


-(void)clickReplyButton:(ApprovalContentModel *)contentModel
{
    if (!_inputView) {
        _inputView = [[InputTextView alloc]initWithFrame:self.viewController.view.bounds];
        _inputView.delegate = self;
        _inputView.hidden = YES;
    }
    [UIView animateWithDuration:0.1 animations:^{
//        [_inputView.textView becomeFirstResponder];
        _inputView.participation_id = contentModel.participation_id;
        _inputView.approval_id = self.approvalID;
        _inputView.other_uid = contentModel.uid;
        _inputView.hidden = NO;
        [self.viewController.view addSubview:_inputView];
    }];
}

-(void)clickReplyButtonOfCellWith:(ApprovalContentModel *)contentModel replyModel:(ApprovalReplyModel *)replyModel
{
    if (!_inputView) {
        _inputView = [[InputTextView alloc]initWithFrame:self.viewController.view.bounds];
       
        _inputView.delegate = self;
        _inputView.hidden = YES;
    }
    [UIView animateWithDuration:0.1 animations:^{
//        [_inputView.textView becomeFirstResponder];
        _inputView.participation_id = contentModel.participation_id;
        _inputView.approval_id = self.approvalID;
        _inputView.other_uid = replyModel.uid;
        _inputView.hidden = NO;
        [self.viewController.view addSubview:_inputView];
    }];
}

#pragma mark UITableView Delegate & DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionCount = self.resultModel.content.count;
    if (self.resultModel.finance) {
       sectionCount += 1;
    }
    if (self.resultModel.supply.count > 0) {
        sectionCount += 1;
    }

    return sectionCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.resultModel.content.count ) {
        return 1;
    }
    if (section == self.resultModel.content.count+1) {
        return self.resultModel.supply.count;
    }
    
    ApprovalContentModel *model = [ApprovalContentModel objectWithKeyValues:self.resultModel.content[section]];
//     NSLog(@"**sdsd*%li",model.replys.count);
    return 1+model.replys.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.section == self.resultModel.content.count+1) {
        ApprovalContentCell *cell = (ApprovalContentCell*)[tableView dequeueReusableCellWithIdentifier:@"ApprovalContentCell"];
        if (!cell) {
            cell = [[ApprovalContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApprovalContentCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if (indexPath.section == self.resultModel.content.count) {
            cell.is_reply = NO;
            [cell setCashierReplyContentWith:self.resultModel.finance];
        }else if (indexPath.section == self.resultModel.content.count+1) {
            cell.is_reply = NO;
            [cell setApprovalProtocolWithDictionary:self.resultModel.supply[indexPath.row]];
        }else{
            
            cell.is_reply = self.is_reply;
            [cell setApprovalContentWith:self.resultModel.content[indexPath.section]];
        }
        return cell;
    }
    ApprovalReplyContentCell *cell = (ApprovalReplyContentCell*)[tableView dequeueReusableCellWithIdentifier:@"ApprovalReplyContentCell"];
    if (!cell) {
        cell = [[ApprovalReplyContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApprovalReplyContentCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.is_reply = self.is_reply;
    cell.delegate = self;
    if (self.resultModel.content.count > 0) {
        ApprovalContentModel *model = [ApprovalContentModel objectWithKeyValues:self.resultModel.content[indexPath.section]];
        if (model.replys.count > 0) {
            cell.approvalContentModel = model;
            [cell setApprovalReplyContentWithDict:model.replys[indexPath.row-1]];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ApprovalContentCell *cell = (ApprovalContentCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    ApprovalReplyContentCell *cell = (ApprovalReplyContentCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return self.headerHeight;
//    }
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

@end
