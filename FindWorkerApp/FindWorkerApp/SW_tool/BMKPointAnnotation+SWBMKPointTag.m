//
//  BMKPointAnnotation+SWBMKPointTag.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/3.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BMKPointAnnotation+SWBMKPointTag.h"
#import <objc/runtime.h>

@implementation BMKPointAnnotation (SWBMKPointTag)

static char *PersonNameKey = "PersonNameKey";

@dynamic tag;

- (NSString *)tag {

    return objc_getAssociatedObject(self,PersonNameKey);
    
}

- (void)setTag:(NSString *)tag {
    
    objc_setAssociatedObject(self, PersonNameKey, tag, OBJC_ASSOCIATION_RETAIN);
    
}

@end
