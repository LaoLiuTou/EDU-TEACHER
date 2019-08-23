//
//  LeaveDetailModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/4.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface LeaveDetailModel : JSONModel


@property (nonatomic,strong) NSString <Optional> *id;//请假记录id
@property (nonatomic,strong) NSString <Optional> *xs_id;//学生id
@property (nonatomic,strong) NSString <Optional> *xs_name;//学生姓名+学号
@property (nonatomic,strong) NSString <Optional> *fd_name;//审核人名称
@property (nonatomic,strong) NSString <Optional> *type;//请假类型
@property (nonatomic,strong) NSString <Optional> *is_leaveschool;//是否离校
@property (nonatomic,strong) NSString <Optional> *is_xiaojia;//是否销假
@property (nonatomic,strong) NSString <Optional> *status;//审批状态
@property (nonatomic,strong) NSString <Optional> *submit_time;//提交时间
@property (nonatomic,strong) NSString <Optional> *approval_time;//审批时间
@property (nonatomic,strong) NSString <Optional> *start_time;//开始时间
@property (nonatomic,strong) NSString <Optional> *end_time;//结束时间
@property (nonatomic,strong) NSString <Optional> *xiaojia_time;//结束时间
@property (nonatomic,strong) NSString <Optional> *zm_name;//证明人姓名
@property (nonatomic,strong) NSString <Optional> *zm_status;//证明状态
@property (nonatomic,strong) NSString <Optional> *reason;//请假原因
@property (nonatomic,strong) NSString <Optional> *lesson;//请假期间的课程
@property (nonatomic,strong) NSString <Optional> *img;//图片
//@property (nonatomic,strong) NSArray <Optional> *img;//图片 后台需要返回数组
@property (nonatomic,strong) NSString <Optional> *reject;//驳回原因
@property (nonatomic,strong) NSString <Optional> *duration;//请假时长
@property (nonatomic,strong) NSString <Optional> *count;//本月请假次数

- (instancetype)initWithDic:(NSDictionary *)dic;
@end

