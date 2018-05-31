//
//  FileListViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/10/20.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "FileListViewController.h"
#import "CXZ.h"
#import "AFNetworking.h"

#import "GuideViewController.h"

#import "FileTableViewCell.h"

@interface FileListViewController ()<UITableViewDelegate,UITableViewDataSource,FileTableViewCellDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@property(nonatomic ,strong)UITableView *tableView;

@property(nonatomic ,strong)NSMutableArray *fileArray;

@property(nonatomic ,strong)NSMutableArray *selectedfileArray;

//保存本地的地址
@property (nonatomic ,copy) NSString *path;

@end

@implementation FileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"本地文件" withColor:[UIColor whiteColor]];
    [self setupNextWithString:@"示例" withColor:[UIColor whiteColor]];
//    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
//    _scrollView.showsVerticalScrollIndicator = YES;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH-16)/375*565*3+100);
//    [self.view addSubview:_scrollView];
//    
//    UIView *lastView;
//    
//    NSArray *titleArray = @[@"description1",@"description2",@"description3"];
//    for (int i = 0; i < titleArray.count; i++) {
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, lastView.bottom, SCREEN_WIDTH-16, (SCREEN_WIDTH-16)/375*565)];
//        imageView.image = [UIImage imageNamed:titleArray[i]];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_scrollView addSubview:imageView];
//        lastView = imageView;
//    }
    

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 100, 150, 25)];
    imageView.image = [UIImage imageNamed:@"example"];
    [self.view addSubview:imageView];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate  = self;
    _tableView.height= self.view.frame.size.height-64;
    _tableView.dataSource = self;
    _tableView.hidden = NO;
    [self.view addSubview:_tableView];
    [self.view bringSubviewToFront:_tableView];
//    if (self.fileArray.count == 0) {
//        _tableView.hidden = YES;
//    }
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refresh];
    }];
//      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"APPLUCATION_OPEN_URL" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:UIApplicationOpenURLOptionsSourceApplicationKey object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


#pragma mark Public Method

-(void)onNext
{
    GuideViewController *guideVC = [[GuideViewController alloc]init];
    guideVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:guideVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

-(void)onBack
{
    if (self.selectedfileArray.count > 0) {
//        if (_DidSelectedFilesArray) {
//            _DidSelectedFilesArray(self.selectedfileArray);
//        }
        [self.delegate chooseFiles:self.selectedfileArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Private Method

-(void)refresh
{
//    NSLog(@"shuaxin");
    [self.fileArray removeAllObjects];
    NSArray *array = [[DataBase sharedDataBase] getAllFile];
    [self.fileArray addObjectsFromArray:array];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];

}

#pragma mark Cell Delegate Method

-(void)clickSeleteButton:(BOOL)isSeleted tag:(NSInteger)tag
{
    FileModel *file = self.fileArray[tag];
    if (isSeleted) {
        [self.selectedfileArray addObject:file];
    }else{
        [self.selectedfileArray removeObject:file];
    }
}


#pragma mark UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fileArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileTableViewCell *cell = (FileTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NormallCell"];
    if (!cell) {
        cell = [[FileTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormallCell"];
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (self.fileArray.count > 0) {
        FileModel *file = self.fileArray[indexPath.row];
        [cell setFileCellWithModel:file];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fileArray.count > 0) {
        FileModel *file = self.fileArray[indexPath.row];
        [self clickTableviewCell:file];
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark 查看附件

-(void)clickTableviewCell:(FileModel*)file
{
   
    [[NetworkSingletion sharedManager]lookFilesDetail:@{@"attachments_id":file.file_id} onSucceed:^(NSDictionary *dict) {
        
        if ([dict[@"code"] integerValue]==0) {
            FilesModel *files = [FilesModel objectWithKeyValues:dict[@"data"]];
            
            [self downLoadFiles:files];
        }
    } OnError:^(NSString *error) {
       
    }];
}

-(void)downLoadFiles:(FilesModel*)filesModel
{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@",IMAGE_HOST, filesModel.attachments];;
  
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",filesModel.file_name,filesModel.attribute];
    
    NSString *file_path =[self destinationFileName:fileName];
   
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //        NSLog(@"%@", downloadProgress);//下载进度
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //返回下载到哪里(返回值是一个路径)
        //拼接存放路径
        //        NSURL *pathURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        //        return [pathURL URLByAppendingPathComponent:[response suggestedFilename]];
        return [self destinationFileDownloadPathWithFileName:fileName];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //下载完成走这个block
        if (!error)
        {
            //如果请求没有错误(请求成功), 则打印地址
            //            NSLog(@"%@", filePath);
            self.path = file_path;
            self.previewController = [QLPreviewController new];
            //                self.previewController.title = fileName;
            self.previewController.dataSource = self;
            [self.previewController setDelegate:self];
            [self presentViewController:self.previewController animated:YES completion:nil];
        }
    }];
    //开始请求

    [task resume];
    
    
}

//下载路径
- (NSURL *)destinationFileDownloadPathWithFileName:(NSString *)fileName
{
    NSURL *downLoadUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    
    return [downLoadUrl URLByAppendingPathComponent:fileName];
    
}

//存放下载完毕的文件
-(NSString *)destinationFileName:(NSString *)fileName
{
    
    NSString *downLoadFileName = [NSString stringWithFormat:@"Documents/%@",fileName];
    return [NSHomeDirectory() stringByAppendingPathComponent:downLoadFileName];
}



#pragma QLPreViewDelegate
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}
- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:_path];
}
- (void)previewControllerDidDismiss:(QLPreviewController *)controller

{
    
    if(![_path  isEqual: @""]){
        NSFileManager * fileManager = [[NSFileManager alloc]init];
        [fileManager removeItemAtPath:_path error:nil];
    }
    
}



#pragma mark get/set

-(NSMutableArray*)fileArray
{
    if (!_fileArray) {
        _fileArray = [NSMutableArray array];
        NSArray *array = [[DataBase sharedDataBase] getAllFile];
        [_fileArray addObjectsFromArray:array];
    }
    return _fileArray;
}

-(NSMutableArray*)selectedfileArray
{
    if (!_selectedfileArray) {
        _selectedfileArray = [NSMutableArray array];
    }
    return _selectedfileArray;
}

@end
