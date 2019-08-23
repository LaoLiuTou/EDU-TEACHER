//
//  RegisterModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/27.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RegisterModel : NSObject
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *repassword;

@property (nonatomic, copy) NSString *schoolId;
@property (nonatomic, copy) NSString *academyId;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *idNumber;
@property (nonatomic, copy) UIImage *idImage;
@property (nonatomic, copy) NSString *idImageUrl;
@end
 
