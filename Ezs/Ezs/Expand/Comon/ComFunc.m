//
//  ComFunc.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/10.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "ComFunc.h"

@implementation ComFunc
/**颜色转图片*/
+ (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
