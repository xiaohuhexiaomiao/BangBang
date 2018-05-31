//
//  SWFinishedCell.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWFinishedCell.h"

#import "CXZ.h"

#define padding 10

@interface SWFinishedCell ()

@property (nonatomic, retain) UILabel *timeLbl;

@property (nonatomic, retain) UILabel *contentLbl;

@property (nonatomic, retain) UIButton *rejectBtn;

@end


@implementation SWFinishedCell

+ (instancetype)initWithTableViewCell:(UITableView *)tableView {
    
    static NSString *indentify = @"FINISHED_CELL";
    
    SWFinishedCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if(!cell) {
        
        cell = [[SWFinishedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
        
    }
    
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.frame = CGRectMake(padding, padding, padding, 0.0);
        _timeLbl.font = [UIFont systemFontOfSize:12];
        _timeLbl.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.16 alpha:1.00];
        [self.contentView addSubview:_timeLbl];
        
        _contentLbl = [[UILabel alloc] init];
        _contentLbl.frame = CGRectMake(padding, CGRectGetMaxY(_timeLbl.frame) + padding, 10, 10);
        _contentLbl.font = [UIFont systemFontOfSize:12];
        _contentLbl.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.16 alpha:1.00];
        [self.contentView addSubview:_contentLbl];
        
        _rejectBtn = [[UIButton alloc] init];
        [_rejectBtn setTitle:@"申请付款" forState:UIControlStateNormal];
        [_rejectBtn setTitleColor:[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00] forState:UIControlStateNormal];
        _rejectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_rejectBtn sizeToFit];
        _rejectBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - _rejectBtn.bounds.size.width, (49.0f - _rejectBtn.bounds.size.height) / 2, _rejectBtn.bounds.size.width, _rejectBtn.bounds.size.height);
        [_rejectBtn addTarget:self action:@selector(clickApplyPayBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rejectBtn];
        
    }
    
    return self;
    
}

- (void)showData:(NSString *)date content:(NSString *)content {
    
    _timeLbl.text = date;
    [_timeLbl sizeToFit];
    
    _contentLbl.text = content;
    [_contentLbl sizeToFit];
    
}

-(void)clickApplyPayBtn:(UIButton*)sender
{
    NSInteger index = ((SWFinishedCell*)[[sender superview]superview]).tag;
    [self.delegate clickApplyPayBtn:index];
}


@end
