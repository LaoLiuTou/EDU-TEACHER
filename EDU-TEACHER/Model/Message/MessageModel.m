//
//  MessageModel.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/16.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "MessageModel.h"
#import "NSString+Utils.h"
@implementation MessageModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    NSError *error = nil;
    self =  [self initWithDictionary:dic error:&error];
    return self;
}
@end
