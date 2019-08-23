//
//  SignInStudentVC.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/2.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKNavigationBarViewController.h"
#import "GKPageScrollView.h"
@interface SignInStudentVC : GKNavigationBarViewController<GKPageListViewDelegate>
@property (nonatomic, strong) NSArray   *listDataArray;
@property (nonatomic, strong) NSString   *signType;
@property (nonatomic, strong) NSString   *type;
@property (nonatomic,strong) NSString *detailId;
@end
