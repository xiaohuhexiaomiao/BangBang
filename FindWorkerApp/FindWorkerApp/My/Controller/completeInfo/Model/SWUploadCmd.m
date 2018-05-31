//
//  SWUploadCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/30.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWUploadCmd.h"
#import "BaseRespond.h"

@implementation SWUploadCmd

-(instancetype)init {
    
    if(self = [super init]){
        
        self.addr = @"/index.php/Mobile/User/update_user_info";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
