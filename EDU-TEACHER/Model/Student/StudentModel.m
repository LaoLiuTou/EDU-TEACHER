//
//  StudentModel.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/19.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentModel.h"
#import "NSString+Utils.h"

@implementation StudentModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    NSError *error = nil;
    self =  [self initWithDictionary:dic error:&error];
    return self;
}
@end
