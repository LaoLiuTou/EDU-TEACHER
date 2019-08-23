//
//  SelectStudentViewController.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/8.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKNavigationBarViewController.h"
@interface SelectStudentTVC : GKNavigationBarViewController
@property (nonatomic,assign) NSString *type;

@property (nonatomic,strong) NSDictionary *value; //   @{1:[1,2,3]}


@property (nonatomic,strong) NSString *select; //   0，1 单选多选

@property (nonatomic,strong) NSString *sub; //   0，1 可选，不可选
@property (nonatomic,strong) NSString *notificationName;
@end

