//
//  StudentHelpModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface StudentHelpModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *id;// id 
@property (nonatomic,strong) NSString <Optional> *xs_name; //学生名+学号
@property (nonatomic,strong) NSString <Optional> *name;//资助标题
@property (nonatomic,strong) NSString <Optional> *date; //资助日期
@property (nonatomic,strong) NSString <Optional> *money; //资助金额
@property (nonatomic,strong) NSString <Optional> *organization; //资助单位
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

