//
//  SWDepositCell.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWDepositCell.h"

#import "CXZ.h"

#define padding 10

@interface SWDepositCell ()

@property (nonatomic, retain) UILabel *timeLbl;

@property (nonatomic, retain) UILabel *moneyLbl;

@property (nonatomic, retain) UILabel *stateLbl;

@end

@implementation SWDepositCell

+ (instancetype)initWithTableViewCell:(UITableView *)tableView {
    
    static NSString *indentify = @"CELL";
    
    SWDepositCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if(!cell) {
        
        cell = [[SWDepositCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
        
    }
    
    return cell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initWithView];
        
    }
    
    return self;
    
}

- (void)initWithView {
    
    _timeLbl = [[UILabel alloc] init];
    _timeLbl.font = [UIFont systemFontOfSize:12];
    _timeLbl.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1.00];
    [self.contentView addSubview:_timeLbl];
    
    _moneyLbl = [[UILabel alloc] init];
    _moneyLbl.font = [UIFont systemFontOfSize:12];
    _moneyLbl.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1.00];
    [self.contentView addSubview:_moneyLbl];
    
    _stateLbl = [[UILabel alloc] init];
    _stateLbl.font = [UIFont systemFontOfSize:12];
    _stateLbl.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1.00];
    [self.contentView addSubview:_stateLbl];
    
    
}

- (void)showData:(NSString *)time money:(NSString *)money state:(NSInteger)state {
    
    _timeLbl.text = time;
    [_timeLbl sizeToFit];
    
    _timeLbl.frame = CGRectMake(padding, (49 - _timeLbl.bounds.size.height) / 2, _timeLbl.bounds.size.width, _timeLbl.bounds.size.height);
    
    _moneyLbl.text = money;
    [_moneyLbl sizeToFit];
    
    _moneyLbl.frame = CGRectMake(CGRectGetMaxX(_timeLbl.frame) + padding, (49 - _moneyLbl.bounds.size.height) / 2, _moneyLbl.bounds.size.width, _moneyLbl.bounds.size.height);
    
    
    /**
     0 待审核，1通过审核 2未通过审核 3.提现完成
     */
    NSString *stateStr = @"";
    if(state == 0) {
        
        stateStr = @"待审核";
        
    }else if(state == 1) {
        
        stateStr = @"通过审核";
        
    }else if(state == 2) {
        
        stateStr = @"未通过审核";
        
    }else {
    
        stateStr = @"提现完成";
        
    }
    
    _stateLbl.text = stateStr;
    [_stateLbl sizeToFit];
    
    _stateLbl.frame = CGRectMake(SCREEN_WIDTH - 10 - _stateLbl.bounds.size.width, (49 - _stateLbl.bounds.size.height) / 2, _stateLbl.bounds.size.width, _stateLbl.bounds.size.height);
    
}


@end
