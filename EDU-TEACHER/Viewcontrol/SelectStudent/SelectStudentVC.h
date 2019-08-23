//
//  SelectStudentVC.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/8.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
 #import "GKNavigationBarViewController.h"

@interface SelectStudentVC : GKNavigationBarViewController
@property (nonatomic,assign) int selectIndex; // 0 , 1

@property (nonatomic,strong) NSString *type; //  all   class  tag

@property (nonatomic,strong) NSDictionary *values; //  {tag:@{1:[1,2,3]},class:@{2:[1,2]}}

@property (nonatomic,strong) NSString *select; //   0，1 单选多选

@property (nonatomic,strong) NSString *sub; //   0，1 可选，不可选
@property (nonatomic,strong) NSString *notificationName;
@end

