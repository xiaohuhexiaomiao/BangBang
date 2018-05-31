//
//  ProductionCollectionViewCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/4/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ProductionCollectionViewCell.h"

@implementation ProductionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickProductionCell:)];
    [self.clickView addGestureRecognizer:tap];
    
}
- (IBAction)clickProductionCell:(id)sender {
    NSLog(@"clici ");
    [self.delegate clickProductionCollectionViewCell:self.productionDict];
}

@end
