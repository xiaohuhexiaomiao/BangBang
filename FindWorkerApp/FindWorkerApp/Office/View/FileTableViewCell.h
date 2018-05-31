//
//  FileTableViewCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/10/20.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FileModel;
@protocol FileTableViewCellDelegate <NSObject>

-(void)clickSeleteButton:(BOOL)isSeleted tag:(NSInteger)tag;

@end;

@interface FileTableViewCell : UITableViewCell

@property(nonatomic,weak)id <FileTableViewCellDelegate>delegate;

-(void)setFileCellWithModel:(FileModel*)file;

@end
