//
//  HttpHander.h
//  HXyxb
//
//  Created by zhangzb on 2017/5/11.
//  Copyright © 2017年 恒信永利. All rights reserved.
//  对AFNetWorking 3.1.0 的封装 里面有引入msgTool工具，是对MBProgressHUD v1.0.0版本的封装

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#pragma mark  基础定义
//网络状态
typedef enum{
  StatusUnknown          = -1, //未知网络
  StatusNotReachable     =  0, //没有网络
  StatusReachableViaWWAN =  1, //手机自带网络
  StatusReachableViaWIFI =  2  //WIFI
}NetworkStatus;

//成功返回
typedef void(^ZBResponseSuccess)(id response);
//失败返回
typedef void(^ZBResponseFail)(NSError *error);
//上传进度
typedef void( ^ ZBUploadProgress)(int64_t bytesProgress,
int64_t totalBytesProgress);
//下载进度
typedef void( ^ ZBDownloadProgress)(int64_t bytesProgress,
int64_t totalBytesProgress);

/**
 *  方便管理请求任务。执行取消，暂停，继续等任务.
 *  - (void)cancel，取消任务
 *  - (void)suspend，暂停任务
 *  - (void)resume，继续任务
 */
typedef NSURLSessionTask ZBURLSessionTask;

@interface HttpHander : NSObject

/**
 *  HttpHander单例
 *
 *  return
 */
+ (HttpHander *)sharedZBNetworking;

/**
 *  获取网络状态
 */
@property (nonatomic,assign)NetworkStatus networkStats;

/**
 *  开启网络监测
 */
+ (void)startMonitoring;

/**
 *  get请求方法,block回调
 *
 *  @param url     请求连接，根路径
 *  @param params  参数
 *  @param success 请求成功返回数据
 *  @param fail    请求失败
 *  @param showHUD 是否显示HUD
 */
+(ZBURLSessionTask *)getWithUrl:(NSString *)url
                         params:(NSDictionary *)params
                        success:(ZBResponseSuccess)success
                           fail:(ZBResponseFail)fail
                        showHUD:(BOOL)showHUD;

/**
 *  post请求方法,block回调
 *
 *  @param url     请求连接，根路径
 *  @param params  参数
 *  @param success 请求成功返回数据
 *  @param fail    请求失败
 *  @param showHUD 是否显示HUD
 */
+(ZBURLSessionTask *)postWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                         success:(ZBResponseSuccess)success
                            fail:(ZBResponseFail)fail
                         showHUD:(BOOL)showHUD;



/**
 上传图片(多图)
 
 @param urlString 上传的url
 @param parameters 上传图片预留参数---视具体情况而定 可移除
 @param imageArray 上传的图片数组
 @param fileName 上传的图片数组fileName
 @param successBlock 上传成功的回调
 @param failureBlock 上传失败的回调
 @param progress 上传进度
 @return BAURLSessionTask
 */
+ (ZBURLSessionTask *)ba_uploadImageWithUrlString:(NSString *)urlString
                                       parameters:(NSDictionary *)parameters
                                       imageArray:(NSArray *)imageArray
                                         fileName:(NSString *)fileName
                                     successBlock:(ZBResponseSuccess)successBlock
                                      failurBlock:(ZBResponseFail)failureBlock
                                   upLoadProgress:(ZBUploadProgress)progress;


#pragma mark - 取消 Http 请求
/*!
 *  取消所有 Http 请求
 */
+ (void)ba_cancelAllRequest;

@end
