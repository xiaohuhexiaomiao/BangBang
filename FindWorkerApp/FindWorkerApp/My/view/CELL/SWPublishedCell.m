//
//  SWPublishedCell.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWPublishedCell.h"

#import "CXZ.h"

#define padding 10

@interface SWPublishedCell ()

@property (nonatomic, retain) UILabel *timeLbl;

@property (nonatomic, retain) UILabel *contentLbl;

@end

@implementation SWPublishedCell

+ (instancetype)initWithTableViewCell:(UITableView *)tableView {
    
    static NSString *indentify = @"Publish_CELL";
    
    SWPublishedCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if(!cell) {
        
        cell = [[SWPublishedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
        
    }
    
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.font = [UIFont systemFontOfSize:12];
        _timeLbl.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.16 alpha:1.00];
        [self.contentView addSubview:_timeLbl];
        
        _contentLbl = [[UILabel alloc] init];
        _contentLbl.font = [UIFont systemFontOfSize:12];
        _contentLbl.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.16 alpha:1.00];
        [self.contentView addSubview:_contentLbl];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    return self;
    
}

- (void)showData:(NSString *)date content:(NSString *)content {
    
    _timeLbl.text = date;
    [_timeLbl sizeToFit];
    _timeLbl.frame = CGRectMake(padding, (49 - _timeLbl.bounds.size.height) / 2, _timeLbl.bounds.size.width, _timeLbl.bounds.size.height);
    
    _contentLbl.text = content;
    [_contentLbl sizeToFit];
    _contentLbl.frame = CGRectMake(CGRectGetMaxX(_timeLbl.frame) + 2 * padding, (49 - _contentLbl.bounds.size.height) / 2, _contentLbl.bounds.size.width, _contentLbl.bounds.size.height);
    
}

@end
