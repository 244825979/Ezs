//
//  MsgTool.h
//  HXyxb
//
//  Created by 恒信永利 on 2017/5/11.
//  Copyright © 2017年 zhangzb. All rights reserved.
//  对MBProgressHUD v1.0.0版本的封装

#import <Foundation/Foundation.h>
#define kMsgTool [MsgTool shareInstance]
@interface MsgTool : NSObject<MBProgressHUDDelegate>
/**
 单例
 */
+ (instancetype)shareInstance;

/**
 显示成功
 */
+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success imageName:(NSString *)imageName;

/**
 显示失败
 */
+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error imageName:(NSString *)imageName;
/**
 显示提示
 */
+ (void)showTips:(NSString *)tips;

/**
 显示加载中消息
 */
+ (void)showMsgWithLoading:(NSString *)message;
+ (void)showNoClickMessage:(NSString *)message;

/**
 仅仅显示消息
 */
+ (void)showMsg:(NSString *)msg;

/**
 隐藏加载中
 */
+ (void)hideMsg;

@end
