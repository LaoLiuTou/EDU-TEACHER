//
//  NoticeModel.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/10.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "NoticeModel.h"
#import "NSString+Utils.h"
@implementation NoticeModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    NSError *error = nil;
    self =  [self initWithDictionary:dic error:&error];
    return self;
}
@end
