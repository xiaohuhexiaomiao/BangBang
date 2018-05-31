//
//  SWAlipay.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWAlipay.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "CXZ.h"



@implementation SWAlipay


/**
 支付宝支付

 @param order_sn_id 订单号
 @param goodsName 商品名称
 @param money 金钱
 @param notify 商品介绍
 */
+ (void)pay:(NSString *)order_sn_id goodName:(NSString *)goodsName money:(CGFloat)money  notify:(NSString *)notify {

//    NSString *appScheme = @"FindWorkerAlipay";
//    NSString *partner = @"2088422614677955";//商户ID
//    NSString *seller = @"18072765452";
//    NSString *privateKey =@"MIICXQIBAAKBgQD73Esjf+N4AGd2kDtDylx+CCDPrjvooVASVWMRs1pVIIRYFLuIRjoYWKtLdesO75sqpbPeVmHjDHtGwzbcKzfBdnwnPkroIUPgdoVYrGexR7kuXDjNvl+CG7amtrPg6zirH3SI6R3NYpZcWRCvJBU2w2A7XbTtEN4mcuDxUDeDSwIDAQABAoGBAOAzxp+fZPqaQYAF/Pvn1FZNHghCbgo0L3dik4JaSnulKqrOKfKxsV2i8TmHiuwM1/Aq+edetlzL66GefeOYhVPq8bpbOPBjdiwtcnYi3qaVNkt8sM8sd6BirpiTDkSTjbdDe6AGDUzvsXqIcFjHLVks7T4riHTjqW4yAGvHt0khAkEA/85HgZyK5UTyFBLJR68wpMTPOhYnmyM7CyL4EZz9zfE4PGj2Uvvms71pR627f2a/KMPKJIAsSYfenf2BWve3DQJBAPwNP1KUpt1KP+Yl8j32Ojwlo0aXEudMuGhBRwtIqsN4uSS2ka8WAU4xqp8J0N/SyAS9N2Kirl2lAxBzCtI4DbcCQFH0v/opsmJ0LW76+dvqqBYSLCZ7FKNirTcLNBlIiBRkNVU9d7XsmOR7SfC6G7lcrOAdonUBT68bRdqubrQ7az0CQQC2OYmfVZNyB109Mg/5lguyMm/h+BUVnlTwIsmPMeErYxtPnKKk157n/mZhhsI5H3W2X2osaHrxfvxBJzsakqXvAkAFfWM4Yye1NZQypfIeUD/46J6hKBX0r0kP67xaIH/kaE82mfdP/kGkVF4M8NfsV3HSYwDEUR1WuxfTrniH3Bla";
//    Order *order = [[Order alloc] init];
//    order.partner = partner;
//    order.seller = seller;
//    order.tradeNO = [NSString stringWithFormat:@"%@",order_sn_id] ;//订单ID（由商家自行制定）
//    order.productName = goodsName ; //商品标题
//    //     order.productDescription = @"测试" ; //商品描述
//    order.amount = [NSString stringWithFormat:@"%.2f", money];
//    order.notifyURL =  notify;//回调地址
//    
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
//    order.service = @"mobile.securitypay.pay";//固定值
//    NSString *orderSpec = [order description];
//    
//    id <DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        NSLog(@"******%@",orderString);
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            //【callback 处理支付结果】
//            NSLog(@"reslut = %@",resultDic);
//            
//            if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
////                [WFHudView showMsg:@"订单支付失败" inView:self.navigationController.view];
//                
//            }
//            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
////                MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
////                [self.view addSubview:hud];
////                hud.removeFromSuperViewOnHide = YES;
////                [hud showAnimated:YES whileExecutingBlock:^{
////                    [WFHudView showMsg:@"订单支付成功" inView:self.navigationController.view];
////                } completionBlock:^{
////                    MyOrderDetailViewController *orderDetail = [[MyOrderDetailViewController alloc]init];
////                    orderDetail.orderID = orderid;
////                    self.hidesBottomBarWhenPushed = YES;
////                    [self.navigationController pushViewController:orderDetail animated:YES];
////                    self.hidesBottomBarWhenPushed = YES;
////                }];
//            }
//            if ([resultDic[@"resultStatus"] isEqualToString:@"8000"]) {
////                [WFHudView showMsg:@"正在处理中" inView:self.navigationController.view];
//            }
//            //            if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
//            //                [WFHudView showMsg:@"取消支付" inView:self.view];
//            //            }//用户中途取消
//            if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
////                [WFHudView showMsg:@"网络连接出错" inView:self.navigationController.view];
//            }
//            
//        }];
//    }
    
}

- (void)payToStr:(NSString *)orderString {

     NSString *appScheme = @"FindWorkerAlipay";
    NSLog(@"***%@",orderString);
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        //【callback 处理支付结果】
        NSLog(@"reslut = %@",resultDic);
        
        if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
            [MBProgressHUD showError:@"订单支付失败" toView:self.messageView];
        }
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            //                MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
            //                [self.view addSubview:hud];
            //                hud.removeFromSuperViewOnHide = YES;
            //                [hud showAnimated:YES whileExecutingBlock:^{
            //                    [WFHudView showMsg:@"订单支付成功" inView:self.navigationController.view];
            //                } completionBlock:^{
            //                    MyOrderDetailViewController *orderDetail = [[MyOrderDetailViewController alloc]init];
            //                    orderDetail.orderID = orderid;
            //                    self.hidesBottomBarWhenPushed = YES;
            //                    [self.navigationController pushViewController:orderDetail animated:YES];
            //                    self.hidesBottomBarWhenPushed = YES;
            //                }];
        }
        if ([resultDic[@"resultStatus"] isEqualToString:@"8000"]) {
            [MBProgressHUD showError:@"正在处理中" toView:self.messageView];
        }
        if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
            [MBProgressHUD showError:@"取消支付" toView:self.messageView];
        }//用户中途取消
        if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
            [MBProgressHUD showError:@"网络连接出错" toView:self.messageView];
        }

        
    }];
    
}

@end
