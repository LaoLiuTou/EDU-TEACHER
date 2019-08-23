//
//  LTHTTPManager.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/7.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "LTHTTPManager.h" 
#import "AFNetworking.h"

@implementation LTHTTPManager



+(instancetype)manager{
    return [[[self class] alloc] init];
}




//AFNetworking的POST方法
-(void)LTPost:(NSString *)url param:(NSDictionary *)param success:(successBlock)success failure:(failureBlock)failture
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:url parameters:param headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //回传Block数据
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //回传Block数据
        failture(task,error);
    }];
    
    
}



//AFNetworking的GET方法
-(void)LTGet:(NSString *)url param:(NSDictionary *)param success:(successBlock)success failure:(failureBlock)failture
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager GET:url parameters:param headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //回传Block数据
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //回传Block数据
        failture(task,error);
    }];
    
}




//测试示例
-(void)LTTest:(NSString *)aString andBlock:(void (^)(NSString *))block
{
    NSString * resultStr = [aString stringByAppendingString:@"123"];
    
    block(resultStr);
}


@end
