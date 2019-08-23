//
//  LTHTTPManager.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/7.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTHTTPManager : NSObject

//参数

/** 账号*/
@property(nonatomic, copy) NSString * username;
/** 密码*/
@property(nonatomic, copy) NSString * password;



//创建管理者
+(instancetype)manager;
 
//成功返回Block
typedef void(^successBlock)(NSURLSessionDataTask * task, id responseDictionary);
//失败返回Block
typedef void(^failureBlock)(NSURLSessionDataTask * task, NSError * error);

//POST方法
-(void)LTPost:(NSString *)url param:(NSDictionary *)param success:(successBlock)success failure:(failureBlock)failture;

//GET方法
-(void)LTGet:(NSString *)url param:(NSDictionary *)param success:(successBlock)success failure:(failureBlock)failture;

//Block写在内部的例子
-(void)LTTest:(NSString *)aString andBlock:(void(^)(NSString *resultString))block;



@end
