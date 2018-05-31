//
//  SearchView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/1/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SearchView.h"
#import "CXZ.h"
#import "SearchWorkerCell.h"
@interface SearchView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,SearchWorkersCellDelegate>

@property (nonatomic, strong) UITableView *searchTbview;

@property (nonatomic, strong) UITextField *searchTextView;

@property (nonatomic, strong) UIButton *searchBtn;


@end
@implementation SearchView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _searchArray = [NSMutableArray array];
        
        _searchTextView = [[UITextField alloc]initWithFrame:CGRectMake(8, 5, SCREEN_WIDTH-55, 26)];
        _searchTextView.layer.masksToBounds = YES;
        _searchTextView.layer.cornerRadius = 5;
        UIColor *color = SUBTITLECOLOR;
        //        _searchTextView.attributedText = [[NSAttributedString alloc] initWithString:@"  请输入姓名或电话号码" attributes:@{NSForegroundColorAttributeName: color}];
        _searchTextView.placeholder = @"  请输入姓名或电话号码";
        _searchTextView.backgroundColor = [UIColor colorWithWhite:255 alpha:0.2];
        _searchTextView.layer.borderColor = TOP_GREEN.CGColor;
        _searchTextView.layer.borderWidth = 1;
        _searchTextView.font = [UIFont systemFontOfSize:12];
        _searchTextView.textColor = SUBTITLECOLOR;
        //        _textField.leftView = [UIView new];
        _searchTextView.returnKeyType = UIReturnKeySearch;
        _searchTextView.textAlignment = NSTextAlignmentNatural;
        _searchTextView.delegate = self;
        [self addSubview:_searchTextView];
        
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _searchBtn.backgroundColor = TOP_GREEN;
        _searchBtn.frame = CGRectMake(_searchTextView.right, _searchTextView.top, 50, 25);
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_searchBtn setTitleColor:TOP_GREEN forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(clickedSearch) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_searchBtn];
        
        _searchTbview = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH,frame.size.height-35) style:UITableViewStylePlain];
        _searchTbview.delegate = self;
        _searchTbview.dataSource = self;
        _searchTbview.backgroundColor = [UIColor whiteColor];
        _searchTbview.tableFooterView = [UIView new];
        [self addSubview:_searchTbview];
        
    }
    return self;
}

-(void)clickedSearch
{
    [self.searchTextView resignFirstResponder];
    if ( ![NSString isBlankString:self.searchTextView.text]) {
//        NSLog(@"textf复古风格ield  %@",self.searchTextView.text);
        [[NetworkSingletion sharedManager]searchWorkersList:@{@"info":self.searchTextView.text} onSucceed:^(NSDictionary *dict) {
            NSLog(@"****%@",dict);
            [self.searchArray removeAllObjects];
            if ([dict[@"code"] integerValue] == 0) {
                [self.searchArray addObjectsFromArray: [dict objectForKey:@"data"]];
            }
            [self.searchTbview reloadData];
        } OnError:^(NSString *error) {
          
        }];
    }
}
#pragma mark CellDelegate
-(void)didClickedAddWorkerBtn:(NSInteger)index
{

    [self.delegate clickedAddWorker:index];
}


#pragma mark UITextfield delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"****%@",textField.text);
    dispatch_queue_t queue =  dispatch_queue_create("zy", NULL);
    if ( ![NSString isBlankString:textField.text]) {
//        dispatch_async(queue, ^{
//            [self clickedSearch];
//        });
//        [self performSelectorOnMainThread:@selector(clickedSearch) withObject:nil waitUntilDone:0.5];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self clickedSearch];
    return YES;
}

#pragma mark UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"***as*%li",self.searchArray.count);
    return self.searchArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SearchWorkerCell";
    SearchWorkerCell *cell = (SearchWorkerCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SearchWorkerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.searchArray.count > 0) {
        [cell setSearchCellWithDictionay:self.searchArray[indexPath.row]];
    }
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchArray.count > 0) {
        NSDictionary *dict = self.searchArray[indexPath.row];
        [self.delegate didClickWorker:dict];
    }
    
    
}



@end
