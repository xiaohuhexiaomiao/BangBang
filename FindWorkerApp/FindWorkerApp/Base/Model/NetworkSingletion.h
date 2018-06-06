//
//  NetworkSingletion.h
//  FindWorkerApp
//
//  Created by cxz on 2016/12/27.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CXZ.h"




@interface NetworkSingletion : NSObject
//请求超时
#define TIMEOUT 10

typedef void(^SuccessedBlock)(NSDictionary *dict);

typedef void(^FailureBlock)(NSString *error);

+(NetworkSingletion *)sharedManager;

-(AFHTTPSessionManager*)baseHtppRequest;


/**
 更新个人信息
 */
-(void)updateMyInfo:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError;


/**
 获取我的工人
 */
-(void)getMyWorkersData:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;


/**
 消息中心列表
 */
-(void)getNoticeList:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError;


/**
 个人资料
 */
-(void)getInfoDetailList:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;

/**
 我要发工资 搜索
 */
-(void)searchWorkersList:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;

/**
 交易记录
 */
-(void)transactionLogList:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError;

/**
 交易记录详情
 */
-(void)transactionDetail:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;

/**
 发工资
 */
-(void)toPayOff:(NSDictionary*)paramDict
      onSucceed:(SuccessedBlock)succeedBlock
        OnError:(FailureBlock)zgrError;

/**
 我要发工资—添加工人
 */
-(void)addWorker:(NSDictionary*)paramDict
       onSucceed:(SuccessedBlock)succeedBlock
         OnError:(FailureBlock)zgrError;
/**
 我要发工资-删除工人
 */
-(void)deleteWorker:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError;

/**
 工人向雇主申请付款
 */
-(void)applyPayment:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError;

/**
 取消 添加收藏工人
 */
-(void)colletedWorker:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;

/**
 我的发布-详情页-工人列表
 */
-(void)publishedDetailWorkerList:(NSDictionary*)paramDict
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError;


/**
 预览合同
 */
-(void)previewConract:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;

/**
 发送合同 合同列表
 */
-(void)getConractList:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;

/**
 获取 总收入 总支出
 */
-(void)getIoAmount:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError;

/**
 账户余额
 */
-(void)getAmountBalance:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;
/**
 拒绝雇佣
 */
-(void)refuseApply:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError;

/**
 忘记密码
 */
-(void)forgetPassWords:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError;


/**
 解除合同
 */
-(void)cancelContract:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;


/**
 找工人-搜索
 */
-(void)searchWorkers:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError;

/**
 找活干-搜索
 */
-(void)searchJobs:(NSDictionary*)paramDict
        onSucceed:(SuccessedBlock)succeedBlock
          OnError:(FailureBlock)zgrError;


/**
 获取工种
 */
-(void)getJobsType:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError;

/**
 邀请好友
 */
-(void)addFriend:(NSDictionary*)paramDict
       onSucceed:(SuccessedBlock)succeedBlock
         OnError:(FailureBlock)zgrError;


/**
 推荐好友列表
 */
-(void)friendList:(NSDictionary*)paramDict
        onSucceed:(SuccessedBlock)succeedBlock
          OnError:(FailureBlock)zgrError;

/**
 获取工种List
 */
-(void)getWorkerType:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError;


/**
 会员规则
 */
-(void)getVipPrice:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError;


/**
 会员支付
 */
-(void)vipPay:(NSDictionary*)paramDict
    onSucceed:(SuccessedBlock)succeedBlock
      OnError:(FailureBlock)zgrError;

/**
 附近工人列表
 */
-(void)getNearbyWorkerList:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError;


/**
 推荐工人列表
 */
-(void)getRecommendWorkerList:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError;


/**
 作品列表
 */
-(void)getMyProductionList:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError;

/**
 上传作品-jiu
 */
-(void)uploadMyProduction:(NSDictionary*)paramDict
                  imgData:(NSArray*)imgArray
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError;
/**
 上传作品 - new
 */
-(void)uploadMyProductionNew:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError;

/**
 删除作品
 */
-(void)deleteMyProduction:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError;


/**
 意见反馈
 */
-(void)feedbackIdea:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError;

/**
 工人详情
 */
-(void)workerDetail:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError;


/**
 工人同意合同-废弃
 */
-(void)workerAgree:(NSDictionary*)paramDict
           imgData:(NSData*)imgData
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError;

/**
 工人同意合同-新
 */
-(void)workerAgreeNew:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;

/**
 发送合同-废弃
 */
-(void)sendContract:(NSDictionary*)paramDict
            imgData:(NSData*)imgData
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError;

/**
 发送合同-新接口
 */
-(void)sendContractNew:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError;



/**
 施工记录列表
 */
-(void)constuctionRecordsList:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError;


/**
 施工记录详情列表
 */
-(void)constuctionRecordsDetailList:(NSDictionary*)paramDict
                          onSucceed:(SuccessedBlock)succeedBlock
                            OnError:(FailureBlock)zgrError;


/**
 上传施工进度-旧
 */
-(void)uploadConstructionRecords:(NSDictionary*)paramDict
                         imgData:(NSArray*)imgArray
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError;

/**
 上传施工进度-新
 */
-(void)uploadConstructionRecordsNew:(NSDictionary*)paramDict
                          onSucceed:(SuccessedBlock)succeedBlock
                            OnError:(FailureBlock)zgrError;
/**
 施工评论
 */
-(void)constuctionCommentList:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError;

/**
 发表施工评论
 */
-(void)sendComment:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError;

/**
 雇主验收
 */
-(void)acceptProduction:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;

/**
 工人申请验收
 */
-(void)applyAcceptProduction:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError;

/**
 工人申请放款
 */
-(void)applyAmount:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError;


/**
 判断工人是否申请验收
 */
-(void)getApplyStatus:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;



/**
 获取合同类型
 */
-(void)getConstractType:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;


/**
 获取合同规范描述
 */
-(void)getConstractDescription:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError;

/**
 修改合同 - 获取合同信息
 */
-(void)getModifyConstractDetail:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError;

/**
 修改合同
 */
-(void)getModifyConstract:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError;

/**
 创建公司
 */
-(void)createCompany:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError;

/**
 判断是否为公司人员 和 管理员
 */
-(void)isInCompany:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError;

/**
 查看公司部门列表
 */
-(void)getDepartmentData:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;


/**
 查看公司部门人员
 */
-(void)getDepartmentPersonnerlData:(NSDictionary*)paramDict
                         onSucceed:(SuccessedBlock)succeedBlock
                           OnError:(FailureBlock)zgrError;


/**
 创建部门
 */
-(void)creatDepartment:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError;

/**
 添加同事
 */
-(void)addColleague:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError;


/**
 审批权限列表
 */
-(void)getApprovalList:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError;



/**
 设置审批权限
 */
-(void)setApprovalList:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError;

/**
 查看公司合同类型
 */
-(void)getCompanyContractTypeList:(NSDictionary*)paramDict
                        onSucceed:(SuccessedBlock)succeedBlock
                          OnError:(FailureBlock)zgrError;

/**
 添加公司合同-废弃
 */
-(void)addCompanyContract:(NSDictionary*)paramDict
                imageData:(NSData*)imgData
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError;

/**
 添加公司合同-新接口
 */
-(void)addCompanyContractNew:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError;


/**
 获取公司合同列表
 */
-(void)getCompanyContractList:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError;

/**
 公司合同-乙方审核合同 1通过, 2 退回修改，3拒绝
 */
-(void)yiFangCheckContract:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError;


/**
 公司合同-乙方同意合同-废弃
 */
-(void)yiFangAgreeContract:(NSDictionary*)paramDict
                 imageData:(NSData*)imgData
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError;

/**
 公司合同-乙方同意合同-NEW
 */
-(void)yiFangAgreeContractNew:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError;

/**
 创建合同评审表
 */
-(void)createContractReview:(NSDictionary*)paramDict
                  onSucceed:(SuccessedBlock)succeedBlock
                    OnError:(FailureBlock)zgrError;


/**
 办公- 处理审批-列表
 */
-(void)getContractReviewList:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError;

/**
 办公- 处理审批-列表详情
 */
-(void)getContractReviewDetail:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError;

/**
 办公- 审批表单-处理审批
 */
-(void)dealWithReview:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;

/**
 办公- 审批表单- 详情-查看处理结果
 */
-(void)getReviewResult:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError;

/**
 修改合同-获取公司合同详情
 */
-(void)getCompanyContractDetail:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError;


/**
 修改公司合同
 */
-(void)updateCompanyContract:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError;


/**
 上传附件 - 旧版
 */
-(void)updateReviewAnnex:(NSDictionary*)paramDict
                   image:(NSArray*)imgArray
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;

/**
 上传附件 - 新版
 */
-(void)updateReviewAnnexNew:(NSDictionary*)paramDict
                  onSucceed:(SuccessedBlock)succeedBlock
                    OnError:(FailureBlock)zgrError;

/**
 合同评审表 - 查看附件
 */
-(void)getReviewAnnexDetail:(NSDictionary*)paramDict
                  onSucceed:(SuccessedBlock)succeedBlock
                    OnError:(FailureBlock)zgrError;


/**
 个人合同列表
 */
-(void)getPersonalContractList:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError;

/**
 添加请款单
 */
-(void)addPaymentForm:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;

/**
 添加请购单
 */
-(void)addPurchaseForm:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError;

/**
 添加印章申请单
 */
-(void)addStampForm:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError;

/**
 公司注册
 */
-(void)registerCompany:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError;

/**
 添加管理员
 */
-(void)addManager:(NSDictionary*)paramDict
        onSucceed:(SuccessedBlock)succeedBlock
          OnError:(FailureBlock)zgrError;

/**
 删除管理员
 */
-(void)deleteManager:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError;


/**
 退出公司
 */
-(void)quiteCompany:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError;


/**
 管理员删除员工
 */
-(void)deletePersonel:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;


/**
 特权审批
 */
-(void)sepecalApproval:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError;

/**
 添加呈批件
 */
-(void)addApprovalFile:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError;


/**
 特权- 设置特权
 */
-(void)setSpecailApproval:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError;


/**
 搜索审批
 */
-(void)searchApproval:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;

/**
 公司人员-更改部门信息
 */
-(void)updateDepartment:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;


/**
 审批下载-获取token
 */
-(void)getLoadToken:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError;

/**
 清空消息
 */
-(void)clearNotice:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError;


/**
 图片上传七牛-获取token
 */
-(void)getQiNiuToken:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError;


/**
 图片上传七牛-获取token
 */
-(void)getQiNiuTokenWithSync:(NSString*)paramString
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError;

/**
 撤回审批
 */
-(void)cancelApproval:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;


/**
 获取公司列表
 */
-(void)getCompanyList:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;

/**
 获取公司权限信息
 */
-(void)getMangerRightInfoOfCompany:(NSDictionary*)paramDict
                         onSucceed:(SuccessedBlock)succeedBlock
                           OnError:(FailureBlock)zgrError;


/**
 删除用户-判断用户是否还有审批
 */
-(void)isHaveApproval:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;

/**
 申请加入公司-公司列表
 */
-(void)getAllCompanyList:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;

/**
 申请加入公司
 */
-(void)applyJoinCompany:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;

/**
 申请加入公司- 申请列表
 */
-(void)listOfapplyJoinCompany:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError;

/**
 申请加入公司- 处理申请加入公司
 */
-(void)approvalApplyJoinCompany:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError;


/**
 审批列表- 添加颜色标记
 */
-(void)addColorSign:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError;

/**
 创建公装合同评审表（新）
 */
-(void)creatCompanyReview:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError;


/**
 搜索公司
 */
-(void)searchCompany:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError;


/**
 创建公司-添加人员
 */
-(void)addPersonToCompany:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError;



/**
 创建公司-预设部门
 */
-(void)presetDepartmentOfCompany:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError;


/**
 创建公司-自定义部门
 */
-(void)customDepartmentOfCompany:(NSDictionary*)paramDict
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError;

/**
 创建公司-自定义职位
 */
-(void)customPosition:(NSDictionary*)paramDict
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError;

/**
 创建公司-完整接口
 */
-(void)lastAddPersonToCompany:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;

/**
 设置审批-获取表单审批人员
 */
-(void)getFormApprovalPerson:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError;

/**
 添加工程
 */
-(void)addProjectOfCompany:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError;
/**
 获取工程列表
 */
-(void)getProjectList:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError;

/**
 工种类型
 */
-(void)getWorkerTypeList:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;

/**
 工种- 自定义工种
 */
-(void)customWorkerType:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;

/**
 创建请款单-获取上次请款记录
 */
-(void)getLastApplyPaymentsList:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;

/**
 公司合同 - 保存草稿箱
 */
-(void)saveContractToDrafts:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError;

/**
 公司合同 - 草稿箱列表
 */
-(void)getContractDraftsList:(NSDictionary*)paramDict
                  onSucceed:(SuccessedBlock)succeedBlock
                    OnError:(FailureBlock)zgrError;


/**
 查看文档
 */
-(void)lookFilesDetail:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError;


/**
获取请款依据列表
 */
-(void)getPaymentBasisList:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError;


/**
附近工人列表
 */
-(void)getAllWorkerList:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError;


/**
设置财务回执人员
 */
-(void)setCashier:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;

/**
删除财务回执人员
 */
-(void)deleteCashier:(NSDictionary*)paramDict
        onSucceed:(SuccessedBlock)succeedBlock
          OnError:(FailureBlock)zgrError;

/**
 财务回执列表
 */
-(void)cashierReplyList:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError;

/**
 财务回执c操作
 */
-(void)cashierReply:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;


/**
 添加单文件
 */
-(void)addFiles:(NSDictionary*)paramDict
          onSucceed:(SuccessedBlock)succeedBlock
            OnError:(FailureBlock)zgrError;


/**
 表单回执 - 设置回执人员
 */
-(void)setReceiptPerson:(NSDictionary*)paramDict
      onSucceed:(SuccessedBlock)succeedBlock
        OnError:(FailureBlock)zgrError;

/**
 表单回执 - 回执人员列表展示
 */
-(void)receiptPersonList:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;

/**
 表单回执 - 回执人员 处理列表
 */
-(void)getReceiptDisposeList:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;

/**
 处理审批-我发起的— 删除已撤销
 */
-(void)deleteMyApproval:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError;


/**
 工作记录-发表日志、周志、月志
 */
-(void)publishOnePlan:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;


/**
 工作记录-日志列表
 */
-(void)getPlanList:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;

/**
 工作记录- 日志详情
 */
-(void)getPlanDetail:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError;


/**
 工作记录- 获取日志评论列表
 */
-(void)getDiaryCommentsList:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError;


/**
 工作记录- 获取点赞列表
 */
-(void)getDiaryGoodsList:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError;

/**
 工作记录- 日志点赞
 */
-(void)clickDiaryGoodsButton:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;


/**
 工作记录- 日志评论
 */
-(void)clickDiaryCommentsButton:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError;

/**
 工作记录- 点评人评分
 */
-(void)clickDiaryReviewsButton:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError;

/**
 工作记录- 外勤签到
 */
-(void)workOutSignIn:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError;

/**
 工作记录- 删除日志
 */
-(void)deleteDiary:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError;

/**
 工作记录- 查看个人日志记录
 */
-(void)lookPersonDiaryList:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError;

/**
 工作记录- 日志统计
 */
-(void)personWorkerPlanCount:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError;

/**
 工作记录- 查看个人某条日志记录
 */
-(void)lookPersonDiaryOfOneDay:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError;


/**
 表单回执-做标记
 */
-(void)cashierListSign:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError;

/**
 日志提醒-获取各类型提醒最新数据
 */
-(void)getNewRemindData:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError;


/**
 日志提醒-回复我的
 */
-(void)getMyReply:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;


/**
 日志提醒-我收到的赞
 */
-(void)getMyGood:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;

/**
 日志提醒-点评列表
 */
-(void)needReviewList:(NSDictionary*)paramDict
       onSucceed:(SuccessedBlock)succeedBlock
         OnError:(FailureBlock)zgrError;

/**
 日志 - 日志类型
 */
-(void)getDiarySubTypeList:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;

/**
 日志 - 获取日志规范
 */
-(void)getDiaryRegulation:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError;

/**
 日志 - 获取日志抄送范围
 */
-(void)getDiarySendRange:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError;

/**
 添加报销单
 */
-(void)publishExpenseAccountForm:(NSDictionary*)paramDict
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError;

/**
 创建子公司
 */
-(void)creatSubCompany:(NSDictionary*)paramDict
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError;

/**
我要发工资-发工资（新）
 */
-(void)toPayAndRecord:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError;


/**
 我要发工资-账本查询
 */
-(void)searchPayRecords:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;

/**
 我发出的合同列表 -未开始一开始
 */
-(void)sendContractList:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;


/**
 合同 -  付定金
 */
-(void)toPayDownPayment:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;


/**
 验收-申请记录
 */
-(void)applyForAcceptanceList:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError;


/**
 验收-查看验收详情
 */
-(void)getAcceptanceDetail:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError;


/**
 验收-处理验收
 */
-(void)dealWithAcceptance:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError;

/**
 验收-处理申请完工
 */
-(void)dealWithEndContract:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError;

/**
 验收-添加验收单
 */
-(void)addAccpectForm:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;

/**
 验收-添加结算单
 */
-(void)addSettlementForm:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;

/**
 验收-最后提交
 */
-(void)submitBigAcceptForm:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError;

/**
 验收- 修改验收大接口
 */
-(void)modifyApplyAccept:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;


/**
 验收- 申请完工
 */
-(void)applyEndContract:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;

/**
 工程-结束报名
 */
-(void)endApplyProject:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError;


/**
 获取用户信息 参数Uid
 */
-(void)getUserInfo:(NSDictionary*)paramDict
             onSucceed:(SuccessedBlock)succeedBlock
               OnError:(FailureBlock)zgrError;


/**
 验收-获取报验单类型列表
 */
-(void)getSingleInspectionList:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError;

/**
 验收-获取结算单类型列表
 */
-(void)getStatementsList:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;


/**
 回复审批操作
 */
-(void)replyApprovalForm:(NSDictionary*)paramDict
         onSucceed:(SuccessedBlock)succeedBlock
           OnError:(FailureBlock)zgrError;

/**
 回复审批消息列表
 */
-(void)getReplyApprovalMessageList:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;


/**
发起个人审批-请购单
 */
-(void)sendPersonalPurchaseForm:(NSDictionary*)paramDict
                         onSucceed:(SuccessedBlock)succeedBlock
                           OnError:(FailureBlock)zgrError;


/**
 发起个人审批-请款单
 */
-(void)sendPersonalPaymentsForm:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError;


/**
 发起个人审批-呈批件
 */
-(void)sendPersonalFileForm:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError;

/**
 发起个人审批-报销单
 */
-(void)sendPersonalExpenseForm:(NSDictionary*)paramDict
                  onSucceed:(SuccessedBlock)succeedBlock
                    OnError:(FailureBlock)zgrError;



/**
 个人审批-审批详情
 */
-(void)getPersonalApprovalDetail:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError;


/**
 个人审批-审批列表
 */
-(void)getPersonalApprovalList:(NSDictionary*)paramDict
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError;

/**
 个人审批-删除
 */
-(void)deletePersonalApproval:(NSDictionary*)paramDict
                     onSucceed:(SuccessedBlock)succeedBlock
                       OnError:(FailureBlock)zgrError;

/**
 个人审批-搜索
 */
-(void)searchPersonalApproval:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError;

/**
 个人审批-处理
 */
-(void)dealWithPersonalApproval:(NSDictionary*)paramDict
                    onSucceed:(SuccessedBlock)succeedBlock
                      OnError:(FailureBlock)zgrError;

/**
 合同模块-申请付款记录
 */
-(void)getApplyPayHistory:(NSDictionary*)paramDict
                      onSucceed:(SuccessedBlock)succeedBlock
                        OnError:(FailureBlock)zgrError;

/**
 合同模块-甲方拒绝付款
 */
-(void)rejectApplyPay:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError;


/**
 融云即时通讯-获取我的群组
 */
-(void)getMyGroupsWithDictionary:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError;


/**
 融云即时通讯-创建群组
 */
-(void)createGroupWithInfo:(NSDictionary*)paramDict
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError;

/**
 融云即时通讯-获取群组成员
 */
-(void)getGroupMemberByID:(NSDictionary*)paramDict
                 onSucceed:(SuccessedBlock)succeedBlock
                   OnError:(FailureBlock)zgrError;

/**
 融云即时通讯-获取单个群组 信息
 */
-(void)getGroupInfoByID:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError;


/**
 融云即时通讯-修改群组 信息
 */
-(void)editGroupInfoByID:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;

/**
 融云即时通讯-解散群
 */
-(void)dissolveGroup:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;

/**
 融云即时通讯-退出群
 */
-(void)quiteGroup:(NSDictionary*)paramDict
           onSucceed:(SuccessedBlock)succeedBlock
             OnError:(FailureBlock)zgrError;

/**
 融云即时通讯-单独添加人员
 */
-(void)addGroupMember:(NSDictionary*)paramDict
        onSucceed:(SuccessedBlock)succeedBlock
          OnError:(FailureBlock)zgrError;

/**
 融云即时通讯-群主删除人员
 */
-(void)deleteGroupMember:(NSDictionary*)paramDict
            onSucceed:(SuccessedBlock)succeedBlock
              OnError:(FailureBlock)zgrError;


/**
 附近公司-所有大公司
 */
-(void)getAllCorporation:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;

/**
 附近公司-工人所在大公司
 */
-(void)getAllCorporationByUserID:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                 OnError:(FailureBlock)zgrError;


/**
 工人-判断是否已付款 （付款后可查看工人详情）
 */
-(void)isPayForTheWorker:(NSDictionary*)paramDict
                       onSucceed:(SuccessedBlock)succeedBlock
                         OnError:(FailureBlock)zgrError;


/**
 工人-付款 （付款后可查看工人详情）
 */
-(void)toPayForTheWorkerFromCount:(NSDictionary*)paramDict
               onSucceed:(SuccessedBlock)succeedBlock
                          OnError:(FailureBlock)zgrError;


/**
 附近工程-个人工程
 */
-(void)nearbyPersonalProject:(NSDictionary*)paramDict
                        onSucceed:(SuccessedBlock)succeedBlock
                          OnError:(FailureBlock)zgrError;


/**
 支付宝充值
 */
-(void)rechargeWithAlipay:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError;


/**
 呈批件协议
 */
-(void)uploadPorotocolOfFile:(NSDictionary*)paramDict
                onSucceed:(SuccessedBlock)succeedBlock
                  OnError:(FailureBlock)zgrError;


/**
 公司审批- 验收单
 */
-(void)uploadInspection:(NSDictionary*)paramDict
                   onSucceed:(SuccessedBlock)succeedBlock
                     OnError:(FailureBlock)zgrError;

/**
 公司审批- 验收单列表
 */
-(void)getCompanyInspectionList:(NSDictionary*)paramDict
              onSucceed:(SuccessedBlock)succeedBlock
                OnError:(FailureBlock)zgrError;


@end
