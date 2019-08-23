//
//  SysMessageModel.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/17.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SysMessageModel.h"
#import "NSString+Utils.h"
@implementation SysMessageModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    NSError *error = nil;
    self =  [self initWithDictionary:dic error:&error];
    return self;
}
@end
