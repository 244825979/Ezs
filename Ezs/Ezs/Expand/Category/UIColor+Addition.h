//
//  UIColor+Addition.h
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/10.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Addition)
/// 使用 16 进制数字创建颜色，例如 0xFF0000 创建红色
///
/// @param hex 16 进制无符号32位整数
///
/// @return 颜色
+ (instancetype)zb_colorWithHex:(uint32_t)hex;

/// 使用 R / G / B 数值创建颜色
///
/// @param red   red
/// @param green green
/// @param blue  blue
///
/// @return 颜色
+ (instancetype)zb_colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue;

@end
