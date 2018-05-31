//
//  SWMyFavoriteData.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@class SWMyFavoriteWorker;

@interface SWMyFavoriteData : Jastor

@property (nonatomic, retain) NSString *cid;

@property (nonatomic, retain) NSString *worker_id;

@property (nonatomic, retain) SWMyFavoriteWorker *worker;

@end
