//
//  FilesView.h
//  FindWorkerApp
//
//  Created by cxz on 2017/10/26.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FileModel;

@protocol FileViewDelegate <NSObject>

-(void)deleteFileView:(NSInteger)tag;

@end

@interface FilesView : UIView

@property(nonatomic ,strong) UILabel *titleLabel;

@property(nonatomic ,strong) NSDictionary *filesDict;

@property(nonatomic ,weak)id <FileViewDelegate> delegate;

-(void)setContentWithModel:(FileModel*)file;

@end
