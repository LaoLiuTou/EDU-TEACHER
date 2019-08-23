//
//  ClassModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/1.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ClassModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *id; //课程id
@property (nonatomic,strong) NSString <Optional> *lesson_name;    //课程名称
@property (nonatomic,strong) NSString <Optional> *teacher;     //教师
@property (nonatomic,strong) NSString <Optional> *room;     //教室
@property (nonatomic,strong) NSString <Optional> *is_signed; //是否已有周期签到，true:有，false：无
@property (nonatomic,strong) NSString <Optional> *have_timetable;     //是否有课程表，true:有，false:无
@property (nonatomic,strong) NSArray <Optional> *timetable_info;    //课程表信息
@property (nonatomic,strong) NSArray <Optional> *xs_info;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
