//
//  NoteDetailVC.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/5.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h> 

#import "GKNavigationBarViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoteDetailVC : GKNavigationBarViewController
@property (nonatomic, copy) NSString *detailId;
@property (nonatomic, copy) NSString *noteType;
@end

NS_ASSUME_NONNULL_END
