//
//  StudentAttentModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
 

@interface StudentAttentModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *id;//谈话id
@property (nonatomic,strong) NSString <Optional> *xs_name;//学生名_学号
@property (nonatomic,strong) NSString <Optional> *time; //关注时间
@property (nonatomic,strong) NSString <Optional> *c_time; //创建时间
@property (nonatomic,strong) NSString <Optional> *level;//等级
@property (nonatomic,strong) NSString <Optional> *comment; //内容


- (instancetype)initWithDic:(NSDictionary *)dic;
@end

