//
//  MyinfoVC.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKNavigationBarViewController.h"
#import "MyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyinfoVC : GKNavigationBarViewController
@property (nonatomic, strong)  MyModel *myModel;
@end

NS_ASSUME_NONNULL_END
