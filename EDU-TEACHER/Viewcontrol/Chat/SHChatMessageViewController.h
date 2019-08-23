//
//  SHChatMessageViewController.h
//  SHChatUI
//
//  Created by CSH on 2018/6/5.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKNavigationBarViewController.h"
#import "MessageModel.h"
/**
 聊天界面
 */
@interface SHChatMessageViewController : GKNavigationBarViewController
@property(nonatomic,copy) MessageModel *model;
@end
