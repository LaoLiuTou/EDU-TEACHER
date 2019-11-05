//
//  ScanRegisterModel.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/10/16.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ScanRegisterModel.h"
#import "NSString+Utils.h"
@implementation ScanRegisterModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    NSError *error = nil;
    self =  [self initWithDictionary:dic error:&error];
    return self;
}
@end
