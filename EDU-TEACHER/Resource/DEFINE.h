

#ifndef DEFINE_h
#define DEFINE_h


//屏幕高度//
#define kHeight [[UIScreen mainScreen] bounds].size.height
//屏幕宽度
#define kWidth [[UIScreen mainScreen] bounds].size.width
//快速生成颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]


#define MPaddingLeftWidth 15.0
// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)


#define RECT_CHANGE_x(v,x)          CGRectMake(x, Y(v), WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_y(v,y)          CGRectMake(X(v), y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_point(v,x,y)    CGRectMake(x, y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_width(v,w)      CGRectMake(X(v), Y(v), w, HEIGHT(v))
#define RECT_CHANGE_height(v,h)     CGRectMake(X(v), Y(v), WIDTH(v), h)
#define RECT_CHANGE_size(v,w,h)     CGRectMake(X(v), Y(v), w, h)
// 判断是否是iPhone X
#define KIS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//iPHoneXr
#define KIS_IPHONEXr (SCREENWIDTH == 414.f && SCREENHEIGHT == 896.f ? YES : NO)

//iPhoneXs
#define KIS_IPHONEXs (SCREENWIDTH == 375.f && SCREENHEIGHT == 812.f ? YES : NO)

//iPhoneXs Max
#define KIS_IPHONEXs_Max (SCREENWIDTH == 414.f && SCREENHEIGHT == 896.f ? YES : NO)

#define fileName(file) [MJRefreshBundleName stringByAppendingPathComponent:file]
//根UIInputView相关
#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define MKeyWindow [UIApplication sharedApplication].keyWindow

#define kDevice_Is_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

#import "Masonry.h"

#define IS_iPhoneX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
(\
CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(812, 375),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(896, 414),[UIScreen mainScreen].bounds.size))\
:\
NO)

#define kNavBarHeight       (IS_iPhoneX ? 88.0f : 64.0f)

//  适配比例
#define ADAPTATIONRATIO     kWidth / 750.0f

// 颜色
#define GKColorRGBA(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]
#define GKColorRGB(r, g, b)     GKColorRGBA(r, g, b, 1.0)
#define GKColorGray(v)          GKColorRGB(v, v, v)

#define GKColorHEX(hexValue, a) GKColorRGBA(((float)((hexValue & 0xFF0000) >> 16)), ((float)((hexValue & 0xFF00) >> 8)), ((float)(hexValue & 0xFF)), a)

#define GKColorRandom           GKColorRGB(arc4random() % 255, arc4random() % 255, arc4random() % 255)

#define HEXCOLOR(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0  blue:((float)(hexValue & 0xFF))/255.0 alpha:a]

#define headerHeight 150
//底部标签栏高度
#define TabBarHeight (IS_iPhoneX ? (50.f+34.f) : 50.f)
#define BottomPaddingHeight (IS_iPhoneX ? (20.f) : 0.f)
#import "LTHTTPManager.h"

#endif
