//
//  StudentClassModel.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentClassModel.h"
#import "NSString+Utils.h"
@implementation StudentClassModel

- (id)initWithPropertiesDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (dic != nil) {
            
            self.day = [dic objectForKey:@"weekDay"];
            self.lesson = [NSString stringWithFormat:@"%@",[dic objectForKey:@"start_classtime"]];
            
            NSString *lessonsNum = @"";
            if([[dic objectForKey:@"start_classtime"] integerValue] == [[dic objectForKey:@"end_classtime"] integerValue]){
                lessonsNum = @"1";
            }else{
                lessonsNum = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"end_classtime"] integerValue] - [[dic objectForKey:@"start_classtime"] integerValue] + 1];
            }
            
            self.lessonsNum = lessonsNum;
            self.courseName = [dic objectForKey:@"kc_name"];
            self.classRoom = [dic objectForKey:@"room"];
            self.teacherName = [dic objectForKey:@"teacher"];
            self.startTime = [dic objectForKey:@"start_time"];
            self.endTime = [dic objectForKey:@"end_time"];
            self.start_classTime = [dic objectForKey:@"start_classtime"];
            self.end_classTime = [dic objectForKey:@"end_classtime"];
        }
    }
    return self;
}

- (void)setStartTime:(NSString *)startTime{
    _startTime = startTime;
    
    NSMutableArray *timeArray = [NSMutableArray arrayWithArray:[startTime componentsSeparatedByString:@":"]];
    [timeArray removeLastObject];
    NSString *timeStr = [timeArray componentsJoinedByString:@":"];
    
    _startTime = timeStr;
}

- (void)setEndTime:(NSString *)endTime{
    _endTime = endTime;
    
    NSMutableArray *timeArray = [NSMutableArray arrayWithArray:[endTime componentsSeparatedByString:@":"]];
    [timeArray removeLastObject];
    NSString *timeStr = [timeArray componentsJoinedByString:@":"];
    
    _endTime = timeStr;
}

@end

@implementation ClassOrderModel

//+ (JSONKeyMapper *)keyMapper{
//    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"classOrderID":@"ID"}];
//}

- (instancetype)initWithDic:(NSDictionary *)dic{
    NSError *error = nil;
    self =  [self initWithDictionary:dic error:&error];
    return self;
}
- (void)setST_T:(NSString<Optional> *)ST_T{
    _ST_T = ST_T;
    
    NSMutableArray *timeArray = [NSMutableArray arrayWithArray:[ST_T componentsSeparatedByString:@":"]];
    [timeArray removeLastObject];
    NSString *timeStr = [timeArray componentsJoinedByString:@":"];
    
    _ST_T = timeStr;
}

@end

