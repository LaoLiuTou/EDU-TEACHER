//
//  SelectSchoolViewController.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/27.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKNavigationBarViewController.h"

@interface SelectSchoolViewController : GKNavigationBarViewController
@property(nonatomic,strong)void(^seletedSchool)(NSDictionary *schoolDic);

@end


