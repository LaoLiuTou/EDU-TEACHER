//
//  ActivityModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface ActivityModel :  JSONModel

@property (nonatomic,strong) NSString <Optional> *id; //活动id
@property (nonatomic,strong) NSString <Optional> *name; //活动名称
@property (nonatomic,strong) NSString <Optional> *type;  //活动类型
@property (nonatomic,strong) NSString <Optional> *publish_name; //发布人
@property (nonatomic,strong) NSString <Optional> *publish_time;//发布时间
@property (nonatomic,strong) NSString <Optional> *baoming_endtime; //报名截止时间
@property (nonatomic,strong) NSString <Optional> *start_time;//开始时间
@property (nonatomic,strong) NSString <Optional> *end_time;//结束时间
@property (nonatomic,strong) NSString <Optional> *status;//状态
@property (nonatomic,strong) NSString <Optional> *image;//图片
@property (nonatomic,strong) NSString <Optional> *address; //地址
@property (nonatomic,strong) NSString <Optional> *number;  //限制人数
@property (nonatomic,strong) NSString <Optional> *comment;  //内容
@property (nonatomic,strong) NSString <Optional> *enroll_count;//已报名人数
@property (nonatomic,strong) NSString <Optional> *unenroll_count;//未报名人数
@property (nonatomic,strong) NSArray <Optional> *enroll_list; //已报名学生列表
@property (nonatomic,strong) NSArray <Optional> *unenroll_list;//未报名学生列表
@property (nonatomic,strong) NSString <Optional> *havefiles;//是否有附件，true：有附件，false：无附件
@property (nonatomic,strong) NSArray <Optional> *files;//附件


@property (nonatomic,strong) NSArray <Optional> *sign_name;//签到名称
@property (nonatomic,strong) NSArray <Optional> *sign_method;//签到方式，类型是签到类型时，必需
@property (nonatomic,strong) NSArray <Optional> *sign_deviceids;//签到设备ids
@property (nonatomic,strong) NSArray <Optional> *sign_start_time;//签到开始时间，类型是签到类型时，必需
@property (nonatomic,strong) NSArray <Optional> *sign_end_time;//签到结束时间

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

