//
//  SignInModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/11.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
 

#import "JSONModel.h"

@interface SignInModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *id; //签到id
@property (nonatomic,strong) NSString <Optional> *task_id;//签到任务id（课程签到、宿舍签到用到）
@property (nonatomic,strong) NSString <Optional> *c_time; //签到创建时间
@property (nonatomic,strong) NSString <Optional> *comment;//备注
@property (nonatomic,strong) NSString <Optional> *name;   //签到标题
@property (nonatomic,strong) NSString <Optional> *type;//签到类型（课程签到、活动签到、宿舍签到、其他签到）
@property (nonatomic,strong) NSString <Optional> *start_time;  //签到开始时间
@property (nonatomic,strong) NSString <Optional> *end_time;//签到结束时间
@property (nonatomic,strong) NSString <Optional> *status;//签到状态
@property (nonatomic,strong) NSString <Optional> *signed_count; //已签到人数
@property (nonatomic,strong) NSString <Optional> *all_count;//签到总人数

 
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
