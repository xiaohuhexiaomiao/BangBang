//
//  SWMyFavoriteData.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMyFavoriteData.h"
#import "SWMyFavoriteWorker.h"

@implementation SWMyFavoriteData

- (Class)worker_class {
    
    return [SWMyFavoriteWorker class];
    
}

@end
