//
//  TalkingModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/22.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface TalkingModel : JSONModel
 

@property (nonatomic,strong) NSString <Optional> *id;//谈话id
@property (nonatomic,strong) NSString <Optional> *NUM;//批次
@property (nonatomic,strong) NSString <Optional> *xs_name; //学生姓名_学号
@property (nonatomic,strong) NSString <Optional> *address;//谈话地点
@property (nonatomic,strong) NSString <Optional> *talk_time;//谈话时间
@property (nonatomic,strong) NSString <Optional> *c_time;//创建时间
@property (nonatomic,strong) NSString <Optional> *count;//谈话次数
@property (nonatomic,strong) NSString <Optional> *comment;//谈话内容
@property (nonatomic,strong) NSString <Optional> *reason;//谈话事由
@property (nonatomic,strong) NSString <Optional> *follow;//后续处理
@property (nonatomic,strong) NSArray <Optional> *files; //附件

 


- (instancetype)initWithDic:(NSDictionary *)dic;

@end
 
