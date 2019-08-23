//
//  ActivitySignInModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/31.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface ActivitySignInModel :  JSONModel

@property (nonatomic,strong) NSString <Optional> *id; //活动签到id
@property (nonatomic,strong) NSString <Optional> *name; //活动名称
@property (nonatomic,strong) NSString <Optional> *start_time;//签到开始时间
@property (nonatomic,strong) NSString <Optional> *end_time;//签到结束时间
@property (nonatomic,strong) NSString <Optional> *hd_start_time;//活动开始时间
@property (nonatomic,strong) NSString <Optional> *hd_end_time;//活动结束时间
@property (nonatomic,strong) NSString <Optional> *status; //签到状态
@property (nonatomic,strong) NSString <Optional> *address; //活动地点
@property (nonatomic,strong) NSString <Optional> *fd_name;//创建人
@property (nonatomic,strong) NSString <Optional> *hd_id; //活动id
@property (nonatomic,strong) NSString <Optional> *sign_count; //已签到人数
@property (nonatomic,strong) NSString <Optional> *unsign_count;//未签到人数
@property (nonatomic,strong) NSString <Optional> *leave_count; //请假人数
@property (nonatomic,strong) NSArray <Optional> *sign_list; //已签到列表
@property (nonatomic,strong) NSArray <Optional> *unsign_list; //未签到列表 


- (instancetype)initWithDic:(NSDictionary *)dic;


@end


