//
//  StudentPunishModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface StudentPunishModel : JSONModel  
@property (nonatomic,strong) NSString <Optional> *id; //处分id
@property (nonatomic,strong) NSString <Optional> *xs_name; //学生名+学号
@property (nonatomic,strong) NSString <Optional> *date;//处分日期
@property (nonatomic,strong) NSString <Optional> *name;//标题
@property (nonatomic,strong) NSString <Optional> *comment;//内容
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

