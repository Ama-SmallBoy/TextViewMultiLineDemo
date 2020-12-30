//
//  PublicConfig.h
//  UPOC_Teacher
//  系统参数配置
//  Created by wangjiawei on 15/12/7.
//  Copyright © 2015年 星梦. All rights reserved.
//

#ifndef PublicConfig_h
#define PublicConfig_h

#pragma mark - SCREEN
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define Selected_Max_Review(MADE_FLOG_BOOL,MADE_MAX_COUNT) (MADE_FLOG_BOOL?8:MADE_MAX_COUNT)

//适配iPhone X的导航栏
#define SafeAreaTopHeight (SCREEN_HEIGHT >= 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (SCREEN_HEIGHT >= 812.0 ? 34 : 0)
#define SafeAreaBottomvideoMessageHeight (SCREEN_HEIGHT >= 812.0 ? 14 : 0)
#define SafeAreaViewRateTopHeight (SCREEN_HEIGHT >= 812.0 ? 98 : 64)
#define HomeworkVCHeight (SCREEN_HEIGHT-SafeAreaTopHeight-46.0)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define textfield_Height 50.f
#define TaskRichFont 14.0
#define TextPaddingSpace  15.0

#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark - OTHERS
#define HUD_TAG 100000
#define Upload_TAG 2017
// 公用未选中颜色
#define UnSelectedColor ([UIColor colorWithRed:169.f/255.f green:169.f/255.f blue:169.f/255.f alpha:1])
// 公用已选中颜色
#define SelectedColor ([UIColor colorWithRed:0.f/255.f green:186.f/255.f blue:151.f/255.f alpha:1])

// 所有背景灰色的色值
#define kGreyBackgroundColor ([UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:245.f/255.f alpha:1])

// 所有按钮可点的颜色
#define kSelectedButtonColor ([UIColor colorWithRed:0.f/255.f green:186.f/255.f blue:151.f/255.f alpha:1])

// 所有按钮不可点的颜色
#define kUnSelectedButtonColor ([UIColor colorWithRed:163.0f/255.f green:222.0f/255.f blue:207.0f/255.f alpha:1])

//拾色
#define kUIColorFromRGB(rgbValue,alphy) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphy]

#define kNavigationColor kUIColorFromRGB(0x6dd7d5,1.0)
#define kUBOGreenColor kUIColorFromRGB(0x00ba97,1.0)
//#define  kAddImage [UIImage  imageNamed:@"addImag"]

#endif /* PublicConfig_h */
