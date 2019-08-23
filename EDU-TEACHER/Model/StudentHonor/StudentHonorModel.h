//
//  StudentHonorModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface StudentHonorModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *id; //荣誉奖励id
@property (nonatomic,strong) NSString <Optional> *xs_name; //学生名+学号
@property (nonatomic,strong) NSString <Optional> *date; //获得日期
@property (nonatomic,strong) NSString <Optional> *name;  //名称
@property (nonatomic,strong) NSString <Optional> *organization; //颁发机构
@property (nonatomic,strong) NSString <Optional> *comment; //说明
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

