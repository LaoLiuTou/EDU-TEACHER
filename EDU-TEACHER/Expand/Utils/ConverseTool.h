//
//  Json2Dic.h
//  EDU-TEACHER
//
//  Created by JiubaiMac on 16/10/23.
//  Copyright © 2016年 JiubaiMacmini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConverseTool : NSObject

+ (NSString *)getBase64Str:(NSString *)string ;

+ (NSString *)formBase64Str:(NSString *)base64String;
#pragma json转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString ;
#pragma 字典转json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
#pragma data转json
+(NSString*)DataTOjsonString:(id)object;
#pragma 毫秒数转日期
+ (NSString *)ConvertStrToTime:(NSString *)timeStr;
#pragma 时间友好
+ (NSString *)compareCurrentTime:(NSDate*) compareDate;
@end
