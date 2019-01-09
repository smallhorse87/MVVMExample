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
#define kHugeCorner  5.0f

/*
 *  样式：颜色
 */
#define UIColorFromRGB(rgbValue)                            \
[UIColor                                                    \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0   \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0             \
blue:((float)(rgbValue & 0xFF))/255.0                       \
alpha:1.0]

#define kColorGreen                     UIColorFromRGB(0x18BC40)
#define kColorGreenButtonHighLightBG    UIColorFromRGB(0x6FD287)

#define kColorMajorNormal               UIColorFromRGB(0xF64040)
#define kColorMajorHighlight            UIColorFromRGB(0xEF856F)

#define kColorOrange                    UIColorFromRGB(0xf64e27)

#define kColorDeepDark                  UIColorFromRGB(0x333333)
#define kColorLittleDeepDark            UIColorFromRGB(0x2a2a2a)
#define kcolor_2E2E2E                   UIColorFromRGB(0x2E2E2E)
#define KColor_444444                   UIColorFromRGB(0x444444)
#define kColorDark                      UIColorFromRGB(0x4d4d4d)
#define kcolor_606060                   UIColorFromRGB(0x606060)
#define kColorLightDark                 UIColorFromRGB(0x666666)
#define kColor_7F7F7F                   UIColorFromRGB(0x7f7f7f)
#define kColorGray                      UIColorFromRGB(0x989898)
#define kColorLightGray                 UIColorFromRGB(0xb2b2b2)
#define kColor_B3B3B3                   UIColorFromRGB(0xB3B3B3)
#define kColor_B6B6B6                   UIColorFromRGB(0xB6B6B6)
#define kColorLight                     UIColorFromRGB(0xcccccc)
#define kOutlineColor                   UIColorFromRGB(0xd8d8d8)
#define kColorNavBarShadow              UIColorFromRGB(0xdadada)
#define kColorHighlightGray             UIColorFromRGB(0xdbdbdb)
#define kColor_E5E5E5                   UIColorFromRGB(0xE5E5E5)
#define kColorSeparator                 UIColorFromRGB(0xe6e6e6)
#define kColor_EDEDED                   UIColorFromRGB(0xEDEDED)
#define kColorSearchBarBg               UIColorFromRGB(0xeeeeee)
#define kColorGrayEF                    UIColorFromRGB(0xefefef)
#define kColorPageBg                    UIColorFromRGB(0xf2f2f2)
#define kColor_f4f4f4                   UIColorFromRGB(0xf4f4f4)
#define kColorFeedbackBg                UIColorFromRGB(0xf8f8f8)
#define kcolor_F9F9F9                   UIColorFromRGB(0xF9F9F9)
#define kColorGrayFA                    UIColorFromRGB(0xFAFAFA)

#define kColorTagText                   UIColorFromRGB(0xFB6F35)
#define kColorTagBG                     UIColorFromRGB(0xfeeae1)
#define kColorMoreText                  UIColorFromRGB(0x5085B4)
#define kColorPwdFieldBorderColor       UIColorFromRGB(0x6FACE3)

//最常用颜色
#define kColorWhite                     [UIColor whiteColor]
#define kColorBlack                     [UIColor blackColor]
#define kColorNone                      [UIColor clearColor]

//以下使用很少
#define kColorTiffanyBlue               UIColorFromRGB(0x82DFB0)
#define kRefundCellBG                   UIColorFromRGB(0xFEF3D9)
#define kColorRefundFont                UIColorFromRGB(0xFF9900)

//新首页颜色hanli
#define kColor_0xF64040                 UIColorFromRGB(0xF64040)

//停车服务
#define kColor_3C96F5                   UIColorFromRGB(0x3C96F5)
#define kColor_D2D7DC                   UIColorFromRGB(0xD2D7DC)
#define kColor_63778C                   UIColorFromRGB(0x63778C)
#define kColor_FF6969                   UIColorFromRGB(0xFF6969)

//会员
#define kcolor_DADFFF               UIColorFromRGB(0xDADFFF)
#define kcolor_565D8E               UIColorFromRGB(0x565D8E)
#define kcolor_F64040               UIColorFromRGB(0xF64040)

//活动
#define kColor_FFABAB               UIColorFromRGB(0xFFABAB)
#define kColor_18BC40               UIColorFromRGB(0x18BC40)
#define KColor_B56F00               UIColorFromRGB(0xB56F00)
#define kColor_6baed6               UIColorFromRGB(0x6baed6)
#define kColor_ff8873               UIColorFromRGB(0xff8873)
#define kColor_FF7070               UIColorFromRGB(0xFF7070)
#define KColor_5BC4FB               UIColorFromRGB(0x5BC4FB)

//地图导航
#define kColorBrightBlue               UIColorFromRGB(0x4287FF)


#define kSystemCountDownTimer 60

NS_ASSUME_NONNULL_BEGIN

@interface BizStyle : NSObject

@end

NS_ASSUME_NONNULL_END
