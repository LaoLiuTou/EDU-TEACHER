//
//  SysMessageModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/17.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface SysMessageModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *ADD_TIME;
@property (nonatomic,strong) NSString <Optional> *CHAT_TYPE;
@property (nonatomic,strong) NSString <Optional> *CONTENT_TYPE;
@property (nonatomic,strong) NSString <Optional> *CONTEXT;
@property (nonatomic,strong) NSString <Optional> *LAST_CONTEXT;
@property (nonatomic,strong) NSString <Optional> *FLAG;
@property (nonatomic,strong) NSString <Optional> *FRIEND_ID;
@property (nonatomic,strong) NSString <Optional> *ID;
@property (nonatomic,strong) NSString <Optional> *ITEM_ID;
@property (nonatomic,strong) NSString <Optional> *MESSAGE_TYPE;
@property (nonatomic,strong) NSString <Optional> *MI;
@property (nonatomic,strong) NSString <Optional> *READ_STATUS;
@property (nonatomic,strong) NSString <Optional> *SEND_STATUS;
@property (nonatomic,strong) NSString <Optional> *TITLE;



- (instancetype)initWithDic:(NSDictionary *)dic;
@end
