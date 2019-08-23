//
//  JBPersonalTools.m
//  xumu
//
//  Created by Dongyifei on 2018/12/17.
//  Copyright © 2018 Dongyifei. All rights reserved.
//

#import "JBPersonalTools.h"
#import <Photos/Photos.h>

@implementation JBPersonalTools

+ (JBPersonalTools *)sharedInstance {
    
    static JBPersonalTools  *tools = nil;
    static dispatch_once_t pre = 0;
    dispatch_once(&pre, ^{
        tools = [[JBPersonalTools alloc] init];
    });
    
    return tools;
}

- (NSString *)getNowDateStrWithFormat:(DateFormate)dateFormate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    switch (dateFormate) {
        case Date_YearMonthDay:
            [formatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case Date_YearMonthDayTime:
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case Date_YearMonthDayTimeSecond:
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
        case Date_Day:
            [formatter setDateFormat:@"dd"];
            break;
        default:
            break;
    }
    
    
    NSDate *datenow = [NSDate date];
    
    return [formatter stringFromDate:datenow];
    
}

- (NSArray *)getDatesOfCurrence:(DateFormate)dateFormate{
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2]; //1代表周日，2代表周一
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:now];
    NSInteger weekDayInteger = [components weekday];
    // 得到几号
    NSInteger day = [components day];
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff;
    if (weekDayInteger == 1) {
        firstDiff = 1-7;
    }else{
        firstDiff = [calendar firstWeekday] - weekDayInteger;
    }
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    
    NSString *month = @"";
    if(firstDayComp.month < 10){
        month = [NSString stringWithFormat:@"0%ld",(long)[firstDayComp month]];
    }else{
        month = [NSString stringWithFormat:@"%ld",(long)[firstDayComp month]];
    }
    
    
    NSString *weekDay = [self getWeekDayFordate:[self getNowDateStrWithFormat:Date_YearMonthDay]];
    
    if([weekDay isEqualToString:@"星期一"]){
        return @[month,
                 [self getNowDateStrWithFormat:dateFormate],
                 [self getDiffersDate:(24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:(2*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:(3*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:(4*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:(5*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:(6*24*60*60) dateFormat:dateFormate]];
    }
    if([weekDay isEqualToString:@"星期二"]){
        return @[month,
                 [self getDiffersDate:-(24*60*60) dateFormat:dateFormate],
                 [self getNowDateStrWithFormat:dateFormate],
                 [self getDiffersDate:(24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:(2*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:(3*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:(4*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:(5*24*60*60) dateFormat:dateFormate]];
    }
    if([weekDay isEqualToString:@"星期三"]){
        return @[month,
                 [self getDiffersDate:-(2*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:-(24*60*60) dateFormat:dateFormate],
                 [self getNowDateStrWithFormat:dateFormate],
                 [self getDiffersDate:(24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:(2*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:(3*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:(4*24*60*60) dateFormat:dateFormate]];
    }
    if([weekDay isEqualToString:@"星期四"]){
        return @[month,
                 [self getDiffersDate:-(3*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:-(2*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:-(24*60*60) dateFormat:dateFormate],
                 [self getNowDateStrWithFormat:dateFormate],
                 [self getDiffersDate:(24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:(2*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:(3*24*60*60) dateFormat:dateFormate]];
    }
    if([weekDay isEqualToString:@"星期五"]){
        return @[month,
                 [self getDiffersDate:-(4*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:-(3*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:-(2*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:-(24*60*60) dateFormat:dateFormate],
                 [self getNowDateStrWithFormat:dateFormate],
                 [self getDiffersDate:(24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:(2*24*60*60) dateFormat:dateFormate]];
    }
    if([weekDay isEqualToString:@"星期六"]){
        return @[month,
                 [self getDiffersDate:-(5*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:-(4*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:-(3*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:-(2*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:-(24*60*60) dateFormat:dateFormate],
                 [self getNowDateStrWithFormat:dateFormate],
                 [self getDiffersDate:(24*60*60) dateFormat:dateFormate]];
    }
    if([weekDay isEqualToString:@"星期日"]){
        return @[month,
                 [self getDiffersDate:-(6*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:-(5*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:-(4*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:-(3*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:-(2*24*60*60) dateFormat:dateFormate],
                 [self getDiffersDate:-(24*60*60) dateFormat:dateFormate],
                 [self getNowDateStrWithFormat:dateFormate]];
    }
    return @[];
}


- (NSString *)getDiffersDate:(NSTimeInterval)differ dateFormat:(DateFormate)dateFormate{
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:differ];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    switch (dateFormate) {
        case Date_YearMonthDay:
            [formatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case Date_YearMonthDayTime:
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case Date_YearMonthDayTimeSecond:
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
        case Date_Day:
            [formatter setDateFormat:@"dd"];
            break;
        default:
            break;
    }
    
    return [formatter stringFromDate:yesterday];
}

- (NSString *)getWeekDayFordate:(NSString *)date {
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:[[formatter dateFromString:date] timeIntervalSince1970]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}
@end
