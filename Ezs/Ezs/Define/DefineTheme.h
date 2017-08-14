//
//  DefineTheme.h
//  
//
//  Created by zhangzb on 2017/4/5.
//  Copyright © 2017年 恒信永利. All rights reserved.
//

#ifndef DefineTheme_h
#define DefineTheme_h
#pragma mark - ****************  宽高
//状态栏高度
#define STATUS_BAR_HEIGHT 20
//NavBar高度
#define NAVIGATION_BAR_HEIGHT 44
//TabBar高度
#define TAB_BAR_HEIGHT 59

//屏幕的bounds
#define SCREEN_RECT ([UIScreen mainScreen].bounds)
//设计屏幕宽度 IPHONE 6 的尺寸作为基准
#define NORM_SCREEN_WIDTH 375
//头部和底部的高度和
#define HEAD_TABBAR_HEIGHT ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT) + (TAB_BAR_HEIGHT))
//屏幕宽度
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//屏幕除去头部和底部的高度
#define CONTENT_HEIGHT (SCREEN_HEIGHT - HEAD_TABBAR_HEIGHT)
//屏幕分辨率
#define SCREEN_RESOLUTION (SCREEN_WIDTH * SCREEN_HEIGHT * ([UIScreen mainScreen].scale))
//表格cell高度
#define CELL_HEIGHT 50
//控件左边距
#define LEFT_ORIGIN 20
//按钮高度
#define BUTTON_HEIGHT 45
//长按钮的宽
#define BUTTON_WIDTH SCREEN_WIDTH - LEFT_ORIGIN * 2
//按钮圆角
#define BUTTON_LAYER_CORNER_RADIUS 2


#pragma mark - **************** 颜色
//颜色
#define kRGBColor(r, g, b)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//颜色+透明度
#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

//随机颜色
#define KRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
//RGB转UIColor（不带alpha值）
#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//RGB转UIColor（带alpha值）
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
//白色
#define WHITE_COLOR [UIColor whiteColor]
//无色
#define CLEAR_COLOR [UIColor clearColor]
//线条颜色
#define LINE_COLOR UIColorFromRGB(0xCCCCCC)
// main color
#define  MAIN_COLOR  [UIColor colorWithRed:244/255.0 green:190/255.0 blue:65/255.0 alpha:1.0]
//tab选中颜色
# define TABBAR_SELECT_TINTCOLOR [UIColor colorWithRed:244/255.0 green:190/255.0 blue:65/255.0 alpha:1.0]
//tab未选中颜色
# define TABBAR_NORMAL_TINTCOLOR [UIColor whiteColor]
//#define TITLE_COLOR [UIColor blackColor]//标题颜色
//#define TEXT_COLOR [UIColor grayColor]//正文颜色
//#define TIPTEXT_COLOR UIColorFromRGB(0x888888)//提示语文本颜色
//#define MAIN_GROUNDCOLOR UIColorFromRGB(0x2ab1e7)//主题景色
//#define BACKGROUNDCOLOR UIColorFromRGB(0xF7F7F7)//背景颜色

#pragma mark - **************** 字体
//字体大小
#define TITLE_FONT [UIFont systemFontOfSize:18]
#define TEXT_FONT [UIFont systemFontOfSize:16]
#define TIP_TEXT_FONT [UIFont systemFontOfSize:12]
//线条粗度
#define LINE_WIDTH 0.5f

#pragma mark - **************** 适配
//自适应高度和宽度
#define HEIGHT_RATIO_6 (SCREEN_HEIGHT / 667)
#define WIDTH_RATIO_6 (SCREEN_WIDTH / 375)
//比例数
#define RATIO_H(number) number*HEIGHT_RATIO_6
#define RATIO_W(number) number*WIDTH_RATIO_6



#endif /* DefineTheme_h */
