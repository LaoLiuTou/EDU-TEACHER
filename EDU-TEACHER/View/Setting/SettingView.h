//
//  SettingView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingDelegate <NSObject>
-(void)clickMenuBtn:(UIButton *)btn;

@end
@interface SettingView : UIView
@property(nonatomic,strong)id<SettingDelegate>delegate;

@end

