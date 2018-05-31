//
//  PerssonalTableViewCell.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "PerssonalTableViewCell.h"
#import "CXZ.h"
#import "PersonCollectionViewCell.h"
@interface PerssonalTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,PersonCollectionDelegate>

@property(nonatomic , strong)  UICollectionView *perCollectionView;

@property(nonatomic ,strong)NSMutableArray *dataArray;

@property(nonatomic , assign) NSInteger lastRow;


@end

@implementation PerssonalTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:233 green:233 blue:233 alpha:1];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(50, 60);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
        _perCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60) collectionViewLayout:flowLayout];
        _perCollectionView.backgroundColor = [UIColor colorWithRed:233 green:233 blue:233 alpha:1];
        _perCollectionView.dataSource = self;
        _perCollectionView.delegate = self;
        [_perCollectionView registerClass:[PersonCollectionViewCell class] forCellWithReuseIdentifier:@"PersonCollectionCell"];
        [self.contentView addSubview:_perCollectionView];
    }
    return self;
}

-(void)setPerssonalCell:(NSArray *)dataArray
{
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObjectsFromArray:dataArray];
    self.lastRow = dataArray.count;
    
    [self.perCollectionView reloadData];
  
    if (self.isDelete) {
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        longGesture.minimumPressDuration = 0.5f;
        [_perCollectionView addGestureRecognizer:longGesture];
        
    }
    
    
}

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
   
    static NSInteger beginIndex;
    static NSInteger endIndex;
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.perCollectionView indexPathForItemAtPoint:[longGesture locationInView:self.perCollectionView]];
            //在路径上则开始移动该路径上的cell
            [self.perCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [self.perCollectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.perCollectionView]];
            break;
        case UIGestureRecognizerStateEnded:{
            //移动结束后关闭cell移动
            [self.perCollectionView endInteractiveMovement];
           
        }
            break;
        default:
            [self.perCollectionView cancelInteractiveMovement];
            break;
    }

}

-(void)clickPersonCOllectionCell:(NSString *)typeStr withIndex:(NSInteger)index
{
//    NSLog(@"**del**%@***%li",typeStr,index);
    if ([typeStr isEqualToString:@"delete"]) {
        [self.dataArray removeObjectAtIndex:index];
        [self.perCollectionView reloadData];
        [self.delegate updateApprovalList:self.dataArray];
    }
    if ([typeStr isEqualToString:@"add"]) {
        [self.delegate clickAddBtn:self.dataArray index:self.index];
    }
}

#pragma mark UICollectionView Delegate & Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count+1;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PersonCollectionViewCell * cell = (PersonCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PersonCollectionCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.delegate = self;
    if (indexPath.row == self.dataArray.count) {
        cell.per_avatarImageview.image = [UIImage imageNamed:@"add"];
        cell.per_nameLabel.hidden = YES;
        cell.per_deleteBtn.hidden = YES;
        if (self.isDelete) {
            cell.isEdit = YES;
        }
        
    }else{
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,[self.dataArray[indexPath.row] objectForKey:@"avatar"]];
        cell.per_nameLabel.text = [self.dataArray[indexPath.row] objectForKey:@"name"];
        [cell.per_avatarImageview sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"temp"]];
        cell.per_nameLabel.hidden = NO;
        if (self.isDelete) {
            cell.per_deleteBtn.hidden = NO;
        }else{
            cell.per_deleteBtn.hidden = YES;
        }
    }
    
    return cell;
}


-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSDictionary *tempDict = self.dataArray[sourceIndexPath.row];
    [self.dataArray removeObject:tempDict];
    [self.dataArray insertObject:tempDict atIndex:destinationIndexPath.row];
    [self.delegate updateApprovalList:self.dataArray];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.perCollectionView.frame = self.contentView.bounds;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
