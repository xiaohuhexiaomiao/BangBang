//
//  NetworkSingletion.m
//  FindWorkerApp
//
//  Created by cxz on 2016/12/27.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "NetworkSingletion.h"
#import "SWTabController.h"
#import "SWLoginController.h"
@implementation NetworkSingletion

/**
 更新个人信息
 */
-(void)updateMyInfo:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError
{
  [self requestUrl:@"/index.php/Mobile/User/update_user_info_new" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 获取我的工人
 */
-(void)getMyWorkersData:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/mobile/employer/get_worker_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 消息中心列表
 */
-(void)getNoticeList:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Find/MyInformation" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 个人资料
 */
-(void)getInfoDetailList:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/worker/get_info_phone" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 我要发工资 搜索
 */
-(void)searchWorkersList:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/mobile/worker/get_worker_info" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 交易记录
 */
-(void)transactionLogList:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/mobile/order/get_all_order" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 交易记录详情
 */
-(void)transactionDetail:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/mobile/order/get_pay_detail" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 发工资
 */
-(void)toPayOff:(NSDictionary*)paramDict
      onSucceed:(SuccessedBlock)succeedBlock
        OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/mobile/alipay/ali_pay" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 我要发工资—添加工人
 */
-(void)addWorker:(NSDictionary*)paramDict
       onSucceed:(SuccessedBlock)succeedBlock
         OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/mobile/employer/add_worker" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 我要发工资-删除工人
 */
-(void)deleteWorker:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/mobile/employer/del_worker" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工人向雇主申请付款
 */
-(void)applyPayment:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/mobile/contract/apply_amount" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 取消 添加收藏工人
 */
-(void)colletedWorker:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Find/collect" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 我的发布-详情页-工人列表
 */
-(void)publishedDetailWorkerList:(NSDictionary*)paramDict
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Myinfo/lookUser" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 预览合同
 */
-(void)previewConract:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
    [self requestGetUrl:@"/index.php/Mobile/Find/show_contract" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 发送合同 合同列表
 */
-(void)getConractList:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
    [self requestGetUrl:@"/index.php/Mobile/Myinfo/myRelease" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 获取 总收入 总支出
 */
-(void)getIoAmount:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/mobile/order/get_io_amount" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 账户余额
 */
-(void)getAmountBalance:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Myinfo/money" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 拒绝雇佣
 */
-(void)refuseApply:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/myinfo/refuse_apply" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 忘记密码
 */
-(void)forgetPassWords:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/skey/setPassword" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 解除合同
 */
-(void)cancelContract:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;
{
    [self requestUrl:@"/index.php/Mobile/Contract/del_contract" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 找工人-搜索
 */
-(void)searchWorkers:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/mobile/worker/search_worker" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 找活干-搜索
 */
-(void)searchJobs:(NSDictionary*)paramDict
        onSucceed:(SuccessedBlock)succeedBlock
          OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/mobile/Task/get_work_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 获取工种
 */
-(void)getJobsType:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/mobile/find/worker_type" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 邀请好友
 */
-(void)addFriend:(NSDictionary*)paramDict
       onSucceed:(SuccessedBlock)succeedBlock
         OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/RequestUser/add_request_user" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 推荐好友列表
 */
-(void)friendList:(NSDictionary*)paramDict
        onSucceed:(SuccessedBlock)succeedBlock
          OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/RequestUser/get_request_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}
/**
 获取工种List
 */
-(void)getWorkerType:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Find/worker_type" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 会员规则
 */
-(void)getVipPrice:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/alipayvip/check_price" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 会员支付
 */
-(void)vipPay:(NSDictionary*)paramDict
    onSucceed:(SuccessedBlock)succeedBlock
      OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/alipayvip/ali_pay" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 附近工人列表
 */
-(void)getNearbyWorkerList:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Find/nearby_worker" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}
/**
 推荐工人列表
 */
-(void)getRecommendWorkerList:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Find/not_registered_worker" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 作品列表
 */
-(void)getMyProductionList:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/works/works" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 上传作品 - JIU
 */
-(void)uploadMyProduction:(NSDictionary*)paramDict
                  imgData:(NSArray*)imgArray
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/works/upload_works" paramDic:paramDict data:imgArray onSucceed:succeedBlock OnError:zgrError];
}

/**
 上传作品 - new
 */
-(void)uploadMyProductionNew:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/works/upload_works_new" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 删除作品
 */
-(void)deleteMyProduction:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/works/del_works" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 意见反馈
 */
-(void)feedbackIdea:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/feedback" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工人详情
 */
-(void)workerDetail:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/worker_info" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}



/**
工人同意合同-废弃
 */
-(void)workerAgree:(NSDictionary*)paramDict
           imgData:(NSData*)imgData
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST, @"/index.php/Mobile/Find/audit"];
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    [manager POST:urlString parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        [formData appendPartWithFileData:imgData name:@"signatory_b" fileName:@"upload.png" mimeType:@"image/jpeg"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respond = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        succeedBlock(respond);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        zgrError([error description]);
    }];
    
}

/**
 工人同意合同-新
 */
-(void)workerAgreeNew:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError
{
     [self requestUrl:@"index.php/Mobile/Find/audit_new" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}



/**
 发送合同-新接口
 */
-(void)sendContractNew:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/mobile/find/addcontract_new" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 施工记录列表
 */
-(void)constuctionRecordsList:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/constr/contracts" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 施工记录详情列表
 */
-(void)constuctionRecordsDetailList:(NSDictionary*)paramDict
                          onSucceed:(SuccessedBlock)succeedBlock
                            OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Constr/constr_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 上传施工进度-旧接口
 */
-(void)uploadConstructionRecords:(NSDictionary*)paramDict
                         imgData:(NSArray*)imgArray
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Constr/upload_constr" paramDic:paramDict data:imgArray onSucceed:succeedBlock OnError:zgrError];
}

/**
 上传施工进度-新
 */
-(void)uploadConstructionRecordsNew:(NSDictionary*)paramDict
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Constr/upload_constr_new" paramDic:paramDict  onSucceed:succeedBlock OnError:zgrError];
}

/**
 施工评论
 */
-(void)constuctionCommentList:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Constr/commentshow" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
 
}
/**
 发表施工评论
 */
-(void)sendComment:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError
{
     [self requestUrl:@"/index.php/Mobile/Constr/comment" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 雇主验收
 */
-(void)acceptProduction:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Find/check_up" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];

}

/**
 工人申请验收
 */
-(void)applyAcceptProduction:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Find/worker_apply" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工人申请放款
 */
-(void)applyAmount:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/mobile/contract/apply_amount" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 判断工人是否申请验收
 */
-(void)getApplyStatus:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Find/is_apply" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 获取合同类型
 */
-(void)getConstractType:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/find/select_contracttypes" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 获取合同规范描述
 */
-(void)getConstractDescription:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError;

{
    [self requestUrl:@"/index.php/Mobile/find/get_form_elements" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 修改合同 - 获取合同信息
 */
-(void)getModifyConstractDetail:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError;
{
    [self requestUrl:@"/index.php/Mobile/find/get_contract_content" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 修改合同
 */
-(void)getModifyConstract:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/edit_contract" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 创建公司
 */
-(void)createCompany:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/User/add_company" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 判断是否为公司人员 和 管理员
 */
-(void)isInCompany:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/User/return_company" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 查看公司部门列表
 */
-(void)getDepartmentData:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/User/get_department_lest" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 查看公司部门人员
 */
-(void)getDepartmentPersonnerlData:(NSDictionary*)paramDict
                         onSucceed:(SuccessedBlock)succeedBlock
                           OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/User/get_company_personnel" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 创建部门
 */
-(void)creatDepartment:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/User/add_department" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 添加同事
 */
-(void)addColleague:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/User/add_personnel" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 审批权限列表
 */
-(void)getApprovalList:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/approval_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
 
}



/**
 设置审批权限
 */
-(void)setApprovalList:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/set_sequence" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];

}

/**
 查看公司合同类型
 */
-(void)getCompanyContractTypeList:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/select_contract_companty_types" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];

}



/**
 添加公司合同-新接口
 */
-(void)addCompanyContractNew:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/find/add_draft" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 获取公司合同列表
 */
-(void)getCompanyContractList:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError
{
     [self requestUrl:@"/index.php/Mobile/find/list_contract_company" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 乙方审核合同 1通过, 2 退回修改，3拒绝
 */
-(void)yiFangCheckContract:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/audit_company_new" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 公司合同-乙方同意合同
 */
-(void)yiFangAgreeContract:(NSDictionary*)paramDict
                 imageData:(NSData*)imgData
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST, @"/index.php/Mobile/find/audit_company"];
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    [manager POST:urlString parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        [formData appendPartWithFileData:imgData name:@"signatory_b" fileName:@"upload.png" mimeType:@"image/jpeg"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respond = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        succeedBlock(respond);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        zgrError([error description]);
    }];
}
/**
 公司合同-乙方同意合同-NEW
 */
-(void)yiFangAgreeContractNew:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/audit_company_new" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 创建合同评审表
 */
-(void)createContractReview:(NSDictionary*)paramDict
                  onSucceed:(SuccessedBlock)succeedBlock
                    OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/add_approval_conyract_company" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 办公- 处理审批-列表
 */
-(void)getContractReviewList:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/see_approval_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 办公- 处理审批-列表详情
 */
-(void)getContractReviewDetail:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/approval_process_show" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 办公- 审批表单-处理审批
 */
-(void)dealWithReview:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/approval_process" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 办公- 审批表单- 详情-查看处理结果
 */
-(void)getReviewResult:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/approval_process_personnel" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 修改合同-获取公司合同详情
 */
-(void)getCompanyContractDetail:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/find/get_contract_company_content" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 修改公司合同
 */
-(void)updateCompanyContract:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/edit_contract_company" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 上传附件 - 旧版
 */
-(void)updateReviewAnnex:(NSDictionary*)paramDict
                   image:(NSArray*)imgArray
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/upload_enclosure" paramDic:paramDict data:imgArray onSucceed:succeedBlock OnError:zgrError];
}


/**
 上传附件 - 新版
 */
-(void)updateReviewAnnexNew:(NSDictionary*)paramDict
                  onSucceed:(SuccessedBlock)succeedBlock
                    OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/upload_enclosure_new" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 合同评审表 - 查看附件
 */
-(void)getReviewAnnexDetail:(NSDictionary*)paramDict
                  onSucceed:(SuccessedBlock)succeedBlock
                    OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/look_enclosure" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 个人合同列表
 */
-(void)getPersonalContractList:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Find/list_contract" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
 
}

/**
 添加请款单
 */
-(void)addPaymentForm:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
  [self requestUrl:@"/index.php/Mobile/approval/add_request_money" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 添加请购单
 */
-(void)addPurchaseForm:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError
{
  [self requestUrl:@"/index.php/Mobile/approval/add_request_buy" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 添加印章申请单
 */
-(void)addStampForm:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/add_request_seal" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 公司注册
 */
-(void)registerCompany:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/skey/register" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 添加管理员
 */
-(void)addManager:(NSDictionary*)paramDict
        onSucceed:(SuccessedBlock)succeedBlock
          OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/User/give_manage" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 删除管理员
 */
-(void)deleteManager:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/User/del_manage" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 退出公司
 */
-(void)quiteCompany:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/User/quit_company" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 管理员删除员工
 */
-(void)deletePersonel:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/user/del_company_personnel" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 特权审批
 */
-(void)sepecalApproval:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/approval_process_boss" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 添加呈批件
 */
-(void)addApprovalFile:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/add_chengpi" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 特权- 设置特权
 */
-(void)setSpecailApproval:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/user/set_boss" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 搜索审批
 */
-(void)searchApproval:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
     [self requestUrl:@"/index.php/Mobile/approval/select_approval" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 公司人员-更改部门信息
 */
-(void)updateDepartment:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/User/department_adjustment" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 审批下载-获取token
 */
-(void)getLoadToken:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/find/get_download_token" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 清空消息
 */
-(void)clearNotice:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/user/delete_news" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 图片上传七牛-获取token
 */
-(void)getQiNiuToken:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/path/get_token" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 图片上传七牛-获取token
 */
-(void)getQiNiuTokenWithSync:(NSString*)paramString
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError
{
    NSString *urlString = [NSString stringWithFormat:@"%@/index.php/Mobile/path/get_token",API_HOST];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"app_token"];
    NSString *uid =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
   NSString *paramStr =  [paramString stringByAppendingFormat:@"&skey=%@&skey_uid=%@",token,uid];
 
     NSData *postDatas = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    [request setHTTPBody:postDatas];
    

    NSData *responseObject = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *respond = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//     NSLog(@"**respond*%@",respond);
    succeedBlock(respond);


}

/**
 撤回审批
 */
-(void)cancelApproval:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/find/withdraw_approval" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 获取公司列表
 */
-(void)getCompanyList:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/user/companies_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 获取公司权限信息
 */
-(void)getMangerRightInfoOfCompany:(NSDictionary*)paramDict
                         onSucceed:(SuccessedBlock)succeedBlock
                           OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/user/return_company_new" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 删除用户-判断用户是否还有审批
 */
-(void)isHaveApproval:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/user/have_approval" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 申请加入公司-公司列表
 */
-(void)getAllCompanyList:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/all_company_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 申请加入公司
 */
-(void)applyJoinCompany:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/request_join_company" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}
/**
 申请加入公司- 申请列表
 */
-(void)listOfapplyJoinCompany:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/find/request_join_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 申请加入公司- 处理申请加入公司
 */
-(void)approvalApplyJoinCompany:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/deal_with_request_join" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 审批列表- 添加颜色标记
 */
-(void)addColorSign:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/add_tagging" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 创建公装合同评审表（新）
 */
-(void)creatCompanyReview:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/add_approval_conyract_company_new" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 搜索公司
 */
-(void)searchCompany:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError

{
    [self requestUrl:@"/index.php/Mobile/find/select_company_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 创建公司-添加人员
 */
-(void)addPersonToCompany:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/add_peo" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}



/**
 创建公司-预设部门
 */
-(void)presetDepartmentOfCompany:(NSDictionary*)paramDict
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/reserve_department_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 创建公司-自定义部门
 */
-(void)customDepartmentOfCompany:(NSDictionary*)paramDict
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/new_department" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 创建公司-自定义职位
 */
-(void)customPosition:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/default_job" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 创建公司-完整接口
 */
-(void)lastAddPersonToCompany:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/entrance_company" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];

}

/**
 设置审批-获取表单审批人员
 */
-(void)getFormApprovalPerson:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/user/get_approval_user_info" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 添加工程
 */
-(void)addProjectOfCompany:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/company/add_company_project" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 获取工程列表
 */
-(void)getProjectList:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/company/company_project_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 工种类型
 */
-(void)getWorkerTypeList:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;
{
    [self requestUrl:@"/index.php/Mobile/find/worker_type_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工种- 自定义工种
 */
-(void)customWorkerType:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;

{
   [self requestUrl:@"/index.php/Mobile/find/add_worker_type" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 创建请款单-获取上次请款记录
 */
-(void)getLastApplyPaymentsList:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/history_request_money" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 公司合同 - 保存草稿箱
 */
-(void)saveContractToDrafts:(NSDictionary*)paramDict
                  onSucceed:(SuccessedBlock)succeedBlock
                    OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/add_draft" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 公司合同 - 草稿箱列表
 */
-(void)getContractDraftsList:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/find/draft_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 查看文档
 */
-(void)lookFilesDetail:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/approval/look_attachments" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 获取请款依据列表
 */
-(void)getPaymentBasisList:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/request_monry_basis" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 附近工人列表
 */
-(void)getAllWorkerList:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Find/nearby_worker_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}



/**
 设置财务回执人员
 */
-(void)setCashier:(NSDictionary*)paramDict
        onSucceed:(SuccessedBlock)succeedBlock
          OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/user/give_finance" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
 
}

/**
 删除财务回执人员
 */
-(void)deleteCashier:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError;
{
    [self requestUrl:@"/index.php/Mobile/user/del_finance" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];

}


/**
 财务回执列表
 */
-(void)cashierReplyList:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/finance_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 财务回执操作
 */
-(void)cashierReply:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/finance_receipt" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 添加单文件
 */
-(void)addFiles:(NSDictionary*)paramDict
      onSucceed:(SuccessedBlock)succeedBlock
        OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/add_attachments" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 表单回执 - 设置回执人员
 */
-(void)setReceiptPerson:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/user/give_finance_new" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 表单回执 - 回执人员列表展示
 */
-(void)receiptPersonList:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/finance_personnel_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 表单回执 - 回执人员 处理列表
 */
-(void)getReceiptDisposeList:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/finance_list_formal" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 处理审批-我发起的— 删除已撤销
 */
-(void)deleteMyApproval:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError
{
     [self requestUrl:@"/index.php/Mobile/find/del_approval" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 工作记录-发表日志、周志、月志
 */
-(void)publishOnePlan:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/publish_log" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 工作记录-日志列表
 */
-(void)getPlanList:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/publish_look_two" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工作记录- 日志详情
 */
-(void)getPlanDetail:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/get_public_content" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工作记录- 获取日志评论列表
 */
-(void)getDiaryCommentsList:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/get_publish_comment" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工作记录- 获取点赞列表
 */
-(void)getDiaryGoodsList:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/like_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工作记录- 日志点赞
 */
-(void)clickDiaryGoodsButton:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/like_company_log" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 工作记录- 日志评论
 */
-(void)clickDiaryCommentsButton:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError;
{
    [self requestUrl:@"/index.php/Mobile/company/user_comment" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工作记录- 点评人评分
 */
-(void)clickDiaryReviewsButton:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/user_reviewer" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工作记录- 外勤签到
 */
-(void)workOutSignIn:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/punch_in" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工作记录- 删除日志
 */
-(void)deleteDiary:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/del_publish" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 工作记录- 查看个人日志记录
 */
-(void)lookPersonDiaryList:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/personnel_publish_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工作记录- 日志统计
 */
-(void)personWorkerPlanCount:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/look_month_publish_timelist" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工作记录- 查看个人某条日志记录
 */
-(void)lookPersonDiaryOfOneDay:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/look_day_publish" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 表单回执-做标记
 */
-(void)cashierListSign:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/finance_add_tagging" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 日志提醒-获取各类型提醒最新数据
 */
-(void)getNewRemindData:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/message_notification_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 日志提醒-回复我的
 */
-(void)getMyReply:(NSDictionary*)paramDict
        onSucceed:(SuccessedBlock)succeedBlock
          OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/reply_me_message_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 日志提醒-我收到的赞
 */
-(void)getMyGood:(NSDictionary*)paramDict
       onSucceed:(SuccessedBlock)succeedBlock
         OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/like_me_message_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 日志提醒-点评列表
 */
-(void)needReviewList:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError

{
    [self requestUrl:@"/index.php/Mobile/company/wait_reviewed_message_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 日志 - 日志类型
 */
-(void)getDiarySubTypeList:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/select_company_log_types" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 日志 - 获取日志规范
 */
-(void)getDiaryRegulation:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/get_company_log_elements" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 日志 - 获取日志抄送范围
 */
-(void)getDiarySendRange:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/company/look_cc_user_name" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
添加报销单
 */
-(void)publishExpenseAccountForm:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/approval/add_baoxiao" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 创建子公司
 */
-(void)creatSubCompany:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/User/add_company_son" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 我要发工资-发工资（新）
 */
-(void)toPayAndRecord:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/User/bookkeeping_book" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}
/**
 我要发工资-账本查询
 */
-(void)searchPayRecords:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/User/bookkeeping_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 我发出的合同列表
 */
-(void)sendContractList:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/contract_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 合同 -  付定金
 */
-(void)toPayDownPayment:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/alipay/ali_pay" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 验收-申请记录
 */
-(void)applyForAcceptanceList:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/apply_history" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 验收-查看验收详情
 */
-(void)getAcceptanceDetail:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/look_apply_content" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 验收-处理验收
 */
-(void)dealWithAcceptance:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/user_inspection" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 验收-处理申请完工
 */
-(void)dealWithEndContract:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/do_examine" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工程-结束报名
 */
-(void)endApplyProject:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/myinfo/end_enter" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 获取用户信息 参数Uid
 */
-(void)getUserInfo:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/User/user_info" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 回复审批
 */
-(void)replyApprovalForm:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/reply_approval" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}
/**
 验收-获取报验单类型列表
 */
-(void)getSingleInspectionList:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/inspection_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 验收-获取结算单类型列表
 */
-(void)getStatementsList:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/seelement_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 验收-添加验收单
 */
-(void)addAccpectForm:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/add_inspection" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 验收-添加结算单
 */
-(void)addSettlementForm:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/add_settlement" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 验收-最后提交
 */
-(void)submitBigAcceptForm:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/worker_apply_dis" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 验收- 修改验收大接口
 */
-(void)modifyApplyAccept:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/edit_worker_apply" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 验收- 申请完工
 */
-(void)applyEndContract:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/examine_apply" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}



/**
 回复审批消息列表
 */
-(void)getReplyApprovalMessageList:(NSDictionary*)paramDict
                         onSucceed:(SuccessedBlock)succeedBlock
                           OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/company/reply_me_approval_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 发起个人审批-请购单
 */
-(void)sendPersonalPurchaseForm:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/personal/add_personal_request_buy" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 发起个人审批-请款单
 */
-(void)sendPersonalPaymentsForm:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/personal/add_request_money_personal" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 发起个人审批-呈批件
 */
-(void)sendPersonalFileForm:(NSDictionary*)paramDict
                  onSucceed:(SuccessedBlock)succeedBlock
                    OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/personal/add_personal_chengpi" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 发起个人审批-报销单
 */
-(void)sendPersonalExpenseForm:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/personal/add_baoxiao" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 个人审批-审批详情
 */
-(void)getPersonalApprovalDetail:(NSDictionary*)paramDict
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/personal/approval_personal_process_show" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 个人审批-审批列表
 */
-(void)getPersonalApprovalList:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/personal/see_approval_personal_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 个人审批-删除
 */
-(void)deletePersonalApproval:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/personal/del_approval_personal" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 个人审批-搜索
 */
-(void)searchPersonalApproval:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/personal/select_personal_approval" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
 
}

/**
 个人审批-处理
 */
-(void)dealWithPersonalApproval:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/personal/personal_approval" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 合同模块-申请付款记录
 */
-(void)getApplyPayHistory:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/apply_pay_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 合同模块-拒绝付款
 */
-(void)rejectApplyPay:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/handle_apply_pay" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}



/**
 融云即时通讯-获取我的群组
 */
-(void)getMyGroupsWithDictionary:(NSDictionary*)paramDict
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError

{
    [self requestUrl:@"/index.php/Mobile/personal/my_group_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 融云即时通讯-创建群组
 */
-(void)createGroupWithInfo:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/personal/create_group" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 融云即时通讯-获取群组成员
 */
-(void)getGroupMemberByID:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/personal/get_group_user_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError]; 
}

/**
 融云即时通讯-获取单个群组 信息
 */
-(void)getGroupInfoByID:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/personal/get_group_content" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
   
}

/**
 融云即时通讯-修改群组 信息
 */
-(void)editGroupInfoByID:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/personal/upload_group_content" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 融云即时通讯-解散群
 */
-(void)dissolveGroup:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError;

{
      [self requestUrl:@"/index.php/Mobile/personal/manager_dissolution" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 融云即时通讯-退出群
 */
-(void)quiteGroup:(NSDictionary*)paramDict
        onSucceed:(SuccessedBlock)succeedBlock
          OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/personal/out_group" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 融云即时通讯-单独添加人员
 */
-(void)addGroupMember:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/personal/add_group_user" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 融云即时通讯-群主删除人员
 */
-(void)deleteGroupMember:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/personal/appoint_out_group" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


/**
 附近公司-所有大公司
 */
-(void)getAllCorporation:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/all_big_company_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 附近公司-公司下的工程列表
 */
-(void)getAllProjectOfCorporation:(NSDictionary*)paramDict
                        onSucceed:(SuccessedBlock)succeedBlock
                          OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/get_project" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 附近公司-工人所在大公司
 */
-(void)getAllCorporationByUserID:(NSDictionary*)paramDict
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/find/get_my_big_company" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工人-判断是否已付款 （付款后可查看工人详情）
 */
-(void)isPayForTheWorker:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError
{
   [self requestUrl:@"/index.php/Mobile/alisun/view_power" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 工人-付款 （付款后可查看工人详情）
 */
-(void)toPayForTheWorkerFromCount:(NSDictionary*)paramDict
                        onSucceed:(SuccessedBlock)succeedBlock
                          OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/alisun/view_payment" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 附近工程-个人工程
 */
-(void)nearbyPersonalProject:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError
{
    [self requestUrl:@"/index.php/Mobile/Find/find_work_personal" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 支付宝充值
 */
-(void)rechargeWithAlipay:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError
{
     [self requestUrl:@"/index.php/Mobile/Alisun/recharge" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 呈批件协议
 */
-(void)uploadPorotocolOfFile:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError
{
 [self requestUrl:@"/index.php/Mobile/Approval/add_chengpi_supply" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 公司审批- 验收单
 */
-(void)uploadInspection:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError
{
  [self requestUrl:@"/index.php/Mobile/approval/add_inspection" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}

/**
 公司审批- 验收单列表
 */
-(void)getCompanyInspectionList:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError
{
 [self requestUrl:@"/index.php/Mobile/approval/inspection_list" paramDic:paramDict onSucceed:succeedBlock OnError:zgrError];
}


#pragma mark

+(NetworkSingletion*)sharedManager
{
    static NetworkSingletion *sharedNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkSingleton = [[self alloc] init];
    });
    return sharedNetworkSingleton;
}

-(AFHTTPSessionManager *)baseHtppRequest
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    //    [manager.requestSerializer setValue:KGETACCESSTOKEN forHTTPHeaderField:KACCESSTOKEN];//设置请求头
    
    return manager;
}

#pragma mark

- (void)requestUrl:(NSString *)url
          paramDic:(NSDictionary *)paramsDic
              data:(NSArray*)dataArray
         onSucceed:(SuccessedBlock)successBlock
           OnError:(FailureBlock)failureBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST, url];
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict addEntriesFromDictionary:paramsDic];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"app_token"];
    NSString *uid =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [paramDict setObject:token forKey:@"skey"];
    [paramDict setObject:uid forKey:@"skey_uid"];
    [manager POST:urlString parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < dataArray.count; i ++) {
            
            [formData appendPartWithFileData:dataArray[i] name:@"picture[]" fileName:@"upload.png" mimeType:@"image/jpeg"];
            //            [formData appendPartWithFileData:dataArray[i] name:@"picture" fileName:[NSString stringWithFormat:@"upload%i.png",i] mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respond = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [respond[@"code"] integerValue];
        if (code==251 || code==252 ) {
            static NSString *alertTitle;
            if (code == 251) {
                alertTitle = @"您的账号被其他设备登录已下线，请重新登录！";
            }else{
                alertTitle = @"您的登录授权已过期，请重新登录！";
            }
            UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:alertTitle  message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alerVC addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SWLoginController *logVC = [[SWLoginController alloc]init];
                UIViewController *resultVC = [self topViewController];
                [resultVC presentViewController:logVC animated:YES completion:nil];
                
            }]];
            UIViewController *resultVC = [self topViewController];
            
            [resultVC presentViewController:alerVC animated:YES completion:nil];
            
        }else{
            successBlock(respond);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock([error description]);
    }];
}



- (void)requestUrl:(NSString *)url
          paramDic:(NSDictionary *)paramsDic
         onSucceed:(SuccessedBlock)successBlock
           OnError:(FailureBlock)failureBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST, url];
    
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict addEntriesFromDictionary:paramsDic];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"app_token"];
    [paramDict setObject:token forKey:@"skey"];
    NSString *uid =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [paramDict setObject:uid forKey:@"skey_uid"];
//    NSLog(@"**paramDict*%@",paramDict);
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        if (request) {
            return request;
            
        }
        return nil;
        
    }];
    
    [manager POST:urlString parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respond = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [respond[@"code"] integerValue];
        if (code==251 || code==252 ) {
            static NSString *alertTitle;
            if (code == 251) {
                alertTitle = @"您的账号被其他设备登录已下线，请重新登录！";
            }else{
                 alertTitle = @"您的登录授权已过期，请重新登录！";
            }
            UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:alertTitle  message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alerVC addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SWLoginController *logVC = [[SWLoginController alloc]init];
                 UIViewController *resultVC = [self topViewController];
                [resultVC presentViewController:logVC animated:YES completion:nil];
                
            }]];
            UIViewController *resultVC = [self topViewController];

            [resultVC presentViewController:alerVC animated:YES completion:nil];
    
        }else{
            successBlock(respond);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock([error description]);
    }];
}

-(void)requestGetUrl:(NSString *)url
            paramDic:(NSDictionary *)paramsDic
           onSucceed:(SuccessedBlock)successBlock
             OnError:(FailureBlock)failureBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST, url];
    
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    [manager GET:urlString parameters:paramsDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respond = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        successBlock(respond);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock([error description]);
    }];
    
}


// 获取topviewcontroller
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
