//
//  WorkerDetailCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/3/21.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "WorkerDetailCell.h"
@interface WorkerDetailCell()

@property(nonatomic ,strong) UILabel *nameLabel;

@property(nonatomic ,strong) UIButton *provinceBtn;

@property(nonatomic ,strong) UIButton *yearBtn;

@end
@implementation WorkerDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
