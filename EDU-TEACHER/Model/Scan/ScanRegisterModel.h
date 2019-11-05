//
//  ScanRegisterModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/10/16.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ScanRegisterModel : JSONModel
  
@property (nonatomic,strong) NSString <Optional> *id;// ---申请记录id
@property (nonatomic,strong) NSString <Optional> *xs_sex;//   --- 性别
@property (nonatomic,strong) NSString <Optional> *class_name;//    --- 班级名称
@property (nonatomic,strong) NSString <Optional> *xs_name;//   --- 学生姓名和学号
@property (nonatomic,strong) NSString <Optional> *status;//  --- 申请状态，0:已通过/1:待审核/2:已拒绝

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
