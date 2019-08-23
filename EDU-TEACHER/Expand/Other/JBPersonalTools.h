//
//  JBPersonalTools.h
//  xumu
//
//  Created by Dongyifei on 2018/12/17.
//  Copyright © 2018 Dongyifei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
//#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DateFormate) {
    Date_YearMonthDay = 0,
    Date_YearMonthDayTime,
    Date_YearMonthDayTimeSecond,
    Date_Day,
};
typedef NS_ENUM(NSInteger, Components) {
    C_Year = 0,
    C_Month,
    C_Day,
    C_Hour,
    C_Minute,
    C_Second,
};

@interface JBPersonalTools : NSObject

+ (JBPersonalTools *)sharedInstance;
/**
 *  获取当天的日期--字符串格式
 */
- (NSString *)getNowDateStrWithFormat:(DateFormate)dateFormate;
/**
 *  获取本周的日期数组
 */
- (NSArray *)getDatesOfCurrence:(DateFormate)dateFormate;
/**
 *  获取相距时间的日期--字符串格式 （昨天）
 */
- (NSString *)getDiffersDate:(NSTimeInterval)differ dateFormat:(DateFormate)dateFormate;

@end

NS_ASSUME_NONNULL_END
