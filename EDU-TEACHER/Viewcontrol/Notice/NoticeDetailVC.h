//
//  NoticeDetailVC.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/12.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKNavigationBarViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDetailVC : GKNavigationBarViewController
@property (nonatomic, copy) NSString *detailId;
@property (nonatomic, copy) NSString *status;
@end

NS_ASSUME_NONNULL_END
