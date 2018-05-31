//
//  NormallSelsectedCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/17.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "NormallSelsectedCell.h"
#import "CXZ.h"
@interface NormallSelsectedCell ()

@property(nonatomic ,strong) UILabel *titleLabel;

@property(nonatomic ,strong) NSDictionary *dateDict;

@end

@implementation NormallSelsectedCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [CustomView customContentUILableWithContentView:self.contentView title:nil];
        _titleLabel.frame = CGRectMake(16, 5, 200, 30);
        
        _selectedButton = [CustomView customButtonWithContentView:self.contentView image:@"unselect" title:nil];
        _selectedButton.frame = CGRectMake(SCREEN_WIDTH-40, 5, 30, 30);
        _selectedButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_selectedButton addTarget:self action:@selector(clickSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


-(void)clickSelectedButton:(UIButton*)button
{
    UIImage *tempImage = [UIImage imageNamed:@"unselect"];
    NSData *tempData = UIImagePNGRepresentation(tempImage);
    UIImage *image = [button imageForState:UIControlStateNormal];
    NSData *data = UIImagePNGRepresentation(image);
    if ([data isEqualToData:tempData]) {
        [_selectedButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        if (self.dateDict) {
            [self.delegate selectedCellWith:YES Model:self.dateDict];
        }else{
            [self.delegate selectedCellWith:YES index:self.tag];
        }
        
    }else{
        [_selectedButton setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        if (self.dateDict) {
            [self.delegate selectedCellWith:NO Model:self.dateDict];
        }else{
            [self.delegate selectedCellWith:NO index:self.tag];
        }
    }

}


-(void)setNormalCellWithDictionary:(NSDictionary*)dict
{
    self.dateDict = dict;
    NSString *departName = [dict objectForKey:@"department_name"];
    if (![NSString isBlankString:departName]) {
        self.titleLabel.text = departName;
    }
}
-(void)setNormalCellWithTitleString:(NSString*)titleString
{
    self.dateDict = nil;
    self.titleLabel.text = titleString;
}

@end
