//
//  MyWorkersCell.h
//  FindWorkerApp
//
//  Created by cxz on 2016/12/28.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,CellType)
{
    NormallType,
    SearchType,//搜索
};

@protocol MyWorkersCellDelegate <NSObject>

-(void)setMoney:(NSInteger)index isSelect:(BOOL)selected isPut:(BOOL)put money:(CGFloat)money;

-(void)setPayMoney:(CGFloat)money;

@end

@interface MyWorkersCell : UITableViewCell

@property (nonatomic, weak) id <MyWorkersCellDelegate> delegate;

@property (nonatomic, assign)CellType type;

- (void) setMoney:(NSString*)moneyStr;

- (void) setMyWorkersCell:(NSDictionary*)dict;

//- (void) setIsEditing:(BOOL)editing;

- (void) setSelectImage:(NSString*)select;

@end
