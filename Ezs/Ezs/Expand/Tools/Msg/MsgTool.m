//
//  MsgTool.m
//  HXyxb
//
//  Created by 恒信永利 on 2017/5/11.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "MsgTool.h"
static MBProgressHUD *_hud;

@interface MsgTool()

@property (nonatomic, strong) MBProgressHUD *showMessage;

@end
@implementation MsgTool

+ (void)load {
//    UIActivityIndicatorView *indicatorView = [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil];
    UIActivityIndicatorView *indicatorView=[UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]];
//    // 设置指示器颜色
    indicatorView.color = [UIColor whiteColor];

    
}

+ (instancetype)shareInstance {
    static MsgTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [MsgTool new];
    });
    return tool;
}

#pragma mark - Public Method

+ (void)showSuccess:(NSString *)success {
    [kMsgTool showMessage:success toView:nil isSuccess:YES];
}

+ (void)showSuccess:(NSString *)success imageName:(NSString *)imageName {
    [kMsgTool showMessage:success toView:nil imageName:imageName];
}


+ (void)showError:(NSString *)error {
    [kMsgTool showMessage:error toView:nil isSuccess:NO];
}


+ (void)showError:(NSString *)error imageName:(NSString *)imageName {
    [kMsgTool showMessage:error toView:nil imageName:imageName];
}



+ (void)showTips:(NSString *)tips {
    NSString *imageName = [NSString stringWithFormat:@"%@", @"info_white.png"];
    [kMsgTool showMessage:tips toView:nil imageName:imageName];
}

+ (void)showTips:(NSString *)tips toView:(UIView *)toView {
    NSString *imageName = [NSString stringWithFormat:@"%@", @"info_white.png"];
    [kMsgTool showMessage:tips toView:toView imageName:imageName];
}

+ (void)showMsgWithLoading:(NSString *)message {
    _hud = [self showLoadMessage:message toView:nil];
}


+ (MBProgressHUD *)showLoadMessage:(NSString *)message toView:(UIView *)toView {
    [kMsgTool showLoadMessage:message toView:toView canClick:YES];
    
    return kMsgTool.showMessage;
}

+ (void)showNoClickMessage:(NSString *)message {
    _hud = [self showNoClickLoadMessage:message toView:nil];
}

+ (MBProgressHUD *)showNoClickLoadMessage:(NSString *)message toView:(UIView *)toView {
    [kMsgTool showLoadMessage:message toView:toView canClick:NO];
    
    return kMsgTool.showMessage;
}

+ (void)hideMsg {
    [_hud hideAnimated:YES];
}

+ (void)showMsg:(NSString *)msg{
   [kMsgTool showSingleMessage:msg toView:nil];
}

#pragma mark - Private Method

/**
 获取当前最顶层的window
 */
- (UIWindow *)getTopLevelWindow {
//    UIWindow *window = nil;
//    for (UIWindow *_window in [UIApplication sharedApplication].windows) {
//        if (window == nil) {
//            window = _window;
//        }
//        if (_window.windowLevel > window.windowLevel) {
//            window = _window;
//        }
//    }
    return [UIApplication sharedApplication].keyWindow;
}

- (void)hideMessage {
    [self.showMessage hideAnimated:YES afterDelay:2.0];
}

- (void)showMessage:(NSString *)message toView:(UIView *)toView isSuccess:(BOOL)success {
    NSString *imageName = [NSString stringWithFormat:@"%@",success ? @"success_white.png" : @"error_white.png"];
    
    [self showMessage:message toView:toView imageName:imageName];
}

- (void)showMessage:(NSString *)message toView:(UIView *)toView imageName:(NSString *)imageName {
    if (self.showMessage) [self.showMessage removeFromSuperview];
    
    if (!toView) toView = [self getTopLevelWindow];
    
    // 创建指示器
    self.showMessage = [MBProgressHUD showHUDAddedTo:toView animated:YES];
    // 设置为自定义模式
    self.showMessage.mode = MBProgressHUDModeCustomView;
    // 隐藏时从父控件中移除
    self.showMessage.removeFromSuperViewOnHide = YES;
    // 设置将要显示的图片
    UIImage *image = [UIImage imageNamed:imageName];
    // 设置自定义视图
    self.showMessage.customView = [[UIImageView alloc] initWithImage:image];
    // 设置bezelView背景色
    self.showMessage.bezelView.color = [UIColor blackColor];
    self.showMessage.bezelView.layer.cornerRadius = 10.0;
    
    // 设置显示的文字内容
    self.showMessage.label.text = message;
    self.showMessage.label.font = [UIFont systemFontOfSize:14.0];
    self.showMessage.label.textColor = [UIColor whiteColor];
    
    [self performSelectorOnMainThread:@selector(hideMessage) withObject:nil waitUntilDone:YES];
}

- (void)showLoadMessage:(NSString *)message toView:(UIView *)toView canClick:(BOOL)canClick {
    if (self.showMessage) [self.showMessage removeFromSuperview];
    if (!toView) toView = [self getTopLevelWindow];
    
    // 创建hud
    self.showMessage = [MBProgressHUD showHUDAddedTo:toView animated:YES];
    self.showMessage.userInteractionEnabled = canClick;
    // 设置背景颜色和圆角
    self.showMessage.bezelView.color = [UIColor blackColor];
    self.showMessage.bezelView.layer.cornerRadius = 10.0;
    // 设置文字内容和颜色
    self.showMessage.label.text = message;
    self.showMessage.label.textColor = [UIColor whiteColor];
}


- (void)showSingleMessage:(NSString *)message toView:(UIView *)toView {
    if (self.showMessage) [self.showMessage removeFromSuperview];
     if (!toView) toView = [self getTopLevelWindow];
     self.showMessage = [MBProgressHUD showHUDAddedTo:toView animated:YES];
     //不可交互
     self.showMessage.userInteractionEnabled =NO;
     //只显示文字
     self.showMessage.mode=MBProgressHUDModeText;
     // 设置背景颜色和圆角
     self.showMessage.bezelView.color = [UIColor blackColor];
     self.showMessage.bezelView.layer.cornerRadius = 10.0;
     // 设置文字内容和颜色
     self.showMessage.label.text = message;
     self.showMessage.label.textColor = [UIColor whiteColor];
    
    [self performSelectorOnMainThread:@selector(hideMessage) withObject:nil waitUntilDone:YES];

}



@end
