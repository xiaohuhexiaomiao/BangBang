//
//  SearchWorkerCell.h
//  FindWorkerApp
//
//  Created by cxz on 2017/1/8.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchWorkersCellDelegate <NSObject>

-(void)didClickedAddWorkerBtn:(NSInteger)index;

@end

@interface SearchWorkerCell : UITableViewCell

@property (nonatomic, weak) id <SearchWorkersCellDelegate> delegate;

-(void)setSearchCellWithDictionay:(NSDictionary*)dict;

@end
