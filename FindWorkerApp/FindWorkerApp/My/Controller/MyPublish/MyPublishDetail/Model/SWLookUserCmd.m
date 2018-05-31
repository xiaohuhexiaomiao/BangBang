//
//  SWLookUserCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWLookUserCmd.h"
#import "BaseRespond.h"

@implementation SWLookUserCmd

- (instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/lookUser";
        self.respondType = [BaseRespond class];
        self.uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    }
    
    return self;
    
}

@end
