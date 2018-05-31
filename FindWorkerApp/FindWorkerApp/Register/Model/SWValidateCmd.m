//
//  SWValidateCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/29.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWValidateCmd.h"
#import "BaseRespond.h"

@implementation SWValidateCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/skey/check_validate_code";
        
    }
    
    return self;
    
}

@end
