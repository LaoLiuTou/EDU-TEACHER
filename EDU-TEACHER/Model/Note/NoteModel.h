//
//  NoteModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/5.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoteModel : JSONModel


@property (nonatomic,strong) NSString <Optional> *id;  //日志id
@property (nonatomic,strong) NSString <Optional> *name;  //标题
@property (nonatomic,strong) NSString <Optional> *c_time; //创建时间
@property (nonatomic,strong) NSString <Optional> *comment; //内容
@property (nonatomic,strong) NSString <Optional> *type;//类型
@property (nonatomic,strong) NSString <Optional> *is_beiwang;//是否为备忘完结的日志，true：是，false：否
@property (nonatomic,strong) NSString <Optional> *level; //重要程度
@property (nonatomic,strong) NSArray <Optional> *xs_list; //相关学生列表
@property (nonatomic,strong) NSString <Optional> *end_time;//完成时间
@property (nonatomic,strong) NSString <Optional> *remind_time;//提醒时间

- (instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
