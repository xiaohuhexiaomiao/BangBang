//
//  DDChoosePhotoViewController.m
//  DiaoDiao
//
//  Created by wangzeng on 14-10-23.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import "DDChoosePhotoViewController.h"
#import "DDChoosePhotoBottom.h"
#import "CXZ.h"

@interface DDChoosePhotoViewController ()

#define ADD_TAG 10000
#define BASE_ITEM_TAG 100000
#define IMAGE_WIDTH 35

@end

@implementation DDChoosePhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    setIndex = [[NSMutableOrderedSet alloc] init];
    setRow = [[NSMutableOrderedSet alloc] init];
    // Reload assets
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    
    photoList = [PHAsset fetchAssetsInAssetCollection:_assetsGroup options:options];
    
    if(_limit != 1) {
        NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"DDChoosePhotoBottom" owner:nil options:nil];
        addView = [array objectAtIndex:0];
        addView.frame = CGRectMake(0, 0, self.navigationController.toolbar.frame.size.width, self.navigationController.toolbar.frame.size.height);
        [addView.bottomButton addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchDown];
        UIImage* imageNor = [CXZImageUtil imageWithColor:[UIColor whiteColor] Size:addView.bottomButton.frame.size];
        UIImage* imageSel = [CXZImageUtil imageWithColor:[UIColor grayColor] Size:addView.bottomButton.frame.size];
        [addView.bottomButton setBackgroundImage:imageNor forState:UIControlStateNormal];
        [addView.bottomButton setBackgroundImage:imageSel forState:UIControlStateHighlighted];
        [addView.bottomButton setTintColor:TINTCOLOR];
        addView.bottomButton.layer.cornerRadius = 6;
        addView.bottomButton.layer.masksToBounds = YES;
        [addView setBackgroundColor:[UIColor clearColor]];
        [[self.navigationController toolbar] setBackgroundImage:[CXZImageUtil imageWithColor:TINTCOLOR Size:[self.navigationController toolbar].frame.size] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        
        [[self.navigationController toolbar] addSubview:addView];
    }
    
    ensureChoose = NO;
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_limit != 1) {
        [self.navigationController setToolbarHidden:NO animated:NO];
    }
    //[self scrollToBottom];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(_limit != 1) {
        [self.navigationController setToolbarHidden:YES animated:NO];
    }
    if(_delegate!=nil){
        _delegate=nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if(addView != nil) {
        [addView removeFromSuperview];
    }
    
}

- (void)itemClicked:(UITapGestureRecognizer*)gr {
    NSInteger item = gr.view.superview.tag - BASE_ITEM_TAG;
    
    if(item >= [photoList count]) {
        return ;
    }
    PHAsset *asset = [photoList objectAtIndex:item];
    if([setIndex containsObject:asset]) {
        UIImageView* imageview = (UIImageView*)[addView.bottomScrollview viewWithTag:item+ADD_TAG];
        [imageview removeFromSuperview];
        NSInteger index = [setIndex indexOfObject:asset];
        [setIndex removeObject:asset];
        [setRow removeObject:@(item+ADD_TAG)];
        for(int i = index; i < [setIndex count]; i ++) {
            NSInteger newItem = [[setRow objectAtIndex:i] intValue];
            UIImageView* imageNext = (UIImageView*)[addView.bottomScrollview viewWithTag:newItem];
            imageNext.frame = CGRectMake(imageNext.frame.origin.x-IMAGE_WIDTH+5, imageNext.frame.origin.y, imageNext.frame.size.width, imageNext.frame.size.height);
        }
    }
    else {
        if(_limit != 0 && [setIndex count] >= _limit) {
            [MBProgressHUD showMessageAutoHide:[NSString stringWithFormat:@"最多选择%ld张照片", _limit] toView:nil];
        }
        else {
            if(_limit != 1) {
                UIImageView* imageview = [[UIImageView alloc] init];
                imageview.frame = CGRectMake([setIndex count]*(IMAGE_WIDTH+5)+5, (44-IMAGE_WIDTH)/2.0, IMAGE_WIDTH, IMAGE_WIDTH);
                imageview.tag = item+ADD_TAG;
                PHImageManager *imageManager = [[PHImageManager alloc] init];
                PHImageRequestOptions *imageoptions = [[PHImageRequestOptions alloc] init];
                imageoptions.synchronous=YES;
                [imageoptions setResizeMode:PHImageRequestOptionsResizeModeFast];
                [imageoptions setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
                [imageManager requestImageForAsset:asset targetSize:imageview.frame.size contentMode:PHImageContentModeAspectFit options:imageoptions resultHandler:^(UIImage * result, NSDictionary * info){
                    if (result) {
                        
                        [imageview setImage:result];
                    }
                }];
                
                
                [addView.bottomScrollview addSubview:imageview];
            }
            [setIndex addObject:asset];
            [setRow addObject:@(item+ADD_TAG)];
        }
    }
    if(_limit != 1) {
        addView.bottomScrollview.contentSize = CGSizeMake((IMAGE_WIDTH+5)*[setIndex count], addView.bottomScrollview.frame.size.height);
        if(addView.bottomScrollview.contentSize.width < addView.bottomScrollview.frame.size.width) {
            addView.bottomScrollview.contentOffset = CGPointMake(0, 0);
        }
        else {
            addView.bottomScrollview.contentOffset = CGPointMake(addView.bottomScrollview.contentSize.width-addView.bottomScrollview.frame.size.width, 0);
        }
    }
    [self.navigationItem setTitle:[NSString stringWithFormat:@"选择照片(%ld)", [setIndex count]]];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:item/4 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    
    if(_limit == 1 && [setIndex count] == 1) {
        [self doneClicked];
    }
}

- (void)doneClicked {
    if(ensureChoose) {
        return ;
    }
    if([setIndex count] == 0) {
        [MBProgressHUD showMessageAutoHide:@"请选择照片" toView:nil];
        return ;
    }
    [MBProgressHUD showMessage:@"正在处理图片，请稍等" toView:nil];
    ensureChoose = YES;
    
    for(int i = 0; i < [setIndex count]; i ++) {
        @autoreleasepool {
            @try {
                NSMutableArray* data = [[NSMutableArray alloc] init];
                PHAsset *asset = [setIndex objectAtIndex:i];
                
                PHImageManager *imageManager = [[PHImageManager alloc] init];
                PHImageRequestOptions *imageoptions = [[PHImageRequestOptions alloc] init];
                imageoptions.synchronous=YES;
                [imageoptions setResizeMode:PHImageRequestOptionsResizeModeExact];
                [imageoptions setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
                [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:imageoptions resultHandler:^(UIImage * result, NSDictionary * info){
                    if (result) {
                        if(_orignal) {
                            [data addObject:result];
                        }
                        else {
                            UIImage* scaleImage = [CXZImageUtil ZIPUIImage:result];
                            [data addObject:scaleImage];
                        }
                        
                        [MBProgressHUD hideAllHUDsForView:nil animated:NO];
                        if(_delegate != nil && [_delegate respondsToSelector:@selector(choosePhotos:)]) {
                            [_delegate choosePhotos:data];
                        }
                        if (i==[setIndex count]-1) {
                            
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                    }
                }];
                
                
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
    }
    
}

#pragma mark - Table view data source
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH/4.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(photoList == nil || [photoList count] == 0) {
        return 0;
    }
    return ([photoList count] - 1) / 4 + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString *CellIdentifier = @"PhotoItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    CGFloat sep = 3.0/[UIScreen mainScreen].scale;
    // Configure the cell...
    for(int i = 0; i < 4; i ++) {
        UIImageView* imageview = (UIImageView*)[cell viewWithTag:1+i*2];
        [imageview setContentMode:UIViewContentModeScaleAspectFill];
        imageview.layer.cornerRadius = 1;
        imageview.layer.masksToBounds = YES;
        UIImageView* flagImageView = (UIImageView*)[cell viewWithTag:2+i*2];
        
        [imageview setUserInteractionEnabled:YES];
        [imageview setImage:nil];
        [flagImageView setImage:nil];
        
        [imageview superview].frame = CGRectMake(((SCREEN_WIDTH-sep*3)/4.0+sep)*i, 0, (SCREEN_WIDTH-sep*3.0)/4.0, (SCREEN_WIDTH-sep*3.0)/4.0);
        imageview.frame = CGRectMake(0, 0, (SCREEN_WIDTH-sep*3.0)/4.0, (SCREEN_WIDTH-sep*3.0)/4.0);
        flagImageView.frame = CGRectMake((SCREEN_WIDTH-sep*3.0)/4.0-flagImageView.frame.size.width-5, (SCREEN_WIDTH-sep*3.0)/4.0-flagImageView.frame.size.height-5, flagImageView.frame.size.width, flagImageView.frame.size.height);
        
        if(row*4+i < [photoList count]) {
            
            PHAsset *asset = [photoList objectAtIndex:row*4+i];
            PHImageManager *imageManager = [[PHImageManager alloc] init];
            PHImageRequestOptions *imageoptions = [[PHImageRequestOptions alloc] init];
            imageoptions.synchronous=YES;
            [imageoptions setResizeMode:PHImageRequestOptionsResizeModeFast];
            [imageoptions setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
            [imageManager requestImageForAsset:asset targetSize:(CGSize){250,250} contentMode:PHImageContentModeAspectFit options:imageoptions resultHandler:^(UIImage * result, NSDictionary * info){
                if (result) {
                    
                    [imageview setImage:result];
                    
                }
            }];
            
            if([setIndex containsObject:asset]) {
                [flagImageView setImage:[UIImage imageNamed:@"photo_state_selected"]];
            }
            else {
                [flagImageView setImage:[UIImage imageNamed:@"photo_state_normal"]];
            }
            if(_limit == 1) {
                [flagImageView setHidden:YES];
            }
            else {
                [flagImageView setHidden:NO];
            }
        }
        
        UITapGestureRecognizer* gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)];
        
        [imageview superview].tag = row*4 + i + BASE_ITEM_TAG;
        [imageview addGestureRecognizer:gr];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 重载返回按钮
- (void)onBack {
    if(addView != nil) {
        [addView removeFromSuperview];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 重载popbydrag
- (void)popByDrag {
    if(addView != nil) {
        [addView removeFromSuperview];
    }
}

#pragma mark - 滚动到底部
- (void)scrollToBottom {
    if(photoList != nil && [photoList count] > 0) {
        CGFloat y = [self.tableView numberOfRowsInSection:0] * 80 - self.tableView.frame.size.height + 44;
        if(y > 0) {
            self.tableView.contentOffset = CGPointMake(0, y);
        }
    }
}
@end
