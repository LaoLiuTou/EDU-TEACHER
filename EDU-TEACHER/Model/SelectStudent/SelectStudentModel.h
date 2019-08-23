//
//  SelectStudentModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/8.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"

@interface SelectStudentModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *id;
@property (nonatomic,strong) NSString <Optional> *NM_T;
@property (nonatomic,strong) NSString <Optional> *SN_T;
@property (nonatomic,strong) NSString <Optional> *PH_P;
@property (nonatomic,strong) NSString <Optional> *I_UPIMG;
@property (nonatomic,strong) NSString <Optional> *status;
@property (nonatomic,strong) NSString <Optional> *extend;
  
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
