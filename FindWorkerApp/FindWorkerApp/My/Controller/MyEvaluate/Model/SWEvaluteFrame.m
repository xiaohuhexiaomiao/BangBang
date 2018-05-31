//
//  SWEvaluteFrame.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWEvaluteFrame.h"

#import "CXZ.h"
#import "SWTools.h"

#define padding 8

@implementation SWEvaluteFrame

-(void)setEvaluateData:(SWEvaluateData *)evaluateData {
    
    _evaluateData = evaluateData;
    
    CGFloat iconX = padding;
    CGFloat iconY = padding;
    CGFloat iconW = 50;
    CGFloat iconH = 50;
    self.iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat phoneX = CGRectGetMaxX(self.iconF) + padding;
    CGFloat phoneY = padding;
    CGSize phoneSize = [evaluateData.phone sizeWithFont:[UIFont systemFontOfSize:10] width:SCREEN_WIDTH - CGRectGetMaxX(self.iconF) - padding];
    CGFloat phoneW = phoneSize.width;
    CGFloat phoneH = phoneSize.height;
    self.phoneF = CGRectMake(phoneX, phoneY, phoneW, phoneH);
    
    CGFloat timeX = phoneX;
    CGFloat timeY = CGRectGetMaxY(self.phoneF) + padding;
    CGSize timeSize = [[SWTools dateFormate:evaluateData.add_time formate:@"yyyy-MM-dd hh:mm"] sizeWithFont:[UIFont systemFontOfSize:10] width:SCREEN_WIDTH - CGRectGetMaxX(self.iconF) - padding];
    CGFloat timeW = timeSize.width;
    CGFloat timeH = timeSize.height;
    self.timeF = CGRectMake(timeX, timeY, timeW, timeH);
    
    NSInteger evaluateState = [evaluateData.rated_type integerValue];
    
    NSString *state = @"";
    
    if(evaluateState == 0) {
        
        state = @"满意";
        
    }else if(evaluateState == 1) {
        
        state = @"一般";
        
    }else if(evaluateState == 2) {
        
        state = @"不满意";
        
    }
    
    CGSize stateSize = [state sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    CGFloat stateX = SCREEN_WIDTH - padding - stateSize.width;
    CGFloat stateY = phoneY;
    CGFloat stateW = stateSize.width;
    CGFloat stateH = stateSize.height;
    self.stateF = CGRectMake(stateX, stateY, stateW, stateH);
    
    CGSize contentSize = [evaluateData.details sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH - CGRectGetMaxX(self.iconF) - padding * 2];
    CGFloat contentX = phoneX;
    CGFloat contentY = CGRectGetMaxY(self.timeF) + padding;
    CGFloat contentW = contentSize.width;
    CGFloat contentH = contentSize.height;
    self.contentF = CGRectMake(contentX, contentY, contentW, contentH);
    
    if(CGRectGetMaxY(self.iconF) > CGRectGetMaxY(self.contentF)) {
        
        self.cellH = CGRectGetMaxY(self.iconF) + padding;
        
    }else {
        
        self.cellH = CGRectGetMaxY(self.contentF) + padding;
        
    }
    
}

- (void)showData:(NSString *)icon phone:(NSString *)phone time:(NSString *)time content:(NSString *)content state:(NSString *)state {
    
    CGFloat iconX = padding;
    CGFloat iconY = padding;
    CGFloat iconW = 50;
    CGFloat iconH = 50;
    self.iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat phoneX = CGRectGetMaxX(self.iconF) + padding;
    CGFloat phoneY = padding;
    CGSize phoneSize = [phone sizeWithFont:[UIFont systemFontOfSize:10] width:SCREEN_WIDTH - CGRectGetMaxX(self.iconF) - padding];
    CGFloat phoneW = phoneSize.width;
    CGFloat phoneH = phoneSize.height;
    self.phoneF = CGRectMake(phoneX, phoneY, phoneW, phoneH);
    
    CGFloat timeX = phoneX;
    CGFloat timeY = CGRectGetMaxY(self.phoneF) + padding;
    CGSize timeSize = [time sizeWithFont:[UIFont systemFontOfSize:10] width:SCREEN_WIDTH - CGRectGetMaxX(self.iconF) - padding];
    CGFloat timeW = timeSize.width;
    CGFloat timeH = timeSize.height;
    self.timeF = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGSize stateSize = [state sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
    CGFloat stateX = SCREEN_WIDTH - padding - stateSize.width;
    CGFloat stateY = phoneY;
    CGFloat stateW = stateSize.width;
    CGFloat stateH = stateSize.height;
    self.stateF = CGRectMake(stateX, stateY, stateW, stateH);
    
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH - CGRectGetMaxX(self.iconF) - padding * 2];
    CGFloat contentX = phoneX;
    CGFloat contentY = CGRectGetMaxY(self.timeF) + padding;
    CGFloat contentW = contentSize.width;
    CGFloat contentH = contentSize.height;
    self.contentF = CGRectMake(contentX, contentY, contentW, contentH);
    
    if(CGRectGetMaxY(self.iconF) > CGRectGetMaxY(self.contentF)) {
        
        self.cellH = CGRectGetMaxY(self.iconF) + padding;
        
    }else {
        
        self.cellH = CGRectGetMaxY(self.contentF) + padding;
        
    }
    
}

@end
