//
//  ActivityStudentVC.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKNavigationBarViewController.h"
#import "GKPageScrollView.h"
@interface ActivityStudentVC : GKNavigationBarViewController<GKPageListViewDelegate>
@property (nonatomic, strong) NSArray   *listDataArray;
@property (nonatomic, strong) NSString   *type;
@property (nonatomic,strong) NSString *activityId;
@end
