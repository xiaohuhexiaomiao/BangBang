//
//  SWSWEmployerConfirmCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/13.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWSWEmployerConfirmCmd.h"

@implementation SWSWEmployerConfirmCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/employerConfirmation";
        
    }
    
    return self;
    
}

@end
