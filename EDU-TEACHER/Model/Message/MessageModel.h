//
//  MessageModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/16.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface MessageModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *ID;
@property (nonatomic,strong) NSString <Optional> *FRIEND_NAME;
@property (nonatomic,strong) NSString <Optional> *FRIEND_IMAGE;
@property (nonatomic,strong) NSString <Optional> *FRIEND_ID;
@property (nonatomic,strong) NSString <Optional> *FRIEND_DETAIL;
@property (nonatomic,strong) NSString <Optional> *LAST_CONTEXT;
@property (nonatomic,strong) NSString <Optional> *LAST_TIME;
@property (nonatomic,strong) NSString <Optional> *UNREAD;
@property (nonatomic,strong) NSString <Optional> *UPDATE_TIME;
@property (nonatomic,strong) NSString <Optional> *FLAG;
@property (nonatomic,strong) NSString <Optional> *ISGROUP;
@property (nonatomic,strong) NSString <Optional> *ISONLINE;

 

- (instancetype)initWithDic:(NSDictionary *)dic;
@end

