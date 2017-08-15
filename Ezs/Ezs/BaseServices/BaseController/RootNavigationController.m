//
//  RootNavigationController.m
//  Ezs
//
//  Created by zhangzb on 2017/8/14.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController ()<UINavigationControllerDelegate>
@property (nonatomic, weak) id popDelegate;
@end

@implementation RootNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    //    //设置tabbar的主题颜色
    [self.navigationBar setBarTintColor:MAIN_COLOR];
    //    //设置导航栏的字体样式
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:TITLE_FONT,NSForegroundColorAttributeName:WHITE_COLOR}];
    self.delegate=self;
}

//统一返回样式
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        //隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        //统一返回样式
        UIButton *btn =[[UIButton alloc]init];
        btn.frame = CGRectMake(0, 0, 22, 22);
        [btn setImage:[UIImage imageNamed:@"ic_return"] forState:0];
        [btn addTarget:self action:@selector(backBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
        viewController.navigationItem.leftBarButtonItem = back;
    }
    [super pushViewController:viewController animated:animated];
    
}

//解决手势失效问题
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}


//设置状态栏样式样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

//返回方法
- (void)backBarButtonItemAction
{
    [self.navigationItem setHidesBackButton:NO];
    [self popViewControllerAnimated:YES];
}



@end
