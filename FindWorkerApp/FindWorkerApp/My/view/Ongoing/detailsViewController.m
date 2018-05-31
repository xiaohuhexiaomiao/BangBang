//
//  detailsViewController.m
//  FindWorkerApp
//
//  Created by 西盛信息 on 16/12/14.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "detailsViewController.h"

@interface detailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)UITableView *tableview;
@end

@implementation detailsViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor=[UIColor whiteColor];
        
        [self maketable];
    }
    return self;
}
-(void)maketable
{
    _tableview=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [self.view addSubview:_tableview];
    
    UIView *HeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50,50)];
    label.text=@"名字";
    [HeaderView addSubview:label];
    HeaderView.backgroundColor=[UIColor whiteColor];
    
    _tableview.tableHeaderView=HeaderView;
    UIView *FooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    UILabel *lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    lable1.text=@"备注";
    [FooterView addSubview:label];
    FooterView.backgroundColor=[UIColor whiteColor];
    _tableview.tableFooterView=FooterView;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{


    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static   NSString *stringmark=@"stringmark";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:stringmark];
    
    if (!cell)
    {
        //创建单元格
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:stringmark];

    }else
    {
        
        while ([cell.contentView.subviews lastObject]!=nil)
        {
            
            cell.backgroundColor=[UIColor whiteColor];
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            
        }
        
    }
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            [self makelabel:cell.contentView].text=@"哈哈";
            
        }
        if (indexPath.row==1)
        {
            [self makelabel:cell.contentView].text=@"哈哈";
            
        }
        if (indexPath.row==2)
        {
            [self makelabel:cell.contentView].text=@"哈哈";
            
        }
        if (indexPath.row==3)
        {
            [self makelabel:cell.contentView].text=@"哈哈";
            
        }
        if (indexPath.row==4)
        {
            [self makelabel:cell.contentView].text=@"哈哈";
            
        }
    }
    

    return cell;

}
-(UILabel*)makelabel:(UIView *)view{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [view addSubview:label];

    return label;
}
//返回单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 50;
            break;
        case 1:
            return 50;
            break;
        case 2:
            return 50;
            break;
        case 3:
            return 50;
        case 4:
            return 50;

        case 5:
            return 50;

            break;
            
        default:
            break;
    }
    return 15;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
