//
//  FilesView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/10/26.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "FilesView.h"

#import "CXZ.h"
#import "FileModel.h"

@interface FilesView()

@property(nonatomic ,strong) UIProgressView *progressView;

@property(nonatomic ,strong) UIButton *deleteButton;

@property(nonatomic ,strong) FileModel *fileModel;

@end

@implementation FilesView

-(id)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [CustomView customTitleUILableWithContentView:self title:nil];
        _titleLabel.frame = CGRectMake(8, 0, frame.size.width-40, 30);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickFileTitle:)];
        _titleLabel.userInteractionEnabled = YES;
        [_titleLabel addGestureRecognizer:tap];
                
        _deleteButton = [CustomView customButtonWithContentView:self image:@"delete" title:nil];
        _deleteButton.frame = CGRectMake(frame.size.width-20, 5, 20, 20);
        
        [_deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];

        
    }
    return self;
}

-(void)clickFileTitle:(UITapGestureRecognizer*)tap
{
    [[NetworkSingletion sharedManager]lookFilesDetail:@{@"attachments_id":self.fileModel.file_id} onSucceed:^(NSDictionary *dict) {
        
        if ([dict[@"code"] integerValue]==0) {
            FilesModel *files = [FilesModel objectWithKeyValues:dict[@"data"]];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",IMAGE_HOST, files.attachments];
            WebViewController *docVC = [[WebViewController alloc]init];
            docVC.urlStr = urlString;
            docVC.filesModel = files;
            docVC.titleString = files.file_name;
            docVC.is_Send = YES;
            [self.viewController.navigationController pushViewController:docVC animated:YES];
        }
        
    } OnError:^(NSString *error) {
        
    }];

}

-(void)setContentWithModel:(FileModel *)file
{
    self.fileModel = file;
    self.titleLabel.text = file.file_all_name;
    self.filesDict = @{@"contract_id":file.file_id,@"type":@(4),@"name":file.file_all_name};
}

-(void)clickDeleteButton:(UIButton*)button
{
    [self.delegate deleteFileView:self.tag];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
