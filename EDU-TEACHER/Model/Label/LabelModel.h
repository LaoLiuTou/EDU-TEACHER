//
//  LabelModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface LabelModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *id; //标签id
@property (nonatomic,strong) NSString <Optional> *NM_T;//标签名称
@property (nonatomic,strong) NSString <Optional> *REMARK;//标签说明
@property (nonatomic,strong) NSString <Optional> *C_DT;//创建时间
@property (nonatomic,strong) NSString <Optional> *count;//人数~~~~
@property (nonatomic,strong) NSString <Optional> *tag_name;//标签名称
@property (nonatomic,strong) NSString <Optional> *remark;//标签说明
@property (nonatomic,strong) NSString <Optional> *xs_id;//选择的学生id
//@property (nonatomic,strong) NSString <Optional> *xs_name;//选择的学生名称
@property (nonatomic,strong) NSArray <Optional> *xs_list;//选择的学生

- (instancetype)initWithDic:(NSDictionary *)dic;
@end

