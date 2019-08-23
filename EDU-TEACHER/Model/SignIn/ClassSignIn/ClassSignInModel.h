//
//  ClassSignInModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/31.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ClassSignInModel : JSONModel


@property (nonatomic,strong) NSString <Optional> *id; //签到id
@property (nonatomic,strong) NSString <Optional> *name;   //签到名称
@property (nonatomic,strong) NSString <Optional> *start_time;    //签到开始时间
@property (nonatomic,strong) NSString <Optional> *end_time; //签到结束时间
@property (nonatomic,strong) NSString <Optional> *status;   // //签到状态，临时签到时：待发起、已发起、已结束 ；重复签到时：忽略、已发起、已结束
@property (nonatomic,strong) NSString <Optional> *fd_name;   //创建人
@property (nonatomic,strong) NSString <Optional> *comment;//说明
@property (nonatomic,strong) NSString <Optional> *sign_mode;//签到方式，手动->临时签到，自动->重复签到
@property (nonatomic,strong) NSString <Optional> *sign_count;  //已签到人数
@property (nonatomic,strong) NSString <Optional> *unsign_count; //未签到人数
@property (nonatomic,strong) NSArray <Optional> *sign_list;     //已签到列表
@property (nonatomic,strong) NSArray <Optional> *unsign_list; //未签到列表

 
@property (nonatomic,strong) NSString <Optional> *teacher;   //教师
@property (nonatomic,strong) NSString <Optional> *room;  // 教室
                

   - (instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
