//
//  BizStyle.h
//  MVVMExample
//
//  Created by chenxiaosong on 2019/1/9.
//  Copyright © 2019年 chenxiaosong. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  样式：尺寸相关
 */
#define kSmallCorner 2.0f
#define kLargeCorner 4.0f

/*
 *  样式：颜色
 */
#define UIColorFromRGB(rgbValue)                            \
[UIColor                                                    \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0   \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0             \
blue:((float)(rgbValue & 0xFF))/255.0                       \
alpha:1.0]

#define kColorMajorNormal               UIColorFromRGB(0xF64040)
#define kColorMajorHighlight            UIColorFromRGB(0xEF856F)
#define kColorWhite                     [UIColor whiteColor]
#define kColorDeepDark                  UIColorFromRGB(0x333333)
#define kColorSeparator                 UIColorFromRGB(0xe6e6e6)
#define kColorLight                     UIColorFromRGB(0xcccccc)


NS_ASSUME_NONNULL_BEGIN

@interface BizStyle : NSObject

@end

NS_ASSUME_NONNULL_END
