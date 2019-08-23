//
//  LeaveModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/3.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JSONModel.h"

@interface LeaveListModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *id;
@property (nonatomic,strong) NSString <Optional> *xs_id;
@property (nonatomic,strong) NSString <Optional> *xs_name;
@property (nonatomic,strong) NSString <Optional> *type;
@property (nonatomic,strong) NSString <Optional> *submit_time;
@property (nonatomic,strong) NSString <Optional> *approval_time;
@property (nonatomic,strong) NSString <Optional> *start_time;
@property (nonatomic,strong) NSString <Optional> *end_time;
@property (nonatomic,strong) NSString <Optional> *status;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end
 
