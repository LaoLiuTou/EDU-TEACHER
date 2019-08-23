//
//  MyModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface MyModel : JSONModel 
@property (nonatomic,strong) NSString <Optional> *id;  //辅导员id
@property (nonatomic,strong) NSString <Optional> *name;   //姓名
@property (nonatomic,strong) NSString <Optional> *image; //头像
@property (nonatomic,strong) NSString <Optional> *sex;    //性别
@property (nonatomic,strong) NSString <Optional> *school_name;   //学校名称
@property (nonatomic,strong) NSString <Optional> *ac_name; //学院名称
@property (nonatomic,strong) NSString <Optional> *role;    //角色
@property (nonatomic,strong) NSString <Optional> *phone;    //手机号
@property (nonatomic,strong) NSString <Optional> *id_card;//身份证号码
@property (nonatomic,strong) NSString <Optional> *idcard_image;  //身份证照片

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
 
