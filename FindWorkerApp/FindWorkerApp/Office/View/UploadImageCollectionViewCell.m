//
//  UploadImageCollectionViewCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/12/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "UploadImageCollectionViewCell.h"
#import "CXZ.h"
#import "UploadImageModel.h"
@interface UploadImageCollectionViewCell ()

@property(nonatomic ,strong) UIImageView *imgView;

//@property(nonatomic ,strong) UILabel *progressLabel;

@property(nonatomic ,strong) UIButton *deleteButon;


@end

@implementation UploadImageCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
        _imgView.image = [UIImage imageNamed:@"placeholder"];
        [self addSubview:_imgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImgview:)];
        _imgView.userInteractionEnabled = YES;
        [_imgView addGestureRecognizer:tap];
        
        
        _progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _progressLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_progressLabel];
        
        _deleteButon = [CustomView customButtonWithContentView:self image:@"delete2" title:nil];
        _deleteButon.frame = CGRectMake(0, 0, 16, 16);
        //        _deleteButon.backgroundColor = [UIColor blackColor];
        _deleteButon.imageEdgeInsets = UIEdgeInsetsMake(-5, -5, 0, 0);
        [_deleteButon addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)setUploadImageCollectonCellWithModel:(UploadImageModel *)uploadImageModel
{
    if (uploadImageModel.is_webImage) {
        NSString *pic1 = [NSString stringWithFormat:@"%@%@?imageView2/2/w/40/h/40",IMAGE_HOST,uploadImageModel.hashString];
         [self.imgView sd_setImageWithURL:[NSURL URLWithString:pic1] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        self.progressLabel.hidden = YES;
        
    }else{
        self.imgView.image = uploadImageModel.image;
        self.progressLabel.hidden = NO;
        if (uploadImageModel.uploadProgress == 100.0) {
            self.progressLabel.hidden = YES;
        }
         self.progressLabel.text = [NSString stringWithFormat:@"%.0f%@",uploadImageModel.uploadProgress ,@"%"];
//        NSLog(@"*hahaha**%li**hah***%li",uploadImageModel.tag,self.tag);
        __weak typeof(self) weakself = self;
        uploadImageModel.UploadImageProgress = ^(CGFloat progress,NSInteger tag){
//            NSLog(@"***%li**hah***%li",tag,weakself.tag);
            dispatch_queue_t mainQueue =  dispatch_get_main_queue();
            dispatch_async(mainQueue, ^{
                if (tag == weakself.tag) {
                    weakself.progressLabel.text = [NSString stringWithFormat:@"%.0f%@",progress ,@"%"];
                    if (progress == 100.0f) {
                        weakself.progressLabel.hidden = YES;
                    }
                }

            });
            
        };
        
    }
    
}

-(void)clickImgview:(UITapGestureRecognizer*)tap
{
    [self.delegate clickLargeImageView:self.tag];
}

-(void)clickDeleteButton:(UIButton*)button
{
    //    NSLog(@"***%li",self.tag);
    [self.delegate clickDeleteImage:self.tag];
}




-(void)setImageViewWithUrlStr:(NSString*)urlStr
{
    self.progressLabel.hidden = YES;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}



@end
