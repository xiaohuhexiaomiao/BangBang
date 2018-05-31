//
//  SWAlipay.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SWAlipay : NSObject

/**
 支付宝支付
 
 @param order_sn_id 订单号
 @param goodsName 商品名称
 @param money 金钱
 @param notify 商品介绍
 */
+ (void)pay:(NSString *)order_sn_id goodName:(NSString *)goodsName money:(CGFloat)money  notify:(NSString *)notify;


/**
 支付宝支付2

 @param orderString 一串支付信息
 */
- (void)payToStr:(NSString *)orderString;


@property (nonatomic, retain) UIView *messageView;

@end
