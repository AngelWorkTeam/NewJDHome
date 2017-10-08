//
//  NetworkingManager+YYNetRequest.h
//  NJDHome
//
//  Created by 袁云龙 on 17/10/6.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "NetworkingManager.h"
@interface NetworkingManager (YYNetRequest)


/**
 *协管人员获取任务数据
 */

+(void)getTrafficsDataWithUserId:(NSString *_Nullable)userId
                            page:(NSInteger)page
                     isNewRecord:(BOOL)isNew
                         success:(NJDHttpSuccessBlockDictionary _Nullable)success
                         failure:(NJDHttpFailureBlock _Nullable)fail;
/**
 *协管人员受理
 */
+(void)trafficAcceptTheRecordWithRecordId:(NSString *_Nullable)recordId
                                  success:(NJDHttpSuccessBlockDictionary _Nullable)success
                                  failure:(NJDHttpFailureBlock _Nullable)fail;

// 协管员—申报登记（注销登记，变更登记）
+(void)trafficRegisterRecordTheRecordWithRecordId:(NSString *_Nullable)recordId
                                   personTypeName:(NSString *_Nullable)personTypeName
                                          success:(NJDHttpSuccessBlockDictionary _Nullable)success
                                          failure:(NJDHttpFailureBlock _Nullable)fail;

/**
 *协管人员 转交
 */
+(void)trafficCareOfRecordTheRecordWithRecordId:(NSString *_Nullable)recordId
                                   changeUserId:(NSString *_Nullable)changeUserId
                                        success:(NJDHttpSuccessBlockDictionary _Nullable)success
                                        failure:(NJDHttpFailureBlock _Nullable)fail;

/**
 *协管人员 退回
 */
+(void)trafficSendBackRecordTheRecordWithRecordId:(NSString *_Nullable)recordId
                                   sendBckContext:(NSString *_Nullable)sendBckContext
                                          success:(NJDHttpSuccessBlockDictionary _Nullable)success
                                          failure:(NJDHttpFailureBlock _Nullable)fail;


/**
*窗口人员 获取列表数据
*/
+(void)getWindowsClerkDataWithUserId:(NSString *_Nullable)userId
                                page:(NSInteger)page
                         isNewRecord:(BOOL)isNew
                             success:(NJDHttpSuccessBlockDictionary _Nullable)success
                             failure:(NJDHttpFailureBlock _Nullable)fail;
/**
 *窗口人员 受理 退回
 */
+(void)windowAcceptAndRejectWithRecordId:(NSString *_Nullable)recordId
                                   state:(NSString *_Nullable)state
                                  reason:(NSString *_Nullable)reason
                                 success:(NJDHttpSuccessBlockDictionary _Nullable)success
                                 failure:(NJDHttpFailureBlock _Nullable)fail;


// ic card
+(void)renderGetShenbaoRecordListByPage:(NSInteger)page
                                success:(NJDHttpSuccessBlockDictionary _Nullable)success
                                failure:(NJDHttpFailureBlock _Nullable)fail;


// 申请记录
+(void)renderGetICCardRecordListByPage:(NSInteger)page
                               success:(NJDHttpSuccessBlockDictionary _Nullable)success
                               failure:(NJDHttpFailureBlock _Nullable)fail;
@end
