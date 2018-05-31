//
//  SWFavoriteCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/6.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWFavoriteCmd.h"
#import "BaseRespond.h"

@implementation SWFavoriteCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/myCollection";
        self.respondType = [BaseRespond class];
        
        
    }
    
    return self;
    
}

@end
