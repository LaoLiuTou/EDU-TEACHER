//
//  LeaveDetailModel.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/4.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "LeaveDetailModel.h"
#import "NSString+Utils.h"
@implementation LeaveDetailModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    NSError *error = nil;
    self =  [self initWithDictionary:dic error:&error];
    return self;
}
@end
