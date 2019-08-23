//
//  StudentInfoVC.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/19.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKNavigationBarViewController.h"
#import "StudentModel.h"
@interface StudentInfoVC : GKNavigationBarViewController
@property (nonatomic, strong)  StudentModel *studentModel;
@end

