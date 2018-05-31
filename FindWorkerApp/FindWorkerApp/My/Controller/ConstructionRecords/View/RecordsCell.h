//
//  RecordsCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/5/12.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordsDetailListModel.h"

@interface RecordsCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(RecordsDetailListModel*)detailModel;

@property(nonatomic ,assign)CGFloat recordsCellHeight;

@end
