//
//  HttpHander.m
//  HXyxb
//
//  Created by zhangzb on 2017/5/11.
//  Copyright © 2017年 恒信永利. All rights reserved.
//

//开发的时候改一下输出日志


#import "HttpHander.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>

/*! 系统相册 */
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

//任务数组
static NSMutableArray *tasks;
static AFHTTPSessionManager *manager;
@implementation HttpHander

//单例
+(HttpHander *) sharedZBNetworking{
    static HttpHander *handler =nil;
    static dispatch_once_t onceToken;
    //实例化一次
    dispatch_once(&onceToken, ^{
        NSLog(@"创建HttpHander");
        handler =[[HttpHander alloc]init];
    });
    return handler;
}

//任务数组
+(NSMutableArray *)tasks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"创建网络任务数组");
        tasks = [[NSMutableArray alloc] init];
    });
    return tasks;
}
/**
 *  网络请求封装，用的是AFNetWorking 3.1.0
 *  (NSUInteger)type， type=1 get请求 type=2 post请求
 */
+(ZBURLSessionTask *)baseRequestWithType:(NSUInteger)type
                                     url:(NSString *)url
                                  params:(NSDictionary *)params
                                 success:(ZBResponseSuccess)success
                                    fail:(ZBResponseFail)fail
                                 showHUD:(BOOL)showHUD{
    NSLog(@"请求地址----%@\n    请求参数----%@",url,params);
    //检查url参数
    if (kStringIsEmpty(url)) {
        return nil;
    }
    //显示loading
    if (showHUD) {
        [MsgTool showMsgWithLoading:@"加载中..."];
    }
    //检查地址中是否有中文
    AFHTTPSessionManager *manager=[self sharedHTTPSession];
    //manager stary
    ZBURLSessionTask *sessionTask=nil;
    //再次设置请求头
    [self sharedHTTPSession].requestSerializer = [AFJSONRequestSerializer serializer];
    NSLog(@"******************** 请求参数 ***************************");
    NSLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",[self sharedHTTPSession].requestSerializer.HTTPRequestHeaders, @(type),url, params);
    NSLog(@"******************************************************");
    if (type==1) {//get
        sessionTask = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求结果=%@",responseObject);
            if (success) {
                success(responseObject);
            }
            
            [[self tasks] removeObject:sessionTask];
            
            if (showHUD==YES) {
                [MsgTool hideMsg];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error=%@",error);
            if (fail) {
                fail(error);
            }
            
            [[self tasks] removeObject:sessionTask];
            if (showHUD==YES) {
                [MsgTool hideMsg];
            }
            if ([[error valueForKey:@"code"] intValue]==-1001) {
                [MsgTool showTips:NETERR];
            }else{
                [MsgTool showTips:NETFAIL];
            }
            
        }];

        
    }else{//post
        sessionTask = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求成功=%@",responseObject);
            if (success) {
                success(responseObject);
            }
            
            [[self tasks] removeObject:sessionTask];
            
            if (showHUD==YES) {
                [MsgTool hideMsg];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error=%@",error);
            if (fail) {
                fail(error);
            }
            
            [[self tasks] removeObject:sessionTask];
            
            if (showHUD==YES) {
                [MsgTool hideMsg];
            }
            if ([[error valueForKey:@"code"] intValue]==-1001) {
                [MsgTool showTips:NETERR];
            }else{
                [MsgTool showTips:NETFAIL];
            }
            
        }];
    
    
    }
    //添加任务
    if (sessionTask) {
        [[self tasks] addObject:sessionTask];
    }
    
    return sessionTask;


}

#pragma mark - 多图上传
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
                                   upLoadProgress:(ZBUploadProgress)progress
{
    if (urlString == nil)
    {
        NSLog(@"url参数不能为空");
        return nil;
    }
    
    kWeakSelf(self);
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:urlString] ? urlString : [self strUTF8Encoding:urlString];
    ZBURLSessionTask *sessionTask = nil;
    //特殊要求，上传图片的时候传递一个案件的ID
    [[self sharedHTTPSession].requestSerializer setValue:[NSString stringWithFormat:@"%@",[parameters valueForKey:@"FK_ID"]] forHTTPHeaderField:@"FK_ID"];
    NSString *boundary = @"wfWiEWrgEFA9A78512weF7106A";
    [[self sharedHTTPSession].requestSerializer setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"******************** 请求参数 ***************************");
    NSLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",[self sharedHTTPSession].requestSerializer.HTTPRequestHeaders, @"POST",URLString, parameters);
    NSLog(@"******************************************************");
    
    sessionTask = [[self sharedHTTPSession] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /*! 出于性能考虑,将上传图片进行压缩 */
        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            /*! image的压缩方法 */
            UIImage *resizedImage;
            /*! 此处是使用原生系统相册 */
            if([obj isKindOfClass:[ALAsset class]])
            {
                // 用ALAsset获取Asset URL  转化为image
                ALAssetRepresentation *assetRep = [obj defaultRepresentation];
                
                CGImageRef imgRef = [assetRep fullResolutionImage];
                resizedImage = [UIImage imageWithCGImage:imgRef
                                                   scale:1.0
                                             orientation:(UIImageOrientation)assetRep.orientation];
                //                imageWithImage
                NSLog(@"1111-----size : %@",NSStringFromCGSize(resizedImage.size));
                
               resizedImage = [weakself imageWithImage:resizedImage scaledToSize:resizedImage.size];
                NSLog(@"2222-----size : %@",NSStringFromCGSize(resizedImage.size));
            }
            else
            {
                /*! 此处是使用其他第三方相册，可以自由定制压缩方法 */
                resizedImage = obj;
            }
            
            /*! 此处压缩方法是jpeg格式是原图大小的0.8倍，要调整大小的话，就在这里调整就行了还是原图等比压缩 */
            NSData *imgData = UIImageJPEGRepresentation(resizedImage, 0.8);
            
            /*! 拼接data */
            if (imgData != nil)
            {   // 图片数据不为空才传递 fileName
                [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picflie%ld",(long)idx] fileName:@"image.png" mimeType:@" image/jpeg"];
                
                //                [formData appendPartWithFileData:imgData
                //                                            name:[NSString stringWithFormat:@"picflie%ld",(long)idx]
                //                                        fileName:fileName
                //                                        mimeType:@"image/jpeg"];
                
            }
            
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        
        if (progress)
        {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"上传图片成功 = %@",responseObject);
        if (successBlock)
        {
            successBlock(responseObject);
        }
        
        [[weakself tasks] removeObject:sessionTask];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败 = %@",error);
        if (failureBlock)
        {
            failureBlock(error);
        }
        [[weakself tasks] removeObject:sessionTask];
    }];
    
    if (sessionTask)
    {
        [[weakself tasks] addObject:sessionTask];
    }
    
    return sessionTask;
}




//调用get请求
+(ZBURLSessionTask *)getWithUrl:(NSString *)url
                         params:(NSDictionary *)params
                        success:(ZBResponseSuccess)success
                           fail:(ZBResponseFail)fail
                        showHUD:(BOOL)showHUD{
    //封装的请求函数 type=1表示get =2表示post
    return [self baseRequestWithType:1 url:url params:params success:success fail:fail showHUD:showHUD];
}

//调用post请求
+(ZBURLSessionTask *)postWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                         success:(ZBResponseSuccess)success
                            fail:(ZBResponseFail)fail
                         showHUD:(BOOL)showHUD{
    //封装的请求函数 type=1表示get =2表示post
    return [self baseRequestWithType:2 url:url params:params success:success fail:fail showHUD:showHUD];

}
//获取AFHTTPSessionManager
+(AFHTTPSessionManager *)sharedHTTPSession{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//初始化一次
        manager = [AFHTTPSessionManager manager];
           // 声明获取到的数据格式
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 15.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        /** 声明支持的Content-Types */
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml",@"image/*",@"text/plain",nil];
    });
    //在head中添加token参数
//    NSLog(@"当前登录的token :%@",TOKEN_ID);
//    [manager.requestSerializer setValue:TOKEN_ID forHTTPHeaderField:@"token"];
    return manager;
}


#pragma makr - 开始监听网络连接

+ (void)startMonitoring
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                [HttpHander sharedZBNetworking].networkStats=StatusUnknown;
                
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络");
                [HttpHander sharedZBNetworking].networkStats=StatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                [HttpHander sharedZBNetworking].networkStats=StatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                
                [HttpHander sharedZBNetworking].networkStats=StatusReachableViaWIFI;
                NSLog(@"WIFI--%d",[HttpHander sharedZBNetworking].networkStats);
                break;
        }
    }];
    [mgr startMonitoring];
}




#pragma mark - 取消 Http 请求
/*!
 *  取消所有 Http 请求
 */
+ (void)ba_cancelAllRequest
{
    // 锁操作
    @synchronized(self)
    {
        [[self tasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self tasks] removeAllObjects];
    }
}



#pragma mark - 压缩图片尺寸
/*! 对图片尺寸进行压缩 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    if (newSize.height > 375/newSize.width*newSize.height)
    {
        newSize.height = 375/newSize.width*newSize.height;
    }
    
    if (newSize.width > 375)
    {
        newSize.width = 375;
    }
    
   // UIImage *newImage = [UIImage needCenterImage:image size:newSize scale:1.0];
    
//    return newImage;
     return nil;
}

#pragma mark - url 中文格式化
+ (NSString *)strUTF8Encoding:(NSString *)str
{
    /*! ios9适配的话 打开第一个 */
//    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0)
//    {
        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
//    }
//    else
//    {
//        return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    }
}


@end
