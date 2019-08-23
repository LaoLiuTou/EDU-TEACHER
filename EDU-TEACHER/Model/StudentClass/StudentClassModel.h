//
//  StudentClassModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import "TimeTable.h"
NS_ASSUME_NONNULL_BEGIN

@interface StudentClassModel : NSObject
{
    NSString        *_day;              //周几,1/2/3/4/5/6/7,代表周一、周二、周三.........
    NSString        *_lesson;           //课时
    NSString        *_lessonsNum;       //课程有几节课
    NSString        *_courseName;       //课程名
    NSString        *_classRoom;        //教室
    NSString        *_teacherName;      //老师名字
}

@property (nonatomic, copy) NSString    *day;
@property (nonatomic, copy) NSString    *lesson;
@property (nonatomic, copy) NSString    *lessonsNum;
@property (nonatomic, copy) NSString    *courseName;
@property (nonatomic, copy) NSString    *classRoom;
@property (nonatomic, copy) NSString    *teacherName;
@property (nonatomic, copy) NSString    *startTime;
@property (nonatomic, copy) NSString    *endTime;
@property (nonatomic, copy) NSString    *date;
@property (nonatomic, copy) NSString    *start_classTime;
@property (nonatomic, copy) NSString    *end_classTime;

- (id)initWithPropertiesDictionary:(NSDictionary *)dic;

@end

@interface ClassOrderModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *classOrderID;

@property (nonatomic, copy) NSString<Optional> *CLASS_ORDER;

@property (nonatomic, copy) NSString<Optional> *ST_T;

@property (nonatomic, copy) NSString<Optional> *ED_T;

@end

NS_ASSUME_NONNULL_END

