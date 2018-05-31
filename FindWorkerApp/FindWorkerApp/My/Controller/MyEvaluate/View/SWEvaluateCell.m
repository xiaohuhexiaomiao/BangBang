//
//  SWEvaluateCell.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWEvaluateCell.h"

#import "CXZ.h"

@interface SWEvaluateCell ()

@property (nonatomic, retain) UIImageView *iconImg; //头像

@property (nonatomic, retain) UILabel *phoneLbl; //手机号码

@property (nonatomic, retain) UILabel *stateLbl; //状态值

@property (nonatomic, retain) UILabel *timeLbl; //时间值

@property (nonatomic, retain) UILabel *contentLbl; //评论内容

@end

@implementation SWEvaluateCell

+ (instancetype)initWithTableViewCell:(UITableView *)tableView {
    
    static NSString *indentify = @"CELL";
    
    SWEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if(!cell) {
        
        cell = [[SWEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
        
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
    
    _iconImg = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImg];
    
    _phoneLbl = [[UILabel alloc] init];
    _phoneLbl.font = [UIFont systemFontOfSize:10];
    _phoneLbl.textColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00];
    [self.contentView addSubview:_phoneLbl];
    
    _stateLbl = [[UILabel alloc] init];
    _stateLbl.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_stateLbl];
    
    _timeLbl = [[UILabel alloc] init];
    _timeLbl.textColor = [UIColor colorWithRed:0.42 green:0.42 blue:0.43 alpha:1.00];
    _timeLbl.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_timeLbl];
    
    _contentLbl = [[UILabel alloc] init];
    _contentLbl.numberOfLines = 0;
    _contentLbl.textColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.13 alpha:1.00];
    _contentLbl.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_contentLbl];
    
}

-(void)setItemFrame:(SWEvaluteFrame *)itemFrame {
    
    _itemFrame = itemFrame;
    
    _iconImg.frame = _itemFrame.iconF;
    _iconImg.layer.cornerRadius = _iconImg.frame.size.height / 2;
    _iconImg.layer.masksToBounds = YES;
    
    _phoneLbl.frame = _itemFrame.phoneF;
    
    _stateLbl.frame = _itemFrame.stateF;
    
    _timeLbl.frame = _itemFrame.timeF;
    
    _contentLbl.frame = _itemFrame.contentF;
    
    
}


- (void)showData:(NSString *)icon phone:(NSString *)phone time:(NSString *)time content:(NSString *)content state:(NSString *)state {
    
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,icon]] placeholderImage:[UIImage imageNamed:@"temp"]];
    
    _phoneLbl.text = phone;
    
    _timeLbl.text = time;
    
    NSString *stateStr = @"";
    
    if([state isEqualToString:@"0"]) {
        stateStr = @"满意";
        _stateLbl.textColor = [UIColor colorWithRed:0.88 green:0.47 blue:0.45 alpha:1.00];
    }else if([state isEqualToString:@"1"]){
        stateStr = @"一般";
        _stateLbl.textColor = [UIColor colorWithRed:0.91 green:0.64 blue:0.45 alpha:1.00];
    
    }else {
        stateStr = @"不满意";
        _stateLbl.textColor = [UIColor colorWithRed:0.56 green:0.76 blue:0.99 alpha:1.00];
        
    }
    _stateLbl.text = stateStr;
    
    _contentLbl.text = content;
    
}



@end
