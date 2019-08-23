//
//  NoticeModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/10.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JSONModel.h"

@interface NoticeModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *id;
@property (nonatomic,strong) NSString <Optional> *name;
@property (nonatomic,strong) NSString <Optional> *status;
@property (nonatomic,strong) NSString <Optional> *publish_time;
@property (nonatomic,strong) NSString <Optional> *havefiles;
@property (nonatomic,strong) NSString <Optional> *yidu_count;
@property (nonatomic,strong) NSString <Optional> *all_count;


@property (nonatomic,strong) NSString <Optional> *fd_name;
@property (nonatomic,strong) NSString <Optional> *comment;
@property (nonatomic,strong) NSString <Optional> *image;
@property (nonatomic,strong) NSArray <Optional> *files;
@property (nonatomic,strong) NSArray <Optional> *yidu_list;
@property (nonatomic,strong) NSArray <Optional> *weidu_list;
@property (nonatomic,strong) NSString <Optional> *weidu_count;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end

