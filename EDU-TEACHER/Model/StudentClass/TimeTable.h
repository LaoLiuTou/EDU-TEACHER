//
//  TimeTable.h
//  timetable
//
//  Created by 董一飞 on 2019/7/31.
//  Copyright © 2019 董一飞. All rights reserved.
//

#ifndef TimeTable_h
#define TimeTable_h

#import "AFNetworking.h"
#import "JSONModelLib.h"
#import "DEFINE.h"
#import "SVProgressHUD.h"
#import "TimeTableObj.h"
#import "UIColor+Hex.h" 
#import "JBPersonalTools.h"

#define kGreenColor [UIColor colorWithHexString:@"#28d6b1"]
#define kGrayColor  [UIColor colorWithHexString:@"#F5F6F7"]
#define kDarkGrayColor [UIColor colorWithHexString:@"#727275"]
#define kLightGrayColor [UIColor colorWithHexString:@"#CACACA"]

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

// iPhone X
#define  JB_iPhoneX (SCREENWIDTH == 375.f && SCREENHEIGHT == 812.f ? YES : NO)

//iPHoneXr
#define JB_iPhoneXr (SCREENWIDTH == 414.f && SCREENHEIGHT == 896.f ? YES : NO)

//iPhoneXs
#define JB_iPhoneXs (SCREENWIDTH == 375.f && SCREENHEIGHT == 812.f ? YES : NO)

//iPhoneXs Max
#define JB_iPhoneXs_Max (SCREENWIDTH == 414.f && SCREENHEIGHT == 896.f ? YES : NO)

//iOS 11
#define  JB_iOS11 @available(iOS 11.0, *)

//顶部安全区margin
#define JB_TopSafeMargin ((JB_iPhoneX==YES || JB_iPhoneXr ==YES || JB_iPhoneXs== YES || JB_iPhoneXs_Max== YES) ? 24.f : 0.f)

// Status bar height.
#define  JB_StatusBarHeight      ((JB_iPhoneX==YES || JB_iPhoneXr ==YES || JB_iPhoneXs== YES || JB_iPhoneXs_Max== YES) ? 44.f : 20.f)

// Navigation bar height.
#define  JB_NavigationBarHeight  44.f

// Navigation bar 隐藏时 状态栏预留高度
#define JB_NavNoneStatusBarHeight      ((JB_iPhoneX==YES || JB_iPhoneXr ==YES || JB_iPhoneXs== YES || JB_iPhoneXs_Max== YES) ? 44.f : 0.f)

// Tabbar height.
#define  JB_TabbarHeight         ((JB_iPhoneX==YES || JB_iPhoneXr ==YES || JB_iPhoneXs== YES || JB_iPhoneXs_Max== YES) ? 83.f : 49.f)

// Tabbar safe bottom margin.
#define  JB_TabbarSafeBottomMargin         ((JB_iPhoneX==YES || JB_iPhoneXr ==YES || JB_iPhoneXs== YES || JB_iPhoneXs_Max== YES) ? 34.f : 0.f)

// Status bar & navigation bar height.
#define  JB_StatusBarAndNavigationBarHeight  ((JB_iPhoneX==YES || JB_iPhoneXr ==YES || JB_iPhoneXs== YES || JB_iPhoneXs_Max== YES) ? 88.f : 64.f)

#endif /* TimeTable_h */
